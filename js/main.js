(() => {
  "use strict";

  const root = document.documentElement.dataset.root || "";
  const $ = (sel, el = document) => el.querySelector(sel);
  const $$ = (sel, el = document) => [...el.querySelectorAll(sel)];

  /* Lucide, decorative only; must never break page init if the CDN drifts. */
  const bootIcons = () => { try { if (window.lucide) window.lucide.createIcons(); } catch (e) {} };

  /* Custom cursor, removed per design decision (native cursor only) */
  const cursor = () => { return; };

  /* Shared lead post: all inquiries route to the Google Sheet backend
     (Apps Script Web App). Paste the /exec URL after Deploy. */
  const FC_BACKEND_URL = "https://script.google.com/macros/s/AKfycbyxZIcRJSSIZZPGr6hoprIwisQk_Se3h8mPq9tKVikhOvYyqlSiXTtoBXTRTWebiZvP/exec";
  const postLead = async (form, extra = {}) => {
    const fd = new FormData(form);
    const data = {};
    fd.forEach((v, k) => { data[k] = typeof v === "string" ? v : ""; });
    /* Drop the legacy Web3Forms key if present in old markup. */
    delete data.access_key;
    /* Tag the form type so Apps Script picks the right Sheet tab. */
    if (!data.form_type) {
      if (form.id === "exit-form") data.form_type = "exit_intent";
      else if (form.id === "gate-form") data.form_type = "gate_download";
      else if (form.id === "consult-form") data.form_type = "contact";
      else if (form.classList && form.classList.contains("news")) data.form_type = "newsletter";
      else data.form_type = form.dataset.subject ? "newsletter" : "newsletter";
    }
    Object.assign(data, extra);
    data.page_url = location.href;
    data.page = (location.pathname.split("/").pop() || "index.html");
    try { data.user_agent = navigator.userAgent; } catch (e) {}
    const res = await fetch(FC_BACKEND_URL, {
      method: "POST",
      headers: { "Content-Type": "text/plain;charset=utf-8" },
      body: JSON.stringify(data)
    });
    const out = await res.json().catch(() => ({}));
    if (!out.success) throw new Error((out && out.message) || "send failed");
    return out;
  };

  /* Nav shadow (header stays sticky; never hides) + brand-text fade
     (logo mark stays put; only the "Finchase Capital" wordmark fades). */
  const navScroll = () => {
    const header = $(".site-header");
    if (!header) return;
    $$(".site-header .logo").forEach((a) => {
      [...a.childNodes].forEach((n) => {
        if (n.nodeType === 3 && n.textContent.trim()) {
          const s = document.createElement("span");
          s.className = "logo-text";
          s.textContent = n.textContent;
          a.replaceChild(s, n);
        }
      });
    });
    window.addEventListener("scroll", () => {
      const y = window.scrollY;
      header.classList.toggle("scrolled", y > 8);
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
    /* Below-fold timeline heads use the scroll-triggered mask wipe (heroes and
       article titles wipe via pure CSS above). Tagged here so no HTML edits
       are needed and untagged copy is never affected. */
    $$(".tl-head h2").forEach((el) => {
      el.setAttribute("data-animate", "mask");
    });
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
    }, { threshold: 0.05, rootMargin: "0px 0px 60px 0px" });
    $$("[data-animate]").forEach((el) => {
      // Headings already near the viewport (e.g. first timeline phase)
      // reveal immediately instead of waiting for a scroll event.
      try {
        const r = el.getBoundingClientRect();
        if (r.top < (window.innerHeight || 800) * 0.92) { el.classList.add("in"); return; }
      } catch (e) {}
      io.observe(el);
    });
    $$(".timeline").forEach((el) => io.observe(el));
    /* Safety net: a masked headline must never stay hidden (e.g. missed IO).
       Fires shortly after any legitimate reveal, so it only catches failures. */
    setTimeout(() => {
      $$('[data-animate="mask"]:not(.in)').forEach((el) => el.classList.add("in"));
    }, 1200);
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
    $("#exit-modal .x")?.addEventListener("click", () => modal.classList.remove("open"));
    $("#exit-form")?.addEventListener("submit", async (e) => {
      e.preventDefault();
      const btn = $("button[type=submit]", e.target);
      if (btn) btn.textContent = "Sending…";
      try { await postLead(e.target); } catch { /* fall through */ }
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
      form.addEventListener("submit", async (e) => {
        e.preventDefault();
        const input = $("input[type=email]", form);
        const btn = $("button", form);
        if (btn) btn.textContent = "Sending…";
        try {
          await postLead(form);
          if (btn) btn.textContent = "Subscribed ✓";
          if (input) input.value = "";
        } catch {
          if (btn) btn.textContent = "Try again";
        }
      });
    });
  };

  /* Email gate + service checklist (service pages build a print-only checklist sheet) */
  const buildServiceChecklist = (scope) => {
    const pack = scope.querySelector(".deliverables");
    if (!pack) return false;
    let sheet = document.getElementById("print-checklist");
    if (!sheet) {
      sheet = document.createElement("section");
      sheet.id = "print-checklist";
      sheet.className = "print-only";
      document.body.appendChild(sheet);
    }
    const title = ((scope.querySelector(".page-hero h1") || {}).textContent || document.title).trim();
    const lis = [...pack.querySelectorAll(".check-grid li")].map((li) => {
      const t = li.textContent.trim();
      return li.classList.contains("grphead")
        ? `<li class="grp">${t}</li>`
        : `<li><span class="box" aria-hidden="true"></span>${t}</li>`;
    }).join("");
    sheet.innerHTML = `<h2>${title} — engagement checklist</h2><ul>${lis}</ul><p>Finchase Capital · finchasecapital@gmail.com · Indore, Madhya Pradesh</p>`;
    document.body.classList.add("has-checklist");
    return true;
  };
  const emailGate = () => {
    const modal = $("#gate-modal");
    if (!modal) return;
    let pending = null;
    let gateCtx = null;
    window.openGate = (cb) => { pending = cb; modal.classList.add("open"); };
    modal.addEventListener("click", (e) => { if (e.target === modal) modal.classList.remove("open"); });
    $("#gate-modal .x")?.addEventListener("click", () => modal.classList.remove("open"));
    $("#gate-form")?.addEventListener("submit", async (e) => {
      e.preventDefault();
      const form = e.target;
      if (gateCtx) {
        for (const [k, v] of Object.entries(gateCtx)) {
          let inp = form.querySelector(`input[name="${k}"]`);
          if (!inp) { inp = document.createElement("input"); inp.type = "hidden"; inp.name = k; form.appendChild(inp); }
          inp.value = v;
        }
      }
      const btn = $("button[type=submit]", form);
      if (btn) btn.textContent = "Sending…";
      try { await postLead(form); } catch { /* still deliver locally */ }
      modal.classList.remove("open");
      if (btn) btn.textContent = "Continue";
      if (typeof pending === "function") pending();
    });
    $$("[data-gate]").forEach((el) => {
      el.addEventListener("click", (e) => {
        e.preventDefault();
        const scope = el.closest("main") || document;
        const h1 = scope.querySelector(".page-hero h1");
        gateCtx = {
          trigger: el.dataset.gate || "download",
          service: h1 ? h1.textContent.trim() : document.title,
          page: (location.pathname.split("/").pop() || "index.html")
        };
        window.openGate(() => {
          if (el.dataset.gate === "checklist") buildServiceChecklist(scope);
          window.print();
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
    const setFieldErr = (inp, msg) => {
      const wrap = inp.closest(".field");
      const err = wrap ? wrap.querySelector(".err") : null;
      if (err) err.textContent = msg || "";
      if (wrap) wrap.classList.toggle("error", !!msg);
    };
    /* Live, as-you-type feedback: precise one-line alerts under each box. */
    const emailLive = $('input[name="email"]', s1);
    if (emailLive) {
      emailLive.addEventListener("input", () => {
        const v = emailLive.value.trim();
        setFieldErr(
          emailLive,
          !v || /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(v) ? "" : "Please enter a valid email address."
        );
      });
    }
    const phoneLive = $('input[name="phone"]', s1);
    if (phoneLive) {
      phoneLive.addEventListener("input", () => {
        /* Letters are denied outright: they never even enter the box. */
        const stripped = phoneLive.value.replace(/[a-zA-Z]/g, "");
        if (stripped !== phoneLive.value) phoneLive.value = stripped;
        const v = phoneLive.value.trim();
        setFieldErr(
          phoneLive,
          !v || /^[+\d\s().-]*$/.test(v) ? "" : "Please use digits only."
        );
      });
    }
    $("#to-step-2")?.addEventListener("click", () => {
      let valid = true;
      $$("[required]", s1).forEach((inp) => {
        const wrap = inp.closest(".field");
        if (!inp.value.trim()) { wrap.classList.add("error"); valid = false; }
        else {
          wrap.classList.remove("error");
          const cleared = wrap.querySelector(".err");
          if (cleared) cleared.textContent = "";
        }
      });
      const email = $('input[name="email"]', s1);
      if (email && email.value.trim() && !/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email.value.trim())) {
        setFieldErr(email, "Please enter a valid email address.");
        valid = false;
      }
      const phone = $('input[name="phone"]', s1);
      if (phone && phone.value.trim() && !/^\+?\d{7,15}$/.test(phone.value.replace(/[\s]/g, ""))) {
        setFieldErr(phone, "Please use digits only.");
        valid = false;
      }
      if (!valid) return;
      s2.classList.remove("hidden");
      $$(".step-dot")[1]?.classList.add("on");
      s2.scrollIntoView({ behavior: "smooth", block: "nearest" });
    });
    $("#to-step-1")?.addEventListener("click", () => {
      s2.classList.add("hidden");
      $$(".step-dot")[1]?.classList.remove("on");
    });
    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const btn = $("button[type=submit]", form);
      const orig = btn ? btn.textContent : "Send Inquiry";
      if (btn) { btn.disabled = true; btn.textContent = "Sending…"; }
      try {
        await postLead(form);
        s1.classList.add("hidden");
        s2.classList.add("hidden");
        $(".steps")?.classList.add("hidden");
        ok.classList.remove("hidden");
        ok.scrollIntoView({ behavior: "smooth", block: "center" });
      } catch {
        if (btn) { btn.disabled = false; btn.textContent = "Couldn't send, email finchasecapital@gmail.com"; }
      }
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
    const orbs = $$(".hero .orb.ambient-canvas .orb");
    if (!orbs.length) return;
    window.addEventListener("scroll", () => {
      const y = window.scrollY * 0.5;
      orbs.forEach((o, i) => { o.style.translate = `0 ${y * (0.15 + i * 0.04)}px`; });
    }, { passive: true });
  };

  /* Services timeline: rail fill + staggered card reveal + DOM search */
  const serviceTimeline = () => {
    const root = $("#svc-timeline");
    if (!root) return;
    const input = $("#svc-search");
    const count = $("#svc-count");
    const fill = $("#tl-fill");
    const phases = [...root.querySelectorAll(".tl-phase")];
    const total = root.querySelectorAll(".tl-card").length;
    let ticking = false;
    const paint = () => {
      ticking = false;
      if (!fill) return;
      const r = root.getBoundingClientRect();
      const vh = window.innerHeight || 1;
      const tip = vh * 0.6;
      const SPAN = 120;
      phases.forEach((ph) => {
        if (ph.hasAttribute("hidden")) return;
        const node = ph.querySelector(".tl-node");
        if (!node) return;
        const nc = node.getBoundingClientRect();
        const c = nc.top + nc.height / 2;
        const rp = Math.min(1, Math.max(0, (tip - c) / SPAN));
        ph.style.setProperty("--ring", rp.toFixed(3));
      });
      const p = Math.min(1, Math.max(0, (tip - r.top) / (r.height || 1)));
      fill.style.transform = "scaleY(" + p + ")";
    };
    const onScroll = () => {
      if (!ticking) { ticking = true; requestAnimationFrame(paint); }
    };
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    if ("IntersectionObserver" in window) {
      const io = new IntersectionObserver((entries) => {
        entries.forEach((e) => {
          if (e.isIntersecting) { e.target.classList.add("lit"); io.unobserve(e.target); }
        });
      }, { threshold: 0.05, rootMargin: "0px 0px 160px 0px" });
      phases.forEach((p) => {
        // First phase(s) already on/near screen light up instantly, 
        // no waiting for a scroll tick.
        try {
          const r = p.getBoundingClientRect();
          if (r.top < (window.innerHeight || 800) * 0.92) { p.classList.add("lit"); return; }
        } catch (e) {}
        io.observe(p);
      });
    } else {
      root.classList.add("lit-all");
    }
    paint();
    /* Infinite-loop placard carousels: DOM recycling keeps every phase
       endlessly scrollable in both directions with no hard boundary. */
    const reducedMotion = () => window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const syncs = [];
    root.querySelectorAll(".tl-car").forEach((car) => {
      const view = car.querySelector(".tl-view");
      const track = car.querySelector(".tl-track");
      if (!view || !track) return;
      [...track.children].forEach((c, i) => { c.dataset.i = i; });
      let offset = 0;
      let busy = false;
      const kids = () => [...track.children];
      const firstVis = () => kids().find((c) => !c.hasAttribute("hidden"));
      const lastVis = () => [...kids()].reverse().find((c) => !c.hasAttribute("hidden"));
      const gap = () => parseFloat(getComputedStyle(track).columnGap) || 0;
      const step = () => {
        const c = track.querySelector(".tl-card:not([hidden])");
        return c ? c.offsetWidth + gap() : 320;
      };
      const max = () => Math.max(0, track.scrollWidth - view.clientWidth);
      const snap = () => {
        track.classList.add("no-anim");
        track.style.transform = "translateX(" + -offset + "px)";
        void track.offsetWidth;
        track.classList.remove("no-anim");
      };
      const glide = () => { track.style.transform = "translateX(" + -offset + "px)"; };
      const sync = () => {
        const m = max(), s = step();
        if (m <= 0 || s <= 0) { offset = 0; snap(); }
        else {
          track.classList.add("no-anim");
          let guard = kids().length + 2;
          while (offset > m && guard-- > 0) { const f = firstVis(); if (!f) break; track.appendChild(f); offset -= s; }
          guard = kids().length + 2;
          while (offset < 0 && guard-- > 0) { const l = lastVis(); if (!l) break; track.prepend(l); offset += s; }
          offset = Math.min(Math.max(0, offset), m);
          track.style.transform = "translateX(" + -offset + "px)";
          void track.offsetWidth;
          track.classList.remove("no-anim");
        }
        car.classList.toggle("flat", max() <= 0);
        paint();
      };
      const onEnd = (fn) => {
        if (reducedMotion()) { fn(); return; }
        let settled = false;
        const done = (e) => {
          if (e && e.target !== track) return;
          if (settled) return;
          settled = true;
          busy = false;
          track.removeEventListener("transitionend", done);
          fn();
        };
        track.addEventListener("transitionend", done);
        setTimeout(done, 650);
      };
      const next = () => {
        if (busy || max() <= 0) return;
        const s = step(), m = max();
        if (offset + s > m) {
          const f = firstVis();
          if (f) { track.appendChild(f); offset -= s; }
          snap();
        }
        busy = true;
        offset += s;
        glide();
        onEnd(sync);
      };
      const prev = () => {
        if (busy || max() <= 0) return;
        const s = step();
        if (offset < s) {
          const l = lastVis();
          if (l) { track.prepend(l); offset += s; }
          snap();
        }
        busy = true;
        offset = Math.max(0, offset - s);
        glide();
        onEnd(sync);
      };
      const prevBtn = car.querySelector(".tl-arrow.prev");
      const nextBtn = car.querySelector(".tl-arrow.next");
      if (prevBtn) prevBtn.addEventListener("click", prev);
      if (nextBtn) nextBtn.addEventListener("click", next);
      syncs.push({
        reset: () => {
          kids().sort((a, b) => (+a.dataset.i || 0) - (+b.dataset.i || 0)).forEach((c) => track.appendChild(c));
          offset = 0;
          sync();
        },
        sync
      });
      sync();
    });
    window.addEventListener("resize", () => syncs.forEach((o) => o.sync()));
    if (!input) return;
    const run = () => {
      const q = input.value.trim().toLowerCase();
      syncs.forEach((o) => o.reset());
      let n = 0;
      phases.forEach((ph) => {
        let vis = 0;
        ph.querySelectorAll(".tl-card").forEach((c) => {
          const hit = !q || c.textContent.toLowerCase().includes(q);
          if (hit) { c.removeAttribute("hidden"); vis++; n++; }
          else { c.setAttribute("hidden", ""); }
        });
        if (q && vis === 0) ph.setAttribute("hidden", "");
        else ph.removeAttribute("hidden");
      });
      root.classList.toggle("show-all", !!q);
      if (count) count.textContent = q ? n + " of " + total + " services" : "";
      syncs.forEach((o) => o.sync());
      paint();
    };
    input.addEventListener("input", run);
    document.addEventListener("keydown", (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "k") { e.preventDefault(); input.focus(); }
    });
  };

  /* Traveling rail pills: fixed gutter clones follow the active section.
     Originals stay in place (hidden) so layout never shifts. */
  const railPills = () => {
    const mq = window.matchMedia("(min-width: 1024px)");
    const sections = [...document.querySelectorAll(".section.rail")];
    if (!sections.length) return;
    const originals = sections.map((s) => s.querySelector(".sticky-label")).filter(Boolean);
    if (!originals.length) return;
    let clones = [];
    let current = -1;
    let ticking = false;
    /* Same anchor the sticky pills always used: below header + announce. */
    const anchorPx = () => {
      const cs = getComputedStyle(document.documentElement);
      const nav = parseFloat(cs.getPropertyValue("--nav-h")) || 72;
      const ann = parseFloat(cs.getPropertyValue("--announce-h")) || 40;
      return nav + ann + 12;
    };
    const paint = () => {
      ticking = false;
      if (!clones.length) return;
      const a = anchorPx();
      /* Active = section that owns the anchor line, but confined to its own
         segment: the pill hides before its section bottom reaches the anchor
         (plus pill height buffer) so it never bleeds into the next segment
         (e.g. 04, CLIENTS into the dark About block). */
      let active = -1;
      sections.forEach((s, i) => {
        const r = s.getBoundingClientRect();
        const pillH = clones[i] ? clones[i].offsetHeight || 120 : 120;
        const topOk = r.top <= a;
        const bottomOk = r.bottom > a + pillH + 24;
        if (topOk && bottomOk) active = i;
      });
      if (active !== current) {
        current = active;
        clones.forEach((c, j) => c.classList.toggle("on", j === active));
      }
    };
    const onScroll = () => {
      if (!ticking) { ticking = true; requestAnimationFrame(paint); }
    };
    const teardown = () => {
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
      clones.forEach((c) => c.remove());
      clones = [];
      current = -1;
      document.documentElement.classList.remove("js-rail");
    };
    const setup = () => {
      teardown();
      if (!mq.matches) return;
      document.documentElement.classList.add("js-rail");
      clones = originals.map((el) => {
        const c = el.cloneNode(true);
        c.classList.add("rail-clone");
        c.setAttribute("aria-hidden", "true");
        document.body.appendChild(c);
        return c;
      });
      window.addEventListener("scroll", onScroll, { passive: true });
      window.addEventListener("resize", onScroll);
      paint();
    };
    if (mq.addEventListener) mq.addEventListener("change", setup);
    setup();
  };

  /* Footer giant: exact margin-to-margin fit. CSS sets a large base
     (10.8cqw); JS shrinks/grows to exactly fill .container width. */
  const fitGiant = () => {
    const els = $$(".ft-giant");
    if (!els.length) return;
    const fitAll = () => {
      els.forEach((el) => {
        if (getComputedStyle(el).whiteSpace !== "nowrap") { el.style.fontSize = ""; return; }
        el.style.fontSize = "";
        const avail = el.clientWidth;
        if (!avail) return;
        const base = parseFloat(getComputedStyle(el).fontSize);
        const full = el.scrollWidth;
        if (!base || !full) return;
        const scale = avail / full;
        if (Math.abs(scale - 1) < 0.005) return;
        el.style.fontSize = (base * Math.min(scale, 1.15) * 0.998).toFixed(2) + "px";
      });
    };
    fitAll();
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(fitAll).catch(() => {});
    let t;
    window.addEventListener("resize", () => { clearTimeout(t); t = setTimeout(fitAll, 120); });
  };

  /* Runs now if parsing already finished (e.g. script ever loads async),
     otherwise on DOMContentLoaded, init must never silently miss. */
  const ready = (fn) => {
    if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", fn);
    else fn();
  };
  ready(() => {
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
    serviceTimeline();
    railPills();
    fitGiant();
    $$(".svc-panel").forEach((p, i) => { if (i === 0) p.classList.add("active"); else p.classList.remove("active"); });
  });
})();

