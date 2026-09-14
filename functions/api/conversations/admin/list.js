/* GET /api/conversations/admin/list → all submissions (newest first).
 * Requires admin session (else 404). Before reading, automatically flags
 * submissions older than one year that were never acted on (status 'new'
 * → 'stale'). Nothing is ever auto-deleted; the team reviews flagged rows.
 */
import { json, notFound, requireAdmin } from "../_lib.js";

const LIST_COLS =
  "id, created_at, updated_at, name, email, phone, stage, status, " +
  "nda_request, flagged_at, " +
  "CASE WHEN file_key <> '' THEN 1 ELSE 0 END AS has_file";

export async function onRequestGet(context) {
  const { request, env } = context;
  try {
    if (!env.DB) return notFound();
    if (!(await requireAdmin(request, env))) return notFound();
    try {
      await env.DB.prepare(
        "UPDATE conversations SET status = 'stale', flagged_at = datetime('now'), " +
          "updated_at = datetime('now') " +
          "WHERE status = 'new' AND created_at < datetime('now', '-1 year')"
      ).run();
    } catch (e) {
      /* flagging is best-effort; the list must still load */
    }
    const rows = await env.DB.prepare(
      "SELECT " + LIST_COLS + " FROM conversations ORDER BY created_at DESC LIMIT 500"
    ).all();
    return json({ ok: true, items: rows.results || [] });
  } catch (e) {
    return json({ error: "something went wrong" }, 500);
  }
}
