/* POST /api/conversations/admin/logout → clears the session cookie. */
import { json, getCookie, sha256Hex, clearAdminCookieHeader } from "../_lib.js";

export async function onRequestPost(context) {
  const { request, env } = context;
  try {
    if (env.DB) {
      const raw = getCookie(request, "fc_conv_admin");
      if (raw) {
        try {
          await env.DB.prepare("DELETE FROM admin_sessions WHERE token_hash = ?")
            .bind(await sha256Hex(raw))
            .run();
        } catch (e) {}
      }
    }
  } catch (e) {}
  return new Response(JSON.stringify({ ok: true }), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
      "Cache-Control": "no-store",
      "Set-Cookie": clearAdminCookieHeader()
    }
  });
}
