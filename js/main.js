(() => {
  "use strict";

  const root = document.documentElement.dataset.root || "";
  const $ = (sel, el = document) => el.querySelector(sel);
  const $$ = (sel, el = document) => [...el.querySelectorAll(sel)];

  /* Lucide */
  const bootIcons = () => { if (window.lucide) window.lucide.createIcons(); };

  /* Custom cursor */
  const cursor = () => {
    if (!window.matchMedia("(hover: hover) and (pointer: fine)").matches) return;
    const dot = document.createElement("div");
    const ring = document.createElement("div");
    dot.className = "cursor-dot";
    ring.className = "cursor-ring";
    document.body.append(dot, ring);
    let x = 0, y = 0, rx = 0, ry = 0;
    document.addEventListener("mousemove", (e) => {
      x = e.clientX; y = e.clientY;
      dot.style.transform = `translate(${x}px,${y}px)`;
    });
    const tick = () => {
      rx += (x - rx) * 0.12;
      ry += (y - ry) * 0.12;
      ring.style.transform = `translate(${rx}px,${ry}px)`;
      requestAnimationFrame(tick);
    };
    tick();
    document.addEventListener("mouseover", (e) => {
      const hit = e.target.closest("a,button,input,textarea,select,.tiltable,.pill-opt");
      ring.classList.toggle("hover", !!hit);
    });
  };

  /* Nav hide/show */
  const navScroll = () => {
    const header = $(".site-header");
    if (!header) return;
    let last = 0;
    window.addEventListener("scroll", () => {
      const y = window.scrollY;
      header.classList.toggle("scrolled", y > 8);
      if (y > last && y > 80) header.classList.add("hide");
      else header.classList.remove("hide");
      last = y;
    }, { passive: true });
  };

  /* Mobile drawer */
  const drawer = () => {
    const btn = $(".hamburger");
    const drawerEl = $(".drawer");
    const overlay = $(".drawer-overlay");
    if (!btn || !drawerEl) return;
    const close = () => {
      drawerEl.classList.remove("open");
      overlay.classList.remove("open");
      btn.setAttribute("aria-expanded", "false");
    };
    btn.addEventListener("click", () => {
      const open = !drawerEl.classList.contains("open");
      drawerEl.classList.toggle("open", open);
      overlay.classList.toggle("open", open);
      btn.setAttribute("aria-expanded", String(open));
    });
    overlay.addEventListener("click", close);
    $$(".drawer a").forEach((a) => a.addEventListener("click", close));
  };

  /* Scroll animations */
  const animate = () => {
    $$("[data-stagger]").forEach((parent) => {
      [...parent.children].forEach((child, i) => {
        if (!child.hasAttribute("data-animate")) child.setAttribute("data-animate", "fade-up");
        child.style.transitionDelay = `${i * 80}ms`;
      });
    });
    const io = new IntersectionObserver((entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting) {
          e.target.classList.add("in");
          io.unobserve(e.target);
        }
      });
    }, { threshold: 0.1, rootMargin: "0px 0px -60px 0px" });
    $$("[data-animate]").forEach((el) => io.observe(el));
    $$(".timeline").forEach((el) => io.observe(el));
  };

  /* Counters */
  const counters = () => {
    const ease = (t) => 1 - Math.pow(1 - t, 3);
    const io = new IntersectionObserver((entries) => {
      entries.forEach((e) => {
        if (!e.isIntersecting) return;
        const el = e.target;
        const target = Number(el.dataset.target || 0);
        const suffix = el.dataset.suffix || "";
        const start = performance.now();
        const tick = (now) => {
          const p = Math.min(1, (now - start) / 1800);
          const val = Math.round(ease(p) * target);
          el.textContent = val.toLocaleString("en-IN") + suffix;
          if (p < 1) requestAnimationFrame(tick);
        };
        requestAnimationFrame(tick);
        io.unobserve(el);
      });
    }, { threshold: 0.2 });
    $$("[data-counter]").forEach((el) => io.observe(el));
  };

  /* Card tilt */
  const tilt = () => {
    $$(".tiltable").forEach((card) => {
      card.addEventListener("mousemove", (e) => {
        const r = card.getBoundingClientRect();
        const px = (e.clientX - r.left) / r.width - 0.5;
        const py = (e.clientY - r.top) / r.height - 0.5;
        card.style.setProperty("--ry", `${px * 8}deg`);
        card.style.setProperty("--rx", `${-py * 8}deg`);
      });
      card.addEventListener("mouseleave", () => {
        card.style.setProperty("--rx", "0deg");
        card.style.setProperty("--ry", "0deg");
      });
    });
  };

  /* Tabs */
  const tabs = (groupSel, btnSel, panelSel) => {
    $$(groupSel).forEach((group) => {
      const btns = $$(btnSel, group);
      const panels = $$(panelSel, group.parentElement.contains($(panelSel)) ? group.parentElement : document);
      const localPanels = group.parentElement.querySelectorAll(panelSel).length
        ? [...group.parentElement.querySelectorAll(panelSel)]
        : panels;
      btns.forEach((btn) => {
        btn.addEventListener("click", () => {
          btns.forEach((b) => b.classList.remove("active"));
          btn.classList.add("active");
          const id = btn.dataset.tab;
          localPanels.forEach((p) => p.classList.toggle("active", p.dataset.panel === id || p.id === id));
        });
      });
    });
  };

  /* Testimonials carousel */
  const carousel = () => {
    const rootEl = $(".carousel");
    if (!rootEl) return;
    const track = $(".carousel-track", rootEl);
    const cards = $$(".t-card", track);
    if (!cards.length) return;
    const dotsWrap = $(".dots", rootEl.parentElement) || $(".dots");
    let i = 0;
    const per = () => window.innerWidth <= 640 ? 1 : window.innerWidth <= 1024 ? 2 : 3;
    const max = () => Math.max(0, cards.length - per());
    const go = (n) => {
      i = Math.max(0, Math.min(n, max()));
      const w = cards[0].getBoundingClientRect().width + 18;
      track.style.transform = `translateX(${-i * w}px)`;
      if (dotsWrap) $$("button", dotsWrap).forEach((d, di) => d.classList.toggle("active", di === i));
    };
    if (dotsWrap) {
      dotsWrap.innerHTML = "";
      cards.forEach((_, di) => {
        const b = document.createElement("button");
        b.type = "button";
        b.setAttribute("aria-label", `Go to slide ${di + 1}`);
        if (di === 0) b.classList.add("active");
        b.addEventListener("click", () => go(di));
        dotsWrap.append(b);
      });
    }
    $(".car-nav.prev")?.addEventListener("click", () => go(i - 1));
    $(".car-nav.next")?.addEventListener("click", () => go(i + 1));
    let timer = setInterval(() => go(i >= max() ? 0 : i + 1), 5000);
    rootEl.addEventListener("mouseenter", () => clearInterval(timer));
    rootEl.addEventListener("mouseleave", () => { timer = setInterval(() => go(i >= max() ? 0 : i + 1), 5000); });
    window.addEventListener("resize", () => go(i));
    go(0);
  };

  /* Exit intent */
  const exitIntent = () => {
    if (sessionStorage.getItem("exit-seen")) return;
    const modal = $("#exit-modal");
    if (!modal) return;
    const open = () => {
      if (sessionStorage.getItem("exit-seen")) return;
      sessionStorage.setItem("exit-seen", "1");
      modal.classList.add("open");
    };
    document.addEventListener("mouseout", (e) => {
      if (e.clientY < 0) open();
    });
    modal.addEventListener("click", (e) => { if (e.target === modal) modal.classList.remove("open"); });
    $(".exit-modal .x")?.addEventListener("click", () => modal.classList.remove("open"));
    $("#exit-form")?.addEventListener("submit", (e) => {
      e.preventDefault();
      modal.classList.remove("open");
    });
  };

  /* Mobile sticky CTA */
  const stickyCta = () => {
    const bar = $(".mobile-cta");
    if (!bar) return;
    window.addEventListener("scroll", () => {
      const p = window.scrollY / (document.documentElement.scrollHeight - window.innerHeight);
      bar.classList.toggle("show", window.innerWidth <= 768 && p > 0.6);
    }, { passive: true });
  };

  /* FAQ */
  const faq = () => {
    $$(".faq-item button").forEach((btn) => {
      btn.addEventListener("click", () => {
        const item = btn.parentElement;
        $$(".faq-item").forEach((el) => { if (el !== item) el.classList.remove("open"); });
        item.classList.toggle("open");
      });
    });
  };

  /* Newsletter */
  const newsletter = () => {
    $$(".news").forEach((form) => {
      form.addEventListener("submit", (e) => {
        e.preventDefault();
        const input = $("input", form);
        const btn = $("button", form);
        if (btn) btn.textContent = "Subscribed";
        if (input) input.value = "";
      });
    });
  };

  /* Email gate */
  const emailGate = () => {
    const modal = $("#gate-modal");
    if (!modal) return;
    let pending = null;
    window.openGate = (cb) => { pending = cb; modal.classList.add("open"); };
    modal.addEventListener("click", (e) => { if (e.target === modal) modal.classList.remove("open"); });
    $(".gate-modal .x")?.addEventListener("click", () => modal.classList.remove("open"));
    $("#gate-form")?.addEventListener("submit", (e) => {
      e.preventDefault();
      modal.classList.remove("open");
      if (typeof pending === "function") pending();
    });
    $$("[data-gate]").forEach((el) => {
      el.addEventListener("click", (e) => {
        e.preventDefault();
        window.openGate(() => {
          if (el.dataset.gate === "print") window.print();
          else alert("Checklist sent to your inbox (simulated).");
        });
      });
    });
  };

  /* Contact form */
  const contact = () => {
    const form = $("#consult-form");
    if (!form) return;
    const s1 = $("#step-1");
    const s2 = $("#step-2");
    const ok = $("#form-success");
    $("#to-step-2")?.addEventListener("click", () => {
      let valid = true;
      $$("[required]", s1).forEach((inp) => {
        const wrap = inp.closest(".field");
        if (!inp.value.trim()) { wrap.classList.add("error"); valid = false; }
        else wrap.classList.remove("error");
      });
      if (!valid) return;
      s1.classList.add("hidden");
      s2.classList.remove("hidden");
      $$(".step-dot")[1]?.classList.add("on");
    });
    $("#to-step-1")?.addEventListener("click", () => {
      s2.classList.add("hidden");
      s1.classList.remove("hidden");
      $$(".step-dot")[1]?.classList.remove("on");
    });
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      s2.classList.add("hidden");
      $(".steps")?.classList.add("hidden");
      ok.classList.remove("hidden");
    });
  };

  /* Filters */
  const filters = () => {
    $$(".filters").forEach((bar) => {
      const cards = $$("[data-filter-item]");
      $$(".filter", bar).forEach((btn) => {
        btn.addEventListener("click", () => {
          $$(".filter", bar).forEach((b) => b.classList.remove("active"));
          btn.classList.add("active");
          const key = btn.dataset.filter;
          cards.forEach((c) => {
            const tags = (c.dataset.tags || "").split(/\s+/);
            const show = key === "all" || tags.includes(key);
            c.style.display = show ? "" : "none";
            if (show) {
              c.classList.remove("in");
              void c.offsetWidth;
              c.classList.add("in");
            }
          });
        });
      });
    });
  };

  /* Reading progress */
  const progress = () => {
    const bar = $(".read-progress");
    if (!bar) return;
    window.addEventListener("scroll", () => {
      const h = document.documentElement.scrollHeight - window.innerHeight;
      bar.style.width = `${Math.min(100, (window.scrollY / h) * 100)}%`;
    }, { passive: true });
  };

  /* Parallax orbs */
  const parallax = () => {
    const orbs = $$(".hero .orb, .ambient-canvas .orb");
    if (!orbs.length) return;
    window.addEventListener("scroll", () => {
      const y = window.scrollY * 0.5;
      orbs.forEach((o, i) => { o.style.translate = `0 ${y * (0.15 + i * 0.04)}px`; });
    }, { passive: true });
  };

  /* Tools */
  const inr = (n) => "₹" + Math.round(n).toLocaleString("en-IN");

  const taxTool = () => {
    const rev = $("#tax-rev");
    const paid = $("#tax-paid");
    if (!rev) return;
    const outSav = $("#tax-save");
    const outPot = $("#tax-pot");
    const live = $("#tax-rev-live");
    const calc = () => {
      const r = Number(rev.value);
      const p = Number(paid.value) || 0;
      const type = document.querySelector("[name=entity]:checked")?.value || "pvt";
      const rate = type === "pvt" ? 0.25 : type === "llp" ? 0.3 : 0.3;
      const naive = r * rate;
      const optimized = naive * (type === "pvt" ? 0.78 : 0.86);
      const save = Math.max(p ? p - optimized : naive - optimized, r * 0.012);
      if (live) live.textContent = inr(r);
      if (outSav) outSav.textContent = inr(save);
      const ratio = save / Math.max(r, 1);
      if (outPot) outPot.textContent = ratio > 0.04 ? "🔥 High" : ratio > 0.02 ? "⚡ Medium" : "● Standard";
    };
    [rev, paid, ...$$("[name=entity]")].forEach((el) => el?.addEventListener("input", calc));
    calc();
    $("#tax-report")?.addEventListener("submit", (e) => {
      e.preventDefault();
      window.openGate?.(() => { e.target.querySelector("button").textContent = "Report queued"; });
    });
  };

  const vestTool = () => {
    const pool = $("#vest-pool");
    if (!pool) return;
    const render = () => {
      const p = Number(pool.value) || 0;
      const cliff = Number($("#vest-cliff").value) || 0;
      const total = Number($("#vest-total").value) || 48;
      const n = Math.max(1, Number($("#vest-n").value) || 1);
      const tbody = $("#vest-body");
      const svg = $("#vest-svg");
      tbody.innerHTML = "";
      const pts = [];
      for (let m = 0; m <= total; m++) {
        let cum = 0;
        if (m >= cliff) cum = Math.min(p, (m / total) * p);
        const per = cum / n;
        const tr = document.createElement("tr");
        tr.innerHTML = `<td>M${m}</td><td>${cum.toFixed(2)}%</td><td>${per.toFixed(2)}%</td>`;
        tbody.append(tr);
        pts.push([m / total, cum / Math.max(p, 1)]);
      }
      const d = pts.map((pt, i) => `${i ? "L" : "M"}${10 + pt[0] * 280},${90 - pt[1] * 70}`).join(" ");
      svg.innerHTML = `<path d="${d} L 290 90 L 10 90 Z" fill="rgba(84,76,217,0.15)" /><path d="${d}" fill="none" stroke="#544CD9" stroke-width="2" />`;
    };
    ["vest-pool", "vest-cliff", "vest-total", "vest-n"].forEach((id) => $("#" + id)?.addEventListener("input", render));
    render();
  };

  const COMPLIANCE = {
    "pvt|new": {
      "One-time": ["Certificate of Incorporation filing", "PAN / TAN application", "GST registration if threshold met", "Shops & Establishment (if applicable)"],
      Monthly: ["TDS deposits", "GST returns (if registered)", "Payroll PF/ESI"],
      Quarterly: ["TDS returns", "Advance tax estimate"],
      Annual: ["AOC-4 / MGT-7", "ITR for company", "Statutory audit (if applicable)"]
    },
    "pvt|mid": {
      "One-time": ["DPIIT / Startup India review", "MSME registration"],
      Monthly: ["Bookkeeping close", "GST & TDS", "Payroll compliance"],
      Quarterly: ["Board pack / MIS", "Advance tax"],
      Annual: ["Statutory audit", "Tax audit if turnover threshold", "ROC annual filings", "ITR"]
    },
    "pvt|late": {
      "One-time": ["Internal controls refresh"],
      Monthly: ["Close calendar", "GST, TDS, payroll"],
      Quarterly: ["Internal audit cycle", "Advance tax"],
      Annual: ["Statutory + tax audit", "Transfer pricing if applicable", "CSR if triggered", "ROC + ITR"]
    },
    "llp|new": {
      "One-time": ["LLP incorporation", "PAN/TAN", "GST if required"],
      Monthly: ["Accounts", "GST/TDS"],
      Quarterly: ["TDS returns"],
      Annual: ["Form 8 / Form 11", "ITR"]
    },
    "llp|mid": {
      "One-time": ["Deed amendments review"],
      Monthly: ["Bookkeeping", "GST"],
      Quarterly: ["TDS"],
      Annual: ["Annual LLP filings", "Tax audit if applicable"]
    },
    "llp|late": {
      "One-time": ["Partner profit-sharing review"],
      Monthly: ["Full close"],
      Quarterly: ["TDS / GST"],
      Annual: ["Form 8/11", "ITR", "Audit"]
    },
    "opc|new": {
      "One-time": ["OPC incorporation", "PAN/TAN", "GST"],
      Monthly: ["Accounts / GST"],
      Quarterly: ["TDS"],
      Annual: ["AOC-4", "ITR"]
    },
    "opc|mid": {
      "One-time": ["Conversion-to-Pvt Ltd readiness"],
      Monthly: ["Bookkeeping"],
      Quarterly: ["Advance tax"],
      Annual: ["ROC + ITR"]
    },
    "opc|late": {
      "One-time": ["Mandatory conversion check"],
      Monthly: ["Close"],
      Quarterly: ["TDS/GST"],
      Annual: ["Audit + ROC + ITR"]
    },
    "startup|new": {
      "One-time": ["DPIIT recognition", "Section 80-IAC eligibility map", "Founders' agreement"],
      Monthly: ["Cap table hygiene", "GST/TDS"],
      Quarterly: ["Board consent calendar"],
      Annual: ["Startup compliance pack", "ITR"]
    },
    "startup|mid": {
      "One-time": ["ESOP pool design"],
      Monthly: ["MIS + payroll"],
      Quarterly: ["Investor reporting"],
      Annual: ["Valuation 56(2)(viib)", "Audit + ROC"]
    },
    "startup|late": {
      "One-time": ["Fundraising data room"],
      Monthly: ["Enterprise close"],
      Quarterly: ["Internal audit"],
      Annual: ["Tax + statutory audit", "Transfer pricing if needed"]
    }
  };

  const complianceTool = () => {
    const type = $("#comp-type");
    const stage = $("#comp-stage");
    const box = $("#comp-list");
    if (!type || !box) return;
    const render = () => {
      const key = `${type.value}|${stage.value}`;
      const data = COMPLIANCE[key] || COMPLIANCE["pvt|new"];
      box.innerHTML = Object.entries(data).map(([g, items]) =>
        `<h4 class="group-h">${g}</h4>` + items.map((it) =>
          `<label><input type="checkbox"><span>${it}</span></label>`).join("")
      ).join("");
      $$("label", box).forEach((lab) => {
        $("input", lab).addEventListener("change", () => lab.classList.toggle("done", $("input", lab).checked));
      });
    };
    type.addEventListener("change", render);
    stage.addEventListener("change", render);
    render();
    $("#comp-pdf")?.addEventListener("click", () => window.openGate?.(() => window.print()));
  };

  const valTool = () => {
    const rev = $("#val-rev");
    if (!rev) return;
    const sectors = {
      saas: [8, 12, 18, 28],
      fintech: [6, 10, 14, 22],
      consumer: [2, 4, 8, 14],
      manufacturing: [1.2, 2.5, 6, 10],
      health: [4, 7, 12, 18],
      logistics: [1.5, 3, 8, 12],
      edtech: [3, 6, 10, 16],
      other: [2, 4, 8, 14]
    };
    const calc = () => {
      const r = Number(rev.value) || 0;
      const e = Number($("#val-ebitda").value) || 0;
      const cagr = (Number($("#val-cagr").value) || 0) / 100;
      const sector = $("#val-sector").value;
      const stage = $("#val-stage").value;
      const [rmin, rmax, emin, emax] = sectors[sector] || sectors.other;
      const stageMul = stage === "pre" ? 0.7 : stage === "early" ? 0.9 : stage === "growth" ? 1 : 1.15;
      const dcf = e > 0 ? (e * (1 + cagr)) / Math.max(0.12 - Math.min(cagr, 0.08), 0.04) : r * 3;
      const lo = Math.min(r * rmin * stageMul, dcf * 0.75);
      const hi = Math.max(r * rmax * stageMul, dcf * 1.2);
      $("#val-range").textContent = `${inr(lo)} – ${inr(hi)}`;
      $("#val-rm").textContent = `${(rmin * stageMul).toFixed(1)}x – ${(rmax * stageMul).toFixed(1)}x`;
      $("#val-em").textContent = `${(emin * stageMul).toFixed(1)}x – ${(emax * stageMul).toFixed(1)}x`;
      $("#val-conf").textContent = e && r && cagr ? "High" : e || r ? "Medium" : "Low";
    };
    ["val-rev", "val-ebitda", "val-cagr", "val-sector", "val-stage"].forEach((id) => $("#" + id)?.addEventListener("input", calc));
    calc();
  };

  document.addEventListener("DOMContentLoaded", () => {
    bootIcons();
    cursor();
    navScroll();
    drawer();
    animate();
    counters();
    tilt();
    tabs(".pill-tabs", "button", ".phase-panel");
    tabs(".v-tabs", "button", ".svc-panel");
    carousel();
    exitIntent();
    stickyCta();
    faq();
    newsletter();
    emailGate();
    contact();
    filters();
    progress();
    parallax();
    taxTool();
    vestTool();
    complianceTool();
    valTool();
    $$(".svc-panel").forEach((p, i) => { if (i === 0) p.classList.add("active"); else p.classList.remove("active"); });
  });
})();
