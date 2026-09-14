-- Finchase Capital, rates store (Cloudflare D1).
-- Single source of truth for js/tools.js. Re-runnable (INSERT OR REPLACE).
-- Apply:  wrangler d1 execute finchase-rates --remote --file=schema.sql

CREATE TABLE IF NOT EXISTS rates (
  key            TEXT PRIMARY KEY,
  value          TEXT NOT NULL,
  effective_from TEXT NOT NULL DEFAULT '2025-04-01',
  source         TEXT NOT NULL DEFAULT '',
  updated_at     TEXT NOT NULL DEFAULT (datetime('now'))
);

INSERT OR REPLACE INTO rates (key, value, effective_from, source) VALUES
('corp', '{"baa":0.22,"baaSur":0.10,"std":0.25,"stdBig":0.30,"sur1":0.07,"sur2":0.12,"llp":0.30,"llpSur":0.12,"cess":0.04}',
 '2025-04-01', 'Finance Act 2025 (115BAA / standard / LLP provisions)'),
('rebate', '{"old":500000,"neu":700000}',
 '2025-04-01', 'Finance Act 2025 (87A rebate limits)'),
('slabs_new', '[[300000,0],[700000,0.05],[1000000,0.10],[1200000,0.15],[1500000,0.20],[null,0.30]]',
 '2025-04-01', 'Finance Act 2025 (new regime individual slabs)'),
('slabs_old', '[[250000,0],[500000,0.05],[1000000,0.20],[null,0.30]]',
 '2025-04-01', 'Finance Act 2025 (old regime individual slabs)'),
('msme', '{"micro":[10000000,50000000],"small":[100000000,500000000],"medium":[500000000,2500000000]}',
 '2020-07-01', 'MSME notification S.O. 2119(E) as amended (composite criteria)'),
('mult', '{"saas":[8,12,18,28],"fintech":[6,10,14,22],"consumer":[2,4,8,14],"manufacturing":[1.2,2.5,6,10],"health":[4,7,12,18],"logistics":[1.5,3,8,12],"edtech":[3,6,10,16],"other":[2,4,8,14]}',
 '2026-04-01', 'Internal review Apr 2026 (observed private-market bands, directional)'),
('stageMult', '{"pre":0.7,"early":0.9,"growth":1,"ent":1.15}',
 '2026-04-01', 'Internal review Apr 2026'),
('cma', '{"wc":0.25,"margin":0.05}',
 '2025-04-01', 'RBI Nayak-committee turnover method as applied'),
('foir', '{"ok":40,"stretch":60}',
 '2026-04-01', 'Internal review Apr 2026 (lender FOIR norms vary by profile)'),
('meta', '{"verified":"Apr 2026","fy":"FY 2025-26"}',
 '2026-04-01', 'Finchase Capital review cycle');

