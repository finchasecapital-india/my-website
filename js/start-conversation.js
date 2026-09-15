/* Finchase Capital, "Start the Conversation" form (public page only).
 * Posts JSON to the Google Apps Script backend (same Sheet as all other
 * forms). File upload: deck is base64-encoded and saved to the Drive folder
 * by Code.gs. See google-apps-script/Code.gs for setup.
 */
(() => {
  "use strict";

  // Paste the same Web App /exec URL as in js/main.js after Deploy.
  const FC_BACKEND_URL = "https://script.google.com/macros/s/AKfycbyxZIcRJSSIZZPGr6hoprIwisQk_Se3h8mPq9tKVikhOvYyqlSiXTtoBXTRTWebiZvP/exec";

  const form = document.getElementById("conversation-form");
  if (!form) return;

  const started = document.getElementById("started_at");
  if (started) started.value = String(Date.now());

  const errBox = document.getElementById("conversation-error");
  const showErr = (msg) => {
    if (!errBox) return;
    errBox.textContent = msg;
    errBox.classList.remove("hidden");
    try {
      errBox.scrollIntoView({ behavior: "smooth", block: "center" });
    } catch (e) {}
  };
  const hideErr = () => {
    if (errBox) errBox.classList.add("hidden");
  };

  const deck = form.elements["deck"];
  const deckName = document.getElementById("deck-name");
  if (deck && deckName) {
    deck.addEventListener("change", () => {
      deckName.textContent = deck.files && deck.files[0] ? deck.files[0].name : "No file chosen";
    });
  }

  const val = (name) => {
    const el = form.elements[name];
    return el ? String(el.value || "").trim() : "";
  };

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    hideErr();

    if (!val("name")) return showErr("Please share your name.");
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(val("email"))) {
      return showErr("That email does not look right.");
    }
    if (!/^[+()\-\s\d]{7,20}$/.test(val("phone"))) {
      return showErr("That phone number does not look right.");
    }
    if (!form.querySelector('input[name="stage"]:checked')) {
      return showErr("Please pick the stage that fits best.");
    }
    if (val("building").length < 20) {
      return showErr("Tell us a little more about what you are building (a couple of lines).");
    }
    if (val("problem").length < 20) {
      return showErr("Tell us a little more about the problem and who has it.");
    }
    if (val("help_needed").length < 10) {
      return showErr("Tell us briefly what kind of help you need.");
    }
    const deck = form.elements["deck"];
    if (deck && deck.files && deck.files[0] && deck.files[0].size > 10 * 1024 * 1024) {
      return showErr("The file must be under 10 MB.");
    }

    const btn = form.querySelector('button[type="submit"]');
    if (btn) {
      btn.disabled = true;
      btn.textContent = "Sending…";
    }
    try {
      const payload = {
        form_type: "conversation",
        name: val("name"),
        email: val("email"),
        phone: val("phone"),
        linkedin: val("linkedin"),
        stage: (form.querySelector('input[name="stage"]:checked') || {}).value || "",
        building: val("building"),
        problem: val("problem"),
        help_needed: val("help_needed"),
        video_url: val("video_url"),
        nda_request: "1",
        started_at: val("started_at"),
        company_website: val("company_website"),
        page_url: location.href,
        user_agent: navigator.userAgent || ""
      };
      const deckFile = deck && deck.files && deck.files[0];
      if (deckFile) {
        payload.fileName = deckFile.name;
        payload.mimeType = deckFile.type || "application/octet-stream";
        payload.dataBase64 = await new Promise((resolve, reject) => {
          const r = new FileReader();
          r.onload = () => resolve(String(r.result).split(",").pop() || "");
          r.onerror = () => reject(new Error("Could not read the file."));
          r.readAsDataURL(deckFile);
        });
      }
      const res = await fetch(FC_BACKEND_URL, {
        method: "POST",
        headers: { "Content-Type": "text/plain;charset=utf-8" },
        body: JSON.stringify(payload)
      });
      let data = {};
      try {
        data = await res.json();
      } catch (e) {}
      if (!res.ok || !data.success) {
        throw new Error((data && data.message) || "something went wrong, please try again");
      }
      form.classList.add("hidden");
      const done = document.getElementById("conversation-success");
      if (done) {
        done.classList.remove("hidden");
        try {
          done.scrollIntoView({ behavior: "smooth", block: "center" });
        } catch (e2) {}
      }
    } catch (err) {
      showErr(err.message || "Something went wrong, please try again.");
      if (btn) {
        btn.disabled = false;
        btn.textContent = "Submit";
      }
    }
  });
})();
