/* POST /api/conversations/admin/login  { token } → session cookie (12h).
 * Rate-limited. Wrong token → 401 (this endpoint must exist publicly so the
 * team can log in; everything else admin returns 404 when unauthenticated).
 */
import { json, sha256Hex, safeEqual, hitRate, adminCookieHeader, clientIp } from "../_lib.js";

export async function onRequestPost(context) {
  const { request, env } = context;
  try {
    if (!env.DB || !env.ADMIN_TOKEN) {
      return json({ error: "admin login is not configured yet" }, 503);
    }
    if (!(await hitRate(env.DB, "conv:login:" + clientIp(request), 8, 60))) {
      return json({ error: "too many attempts, wait a minute and try again" }, 429);
    }
    let body;
    try {
      body = await request.json();
    } catch (e) {
      return json({ error: "bad request" }, 400);
    }
    const got = typeof body.token === "string" ? body.token : "";
    if (!got || !safeEqual(got, env.ADMIN_TOKEN)) {
      return json({ error: "wrong password" }, 401);
    }
    const bytes = new Uint8Array(32);
    crypto.getRandomValues(bytes);
    const token = [...bytes].map((b) => b.toString(16).padStart(2, "0")).join("");
    const h = await sha256Hex(token);
    await env.DB.prepare(
      "INSERT INTO admin_sessions (token_hash, expires_at) VALUES (?, datetime('now', '+12 hours'))"
    )
      .bind(h)
      .run();
    try {
      await env.DB.prepare("DELETE FROM admin_sessions WHERE expires_at <= datetime('now')").run();
    } catch (e) {}
    return new Response(JSON.stringify({ ok: true }), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "no-store",
        "Set-Cookie": adminCookieHeader(token, 12 * 3600)
      }
    });
  } catch (e) {
    return json({ error: "something went wrong" }, 500);
  }
}
