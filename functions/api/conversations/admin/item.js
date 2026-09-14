/* Admin item endpoints (all require session, else 404):
 *   GET    /api/conversations/admin/item?id=…    → full submission detail
 *   PATCH  /api/conversations/admin/item?id=…    → { status?, notes? }
 *   DELETE /api/conversations/admin/item?id=…    → permanently deletes the row
 *        AND the uploaded file from the private bucket.
 */
import { json, notFound, requireAdmin } from "../_lib.js";

const STATUSES = ["new", "reviewed", "contacted", "stale"];

function idOf(url) {
  try {
    return new URL(url).searchParams.get("id") || "";
  } catch (e) {
    return "";
  }
}

export async function onRequestGet(context) {
  const { request, env } = context;
  try {
    if (!env.DB) return notFound();
    if (!(await requireAdmin(request, env))) return notFound();
    const id = idOf(request.url);
    if (!id) return json({ error: "missing id" }, 400);
    const row = await env.DB.prepare("SELECT * FROM conversations WHERE id = ?").bind(id).first();
    if (!row) return notFound();
    return json({ ok: true, item: row });
  } catch (e) {
    return json({ error: "something went wrong" }, 500);
  }
}

export async function onRequestPatch(context) {
  const { request, env } = context;
  try {
    if (!env.DB) return notFound();
    if (!(await requireAdmin(request, env))) return notFound();
    const id = idOf(request.url);
    if (!id) return json({ error: "missing id" }, 400);
    let body;
    try {
      body = await request.json();
    } catch (e) {
      return json({ error: "bad request" }, 400);
    }
    const sets = [];
    const args = [];
    if (body.status !== undefined) {
      if (STATUSES.indexOf(body.status) < 0) return json({ error: "bad status" }, 400);
      sets.push("status = ?");
      args.push(body.status);
    }
    if (body.notes !== undefined) {
      const notes = String(body.notes).slice(0, 4000);
      sets.push("notes = ?");
      args.push(notes);
    }
    if (!sets.length) return json({ error: "nothing to update" }, 400);
    sets.push("updated_at = datetime('now')");
    args.push(id);
    const res = await env.DB.prepare(
      "UPDATE conversations SET " + sets.join(", ") + " WHERE id = ?"
    )
      .bind(...args)
      .run();
    if (!res.meta || res.meta.changes === 0) return notFound();
    return json({ ok: true });
  } catch (e) {
    return json({ error: "something went wrong" }, 500);
  }
}

export async function onRequestDelete(context) {
  const { request, env } = context;
  try {
    if (!env.DB) return notFound();
    if (!(await requireAdmin(request, env))) return notFound();
    const id = idOf(request.url);
    if (!id) return json({ error: "missing id" }, 400);
    const row = await env.DB.prepare("SELECT file_key FROM conversations WHERE id = ?")
      .bind(id)
      .first();
    if (!row) return notFound();
    await env.DB.prepare("DELETE FROM conversations WHERE id = ?").bind(id).run();
    if (row.file_key && env.CONVERSATIONS_BUCKET) {
      try {
        await env.CONVERSATIONS_BUCKET.delete(row.file_key);
      } catch (e) {
        /* row is gone; a stray object is harmless and never publicly listed */
      }
    }
    return json({ ok: true });
  } catch (e) {
    return json({ error: "something went wrong" }, 500);
  }
}
