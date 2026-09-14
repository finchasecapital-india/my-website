/* Finchase Capital, Rates API (Cloudflare Pages Functions + D1).
 *
 * GET /api/rates → versioned constants consumed by js/tools.js.
 *   Shape: { corp, rebate, slabs:{new,old}, msme, mult, stageMult, cma, foir, meta, detail? }
 *   Slab caps use null for Infinity (client normalises). Cached at the edge for 1h.
 *   Any failure → 503, and the frontend falls back to built-in figures.
 * PUT /api/rates → Bearer ADMIN_TOKEN. Partial update; accepts any subset of the
 *   top-level keys above (slabs_new / slabs_old or nested slabs:{new,old}).
 */
const KNOWN = ["corp", "rebate", "slabs_new", "slabs_old", "msme", "mult", "stageMult", "cma", "foir", "meta"];

function upsert(db, key, value) {
  return db
    .prepare(
      "INSERT INTO rates (key, value, effective_from, source, updated_at) " +
        "VALUES (?, ?, COALESCE((SELECT effective_from FROM rates WHERE key = ?), date('now')), " +
        "COALESCE((SELECT source FROM rates WHERE key = ?), 'admin update'), datetime('now')) " +
        "ON CONFLICT(key) DO UPDATE SET value = excluded.value, updated_at = datetime('now')"
    )
    .bind(key, JSON.stringify(value), key, key);
}

export async function onRequestGet(context) {
  const cached = await caches.default.match(context.request);
  if (cached) return cached;
  try {
    if (!context.env.DB) throw new Error("no-db");
    const rows = await context.env.DB.prepare("SELECT key, value, effective_from, source FROM rates").all();
    const d = {};
    for (const r of rows.results || []) {
      try {
        d[r.key] = { v: JSON.parse(r.value), from: r.effective_from, src: r.source };
      } catch (e) {
        /* skip malformed row */
      }
    }
    for (const k of KNOWN) {
      if (!d[k]) throw new Error("missing:" + k);
    }
    const detail = {};
    for (const k of KNOWN) detail[k] = { effective_from: d[k].from, source: d[k].src };
    const body = JSON.stringify({
      corp: d.corp.v,
      rebate: d.rebate.v,
      slabs: { new: d.slabs_new.v, old: d.slabs_old.v },
      msme: d.msme.v,
      mult: d.mult.v,
      stageMult: d.stageMult.v,
      cma: d.cma.v,
      foir: d.foir.v,
      meta: d.meta.v,
      detail
    });
    const res = new Response(body, {
      headers: { "Content-Type": "application/json", "Cache-Control": "public, max-age=3600" }
    });
    context.waitUntil(caches.default.put(context.request, res.clone()));
    return res;
  } catch (e) {
    return Response.json({ error: "rates unavailable" }, { status: 503 });
  }
}

export async function onRequestPut(context) {
  const token = context.env.ADMIN_TOKEN || "";
  const got = (context.request.headers.get("Authorization") || "").replace(/^Bearer\s+/i, "");
  if (!token || got !== token) {
    return Response.json({ error: "unauthorized" }, { status: 401 });
  }
  if (!context.env.DB) {
    return Response.json({ error: "no-db" }, { status: 503 });
  }
  let body;
  try {
    body = await context.request.json();
  } catch (e) {
    return Response.json({ error: "bad json" }, { status: 400 });
  }
  const stmts = [];
  const take = (key, value, isArr) => {
    if (value === undefined || value === null) return;
    if (isArr && !Array.isArray(value)) return;
    if (!isArr && (typeof value !== "object" || Array.isArray(value))) return;
    stmts.push(upsert(context.env.DB, key, value));
  };
  for (const k of ["corp", "rebate", "msme", "mult", "stageMult", "cma", "foir", "meta"]) take(k, body[k], false);
  take("slabs_new", body.slabs_new, true);
  take("slabs_old", body.slabs_old, true);
  if (body.slabs && typeof body.slabs === "object" && !Array.isArray(body.slabs)) {
    take("slabs_new", body.slabs.new, true);
    take("slabs_old", body.slabs.old, true);
  }
  if (!stmts.length) {
    return Response.json({ error: "nothing to update" }, { status: 400 });
  }
  await context.env.DB.batch(stmts);
  try {
    await caches.default.delete(context.request.url);
  } catch (e) {
    /* cache purge is best-effort */
  }
  return Response.json({ ok: true, updated: stmts.length });
}

