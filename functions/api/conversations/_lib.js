/* Finchase Capital, conversations API shared helpers (Cloudflare Pages Functions).
 *
 * Imported by functions under /api/conversations/*. Never exposed directly.
 * Bindings used: DB (D1, shared with rates), CONVERSATIONS_BUCKET (R2, private).
 * Secrets used: ADMIN_TOKEN (required for admin), RESEND_API_KEY / TEAM_EMAIL /
 *   FROM_EMAIL (optional, notifications), IP_PEPPER (optional, IP hashing).
 */

export function json(data, status) {
  return Response.json(data, {
    status: status || 200,
    headers: { "Cache-Control": "no-store" }
  });
}

/* 404 for unauthenticated admin access (does not confirm the endpoint exists). */
export function notFound() {
  return json({ error: "not found" }, 404);
}

export async function sha256Hex(text) {
  const buf = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
  return [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

export function safeEqual(a, b) {
  if (typeof a !== "string" || typeof b !== "string") return false;
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

export function getCookie(request, name) {
  const header = request.headers.get("Cookie") || "";
  const parts = header.split(";");
  for (const p of parts) {
    const idx = p.indexOf("=");
    if (idx < 0) continue;
    if (p.slice(0, idx).trim() === name) return decodeURIComponent(p.slice(idx + 1).trim());
  }
  return "";
}

export function clientIp(request) {
  return (
    request.headers.get("CF-Connecting-IP") ||
    (request.headers.get("X-Forwarded-For") || "").split(",")[0].trim() ||
    "unknown"
  );
}

export async function ipHash(request, env) {
  const pepper = env.IP_PEPPER || "finchase-conversations";
  return sha256Hex(clientIp(request) + "|" + pepper);
}

/* Sliding-window rate limit backed by D1. Returns true when allowed. */
export async function hitRate(db, key, limit, windowSec) {
  const now = Math.floor(Date.now() / 1000);
  try {
    await db
      .prepare("DELETE FROM rate_hits WHERE ts < ?")
      .bind(now - windowSec)
      .run();
    const row = await db
      .prepare("SELECT COUNT(*) AS n FROM rate_hits WHERE key = ? AND ts >= ?")
      .bind(key, now - windowSec)
      .first();
    const n = (row && row.n) || 0;
    if (n >= limit) return false;
    await db.prepare("INSERT INTO rate_hits (key, ts) VALUES (?, ?)").bind(key, now).run();
    return true;
  } catch (e) {
    /* Fail open for rate limiting only (never block legit traffic on DB hiccup). */
    return true;
  }
}

const ADMIN_COOKIE = "fc_conv_admin";

export async function requireAdmin(request, env) {
  try {
    if (!env.DB) return null;
    const raw = getCookie(request, ADMIN_COOKIE);
    if (!raw) return null;
    const h = await sha256Hex(raw);
    const row = await env.DB.prepare(
      "SELECT token_hash FROM admin_sessions WHERE token_hash = ? AND expires_at > datetime('now')"
    )
      .bind(h)
      .first();
    return row ? true : null;
  } catch (e) {
    return null;
  }
}

export function adminCookieHeader(token, maxAgeSec) {
  return (
    ADMIN_COOKIE +
    "=" +
    encodeURIComponent(token) +
    "; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=" +
    maxAgeSec
  );
}

export function clearAdminCookieHeader() {
  return ADMIN_COOKIE + "=; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=0";
}

/* Best-effort email via Resend. Resolves false when not configured or on failure;
 * callers must never fail a submission because email failed. */
export async function sendMail(env, to, subject, text) {
  try {
    const key = env.RESEND_API_KEY || "";
    if (!key || !to) return false;
    const from = "Finchase Capital <" + (env.FROM_EMAIL || "ideas@finchasecapital.in") + ">";
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { Authorization: "Bearer " + key, "Content-Type": "application/json" },
      body: JSON.stringify({ from, to: [to], subject, text })
    });
    return res.ok;
  } catch (e) {
    return false;
  }
}

export function siteUrl(env) {
  return (env.SITE_URL || "https://finchasecapital.in").replace(/\/$/, "");
}
