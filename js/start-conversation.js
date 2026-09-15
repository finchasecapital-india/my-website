/* Finchase Capital, "Start the Conversation" form (public page only).
 * TEMPORARY: posts multipart to Web3Forms so submissions land in email
 * until the Cloudflare-hosted backend is ready. Then point WEB3FORMS_URL
 * back at /api/conversations/submit and restore the data.ok check.
 * The server remains the source of truth for validation; this only gives
 * fast, friendly client-side feedback.
 */
(() => {
  "use strict";

  // Temporary backend. Swap back to "/api/conversations/submit" later.
  const WEB3FORMS_URL = "https://api.web3forms.com/submit";

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
      const res = await fetch(WEB3FORMS_URL, {
        method: "POST",
        body: new FormData(form)
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
