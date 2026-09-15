/* Finchase Capital, confidential idea intake.
 *
 * POST /api/conversations/submit (multipart/form-data)
 *   Stores the submission in D1, the optional deck in the private R2 bucket,
 *   rate-limits + honeypot/time-trap against bots, and fires best-effort
 *   notification emails (team + submitter confirmation) via Resend when
 *   configured. Always responds generically so bots learn nothing.
 */
import { json, ipHash, hitRate, sendMail, siteUrl } from "./_lib.js";

const STAGES = ["idea", "registered", "early-revenue", "scaling"];
const FILE_TYPES = {
  pdf: "application/pdf",
  ppt: "application/vnd.ms-powerpoint",
  pptx: "application/vnd.openxmlformats-officedocument.presentationml.presentation",
  doc: "application/msword",
  docx: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  odp: "application/vnd.oasis.opendocument.presentation"
};
const MAX_FILE_BYTES = 10 * 1024 * 1024;
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

function str(v, max) {
  const s = (v === undefined || v === null ? "" : String(v)).trim();
  return s.length > max ? s.slice(0, max) : s;
}

export async function onRequestPost(context) {
  const { request, env } = context;
  try {
    if (!env.DB || !env.CONVERSATIONS_BUCKET) {
      return json({ error: "temporarily unavailable, please email us instead" }, 503);
    }
    let form;
    try {
      form = await request.formData();
    } catch (e) {
      return json({ error: "could not read that submission, please try again" }, 400);
    }
    const g = (k) => (form.get(k) === null || form.get(k) === undefined ? "" : String(form.get(k)));

    /* Honeypot: bots fill it, humans never see it. Pretend success. */
    if (g("company_website").trim() !== "") {
      return json({ ok: true });
    }

    /* Time trap: submitted absurdly fast (<6s) or impossibly late (>24h). */
    const started = Number(g("started_at") || 0);
    const ageMs = Date.now() - started;
    if (!started || ageMs < 6000 || ageMs > 24 * 3600 * 1000) {
      return json({ ok: true });
    }

    const name = str(g("name"), 120);
    const phone = str(g("phone"), 30);
    const email = str(g("email"), 254).toLowerCase();
    const linkedin = str(g("linkedin"), 500);
    const stage = str(g("stage"), 30);
    const building = str(g("building"), 3000);
    const problem = str(g("problem"), 3000);
    const helpNeeded = str(g("help_needed"), 2000);
    const videoUrl = str(g("video_url"), 500);
    const ndaRequest = g("nda_request") === "1" || g("nda_request") === "on";

    if (name.length < 2) return json({ error: "please share your name" }, 400);
    if (!/^[+()\-\s\d]{7,20}$/.test(phone)) {
      return json({ error: "that phone number does not look right" }, 400);
    }
    if (!EMAIL_RE.test(email)) return json({ error: "that email does not look right" }, 400);
    if (linkedin && linkedin.toLowerCase().indexOf("linkedin.com") < 0) {
      return json({ error: "the LinkedIn field should be a linkedin.com profile link" }, 400);
    }
    if (STAGES.indexOf(stage) < 0) {
      return json({ error: "please pick the stage that fits best" }, 400);
    }
    if (building.length < 20) {
      return json({ error: "tell us a little more about what you are building (a couple of lines)" }, 400);
    }
    if (problem.length < 20) {
      return json({ error: "tell us a little more about the problem and who has it" }, 400);
    }
    if (helpNeeded.length < 10) {
      return json({ error: "tell us briefly what kind of help you need" }, 400);
    }
    if (videoUrl && !/^https:\/\/.+\..+/.test(videoUrl)) {
      return json({ error: "the video link should be a full https URL" }, 400);
    }

    /* Rate limits: same visitor and same email cannot flood the form. */
    const ip = await ipHash(request, env);
    if (!(await hitRate(env.DB, "conv:ip-hour:" + ip, 5, 3600))) {
      return json({ error: "too many submissions close together, please try again in an hour" }, 429);
    }
    if (!(await hitRate(env.DB, "conv:ip-day:" + ip, 20, 86400))) {
      return json({ error: "too many submissions today, please try again tomorrow" }, 429);
    }
    if (!(await hitRate(env.DB, "conv:email-day:" + email, 3, 86400))) {
      return json({ error: "we already have recent submissions from this email, please wait a day" }, 429);
    }

    /* Optional deck: private R2 object, never publicly listed or linked. */
    const rowId = crypto.randomUUID();
    let fileKey = "";
    let fileName = "";
    let fileSize = 0;
    let fileType = "";
    const file = form.get("deck");
    if (file && typeof file === "object" && "size" in file && file.size > 0) {
      if (file.size > MAX_FILE_BYTES) {
        return json({ error: "the file must be under 10 MB" }, 400);
      }
      const orig = str(file.name || "deck", 160).replace(/[^\w.\-() ]+/g, "_");
      const ext = (orig.split(".").pop() || "").toLowerCase();
      if (!FILE_TYPES[ext]) {
        return json({ error: "please attach a PDF, PowerPoint, Word or ODP file" }, 400);
      }
      fileKey = "conv/" + rowId + "/" + Date.now() + "-" + orig;
      fileName = orig;
      fileSize = file.size;
      fileType = FILE_TYPES[ext];
      try {
        await env.CONVERSATIONS_BUCKET.put(fileKey, file.stream(), {
          httpMetadata: { contentType: fileType }
        });
      } catch (e) {
        return json({ error: "the file could not be stored, please try again" }, 500);
      }
    }

    try {
      await env.DB.prepare(
        "INSERT INTO conversations (id, name, phone, email, linkedin, stage, building, problem, " +
          "help_needed, video_url, nda_request, file_key, file_name, file_size, file_type, ip_hash, status) " +
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'new')"
      )
        .bind(
          rowId,
          name,
          phone,
          email,
          linkedin,
          stage,
          building,
          problem,
          helpNeeded,
          videoUrl,
          ndaRequest ? 1 : 0,
          fileKey,
          fileName,
          fileSize,
          fileType,
          ip
        )
        .run();
    } catch (e) {
      if (fileKey) {
        try {
          await env.CONVERSATIONS_BUCKET.delete(fileKey);
        } catch (e2) {}
      }
      return json({ error: "temporarily unavailable, please try again" }, 500);
    }

    /* Notifications (best-effort; a failed email never fails the submission). */
    const teamTo = env.TEAM_EMAIL || "";
    const stageLabel = {
      idea: "idea only",
      registered: "registered, no revenue yet",
      "early-revenue": "early revenue",
      scaling: "already scaling"
    }[stage];
    if (teamTo) {
      const lines = [
        "A new confidential startup-idea submission just came in.",
        "",
        "Name: " + name,
        "Email: " + email,
        "Phone: " + phone,
        "LinkedIn: " + (linkedin || "-"),
        "Stage: " + stageLabel,
        "NDA: auto-applied to every submission",
        "File attached: " + (fileName ? fileName + " (" + Math.round(fileSize / 1024) + " KB)" : "none"),
        "Video link: " + (videoUrl || "-"),
        "",
        "What they are building:",
        building,
        "",
        "Problem and who has it:",
        problem,
        "",
        "Help they think they need:",
        helpNeeded,
        "",
        "Review it (login required): " + siteUrl(env) + "/conversations-admin.html"
      ].join("\n");
      await sendMail(env, teamTo, "New confidential idea submission (" + stageLabel + ")", lines);
    }
    const confirmLines = [
      "Hi " + name + ",",
      "",
      "Thank you for trusting us with your idea. This confirms we received it.",
      "",
      "Our confidentiality promise: what you shared stays between you and our internal " +
        "team. We never share, sell, or discuss submissions with anyone else. " +
        "A mutual NDA covers your submission automatically.",
      "",
      "A senior advisor will reply within two business days.",
      "",
      "Finchase Capital · Indore"
    ].join("\n");
    await sendMail(env, email, "We received your idea, kept confidential", confirmLines);

    return json({ ok: true });
  } catch (e) {
    return json({ error: "something went wrong, please try again" }, 500);
  }
}
