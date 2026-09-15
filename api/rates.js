/* GET /api/rates, versioned public rates for the Finchase tools hub.
 *
 * Deploy: push this repo to Vercel, files under api/ become endpoints automatically.
 *   No config needed. Response is cacheable (1h) and CORS-open for GET.
 * Update rates WITHOUT redeploying the frontend: edit ../data/rates.json
 *   (values + meta.version + meta.verified) and redeploy just the API
 *   (or point this file at a KV/blob store later, the shape stays the same).
 * Netlify: move this file to netlify/functions/rates.js, the .handler export
 *   below already matches Netlify's (event) => {statusCode, body} shape.
 */
const RATES = require("../data/rates.json");

function payload() {
  return JSON.stringify(RATES);
}

function vercelHandler(req, res) {
  if (req.method === "OPTIONS") {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
    res.statusCode = 204;
    res.end();
    return;
  }
  if (req.method !== "GET") {
    res.statusCode = 405;
    res.setHeader("Allow", "GET");
    res.end("Method not allowed");
    return;
  }
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Cache-Control", "public, max-age=3600, stale-while-revalidate=86400");
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.end(payload());
}

module.exports = vercelHandler;
module.exports.handler = async () => ({
  statusCode: 200,
  headers: {
    "Content-Type": "application/json",
    "Cache-Control": "public, max-age=3600, stale-while-revalidate=86400",
    "Access-Control-Allow-Origin": "*"
  },
  body: payload()
});

