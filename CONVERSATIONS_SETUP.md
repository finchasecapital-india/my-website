# "Start the Conversation" — setup guide (one-time, ~20 minutes)

Everything below is dashboard clicking plus copy-paste. No backend code to write:
all of it already lives in this repo (`start-conversation.html`,
`conversations-admin.html`, `js/start-conversation.js`,
`functions/api/conversations/*`, `schema-conversations.sql`).

Public page: `https://finchasecapital.in/start-conversation.html`
Team inbox: `https://finchasecapital.in/conversations-admin.html` (unlinked, noindexed)

---

## 1. Database (D1) — 5 minutes

Reuse the same D1 database the site already uses for rates (its binding is
already called `DB`).

1. Install wrangler once and log in (on your own machine):
   `npm i -g wrangler` then `wrangler login`
2. Apply the new tables (re-runnable, does not touch the `rates` table):
   `wrangler d1 execute <your-database-name> --remote --file=schema-conversations.sql`
3. In the Cloudflare dashboard, go to **Workers & Pages → your Pages project →
   Settings → Functions → D1 database bindings** and confirm a binding named
   `DB` points at that database. (The rates API already needs this, so it is
   most likely already there.)

## 2. Private file storage (R2) — 5 minutes

Pitch decks must live somewhere with no public URL at all.

1. Dashboard: **R2 object storage → Create bucket**, name it
   `finchase-conversations`. Leave all defaults (private).
2. **Workers & Pages → your Pages project → Settings → Functions → R2 bucket
   bindings → Add binding**, variable name exactly
   `CONVERSATIONS_BUCKET`, bucket `finchase-conversations`.
3. Redeploy (push any commit, or **Deployments → Retry deployment**) so the
   binding takes effect.

## 3. Secrets — 3 minutes

**Workers & Pages → your Pages project → Settings → Environment variables**
(add as **Secrets**, same values for Production and Preview):

| Variable         | Required? | What to put |
|------------------|-----------|-------------|
| `ADMIN_TOKEN`    | Yes       | A long random password for the team inbox (e.g. 40+ characters). You may already have one set for the rates API — reuse it, the inbox uses the same secret. |
| `TEAM_EMAIL`     | For email alerts | Where new-submission notifications go, e.g. `finchasecapital@gmail.com`. |
| `RESEND_API_KEY` | For email alerts | Key from resend.com (free tier: 100 emails/day — far above this form's volume). Without it, everything still works; emails are simply skipped and the inbox page becomes the notification surface. |
| `FROM_EMAIL`     | Only with Resend | Sending address on a domain you verified in Resend, e.g. `ideas@finchasecapital.in`. Defaults to that if unset. |
| `SITE_URL`       | No | Defaults to `https://finchasecapital.in`. Only set if testing elsewhere. |
| `IP_PEPPER`      | No | Any random string; used to hash visitor IPs before storing. Defaults set. |

Resend domain check (only if you want the two emails): Resend → Domains →
Add `finchasecapital.in` → it gives you 2–3 DNS records → add them in
Cloudflare **DNS** (you're already on Cloudflare, so verification is usually
instant). Until then, leave the key out; nothing breaks.

## 4. Deploy — 1 minute

`git add -A && git commit -m "Start the Conversation page" && git push`.
Cloudflare Pages builds and the new API routes go live with it. No separate
backend deploy, no servers, no cron jobs to manage.

## 5. Test — 5 minutes

1. Open `/start-conversation.html`, submit with your own details and a small PDF.
2. You should see "Received. It's just between us." mentioning a reply
   **within two business days**.
3. If `TEAM_EMAIL` + `RESEND_API_KEY` are set: inbox gets the internal alert,
   you get the confirmation email restating confidentiality.
4. Open `/conversations-admin.html`, log in with `ADMIN_TOKEN`: the row is
   there, file downloads, mark reviewed → add a note → delete it (file goes
   too). Confirm the row and file are gone.

## 6. How each requirement is met (for your records)

- **Private by default:** submissions live only in D1 + the private R2 bucket.
  There is no public API that lists them; admin endpoints return 404 without a
  valid 12-hour HttpOnly session cookie. The admin page is unlinked, carries
  `noindex`, and is disallowed in `robots.txt`. Files are streamed only through
  the authed download endpoint as attachments with `no-store` — no public URLs.
- **Spam bots:** hidden honeypot field (bots fill it, humans can't see it),
  minimum-fill-time trap, plus server-side validation on everything.
- **Flooding:** same visitor capped at 5/hour and 20/day; same email 3/day.
- **Yearly review, no indefinite hoarding:** every time the inbox loads, any
  submission older than one year that was never acted on (`new`) is flagged
  `stale` ("Year+ old" filter) for the team to review or delete. Nothing is
  ever auto-deleted. This runs inside the existing list endpoint, so it needs
  no scheduler, worker, or extra paid service.
- **Free-tier fit:** D1 (5 GB, millions of reads), R2 (10 GB), Pages Functions
  (100k requests/day) and Resend (100 emails/day) all stay deep inside free
  limits at this form's volume.

## 7. Ongoing maintenance (almost none)

- Change the admin password anytime by updating the `ADMIN_TOKEN` secret.
- Old `rate_hits` rows prune themselves on every check.
- If you ever regenerate the site with `generate.ps1`, these files are
  standalone and untouched — but re-apply nothing; just don't delete them.
- To link the page publicly later, add it to the nav/footer/sitemap like any
  other page; the admin page must stay unlinked.
