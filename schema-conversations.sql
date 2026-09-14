-- Finchase Capital, confidential "Start the Conversation" submissions (Cloudflare D1).
-- Re-runnable. Apply to the SAME D1 database the site already uses for rates:
--   wrangler d1 execute finchase-rates --remote --file=schema-conversations.sql
-- (Use your actual database name if different. Tables are separate from `rates`.)

CREATE TABLE IF NOT EXISTS conversations (
  id          TEXT PRIMARY KEY,
  created_at  TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at  TEXT NOT NULL DEFAULT (datetime('now')),
  name        TEXT NOT NULL,
  phone       TEXT NOT NULL,
  email       TEXT NOT NULL,
  linkedin    TEXT NOT NULL DEFAULT '',
  stage       TEXT NOT NULL,
  building    TEXT NOT NULL,
  problem     TEXT NOT NULL,
  help_needed TEXT NOT NULL,
  video_url   TEXT NOT NULL DEFAULT '',
  nda_request INTEGER NOT NULL DEFAULT 0,
  file_key    TEXT NOT NULL DEFAULT '',
  file_name   TEXT NOT NULL DEFAULT '',
  file_size   INTEGER NOT NULL DEFAULT 0,
  file_type   TEXT NOT NULL DEFAULT '',
  ip_hash     TEXT NOT NULL DEFAULT '',
  status      TEXT NOT NULL DEFAULT 'new',
  notes       TEXT NOT NULL DEFAULT '',
  flagged_at  TEXT
);

CREATE INDEX IF NOT EXISTS idx_conv_status_created ON conversations(status, created_at);
CREATE INDEX IF NOT EXISTS idx_conv_email_created ON conversations(email, created_at);
CREATE INDEX IF NOT EXISTS idx_conv_ip_created ON conversations(ip_hash, created_at);

-- Admin login sessions (cookie token hashes, 12h expiry).
CREATE TABLE IF NOT EXISTS admin_sessions (
  token_hash TEXT PRIMARY KEY,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  expires_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_sess_expires ON admin_sessions(expires_at);

-- Generic rate-limit hits (key = purpose + identifier, ts = unix seconds).
CREATE TABLE IF NOT EXISTS rate_hits (
  key TEXT NOT NULL,
  ts  INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_rate_key_ts ON rate_hits(key, ts);
