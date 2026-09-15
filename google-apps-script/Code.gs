/* Finchase Capital — Google Sheets backend (Apps Script)
 *
 * Binds to Sheet: https://docs.google.com/spreadsheets/d/1EvQNuJGV4UYDPlN2CJJhOIIq24SUUdFAnsjyYRmviAY/edit
 * Deck uploads go to Drive folder: https://drive.google.com/drive/folders/1TrCh7MHYkLsovSdjnKfZAs0Kk2M2ofVW
 *
 * SETUP (one time, ~5 min, done by site owner in a browser):
 * 1. Open the Sheet above > Extensions > Apps Script.
 * 2. Delete any code in Code.gs, paste this entire file, Save.
 * 3. Check CONFIG below (Sheet ID, Drive folder ID, notify email are pre-filled).
 * 4. Run > setup once (accept permissions: Sheets, Drive, Mail). This creates
 *    the 4 tabs + headers.
 * 5. Deploy > New deployment > type Web app > Execute as: Me >
 *    Who has access: Anyone > Deploy. Copy the /exec URL.
 * 6. Paste that /exec URL into js/main.js (FC_BACKEND_URL) and
 *    js/start-conversation.js (FC_BACKEND_URL). Done.
 *
 * Frontend sends: POST with Content-Type: text/plain (avoids CORS preflight)
 *   body = JSON string: { form_type, email, name, phone, ..., fileName, mimeType, dataBase64 }
 * Backend replies: JSON { success: true }
 */

var CONFIG = {
  SHEET_ID: '1EvQNuJGV4UYDPlN2CJJhOIIq24SUUdFAnsjyYRmviAY',
  DRIVE_FOLDER_ID: '1TrCh7MHYkLsovSdjnKfZAs0Kk2M2ofVW',
  NOTIFY_EMAIL: 'finchasecapital@gmail.com',
  MAX_FILE_BYTES: 10 * 1024 * 1024
};

/* Tab name per form_type sent by the website */
var TABS = {
  newsletter: 'Newsletter',
  exit_intent: 'Exit_Intent',
  gate_download: 'Gate_Downloads',
  conversation: 'Conversations',
  contact: 'Contacts'
};

var HEADERS = {
  Newsletter: ['timestamp', 'email', 'page_url', 'page', 'user_agent'],
  Exit_Intent: ['timestamp', 'email', 'page_url', 'page', 'user_agent'],
  Gate_Downloads: ['timestamp', 'email', 'page_url', 'page', 'service', 'trigger', 'user_agent'],
  Conversations: ['timestamp', 'name', 'email', 'phone', 'linkedin', 'stage', 'building', 'problem', 'help_needed', 'video_url', 'deck_name', 'deck_link', 'nda_request', 'started_at', 'page_url', 'user_agent'],
  Contacts: ['timestamp', 'name', 'email', 'phone', 'message', 'page_url', 'service', 'user_agent']
};

function setup() {
  var ss = SpreadsheetApp.openById(CONFIG.SHEET_ID);
  Object.keys(HEADERS).forEach(function (tab) {
    var sh = ss.getSheetByName(tab);
    if (!sh) sh = ss.insertSheet(tab);
    ensureHeaders_(sh, HEADERS[tab]);
  });
}

function ensureHeaders_(sh, headers) {
  if (sh.getLastRow() === 0) {
    sh.appendRow(headers);
    return;
  }
  var first = sh.getRange(1, 1, 1, headers.length).getValues()[0];
  var missing = headers.some(function (h, i) { return String(first[i] || '') !== h; });
  if (missing) sh.getRange(1, 1, 1, headers.length).setValues([headers]);
}

function doGet() {
  return json_({ ok: true, service: 'finchase-leads', time: new Date().toISOString() });
}

