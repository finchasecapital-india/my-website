/* Finchase Capital, Tools hub: shared framework + renderers (rules as per FY 2025-26).
   Tool content lives in TOOL_DEFS below (data + pure compute fns). No bespoke per-tool
   wiring: every tool renders through one of the shared renderers. */
(() => {
"use strict";

/* ---------- tiny DOM helpers ---------- */
const $ = (s, e) => (e || document).querySelector(s);
const $$ = (s, e) => Array.prototype.slice.call((e || document).querySelectorAll(s));
const esc = s => String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");

/* ---------- Indian money helpers ---------- */
function inr0(n) { n = Math.round(Number(n) || 0); return "₹" + n.toLocaleString("en-IN"); }
function trim2(n) { return String(Math.round(Number(n) * 100) / 100); }
function fmtShort(n) {
  n = Number(n) || 0; const a = Math.abs(n);
  if (a >= 1e7) return "₹" + trim2(n / 1e7) + " Cr";
  if (a >= 1e5) return "₹" + trim2(n / 1e5) + " L";
  return inr0(n);
}
/* Parses "50L", "1.5cr", "8,00,00,000", "₹2500000" into absolute rupees. */
function parseINR(v) {
  if (v === null || v === undefined) return NaN;
  let s = String(v).trim().toLowerCase().replace(/₹/g, "").replace(/,/g, "").trim();
  if (!s) return NaN;
  s = s.replace(/\brs\b\.?/g, "").trim();
  let m = 1;
  const u = s.match(/(crore|cr|lakh|lac|thousand|l|k|c)$/);
  if (u) {
    const t = u[1]; s = s.slice(0, s.length - t.length).trim();
    if (t === "crore" || t === "cr" || t === "c") m = 1e7;
    else if (t === "lakh" || t === "lac" || t === "l") m = 1e5;
    else if (t === "thousand" || t === "k") m = 1e3;
  }
  const n = parseFloat(s);
  return isNaN(n) ? NaN : n * m;
}
function echoINR(n) {
  if (isNaN(n)) return "";
  return " = " + inr0(n) + (Math.abs(n) >= 1e5 ? " (" + fmtShort(n).replace("₹", "") + ")" : "");
}

/* ---------- persistence (best-effort localStorage) ---------- */
function storeGet(k, fb) { try { const r = localStorage.getItem(k); return r ? JSON.parse(r) : fb; } catch (e) { return fb; } }
function storeSet(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) {} }

/* ---------- validation ---------- */
function setErr(input, err, msg) {
  if (err) err.textContent = msg || "";
  if (input) input.setAttribute("aria-invalid", msg ? "true" : "false");
}
function valNum(input, rule) {
  rule = rule || {};
  const wrap = input.closest ? input.closest(".field") : null;
  const err = wrap ? $(".err", wrap) : null;
  if (rule.allowBlank && input.value.trim() === "") { setErr(input, err, ""); return { ok: true, val: NaN, blank: true }; }
  const n = parseINR(input.value);
  let msg = "";
  if (isNaN(n)) msg = "Enter a number, L / Cr works too (e.g. 50L).";
  else if (rule.min !== undefined && n < rule.min) msg = "Must be " + fmtShort(rule.min) + " or more.";
  else if (rule.max !== undefined && n > rule.max) msg = "Must be " + fmtShort(rule.max) + " or less.";
  setErr(input, err, msg);
  return { ok: !msg, val: n };
}

/* ---------- field builders ---------- */
function numField(d) {
  return '<label class="field"><span>' + esc(d.label) +
    (d.help ? ' <small class="fh">' + esc(d.help) + "</small>" : "") + "</span>" +
    '<span class="inwrap"><input data-k="' + esc(d.k) + '" type="text" inputmode="decimal" placeholder="' + esc(d.ph || "") + '" value="' + esc(d.def !== undefined ? d.def : "") + '"><span class="echo" aria-hidden="true"></span></span>' +
    '<span class="err" role="alert"></span></label>';
}
function selField(d) {
  const opts = d.opts.map(o => '<option value="' + esc(o[0]) + '"' + (String(o[0]) === String(d.def) ? " selected" : "") + ">" + esc(o[1]) + "</option>").join("");
  return '<label class="field"><span>' + esc(d.label) + "</span>" + '<select data-k="' + esc(d.k) + '">' + opts + "</select></label>";
}

/* ---------- shared section shell + assumptions ---------- */
const CATS = { founders: "Founders & Business", personal: "Individuals & Households", trackers: "Trackers" };
function assumptions(t) {
  return '<details class="assume"><summary>Assumptions &amp; verified date</summary>' +
    '<p class="micro">Verified: ' + esc(t.verified) + "</p><ul>" +
    (t.assumptions || []).map(a => "<li>" + a + "</li>").join("") + "</ul>" +
    '<p class="micro">Indicative only, provisions are simplified. <a href="contact.html">Confirm with an advisor →</a></p></details>';
}
function sectionShell(t) {
  return '<section class="glass-card tool-card tool-sec collapsed" id="sec-' + t.id + '">' +
    '<button class="tool-toggle" type="button" aria-expanded="false" aria-controls="sec-' + t.id + '-body" aria-label="Expand ' + esc(t.title) + '"></button>' +
    '<span class="tcat">' + esc(CATS[t.cat] || t.cat) + " · " + esc(t.type) + "</span>" +
    "<h2>" + esc(t.title) + "</h2><p>" + esc(t.desc) + "</p>" +
    '<div class="tool-collapsible" id="sec-' + t.id + '-body">' +
    '<div class="tool-body"></div><div class="tool-out" aria-live="polite"></div>' +
    assumptions(t) +
    '<p class="micro tool-cta">Want the full working papers? <a href="contact.html">Talk to an advisor →</a></p></div></section>';
}

/* ---------- generic calculator renderer ---------- */
function renderCalc(sec, t) {
  const body = $(".tool-body", sec), out = $(".tool-out", sec);
  body.innerHTML = t.inputs.map(d => (d.opts ? selField(d) : numField(d))).join("");
  const echo = () => {
    t.inputs.forEach(d => {
      if (d.opts) return;
      const inp = $("[data-k='" + d.k + "']", body);
      const n = parseINR(inp.value);
      const e = $(".echo", inp.closest(".field"));
      if (e) e.textContent = isNaN(n) ? "" : echoINR(n);
    });
  };
  const run = () => {
    echo();
    const vals = {}; let ok = true;
    t.inputs.forEach(d => {
      if (d.opts) { vals[d.k] = $("[data-k='" + d.k + "']", body).value; return; }
      const r = valNum($("[data-k='" + d.k + "']", body), d);
      if (!r.ok) ok = false; vals[d.k] = r.val;
    });
    if (!ok) { out.innerHTML = '<p class="micro">Fix the highlighted fields to see results.</p>'; return; }
    const res = t.compute(vals);
    out.innerHTML = '<div class="res-rows">' +
      res.rows.map(r => '<div class="res-row"><span>' + r[0] + "</span><strong>" + r[1] + "</strong></div>").join("") +
      "</div>" + (res.note ? '<p class="micro">' + res.note + "</p>" : "");
  };
  body.addEventListener("input", run);
  body.addEventListener("change", run);
  run();
}

/* ---------- diagnostic quiz renderer (score → tiered verdict → CTA) ---------- */
function renderQuiz(sec, t) {
  const body = $(".tool-body", sec), out = $(".tool-out", sec);
  body.innerHTML = '<div class="quiz">' + t.qs.map((q, i) =>
    "<fieldset><legend>" + (i + 1) + ". " + esc(q.q) + '</legend><div class="pills">' +
    q.opts.map(o => '<label class="pill-opt"><input type="radio" name="' + t.id + "-q" + i + '" value="' + o.s + '"> ' + esc(o.t) + "</label>").join("") +
    "</div></fieldset>").join("") +
    '<button class="btn btn-primary" type="button">See my score</button></div>';
  $("button", body).addEventListener("click", () => {
    const fd = []; let max = 0, answered = 0;
    t.qs.forEach((q, i) => {
      const sel = $("input[name='" + t.id + "-q" + i + "']:checked", body);
      max += Math.max.apply(null, q.opts.map(o => o.s));
      if (sel) { answered++; fd.push(Number(sel.value)); }
    });
    if (answered < t.qs.length) { out.innerHTML = '<p class="micro">Answer all ' + t.qs.length + " questions to score this diagnostic.</p>"; return; }
    const s = fd.reduce((a, b) => a + b, 0);
    const pct = Math.round((s / max) * 100);
    let v = t.tiers[t.tiers.length - 1][1];
    for (const th of t.tiers) { if (pct >= th[0]) { v = th[1]; break; } }
    out.innerHTML = "<div class='res-rows'><div class='res-row'><span>" + esc(t.title) + "</span><strong>" + pct + "<span style='font-size:1rem'>/100</span></strong></div></div>" +
      "<p><strong>" + v + "</strong></p>" +
      "<p><a class='btn btn-primary' href='contact.html'>" + esc(t.cta || "Book the action-plan call →") + "</a></p>";
  });
}

/* ---------- compliance checklist renderer (data-driven + persisted + printable) ---------- */
function renderChecklist(sec, t) {
  const body = $(".tool-body", sec), out = $(".tool-out", sec);
  const LS = "fcT1.compliance";
  body.innerHTML =
    '<p class="micro">Rules as per <strong>FY 2025-26</strong> · verified Apr 2026. State-specific items are flagged.</p>' +
    '<div class="row-2">' +
    '<label class="field"><span>Company type</span><select id="comp-type"><option value="pvt">Pvt Ltd</option><option value="llp">LLP</option><option value="opc">OPC</option><option value="startup">DPIIT Startup</option></select></label>' +
    '<label class="field"><span>Stage</span><select id="comp-stage"><option value="new">Newly incorporated</option><option value="mid">1–3 years</option><option value="late">3+ years</option></select></label>' +
    "</div><div id='comp-list'></div>" +
    '<div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:14px"><button class="btn btn-secondary" type="button" id="comp-print">Print / save PDF</button>' +
    '<button class="btn btn-ghost" type="button" id="comp-reset">Reset checklist</button></div>';
  const paint = () => {
    const key = $("#comp-type", body).value + "|" + $("#comp-stage", body).value;
    const data = t.groups[key] || t.groups["pvt|new"];
    const saved = storeGet(LS, {});
    const done = saved[key] || [];
    let total = 0, ticked = 0;
    $("#comp-list", body).innerHTML = Object.keys(data).map(g => {
      const items = data[g].map((it, i) => {
        const id = g + ":" + i; total++;
        const on = done.indexOf(id) !== -1; if (on) ticked++;
        return '<label class="' + (on ? "done" : "") + '"><input type="checkbox" data-id="' + esc(id) + '"' + (on ? " checked" : "") + "><span>" + esc(it.t) +
          (it.due ? ' <em class="due">Due: ' + esc(it.due) + "</em>" : "") +
          (it.note ? '<small class="cnote">' + esc(it.note) + "</small>" : "") + "</span></label>";
      }).join("");
      return '<h4 class="group-h">' + esc(g) + "</h4>" + items;
    }).join("");
    $$("input[type=checkbox]", $("#comp-list", body)).forEach(cb => cb.addEventListener("change", () => {
      const s = storeGet(LS, {}); const arr = s[key] || [];
      const id = cb.dataset.id;
      s[key] = cb.checked ? arr.concat([id]) : arr.filter(x => x !== id);
      storeSet(LS, s); paint();
    }));
    out.innerHTML = "<p><strong>" + ticked + " of " + total + " done.</strong> Progress saves in this browser automatically.</p>";
  };
  $("#comp-type", body).addEventListener("change", paint);
  $("#comp-stage", body).addEventListener("change", paint);
  $("#comp-reset", body).addEventListener("click", () => {
    const key = $("#comp-type", body).value + "|" + $("#comp-stage", body).value;
    const s = storeGet(LS, {}); delete s[key]; storeSet(LS, s); paint();
  });
  $("#comp-print", body).addEventListener("click", () => {
    const go = () => {
      document.body.classList.add("print-checklist");
      setTimeout(() => { window.print(); setTimeout(() => document.body.classList.remove("print-checklist"), 800); }, 60);
    };
    if (window.openGate) window.openGate(go); else go();
  });
  paint();
}

/* ---------- vesting renderer (correct cliff-then-monthly curve) ---------- */
function renderVest(sec, t) {
  const body = $(".tool-body", sec), out = $(".tool-out", sec);
  body.innerHTML =
    '<div class="row-2">' +
    '<label class="field"><span>Equity pool %</span><input data-k="pool" type="text" inputmode="decimal" value="12" placeholder="e.g. 12"><span class="err" role="alert"></span></label>' +
    '<label class="field"><span>Cliff (months)</span><input data-k="cliff" type="text" inputmode="numeric" value="12" placeholder="e.g. 12"><span class="err" role="alert"></span></label>' +
    '<label class="field"><span>Total vest (months)</span><input data-k="total" type="text" inputmode="numeric" value="48" placeholder="e.g. 48"><span class="err" role="alert"></span></label>' +
    '<label class="field"><span>Co-founders sharing it</span><input data-k="n" type="text" inputmode="numeric" value="2" placeholder="e.g. 2"><span class="err" role="alert"></span></label>' +
    "</div>" +
    '<svg id="vest-svg-' + t.id + '" viewBox="0 0 300 100" width="100%" height="120" role="img" aria-label="Vesting curve chart"></svg>' +
    '<div style="max-height:240px;overflow:auto"><table class="track-table vest-table"><thead><tr><th>Month</th><th>Pool vested</th><th>Per founder</th></tr></thead><tbody id="vest-b-' + t.id + '"></tbody></table></div>';
  const g = k => $("[data-k='" + k + "']", body);
  const run = () => {
    const P = valNum(g("pool"), { min: 0.1, max: 100 });
    const C = valNum(g("cliff"), { min: 0, max: 120 });
    const T = valNum(g("total"), { min: 1, max: 120 });
    const N = valNum(g("n"), { min: 1, max: 20 });
    if (!P.ok || !C.ok || !T.ok || !N.ok) { out.innerHTML = '<p class="micro">Fix the highlighted fields to see the curve.</p>'; return; }
    const p = P.val, cliff = Math.floor(C.val), total = Math.floor(T.val), n = Math.max(1, Math.floor(N.val));
    if (cliff > total) { setErr(g("cliff"), $(".err", g("cliff").closest(".field")), "Cliff can't exceed total vest."); out.innerHTML = ""; return; }
    const tb = $("#vest-b-" + t.id, body), svg = $("#vest-svg-" + t.id, body);
    tb.innerHTML = ""; const pts = [];
    for (let m = 0; m <= total; m++) {
      let cum = 0;
      if (m >= cliff) cum = (cliff >= total) ? p : Math.min(p, p * (cliff / total + ((m - cliff) / (total - cliff)) * (1 - cliff / total)));
      const per = cum / n;
      const tr = document.createElement("tr");
      const tds = [("M" + m), cum.toFixed(2) + "%", per.toFixed(2) + "%"];
      tds.forEach((x, i) => { const td = document.createElement("td"); td.textContent = x; tr.appendChild(td); });
      tb.appendChild(tr);
      pts.push([m / total, cum / Math.max(p, 0.01)]);
    }
    const d = pts.map((pt, i) => (i ? "L" : "M") + (10 + pt[0] * 280) + "," + (90 - pt[1] * 70)).join(" ");
    svg.innerHTML = "";
    const mk = (tag, attrs) => { const el = document.createElementNS("http://www.w3.org/2000/svg", tag); for (const k in attrs) el.setAttribute(k, attrs[k]); return el; };
    svg.appendChild(mk("path", { d: d + " L 290 90 L 10 90 Z", fill: "rgba(84,76,217,0.15)" }));
    svg.appendChild(mk("path", { d: d, fill: "none", stroke: "#544CD9", "stroke-width": "2" }));
    const atCliff = cliff >= total ? p : p * (cliff / total);
    out.innerHTML = "<p><strong>" + atCliff.toFixed(1) + "% vests at the month-" + cliff + " cliff</strong>, then monthly to " + p.toFixed(1) + "% by month " + total + " (" + (p / n).toFixed(2) + "% per founder).</p>";
  };
  body.addEventListener("input", run); run();
}

const RENDER = { calc: renderCalc, quiz: renderQuiz, checklist: renderChecklist, vest: renderVest };

/* ================= TOOL DEFINITIONS (data + pure compute) ================= */
const TOOLS = [];

/* ---------- shared tax math (FY 2025-26) ---------- */
function slabTax(inc, slabs) {
  let t = 0, prev = 0; inc = Math.max(0, inc);
  for (const s of slabs) { if (inc <= prev) break; t += (Math.min(inc, s[0]) - prev) * s[1]; prev = s[0]; }
  return t;
}
const IND_NEW = [[400000, 0], [800000, .05], [1200000, .10], [1600000, .15], [2000000, .20], [2400000, .25], [Infinity, .30]];
const IND_OLD = [[250000, 0], [500000, .05], [1000000, .20], [Infinity, .30]];
const withCess = t => t * 1.04;

/* ---------- live rates (GET api/rates, graceful fallback to built-ins) ---------- */
const R = {
  corp: { baa: .22, baaSur: .10, std: .25, stdBig: .30, sur1: .07, sur2: .12, llp: .30, llpSur: .12, cess: .04 },
  rebate: { old: 500000, neu: 1200000 },
  slabsNew: IND_NEW.map(s => s.slice()),
  slabsOld: IND_OLD.map(s => s.slice()),
  msme: { micro: [2.5e7, 1e8], small: [2.5e8, 1e9], medium: [1.25e9, 5e9] },
  mult: { saas: [8, 12, 18, 28], fintech: [6, 10, 14, 22], consumer: [2, 4, 8, 14], manufacturing: [1.2, 2.5, 6, 10], health: [4, 7, 12, 18], logistics: [1.5, 3, 8, 12], edtech: [3, 6, 10, 16], other: [2, 4, 8, 14] },
  stageMult: { pre: .7, early: .9, growth: 1, ent: 1.15 },
  cma: { wc: .25, margin: .05 },
  foir: { ok: 40, stretch: 60 },
  verified: "Sep 2026 · FY 2025-26 (built-in)"
};
async function loadRates() {
  const note = document.getElementById("rates-note");
  try {
    const res = await fetch("api/rates", { cache: "no-store" });
    if (!res.ok) throw new Error("http " + res.status);
    const r = await res.json();
    if (r.corp) Object.assign(R.corp, r.corp);
    if (r.rebate) Object.assign(R.rebate, r.rebate);
    const norm = a => a.map(s => [(s[0] === null || s[0] === undefined) ? Infinity : s[0], s[1]]);
    if (r.slabs) {
      if (r.slabs.new) R.slabsNew = norm(r.slabs.new);
      if (r.slabs.old) R.slabsOld = norm(r.slabs.old);
    }
    if (r.msme) Object.assign(R.msme, r.msme);
    if (r.mult) Object.assign(R.mult, r.mult);
    if (r.stageMult) Object.assign(R.stageMult, r.stageMult);
    if (r.cma) Object.assign(R.cma, r.cma);
    if (r.foir) Object.assign(R.foir, r.foir);
    if (r.meta && r.meta.verified) R.verified = r.meta.verified + (r.meta.fy ? " · " + r.meta.fy : "") + " · live rates";
    if (note) note.textContent = "Rates live · verified " + R.verified + ".";
  } catch (e) {
    if (note) note.textContent = "Rates baseline: FY 2025-26 (Sep 2026), showing built-in figures.";
  }
}

TOOLS.push(
{ id: "profit-tax", render: "calc", type: "Calculator", cat: "founders",
  title: "Business Tax: Company vs LLP vs Proprietor",
  desc: "What the same taxable profit actually costs under each structure, real slabs and rates, FY 2025-26.",
  verified: "Sep 2026 · rates as per FY 2025-26 (Budget 2025 slabs)",
  assumptions: ["22% concessional rate u/s 115BAA (effective 25.17% with 10% surcharge + 4% cess).", "25% standard company rate where turnover is up to ₹400 Cr (30% above); surcharge 7% over ₹1 Cr, 12% over ₹10 Cr.", "LLP/firm 30% + 12% surcharge above ₹1 Cr. 4% cess everywhere.", "Proprietor taxed as an individual (see slabs); new-regime 87A rebate nil tax up to ₹12L, salaried standard deduction (₹75k) and marginal relief not modelled; surcharge above ₹50L not modelled.", "MAT/AMT not modelled, confirm before deciding."],
  inputs: [
    { k: "P", label: "Taxable profit for the year", ph: "e.g. 80L or 8000000", def: "8000000", min: 0, max: 1e12 },
    { k: "who", label: "I am a…", def: "company", opts: [["company", "Private limited company"], ["llp", "LLP / partnership firm"], ["prop", "Proprietor (individual)"]] },
    { k: "big", label: "Company turnover above ₹400 Cr?", def: "no", opts: [["no", "No, ₹400 Cr or less"], ["yes", "Yes, above ₹400 Cr"]] }
  ],
  compute(v) {
    const P = v.P, rows = [], C = R.corp;
    if (v.who === "company") {
      const a = C.baa * (1 + C.baaSur) * (1 + C.cess) * P;
      const r = v.big === "yes" ? C.stdBig : C.std;
      const s = P > 1e8 ? C.sur2 : (P > 1e7 ? C.sur1 : 0);
      const b = r * (1 + s) * (1 + C.cess) * P;
      rows.push(["115BAA concessional (22%)", inr0(a)], ["Standard rate" + (v.big === "yes" ? " (30%)" : " (25%)"), inr0(b)], ["Difference", inr0(Math.abs(a - b)) + (a < b ? " saved under 115BAA" : " saved under standard")]);
      return { rows, note: "115BAA bars certain exemptions and MAT credit, the lower rate is not free money. Confirm eligibility before opting." };
    }
    if (v.who === "llp") {
      const s = P > 1e7 ? C.llpSur : 0;
      rows.push(["LLP / firm tax", inr0(C.llp * (1 + s) * (1 + C.cess) * P)]);
      return { rows, note: "Partners are taxed separately on remuneration and profit share, model the combined incidence, not just the firm." };
    }
    const o = P <= R.rebate.old ? 0 : withCess(slabTax(P, R.slabsOld));
    const n = P <= R.rebate.neu ? 0 : withCess(slabTax(P, R.slabsNew));
    rows.push(["Old regime (standard slabs)", inr0(o)], ["New regime (default)", inr0(n)],
      ["Better option", o < n ? "Old regime by " + inr0(n - o) : (n < o ? "New regime by " + inr0(o - n) : "Identical")]);
    return { rows, note: "87A rebate applied (nil tax up to ₹5L old / ₹12L new). Before personal deductions, use the Regime Comparator for deduction-adjusted math." };
  }
},
{ id: "msme", render: "calc", type: "Calculator", cat: "founders",
  title: "MSME Udyam Classification Checker",
  desc: "Micro, Small or Medium? Both investment and turnover must hold, the tool finds the binding one.",
  verified: "Sep 2026 · revised criteria w.e.f. 1 Apr 2025 (S.O. 1364(E))",
  assumptions: ["Micro: investment ≤ ₹2.5 Cr and turnover ≤ ₹10 Cr. Small: ≤ ₹25 Cr and ≤ ₹100 Cr. Medium: ≤ ₹125 Cr and ≤ ₹500 Cr (w.e.f. 1 Apr 2025).", "Both conditions must hold simultaneously; classification follows the lower of the two."],
  inputs: [
    { k: "inv", label: "Investment in plant & machinery / equipment", ph: "e.g. 80L", def: "8000000", min: 0, max: 1e12 },
    { k: "to", label: "Annual turnover", ph: "e.g. 4Cr", def: "40000000", min: 0, max: 1e12 }
  ],
  compute(v) {
    const cls = (il, tl, name) => ({ il, tl, name });
    const bands = [cls(R.msme.micro[0], R.msme.micro[1], "Micro"), cls(R.msme.small[0], R.msme.small[1], "Small"), cls(R.msme.medium[0], R.msme.medium[1], "Medium")];
    let c = "Large (above MSME)", bind = "Both investment and turnover exceed Medium limits.";
    for (const b of bands) {
      if (v.inv <= b.il && v.to <= b.tl) {
        c = b.name;
        const hi = v.inv / b.il, ht = v.to / b.tl;
        bind = hi > ht
          ? "Investment is the binding constraint (" + Math.round(hi * 100) + "% of the " + b.name + " ceiling vs " + Math.round(ht * 100) + "% on turnover)."
          : "Turnover is the binding constraint (" + Math.round(ht * 100) + "% of the " + b.name + " ceiling vs " + Math.round(hi * 100) + "% on investment).";
        break;
      }
    }
    return { rows: [["Classification", c], ["Binding constraint", bind]], note: "Register on the Udyam portal to claim tender, credit and compliance benefits." };
  }
},
{ id: "valuation", render: "calc", type: "Calculator", cat: "founders",
  title: "Business Valuation Range (Multiple-Based)",
  desc: "An honest triangulation from observed private-market multiples, explicitly not a DCF.",
  verified: "Apr 2026 · multiple bands reviewed Apr 2026",
  assumptions: ["Observed private-market multiple bands for Indian growth companies, directional, not transaction comps.", "No explicit free-cash-flow projection, WACC or terminal value is modelled here, that is what makes a DCF, and its absence is stated, not hidden.", "56(2)(viib) / FEMA reports must come from a registered valuer and pre-date the transaction."],
  inputs: [
    { k: "rev", label: "Annual revenue", ph: "e.g. 8Cr", def: "80000000", min: 0, max: 1e13 },
    { k: "ebitda", label: "Annual EBITDA (0 if none)", ph: "e.g. 1.2Cr", def: "12000000", min: 0, max: 1e13 },
    { k: "sector", label: "Sector", def: "saas", opts: [["saas", "SaaS"], ["fintech", "Fintech"], ["consumer", "Consumer"], ["manufacturing", "Manufacturing"], ["health", "Health"], ["logistics", "Logistics"], ["edtech", "Edtech"], ["other", "Other"]] },
    { k: "stage", label: "Stage", def: "growth", opts: [["pre", "Pre-revenue"], ["early", "Early"], ["growth", "Growth"], ["ent", "Enterprise"]] }
  ],
  compute(v) {
    const m = R.mult[v.sector] || R.mult.other;
    const sm = R.stageMult[v.stage] || 1;
    const rows = [["Revenue-implied range", fmtShort(v.rev * m[0] * sm) + " – " + fmtShort(v.rev * m[1] * sm)],
      ["Applied revenue multiple", (m[0] * sm).toFixed(1) + "x – " + (m[1] * sm).toFixed(1) + "x"]];
    if (v.ebitda > 0) rows.push(["EBITDA cross-check", fmtShort(v.ebitda * m[2] * sm) + " – " + fmtShort(v.ebitda * m[3] * sm) + "  (" + (m[2] * sm).toFixed(1) + "x–" + (m[3] * sm).toFixed(1) + "x)"]);
    rows.push(["Confidence", v.rev > 0 && v.ebitda > 0 ? "Medium, two triangulations" : "Low, single triangulation"]);
    return { rows, note: "Where the two ranges overlap is the comfort zone. A transaction-grade opinion needs diligence, not just multiples." };
  }
},
{ id: "vest", render: "vest", type: "Calculator", cat: "founders",
  title: "Equity Vesting Curve (Cliff-Correct)",
  desc: "Standard 4-year / 1-year-cliff math done right: 25% jumps at the cliff, then monthly.",
  verified: "Apr 2026 · standard market practice",
  assumptions: ["Cliff vests its full accrued share at the cliff month, then monthly straight-line to 100%.", "Illustrative only, your scheme document governs."],
  inputs: []
},
{ id: "ipo", render: "quiz", type: "Diagnostic", cat: "founders",
  title: "IPO Readiness Index", desc: "Six questions across restatements, board, related parties, controls, cap table and debt.",
  verified: "Apr 2026", cta: "Book the action-plan call →",
  assumptions: ["Six-question self-assessment, not a substitute for a listing-readiness review.", "Score bands reflect typical merchant-banker gating, not regulatory minima."],
  qs: [
    { q: "Restated audited financials (3 yrs, IPO-ready policies)?", opts: [{ t: "Yes", s: 2 }, { t: "Partial", s: 1 }, { t: "No", s: 0 }] },
    { q: "Board with independent directors and committees?", opts: [{ t: "Yes", s: 2 }, { t: "In progress", s: 1 }, { t: "No", s: 0 }] },
    { q: "Related-party transactions documented at arm's length?", opts: [{ t: "Yes", s: 2 }, { t: "Partial", s: 1 }, { t: "No", s: 0 }] },
    { q: "Internal financial controls with a tested cadence?", opts: [{ t: "Yes", s: 2 }, { t: "Basic", s: 1 }, { t: "No", s: 0 }] },
    { q: "Promoter holding, cap table and ESOPs listing-clean?", opts: [{ t: "Yes", s: 2 }, { t: "Needs cleanup", s: 1 }, { t: "No", s: 0 }] },
    { q: "Debt service comfortable (DSCR ≥ 1.5x)?", opts: [{ t: "Yes", s: 2 }, { t: "Borderline", s: 1 }, { t: "Stressed", s: 0 }] }
  ],
  tiers: [[75, "Listing-ready trajectory. Proceed to DRHP scoping and restated financials."], [45, "Near-ready. Prioritise board composition, restatements and debt clean-up over the next 2–3 quarters."], [0, "Foundation stage. Strengthen governance, internal audit and capital structure before setting a listing timeline."]]
},
{ id: "bankloan-q", render: "quiz", type: "Diagnostic", cat: "founders",
  title: "Bank-Loan Readiness", desc: "Six questions that decide whether a sanction is weeks or quarters away.",
  verified: "Apr 2026", cta: "Book the debt action-plan call →",
  assumptions: ["Self-assessment against common sanction checklists; lenders apply their own norms.", "A high score shortens the process, it does not guarantee sanction."],
  qs: [
    { q: "CMA-ready projections with DSCR math?", opts: [{ t: "Yes", s: 2 }, { t: "Draft", s: 1 }, { t: "No", s: 0 }] },
    { q: "Three years of consistent audited financials?", opts: [{ t: "Yes", s: 2 }, { t: "Mostly", s: 1 }, { t: "No", s: 0 }] },
    { q: "Banking conduct clean (no overdues, no cheque returns)?", opts: [{ t: "Yes", s: 2 }, { t: "Minor blips", s: 1 }, { t: "No", s: 0 }] },
    { q: "Collateral and net-worth position documented?", opts: [{ t: "Yes", s: 2 }, { t: "Partially", s: 1 }, { t: "No", s: 0 }] },
    { q: "CIBIL and company credit scores checked recently?", opts: [{ t: "Yes", s: 2 }, { t: "A while ago", s: 1 }, { t: "Never", s: 0 }] },
    { q: "Working-capital cycle quantified (stock, debtors)?", opts: [{ t: "Yes", s: 2 }, { t: "Roughly", s: 1 }, { t: "No", s: 0 }] }
  ],
  tiers: [[75, "Sanction-ready. Approach lenders with the file, not just the ask."], [45, "Near-ready. Fix conduct blips and CMA consistency first."], [0, "Not yet bankable on paper. Build the documentation track before the meeting."]]
}
);

/* ---------- compliance data: thresholds, dues, FY context ---------- */
const COMP_GROUPS = {
  "pvt|new": { "One-time": [{ t: "Certificate of Incorporation filing" }, { t: "PAN / TAN application" }, { t: "GST registration", note: "Mandatory above ₹40L turnover (goods) / ₹20L (services); lower in special-category states." }, { t: "Shops & Establishment registration", note: "State-specific, register on your state's labour portal." }], "Monthly": [{ t: "TDS deposits", due: "7th of next month" }, { t: "GSTR-1 filing", due: "11th of next month" }, { t: "GSTR-3B + payment", due: "20th of next month" }, { t: "Payroll PF / ESI deposit", due: "15th of next month" }], "Quarterly": [{ t: "TDS returns (24Q / 26Q)", due: "31st of month after quarter-end" }, { t: "Advance-tax instalment check", due: "15 Jun / Sep / Dec / Mar" }], "Annual": [{ t: "AOC-4 filing", due: "30 days from AGM" }, { t: "MGT-7 filing", due: "60 days from AGM" }, { t: "Company ITR", due: "31 Oct (audit cases)" }, { t: "Statutory audit", due: "Before AGM" }] },
  "pvt|mid": { "One-time": [{ t: "DPIIT / Startup India review" }, { t: "Udyam (MSME) registration" }], "Monthly": [{ t: "Bookkeeping close" }, { t: "GST + TDS cycle", due: "11th / 20th / 7th" }, { t: "Payroll compliance", due: "15th" }], "Quarterly": [{ t: "Board pack / MIS" }, { t: "Advance tax", due: "15 Jun / Sep / Dec / Mar" }], "Annual": [{ t: "Statutory audit" }, { t: "Tax audit (turnover above threshold)", due: "Report by 30 Sep" }, { t: "ROC annual filings" }, { t: "Company ITR", due: "31 Oct" }] },
  "pvt|late": { "One-time": [{ t: "Internal controls refresh" }], "Monthly": [{ t: "Close calendar" }, { t: "GST, TDS, payroll" }], "Quarterly": [{ t: "Internal audit cycle" }, { t: "Advance tax" }], "Annual": [{ t: "Statutory + tax audit" }, { t: "Transfer pricing documentation (associated enterprises)" }, { t: "CSR spend + reporting (if triggered)" }, { t: "ROC + ITR" }] },
  "llp|new": { "One-time": [{ t: "LLP incorporation (FiLLiP)" }, { t: "PAN / TAN application" }, { t: "GST registration (thresholds as for companies)" }], "Monthly": [{ t: "Accounts + GST / TDS cycle" }], "Quarterly": [{ t: "TDS returns" }], "Annual": [{ t: "Form 11 (annual return)", due: "30 May" }, { t: "Form 8 (accounts & solvency)", due: "30 Oct" }, { t: "LLP ITR", due: "31 Jul" }] },
  "llp|mid": { "One-time": [{ t: "LLP deed amendments review" }], "Monthly": [{ t: "Bookkeeping" }, { t: "GST cycle" }], "Quarterly": [{ t: "TDS returns" }], "Annual": [{ t: "Form 11", due: "30 May" }, { t: "Form 8", due: "30 Oct" }, { t: "Tax audit (if applicable)" }] },
  "llp|late": { "One-time": [{ t: "Partner profit-sharing review" }], "Monthly": [{ t: "Full close" }], "Quarterly": [{ t: "TDS / GST" }], "Annual": [{ t: "Form 8 / 11" }, { t: "ITR + audit" }] },
  "opc|new": { "One-time": [{ t: "OPC incorporation" }, { t: "PAN / TAN + GST (thresholds as for companies)" }], "Monthly": [{ t: "Accounts / GST cycle" }], "Quarterly": [{ t: "TDS returns" }], "Annual": [{ t: "AOC-4", due: "30 days from AGM" }, { t: "Company ITR" }] },
  "opc|mid": { "One-time": [{ t: "Conversion-to-Pvt Ltd readiness (paid-up / turnover triggers)" }], "Monthly": [{ t: "Bookkeeping" }], "Quarterly": [{ t: "Advance tax" }], "Annual": [{ t: "ROC + ITR" }] },
  "opc|late": { "One-time": [{ t: "Mandatory conversion check" }], "Monthly": [{ t: "Close" }], "Quarterly": [{ t: "TDS / GST" }], "Annual": [{ t: "Audit + ROC + ITR" }] },
  "startup|new": { "One-time": [{ t: "DPIIT recognition" }, { t: "Section 80-IAC eligibility map" }, { t: "Founders' agreement + cap table v1" }], "Monthly": [{ t: "Cap-table hygiene" }, { t: "GST / TDS cycle" }], "Quarterly": [{ t: "Board consent calendar" }], "Annual": [{ t: "Startup compliance pack" }, { t: "ITR" }] },
  "startup|mid": { "One-time": [{ t: "ESOP pool design (10–15%)" }], "Monthly": [{ t: "MIS + payroll" }], "Quarterly": [{ t: "Investor reporting" }], "Annual": [{ t: "Valuation for 56(2)(viib)", note: "Report must pre-date the transaction." }, { t: "Audit + ROC" }] },
  "startup|late": { "One-time": [{ t: "Fundraising data room" }], "Monthly": [{ t: "Enterprise close" }], "Quarterly": [{ t: "Internal audit" }], "Annual": [{ t: "Tax + statutory audit" }, { t: "Transfer pricing (if group entities)" }] }
};

TOOLS.push(
{ id: "compliance", render: "checklist", type: "Checklist", cat: "founders",
  title: "Compliance Checklist",
  desc: "One-time, monthly, quarterly and annual dues with thresholds, due dates and persistence.",
  verified: "Apr 2026 · FY 2025-26",
  assumptions: ["Thresholds and due dates as notified for FY 2025-26; state portals govern Shops & Establishment.", "Progress saves in this browser; print produces a clean checklist-only document."],
  inputs: [], groups: COMP_GROUPS
},
{ id: "emi", render: "calc", type: "Calculator", cat: "personal",
  title: "EMI, Amortization & Affordability",
  desc: "Reducing-balance EMI with a yearly schedule, plus an FOIR-style affordability check.",
  verified: "Apr 2026",
  assumptions: ["Reducing-balance EMI; lenders assess FOIR (all EMIs ÷ income) around 40–60% depending on profile.", "Processing fees, insurance and floating-rate resets excluded."],
  inputs: [
    { k: "P", label: "Loan amount", ph: "e.g. 50L", def: "5000000", min: 0, max: 1e10 },
    { k: "R", label: "Interest % p.a.", ph: "e.g. 9", def: "9", min: 0, max: 36 },
    { k: "N", label: "Tenure (months)", ph: "e.g. 240", def: "240", min: 1, max: 600 },
    { k: "inc", label: "Monthly take-home (for FOIR check)", ph: "e.g. 2L (optional)", def: "", min: 0, max: 1e9, allowBlank: true }
  ],
  compute(v) {
    const r = v.R / 1200;
    const emi = r === 0 ? v.P / v.N : v.P * r / (1 - Math.pow(1 + r, -v.N));
    let bal = v.P, totI = 0; const rows = [["Monthly EMI", inr0(emi)]];
    const yrs = Math.ceil(v.N / 12);
    for (let y = 1; y <= yrs; y++) {
      let yi = 0, yp = 0;
      for (let m = 1; m <= 12 && (y - 1) * 12 + m <= v.N; m++) { const i = bal * r; const p = Math.min(emi - i, bal); yi += i; yp += p; bal -= p; totI += i; }
      rows.push(["Year " + y + ", interest / principal", inr0(yi) + " / " + inr0(yp)]);
    }
    rows.push(["Total interest", inr0(totI)]);
    if (!isNaN(v.inc) && v.inc > 0) {
      const f = emi * 100 / v.inc;
      rows.push(["FOIR", f.toFixed(1) + "%" + (f <= R.foir.ok ? ", comfortable" : f <= R.foir.stretch ? ", stretch zone" : ", likely declined")]);
    }
    return { rows, note: "Early years are almost all interest, prepay then if you prepay at all." };
  }
},
{ id: "cma", render: "calc", type: "Calculator", cat: "founders",
  title: "CMA Working Capital Estimator (Turnover Method)",
  desc: "The Nayak-committee math banks use for working-capital limits, requirement, margin, bank finance.",
  verified: "Apr 2026 · RBI turnover method as applied",
  assumptions: ["Turnover method (for fund-based limits typically up to ₹5 Cr): working capital 25% of projected sales, 5% promoter margin, 80% of the gap as bank finance.", "Banks apply their own norms and traditional MPBF alongside, this is the opening number, not the sanction."],
  inputs: [
    { k: "sales", label: "Projected annual sales", ph: "e.g. 4Cr", def: "40000000", min: 0, max: 1e12 }
  ],
  compute(v) {
    const wc = v.sales * R.cma.wc, margin = v.sales * R.cma.margin, bank = wc - margin;
    const pct = x => Math.round(x * 100) + "%";
    return { rows: [["Working capital requirement (" + pct(R.cma.wc) + ")", inr0(wc)], ["Less: promoter margin (" + pct(R.cma.margin) + ")", inr0(margin)], ["Maximum bank finance (" + pct(R.cma.wc - R.cma.margin) + ")", inr0(bank)]],
      note: "If your CMA projections don't tie to audited financials, expect the sanction to shrink or stall." };
  }
}
);

/* ================= pill-gated single-tool view (tools page only) =================
   Only the tool whose pill was clicked is visible. Everything is rendered but
   hidden (SEO-safe), until a pill or a #sec-* deep link opens one tool. */
let openId = null;
function pillModeCSS() {
  if (document.getElementById("tool-pill-mode-css")) return;
  const st = document.createElement("style");
  st.id = "tool-pill-mode-css";
  st.textContent = ".tool-hidden{display:none!important}" +
    ".tool-empty{padding:28px 4px;color:var(--mid-gray)}" +
    ".tool-toc .toc-link.active{border-color:var(--accent);color:var(--accent);background:rgba(84,76,217,.08);font-weight:600}";
  document.head.appendChild(st);
}
function ensureEmptyState(wrap) {
  let el = document.getElementById("tool-empty");
  if (!el) {
    el = document.createElement("p");
    el.id = "tool-empty";
    el.className = "micro tool-empty";
    el.textContent = "Choose a tool above to begin.";
    wrap.insertBefore(el, wrap.firstChild);
  }
  return el;
}
function setActivePill(id) {
  $$(".toc-link").forEach(a => {
    const on = id && a.getAttribute("href") === "#sec-" + id;
    a.classList.toggle("active", !!on);
    if (on) a.setAttribute("aria-current", "true");
    else a.removeAttribute("aria-current");
  });
}
function showTool(id, scroll) {
  const wrap = $("#tool-sections");
  if (!wrap || !document.getElementById("sec-" + id)) return;
  openId = id;
  TOOLS.forEach(t => {
    const sec = document.getElementById("sec-" + t.id);
    if (sec) sec.classList.toggle("tool-hidden", t.id !== id);
  });
  $$(".tool-group", wrap).forEach(g => g.classList.add("tool-hidden"));
  const empty = document.getElementById("tool-empty");
  if (empty) empty.classList.add("tool-hidden");
  setActivePill(id);
  const sec = document.getElementById("sec-" + id);
  if (sec && sec.classList.contains("collapsed")) setOpen(sec, true);
  try { history.replaceState(null, "", "#sec-" + id); } catch (e) {}
  if (scroll !== false && sec) {
    try { sec.scrollIntoView({ behavior: "smooth", block: "start" }); } catch (e) {}
  }
}
function hideTools() {
  const wrap = $("#tool-sections");
  if (!wrap) return;
  openId = null;
  TOOLS.forEach(t => {
    const sec = document.getElementById("sec-" + t.id);
    if (sec) sec.classList.add("tool-hidden");
  });
  $$(".tool-group", wrap).forEach(g => g.classList.add("tool-hidden"));
  ensureEmptyState(wrap).classList.remove("tool-hidden");
  setActivePill(null);
  try { history.replaceState(null, "", window.location.pathname + window.location.search); } catch (e) {}
}
function wirePills() {
  $$(".toc-link").forEach(a => {
    const href = a.getAttribute("href") || "";
    if (href.indexOf("#sec-") !== 0) return;
    const id = href.slice(5);
    a.addEventListener("click", e => {
      e.preventDefault();
      if (openId === id) hideTools();
      else showTool(id, true);
    });
  });
}

/* ================= sections ================= */
function renderSections() {
  const wrap = $("#tool-sections");
  if (!wrap) return;
  let lastCat = "";
  let html = "";
  TOOLS.forEach(t => {
    try {
      if (t.cat !== lastCat) { lastCat = t.cat; html += "<h2 class='tool-group'>" + esc(CATS[t.cat] || t.cat) + "</h2>"; }
      html += sectionShell(t);
    } catch (e) {
      html += "<section class='glass-card tool-card tool-sec' id='sec-" + esc(t.id) + "'><h2>" + esc(t.title || t.id) + "</h2><p class='micro'>This instrument could not be loaded. <a href='contact.html'>Tell us →</a></p></section>";
    }
  });
  wrap.innerHTML = html;
  pillModeCSS();
  ensureEmptyState(wrap);
  TOOLS.forEach(t => {
    const sec = document.getElementById("sec-" + t.id);
    if (sec) sec.classList.add("tool-hidden");
  });
  $$(".tool-group", wrap).forEach(g => g.classList.add("tool-hidden"));
  TOOLS.forEach(t => {
    const sec = $("#sec-" + t.id);
    if (sec && RENDER[t.render]) {
      try { RENDER[t.render](sec, t); }
      catch (e) { const o = $(".tool-out", sec); if (o) o.innerHTML = '<p class="micro">This instrument hit a snag. Refresh, or <a href="contact.html">tell us →</a></p>'; }
    }
  });
}
function setOpen(sec, open) {
  sec.classList.toggle("collapsed", !open);
  const btn = $(".tool-toggle", sec);
  if (btn) btn.setAttribute("aria-expanded", open ? "true" : "false");
}
function wireToggles() {
  $$(".tool-sec").forEach(sec => {
    const btn = $(".tool-toggle", sec);
    if (btn) btn.addEventListener("click", () => setOpen(sec, sec.classList.contains("collapsed")));
    const h = $("h2", sec);
    if (h) h.addEventListener("click", () => setOpen(sec, sec.classList.contains("collapsed")));
  });
  $$(".toc-link").forEach(a => a.addEventListener("click", () => {
    let sec = null;
    try { sec = $(a.getAttribute("href")); } catch (e) { sec = null; }
    if (sec && sec.classList && sec.classList.contains("collapsed")) setOpen(sec, true);
  }));
  if (window.location.hash) {
    let sec = null;
    try { sec = $(window.location.hash); } catch (e) { sec = null; }
    if (sec && sec.classList && sec.classList.contains("tool-sec")) setOpen(sec, true);
  }
}
function boot() {
  if (!$("#tool-sections")) return;
  loadRates().then(() => {
    renderSections();
    wireToggles();
    wirePills();
    let deep = null;
    try {
      const m = (window.location.hash || "").match(/^#sec-([A-Za-z0-9_-]+)$/);
      if (m && document.getElementById("sec-" + m[1])) deep = m[1];
    } catch (e) {}
    if (deep) showTool(deep, false);
    else hideTools();
  });
}
document.addEventListener("DOMContentLoaded", boot);
})();
