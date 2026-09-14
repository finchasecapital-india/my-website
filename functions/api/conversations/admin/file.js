/* GET /api/conversations/admin/file?id=… → streams the uploaded deck.
 * Requires admin session (else 404). Served as an attachment with
 * no-store, so the file is never cached and never has a public URL.
 */
import { json, notFound, requireAdmin } from "../_lib.js";

export async function onRequestGet(context) {
  const { request, env } = context;
  try {
    if (!env.DB || !env.CONVERSATIONS_BUCKET) return notFound();
    if (!(await requireAdmin(request, env))) return notFound();
    let id = "";
    try {
      id = new URL(request.url).searchParams.get("id") || "";
    } catch (e) {}
    if (!id) return json({ error: "missing id" }, 400);
    const row = await env.DB.prepare(
      "SELECT file_key, file_name, file_type, file_size FROM conversations WHERE id = ?"
    )
      .bind(id)
      .first();
    if (!row || !row.file_key) return notFound();
    const obj = await env.CONVERSATIONS_BUCKET.get(row.file_key);
    if (!obj) return notFound();
    const safeName = String(row.file_name || "deck").replace(/["\r\n]+/g, "_");
    return new Response(obj.body, {
      status: 200,
      headers: {
        "Content-Type": row.file_type || "application/octet-stream",
        "Content-Disposition": 'attachment; filename="' + safeName + '"',
        "Content-Length": String(row.file_size || obj.size || ""),
        "Cache-Control": "no-store"
      }
    });
  } catch (e) {
    return json({ error: "something went wrong" }, 500);
  }
}