/* Main entry: handles JSON (text/plain) + classic form posts */
function doPost(e) {
  try {
    var data = {};
    if (e && e.postData && e.postData.contents) {
      try { data = JSON.parse(e.postData.contents); }
      catch (err) { data = e.parameter || {}; }
    } else if (e && e.parameter) {
      data = e.parameter;
    }

    /* Honeypot: bots fill company_website -> pretend success, store nothing */
    if (data.company_website) return json_({ success: true });

    var formType = String(data.form_type || guessType_(data) || 'newsletter');
    var tab = TABS[formType] || TABS.newsletter;
    var email = String(data.email || '').trim();

    /* Minimal validation: email-only forms need an email; conversation needs more */
    if (formType === 'conversation') {
      if (!email || !data.name || !data.building) return json_({ success: false, message: 'Missing required fields.' });
    } else if (!email) {
      return json_({ success: false, message: 'Email is required.' });
    }
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email)) {
      return json_({ success: false, message: 'That email does not look right.' });
    }

    /* Deck upload (conversations only): { fileName, mimeType, dataBase64 } */
    var deckLink = '';
    var deckName = String(data.fileName || data.deck_name || '');
    if (data.dataBase64 && deckName) {
      try {
        var bytes = Utilities.base64Decode(String(data.dataBase64).split(',').pop());
        if (bytes.length > CONFIG.MAX_FILE_BYTES) {
          return json_({ success: false, message: 'The file must be under 10 MB.' });
        }
        var folder = DriveApp.getFolderById(CONFIG.DRIVE_FOLDER_ID);
        var blob = Utilities.newBlob(bytes, String(data.mimeType || 'application/octet-stream'), deckName);
        var file = folder.createFile(blob);
        file.setDescription('Finchase conversation deck from ' + email + ' at ' + new Date().toISOString());
        deckLink = file.getUrl();
      } catch (ferr) {
        /* File failed but lead matters more: keep lead, flag upload error */
        deckLink = 'UPLOAD_FAILED: ' + ferr.message;
      }
    }

    var ss = SpreadsheetApp.openById(CONFIG.SHEET_ID);
    var sh = ss.getSheetByName(tab);
    if (!sh) sh = ss.insertSheet(tab);
    var headers = HEADERS[tab] || HEADERS.Newsletter;
    ensureHeaders_(sh, headers);

    var now = new Date();
    var rowMap = {
      timestamp: now,
      email: email,
      name: String(data.name || ''),
      phone: String(data.phone || ''),
      linkedin: String(data.linkedin || ''),
      stage: String(data.stage || ''),
      building: String(data.building || ''),
      problem: String(data.problem || ''),
      help_needed: String(data.help_needed || ''),
      video_url: String(data.video_url || ''),
      deck_name: deckName,
      deck_link: deckLink,
      nda_request: String(data.nda_request || ''),
      started_at: String(data.started_at || ''),
      message: String(data.message || ''),
      page_url: String(data.page_url || data.page || ''),
      page: String(data.page || data.page_url || ''),
      service: String(data.service || ''),
      trigger: String(data.trigger || ''),
      user_agent: String(data.user_agent || '')
    };
    sh.appendRow(headers.map(function (h) { return rowMap[h] !== undefined ? rowMap[h] : ''; }));

    /* Email notification (best effort, never blocks the write) */
    try {
      var subject = '[Finchase] ' + tab + ' — ' + email;
      var body = headers.map(function (h) {
        var v = String(rowMap[h] === undefined ? '' : rowMap[h]);
        if (v.length > 1200) v = v.slice(0, 1200) + '…';
        return h + ': ' + v;
      }).join('\n');
      MailApp.sendEmail(CONFIG.NOTIFY_EMAIL, subject, body);
    } catch (merr) {}

    return json_({ success: true });
  } catch (err) {
    return json_({ success: false, message: String(err && err.message || err) });
  }
}

function guessType_(d) {
  if (d.building || d.help_needed || d.stage) return 'conversation';
  if (d.trigger || d.service) return 'gate_download';
  return 'newsletter';
}

function json_(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}
