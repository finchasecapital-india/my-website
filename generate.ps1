$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
function P($n) { if ($n) { "../" } else { "" } }

function Head($title, $desc, $path, $nested, $schema, $keywords) {
  $pre = P $nested
  $canon = 'https://finchasecapital.in/' + $path
  $kwTag = ''
  if ($keywords) { $kwTag = '  <meta name="keywords" content="' + $keywords + '">' }
  $h = @'
<!DOCTYPE html>
<html lang="en-IN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>__TITLE__</title>
  <meta name="description" content="__DESC__">
__KEYWORDS__
  <link rel="canonical" href="__CANON__">
  <meta property="og:title" content="__TITLE__">
  <meta property="og:description" content="__DESC__">
  <meta property="og:image" content="https://finchasecapital.in/images/og-logo.png">
  <meta property="og:type" content="website">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="__TITLE__">
  <meta name="twitter:description" content="__DESC__">
  <meta name="twitter:image" content="https://finchasecapital.in/images/og-logo.png">
  <link rel="icon" type="image/png" href="__PRE__images/favicon-32.png">
  <link rel="apple-touch-icon" href="__PRE__images/apple-touch-icon.png">
  <meta name="theme-color" content="#0F2942">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;1,300;1,400&family=Poppins:wght@300;400;500;600&display=swap">
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;1,300;1,400&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
  <link rel="stylesheet" href="__PRE__css/style.css?v=38">
  __SCHEMA__
</head>
'@
  $h.Replace('__TITLE__', $title).Replace('__DESC__', $desc).Replace('__KEYWORDS__', $kwTag).Replace('__CANON__', $canon).Replace('__PRE__', $pre).Replace('__SCHEMA__', [string]$schema)
}

function ChromeStart($nested, $active, $noWa, $noOrbs) {
  $pre = P $nested
  $body = if ($noWa) { '<body class="no-wa">' } else { "<body>" }
  $orbHtml = if ($noOrbs) { "" } else { '  <div class="ambient-canvas" aria-hidden="true"><div class="orb orb-blue"></div><div class="orb orb-purple"></div><div class="orb orb-green"></div></div>' }
  $cur = { param($n) if ($n -eq $active) { ' aria-current="page"' } else { "" } }
  @"
$body
  <a class="skip-link" href="#main">Skip to content</a>
  $orbHtml
  <div class="page">
    <div class="announce"><span class="pulse-dot"></span><span class="full">Finchase Capital is now onboarding FY 2026–27 engagements.</span> <a href="$($pre)contact.html">Book a strategy call -></a></div>
    <header class="site-header">
      <div class="container nav-inner">
        <a class="logo" href="$($pre)index.html"><span class="logo-mark"><img src="$($pre)images/finchase-logo.png" alt="Finchase Capital" loading="eager" onerror="this.remove()"></span>Finchase Capital</a>
        <nav class="nav-links" aria-label="Primary">
          <a class="nav-link" href="$($pre)index.html"$(& $cur 'home')>Home</a>
          <a class="nav-link" href="$($pre)about.html"$(& $cur 'about')>Story</a>
          <div class="nav-item">
            <a class="nav-link" href="$($pre)services.html"$(& $cur 'services')>Practice</a>
            <div class="mega">
              <div><h4>Build</h4><a href="$($pre)services/incorporation.html">Incorporation</a><a href="$($pre)services/startup-india.html">Startup India</a><a href="$($pre)services/founders-agreement.html">Founders' Agreement</a><a href="$($pre)services/gst.html">GST</a></div>
              <div><h4>Operate</h4><a href="$($pre)services/bookkeeping.html">Bookkeeping</a><a href="$($pre)services/financial-statements.html">Financial Statements</a><a href="$($pre)services/indirect-tax.html">Indirect Tax</a><a href="$($pre)services/itr.html">ITR Filing</a><a href="$($pre)services/payroll.html">Payroll</a><a href="$($pre)services/tax-planning.html">Tax Planning</a><a href="$($pre)services/tds.html">TDS Filing</a></div>
              <div><h4>Govern</h4><a href="$($pre)services/bank-branch-audit.html">Bank Branch Audit</a><a href="$($pre)services/budgeting.html">Budgeting</a><a href="$($pre)services/certifications.html">Certifications</a><a href="$($pre)services/concurrent-audit.html">Concurrent Audit</a><a href="$($pre)services/internal-audit.html">Internal Audit</a><a href="$($pre)services/international-tax.html">International Tax</a><a href="$($pre)services/project-finance.html">Project Finance</a><a href="$($pre)services/roc.html">ROC Compliance</a><a href="$($pre)services/statutory-audit.html">Statutory Audit</a><a href="$($pre)services/stock-audit.html">Stock Audit</a><a href="$($pre)services/tax-audit.html">Tax Audit</a><a href="$($pre)services/transfer-pricing.html">Transfer Pricing</a><a href="$($pre)services/unit-economics.html">Unit Economics</a></div>
              <div><h4>Scale</h4><a href="$($pre)services/bank-funding.html">Bank Funding</a><a href="$($pre)services/capital-restructuring.html">Capital Restructuring</a><a href="$($pre)services/due-diligence.html">Due Diligence</a><a href="$($pre)services/esop.html">ESOP</a><a href="$($pre)services/financial-modeling.html">Financial Modeling</a><a href="$($pre)services/fundraising.html">Fundraising</a><a href="$($pre)services/ma.html">M&amp;A</a><a href="$($pre)services/strategic-mentorship.html">Strategic Mentorship</a><a href="$($pre)services/valuation.html">Valuation</a></div>
              <div><h4>Exit</h4><a href="$($pre)services/drhp.html">DRHP</a><a href="$($pre)services/ipo-pricing.html">Initial Public Offering</a><a href="$($pre)services/pre-ipo.html">Pre-IPO</a><a href="$($pre)services/post-ipo.html">Post-IPO</a></div>
            </div>
          </div>
          <a class="nav-link" href="$($pre)insights.html"$(& $cur 'insights')>Notes</a>
          <a class="nav-link" href="$($pre)start-conversation.html"$(& $cur 'start')>Start the Conversation</a>
        </nav>
        <div class="nav-actions">
          <button class="hamburger" type="button" aria-label="Open menu" aria-expanded="false"><span></span><span></span><span></span></button>
        </div>
      </div>
    </header>
    <div class="drawer-overlay"></div>
    <aside class="drawer"><a href="$($pre)index.html">Home</a><a href="$($pre)about.html">Story</a><details><summary>Practice</summary><a href="$($pre)services.html">All services</a><a href="$($pre)services.html#build">Build</a><a href="$($pre)services.html#operate">Operate</a><a href="$($pre)services.html#govern">Govern</a><a href="$($pre)services.html#scale">Scale</a><a href="$($pre)services.html#exit">Exit</a></details><a href="$($pre)insights.html">Notes</a><a href="$($pre)start-conversation.html">Start the Conversation</a><p style="margin-top:20px;font-size:13px;color:var(--mid-gray)">finchasecapital@gmail.com<br>Indore, Madhya Pradesh</p></aside>
    <main id="main">
"@
}

function ChromeEnd($nested) {
  $pre = P $nested
  @"
    </main>
    <footer class="site-footer">
      <div class="container">
        <div class="ft-top">
          <div class="ft-brand"><a class="logo" href="$($pre)index.html" style="color:#fff" aria-label="Finchase Capital"><span class="logo-mark"><img src="$($pre)images/finchase-logo.png" alt="Finchase Capital" loading="eager" onerror="this.remove()"></span></a>
            <div class="socials"><a href="#" aria-label="LinkedIn"><i data-lucide="linkedin"></i></a><a href="#" aria-label="X"><i data-lucide="twitter"></i></a><a href="#" aria-label="Instagram"><i data-lucide="instagram"></i></a></div></div>
          <form class="news" data-fc-form="newsletter" method="post"><input type="hidden" name="form_type" value="newsletter"><input type="email" name="email" required placeholder="Work email" aria-label="Work email"><button class="btn btn-primary" type="submit">Subscribe</button></form>
        </div>
        <div class="ft-nav">
          <div><a href="$($pre)case-studies.html">Proof</a><a href="$($pre)tools.html">Instruments</a><a href="$($pre)contact.html">Contact</a></div>
          <div><a href="$($pre)privacy-policy.html">Privacy Policy</a><a href="$($pre)terms-of-use.html">Terms of Use</a><a href="$($pre)grievance-redressal.html">Grievance Redressal</a><a href="$($pre)professional-conduct.html">Professional &amp; Ethical Conduct Policy</a></div>
        </div>
        <div class="ft-giant" aria-hidden="true">Finchase Capital</div>
        <div class="ft-bot"><span>© 2025–2026 Finchase Capital Private Limited. All rights reserved.</span><span>India's end-to-end finance firm.</span></div>
      </div>
    </footer>
  </div>
  <div class="mobile-cta"><a class="btn btn-primary" href="$($pre)contact.html">Book Consultation</a><a class="btn btn-secondary" href="mailto:finchasecapital@gmail.com">Email Us</a></div>
  <div class="modal-bg" id="exit-modal" role="dialog"><div class="glass-card modal"><button class="x" type="button" aria-label="Close">×</button><h3>Before you go - a 30-minute diagnostic.</h3><p>Leave your email. Our team will send a one-page lifecycle map for your stage.</p><form id="exit-form" data-fc-form="exit_intent" class="field" style="margin-top:16px" method="post"><input type="hidden" name="form_type" value="exit_intent"><input type="email" name="email" required placeholder="Founder email" aria-label="Founder email"><button class="btn btn-primary" type="submit" style="margin-top:10px">Send the map</button></form></div></div>
  <div class="modal-bg" id="gate-modal" role="dialog"><div class="glass-card modal"><button class="x" type="button" aria-label="Close">×</button><h3>Where should we send it?</h3><form id="gate-form" data-fc-form="gate_download" method="post"><input type="hidden" name="form_type" value="gate_download"><label class="field"><input type="email" name="email" required placeholder="Work email" aria-label="Work email"></label><button class="btn btn-primary" type="submit">Continue</button></form></div></div>
  <script src="https://unpkg.com/lucide@latest" async onload="window.lucide&&lucide.createIcons()"></script>
  <script src="$($pre)js/main.js?v=7"></script>
</body></html>
"@
}

function Cta($nested) {
  $pre = P $nested
  @"
<section class="section final-cta ed-cta"><div class="container"><div class="cta-inner">
<h2>Ready to build a company that lasts generations?</h2>
<p style="margin:12px 0 22px">One 30-minute call covers audit, tax, debt and capital — because one team does all four.</p>
<a class="btn btn-primary btn-lg" href="$($pre)contact.html">Book Free Consultation</a>
<a class="btn btn-secondary" href="mailto:finchasecapital@gmail.com">finchasecapital@gmail.com</a>
<p class="micro">No spam · 100% confidential · <a href="$($pre)contact.html#book" style="text-decoration:underline;text-underline-offset:3px">or pick a time</a></p></div></div></section>
"@
}

# --- ABOUT ---
$about = (Head 'About Finchase Capital - lifecycle advisory from incorporation to IPO' 'The story, team and operating principles behind Finchase Capital Private Limited, an integrated financial services firm in Indore, Madhya Pradesh.' 'about.html' $false '<script type="application/ld+json">{"@context":"https://schema.org","@type":"ProfessionalService","name":"Finchase Capital Private Limited","description":"Indore-based end-to-end lifecycle finance firm: incorporation to IPO under one roof with zero consultant handoffs.","founder":{"@type":"Person","name":"CA Vaibhav Saklecha"},"address":{"@type":"PostalAddress","addressLocality":"Indore","addressRegion":"Madhya Pradesh","addressCountry":"IN"},"areaServed":{"@type":"Country","name":"IN"},"knowsAbout":["lifecycle advisory","startup incorporation","audit and assurance","tax planning","debt syndication","business valuation","fundraising","pre-IPO readiness"]}</script>' 'Finchase Capital Private Limited, CA Vaibhav Saklecha, lifecycle advisory firm India, integrated financial services firm Indore, Build Operate Govern Scale Exit, single financial backbone startup India, Day 0 to IPO advisory') + (ChromeStart $false 'about' $false) + @"
<section class="page-hero" style="background:var(--off-white)"><div class="container">
  <span class="section-label">About</span>
  <h1>We don't just file your returns.<br>We <em class="italic gradient-text">architect</em> your future.</h1>
  <p class="sub" style="max-width:1200px;font-size:1rem;line-height:1.7;text-align:justify">Finchase Capital Private Limited, an integrated financial services firm headquartered in Indore, Madhya Pradesh, positioning itself as a unified business solutions provider, helping companies navigate their entire lifecycle from corporate establishment up to capital markets. Led by CA Vaibhav Saklecha, with a team of 20 professionals across assurance, tax, debt and capital markets.</p>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">01 - STORY</span>
  <h2>A practice built on one idea: context compounds.</h2>
  <div class="timeline" data-animate="fade-in" style="margin-top:36px">
    <div class="tl-row"><div class="yr">Origin</div><div><h3>A <span class="grad-em">practice</span>, not a plan</h3><p>Vaibhav Saklecha qualified as a Chartered Accountant and began independent practice, building the kind of client relationships that don't show up in a scope-of-work, the ones where the accountant is trusted before the number is.</p></div></div>
    <div class="tl-row"><div class="yr">Proof</div><div><h3>The first <span class="grad-em">listings</span></h3><p>Over the years that followed, that practice carried a handful of companies through to public listing, work that doesn't reward good intentions, only precision. Around this time, Ishan Chopra joined the practice.</p></div></div>
    <div class="tl-row"><div class="yr">Convergence</div><div><h3>Two <span class="grad-em">ways</span> of working, one standard</h3><p>What followed was less a handover than a convergence, two more listings completed together, run alongside an established practice on one side and a disciplined early independent practice on the other. The work looked the same either way, which was the point.</p></div></div>
    <div class="tl-row"><div class="yr">The Gap</div><div><h3>The <span class="grad-em">problem</span> neither of us was hired to fix</h3><p>Somewhere in that stretch, a pattern became impossible to ignore: a founder building a company would end up managing three or four different consultants, an accountant here, a lawyer there, a valuer somewhere else, and spend more energy translating between them than building the business itself. Nobody was responsible for the whole picture. Everybody was responsible for a piece of it.</p></div></div>
    <div class="tl-row"><div class="yr">Finchase</div><div><h3>One firm, built to hold the <span class="grad-em">whole picture</span></h3><p>Finchase Capital was founded to close exactly that gap, a single team carrying a company's full financial and regulatory context from day zero through to the public markets, so a founder never has to re-explain their business to someone new again. One firm holding the whole picture — that's the gap Finchase was founded to close.</p></div></div>
  </div>
  <div class="ph about-img"><img src="images/about-office.png" alt="Finchase Capital studio, Indore" loading="lazy" onerror="this.closest('.about-img').remove()"></div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">02 - TEAM</span>
  <h2>Founders who stay in the room.</h2>
  <div class="team-grid" style="margin-top:28px" data-stagger>
    <article class="flip-card" data-flip><div class="flip-inner">
      <div class="flip-face flip-front">
        <span class="flip-lines" aria-hidden="true"><i></i><i></i><i></i></span>
        <span class="flip-role">Co-founder</span>
        <img class="flip-photo" src="images/vs%20image.png" alt="Portrait of CA Vaibhav Saklecha" loading="lazy">
        <div class="flip-foot"><h3>CA Vaibhav<br>Saklecha</h3><button type="button" class="flip-btn" aria-label="Flip card to read introduction"><i data-lucide="arrow-right"></i></button></div>
      </div>
      <div class="flip-face flip-back">
        <h3>CA Vaibhav Saklecha</h3>
        <p>Vaibhav Saklecha is a practicing Chartered Accountant with 14+ years across bank finance, capital structuring, SME &amp; mainboard IPO advisory, ESG strategy and government mandates — from early raises to listings, SEBI compliance and cross-border setup.</p>
        <div class="flip-back-foot">
          <a class="flip-link" href="https://vaibhavsaklecha.in/" target="_blank" rel="noopener">vaibhavsaklecha.in →</a>
          <button type="button" class="flip-btn" aria-label="Flip card back"><i data-lucide="arrow-left"></i></button>
        </div>
      </div>
    </div></article>
    <article class="flip-card" data-flip><div class="flip-inner">
      <div class="flip-face flip-front">
        <span class="flip-lines" aria-hidden="true"><i></i><i></i><i></i></span>
        <span class="flip-role">Co-founder</span>
        <span class="flip-mono" aria-hidden="true">C</span>
        <div class="flip-foot"><h3>Cofounder</h3><button type="button" class="flip-btn" aria-label="Flip card to read introduction"><i data-lucide="arrow-right"></i></button></div>
      </div>
      <div class="flip-face flip-back">
        <h3>Cofounder</h3>
        <p>Co-founder at Finchase Capital, partnering with founders from the first cheque to the public listing. Sample introduction text — the final bio, photo, and website link will replace this placeholder.</p>
        <div class="flip-back-foot">
          <a class="flip-link" href="#" aria-label="Cofounder website (coming soon)">Website →</a>
          <button type="button" class="flip-btn" aria-label="Flip card back"><i data-lucide="arrow-left"></i></button>
        </div>
      </div>
    </div></article>
  </div>
  <script>
  document.addEventListener('click', function (e) {
    var btn = e.target.closest ? e.target.closest('.flip-btn') : null;
    if (!btn) return;
    var card = btn.closest('[data-flip]');
    if (card) card.classList.toggle('flipped');
  });
  </script>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">03 - VALUES</span>
  <div class="values" data-stagger>
    <article class="glass-card pillar"><img class="pillar-media" src="images/candor-first.jpg" alt="Candor First" loading="lazy"><h3>Candor First</h3><p>Fees, scope, and findings — always in writing, before you have to ask. No surprise invoices, ever.</p></article>
    <article class="glass-card pillar"><img class="pillar-media" src="images/speak-founder.jpg" alt="Speak Founder" loading="lazy"><h3>Speak Founder</h3><p>We lead with runway and dilution, not legal jargon. A section number only comes up if it actually changes your decision.</p></article>
    <article class="glass-card pillar"><img class="pillar-media" src="images/built-to-close.jpg" alt="Built to Close" loading="lazy"><h3>Built to Close</h3><p>A filing is just paperwork. A closed round, a clean audit, lower leakage — that's what we're actually here to deliver.</p></article>
    <article class="glass-card pillar"><img class="pillar-media" src="images/play-the-long-game.jpg" alt="Play the Long Game" loading="lazy"><h3>Play the Long Game</h3><p>We'd rather stay your advisor through the listing than win one big filing and never hear from you again.</p></article>
  </div>
</div></section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content -Path "$root\about.html" -Value $about -Encoding UTF8

# --- SERVICES HUB ---
$phases = @(
  @{ id="build"; n="01"; title="Build"; s="Identity, equity & tax registration"; d="Legal identity, equity, and tax registration before the first invoice."; count="4"; img="phase-build.png"; alt="Founders formalising company setup, Finchase Capital Build phase" },
  @{ id="operate"; n="02"; title="Operate"; s="Books, payroll & tax discipline"; d="Books, people costs, and tax that keep the company honest every month."; count="7"; img="phase-operate.png"; alt="Monthly close and reporting discipline, Finchase Capital Operate phase" },
  @{ id="govern"; n="03"; title="Govern"; s="Audit, ROC & board controls"; d="Audit, ROC, forecasts, and certifications lenders and boards require."; count="13"; img="phase-govern.png"; alt="Board-grade governance and audit, Finchase Capital Govern phase" },
  @{ id="scale"; n="04"; title="Scale"; s="Valuation, capital & deals"; d="Valuation, capital, ESOPs, and transactions that change the cap table."; count="9"; img="phase-scale.png"; alt="Fundraising and growth capital, Finchase Capital Scale phase" },
  @{ id="exit"; n="05"; title="Exit"; s="IPO readiness & listing"; d="Public-market hygiene from restructuring through post-listing IR."; count="4"; img="phase-exit.png"; alt="IPO and public listing readiness, Finchase Capital Exit phase" }
)

$svc = @(
  @{ slug="incorporation"; phase="build"; name="Company and LLP Incorporation"; icon="building-2"; blurb="SPICe+, FiLLiP, and a share regime that will survive a term sheet." },
  @{ slug="startup-india"; phase="build"; name="Startup India Recognition and DPIIT Registration"; icon="badge-check"; blurb="Recognition, 80-IAC mapping, and a file SEBI or a fund will not reject." },
  @{ slug="founders-agreement"; phase="build"; name="Founders' Agreement and Equity Splitting Advisory"; icon="users"; blurb="Vesting, roles, IP assignment, and deadlock - in founder English." },
  @{ slug="gst"; phase="build"; name="GST Registration and Return Filing"; icon="receipt"; blurb="Registration, GSTR cadence, and reconciliations that match the books." },
  @{ slug="bookkeeping"; phase="operate"; name="Financial Record Keeping and Bookkeeping"; icon="book-open"; blurb="Accrual close, vendor hygiene, and a chart of accounts built for MIS." },
  @{ slug="payroll"; phase="operate"; name="Payroll Management"; icon="wallet"; blurb="Payslips, PF/ESI, and TDS that employees and inspectors both accept." },
  @{ slug="financial-statements"; phase="operate"; name="Financial Statement Preparation"; icon="file-text"; blurb="Schedule III packs, notes, and cash-flow that bankers can underwrite." },
  @{ slug="tds"; phase="operate"; name="TDS Compliance and Filing"; icon="percent"; blurb="Deduction logic, deposits, and returns without interest leakage." },
  @{ slug="itr"; phase="operate"; name="Income Tax Return (ITR) Filing"; icon="file-check"; blurb="Company, LLP, and founder ITRs that reconcile to the trial balance." },
  @{ slug="tax-planning"; phase="operate"; name="Tax Planning and Advisory"; icon="calculator"; blurb="Structure, timing, and incentives decided before the year closes." },
  @{ slug="indirect-tax"; phase="operate"; name="Indirect Tax Advisory"; icon="package"; blurb="Classification, place of supply, and litigation posture for GST." },
  @{ slug="statutory-audit"; phase="govern"; name="Statutory Audit"; icon="shield-check"; blurb="An opinion your lenders, board, and future buyer can rely on." },
  @{ slug="tax-audit"; phase="govern"; name="Tax Audit"; icon="search"; blurb="Form 3CA/3CB and 3CD that match reality, not last year's template." },
  @{ slug="internal-audit"; phase="govern"; name="Internal Audit"; icon="scan-eye"; blurb="Controls, revenue leakage, and a cycle the audit committee can use." },
  @{ slug="roc"; phase="govern"; name="Registrar of Companies (ROC) Compliance"; icon="landmark"; blurb="Annual and event-based MCA filings without compounding surprises." },
  @{ slug="budgeting"; phase="govern"; name="Budgeting and Forecasting"; icon="line-chart"; blurb="Board packs tied to hiring, burn, and covenant headroom." },
  @{ slug="unit-economics"; phase="govern"; name="Business Model Validation and Unit Economics Advisory"; icon="sigma"; blurb="Contribution, CAC payback, and a story the model can defend." },
  @{ slug="project-finance"; phase="govern"; name="Project Finance"; icon="scroll"; blurb="CMA data, DSCR, and a narrative credit committees finish." },
  @{ slug="stock-audit"; phase="govern"; name="Stock Audit"; icon="boxes"; blurb="Physical verification and valuation that working-capital lenders trust." },
  @{ slug="bank-branch-audit"; phase="govern"; name="Bank Branch Audit"; icon="building"; blurb="RBI-grade branch work with documentation that survives LFAR review." },
  @{ slug="concurrent-audit"; phase="govern"; name="Concurrent Audit"; icon="activity"; blurb="In-year control testing for banks, NBFCs, and high-volume ops." },
  @{ slug="international-tax"; phase="govern"; name="International Taxation Advisory"; icon="globe"; blurb="PE, DTAA, equalisation, and substance for cross-border founders." },
  @{ slug="transfer-pricing"; phase="govern"; name="Transfer Pricing Documentation"; icon="git-compare"; blurb="Local file, Form 3CEB, and methods that match how you actually operate." },
  @{ slug="certifications"; phase="govern"; name="Statutory Certifications"; icon="stamp"; blurb="Net-worth, turnover, and special-purpose certificates on letterhead." },
  @{ slug="valuation"; phase="scale"; name="Business Valuation"; icon="pie-chart"; blurb="DCF, comps, and 56(2)(viib) / FEMA reports boards can sign." },
  @{ slug="esop"; phase="scale"; name="ESOP Structuring and Compliance"; icon="layers"; blurb="Pool, trust, grants, and tax that employees can explain at dinner." },
  @{ slug="financial-modeling"; phase="scale"; name="Financial Modeling and Pitch Deck Preparation"; icon="table"; blurb="Three-statement models and a deck whose numbers match the data room." },
  @{ slug="strategic-mentorship"; phase="scale"; name="Strategic Mentorship and Growth Advisory"; icon="compass"; blurb="A CA in the weekly operating rhythm - not a once-a-year signing." },
  @{ slug="fundraising"; phase="scale"; name="Venture Capital and Private Equity Fundraising Advisory"; icon="rocket"; blurb="Process, data room, and term-sheet mechanics for Indian rounds." },
  @{ slug="due-diligence"; phase="scale"; name="Financial Due Diligence"; icon="file-search"; blurb="Buy-side and sell-side QoE that prices risk instead of hiding it." },
  @{ slug="ma"; phase="scale"; name="Mergers and Acquisitions Advisory"; icon="git-merge"; blurb="Structure, synergy, and closing accounts for India Inc. deals." },
  @{ slug="capital-restructuring"; phase="scale"; name="Capital Restructuring and Financial Reengineering"; icon="refresh-cw"; blurb="Bonus, buyback, merger, and debt-equity that MCA will register." },
  @{ slug="bank-funding"; phase="scale"; name="Bank Funding for Scale"; icon="landmark"; blurb="Bank, NBFC, and structured debt with covenant design." },
  @{ slug="pre-ipo"; phase="exit"; name="Pre-IPO Restructuring and Compliance"; icon="building"; blurb="Group cleanup, related parties, and restatements before the DRHP." },
  @{ slug="drhp"; phase="exit"; name="Draft Red Herring Prospectus (DRHP) Financial Drafting"; icon="file-stack"; blurb="MD and A-ready numbers and notes that survive SEBI comments." },
  @{ slug="ipo-pricing"; phase="exit"; name="Initial Public Offering and Underwriting Coordination"; icon="badge-indian-rupee"; blurb="Bridge between the model, comps, and the book-building room." },
  @{ slug="post-ipo"; phase="exit"; name="Post-IPO Compliance and Investor Relations Support"; icon="megaphone"; blurb="Results calendar, IND AS packs, and IR that listed life requires." }
)

# Number the services 01-37 in catalogue order and build the dashboard pieces.
$n = 0
$svcNumbered = $svc | ForEach-Object { $n++; $num = "{0:D2}" -f $n; @{ num=$num; phase=$_.phase; slug=$_.slug; name=$_.name; blurb=$_.blurb } }

# Structured data store: data/services.json (single source for the front-end console).
$jsonPhases = ($phases | ForEach-Object { '{"id":"' + $_.id + '","n":"' + $_.n + '","title":"' + $_.title + '","short":"' + $_.s + '","desc":"' + $_.d + '"}' }) -join ","
$jsonSvc = ($svcNumbered | ForEach-Object { '{"num":"' + $_.num + '","phase":"' + $_.phase + '","slug":"' + $_.slug + '","name":"' + ($_.name -replace '"','\"') + '","blurb":"' + ($_.blurb -replace '"','\"') + '"}' }) -join ","
$svcJson = '{"phases":[' + $jsonPhases + '],"services":[' + $jsonSvc + ']}'
[System.IO.File]::WriteAllText("$root\data\services.json", $svcJson, (New-Object System.Text.UTF8Encoding $false))

# Serverless data endpoint: GET /api/services (Cloudflare Pages Function).
# Deploy: git push to the connected GitHub repo, files under functions/api/
# become serverless endpoints automatically. No payment gateway SDKs anywhere
# in this stack. Catalogue is baked in at build time from the same $svc source.
$apiServices = @'
/* Finchase Capital, Services catalogue API (Cloudflare Pages Function).
 *
 * GET /api/services → { phases, services }, 37 advisory services mapped to
 *   5 chronological phases. Generated from generate.ps1, do not hand-edit.
 *   Cached at the edge for 1h. Any failure → 503 JSON.
 */
const CATALOGUE = __CATALOGUE__;

export async function onRequestGet(context) {
  try {
    const cached = await caches.default.match(context.request);
    if (cached) return cached;
    const res = new Response(JSON.stringify(CATALOGUE), {
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "public, max-age=3600, stale-while-revalidate=86400",
        "Access-Control-Allow-Origin": "*"
      }
    });
    context.waitUntil(caches.default.put(context.request, res.clone()));
    return res;
  } catch (e) {
    return Response.json({ error: "services unavailable" }, { status: 503 });
  }
}
'@
$apiServices = $apiServices.Replace('__CATALOGUE__', $svcJson)
[System.IO.File]::WriteAllText("$root\functions\api\services.js", $apiServices, (New-Object System.Text.UTF8Encoding $false))

# Timeline component: one rail section per phase; cards ride an infinite carousel track.
$tlPhases = ($phases | ForEach-Object {
  $ph = $_
  $cards = (($svcNumbered | Where-Object { $_.phase -eq $ph.id } | ForEach-Object -Begin { $script:i = 0 } -Process {
    $c = '<a class="tl-card" style="--i:' + $script:i + '" href="services/' + $_.slug + '.html"><strong class="tl-card-name">' + $_.name + '</strong><span class="tl-card-blurb">' + $_.blurb + '</span><span class="tl-card-go">Open <span aria-hidden="true">↗</span></span></a>'
    $script:i++
    $c
  }) -join "`r`n            ")
  '      <section class="tl-phase" id="' + $ph.id + '" data-phase="' + $ph.id + '">' + "`r`n" + '        <div class="tl-node" aria-hidden="true"><svg class="tl-ring" viewBox="0 0 64 64" aria-hidden="true"><circle class="tl-ring-bg" cx="32" cy="32" r="30.5"/><circle class="tl-ring-fg" cx="32" cy="32" r="30.5"/></svg><span>' + $ph.n + '</span></div>' + "`r`n" + '        <div class="tl-head"><span class="tl-eyebrow">Phase ' + $ph.n + '</span><h2>' + $ph.title + '</h2><p>' + $ph.d + '</p></div>' + "`r`n" + '        <div class="tl-car">' + "`r`n" + '          <button type="button" class="tl-arrow prev" aria-label="Previous ' + $ph.title + ' services"><i data-lucide="chevron-left"></i></button>' + "`r`n" + '          <div class="tl-view"><div class="tl-track">' + "`r`n" + '            ' + $cards + "`r`n" + '          </div></div>' + "`r`n" + '          <button type="button" class="tl-arrow next" aria-label="Next ' + $ph.title + ' services"><i data-lucide="chevron-right"></i></button>' + "`r`n" + '        </div>' + "`r`n" + '      </section>'
}) -join "`r`n"

$svcSchemaItems = ($svc | ForEach-Object -Begin { $script:n = 0 } -Process { $script:n++; '{"@type":"ListItem","position":' + $script:n + ',"name":"' + $_.name + '","url":"https://finchasecapital.in/services/' + $_.slug + '.html"}' }) -join ","
$svcSchema = '<script type="application/ld+json">{"@context":"https://schema.org","@type":"ItemList","name":"Finchase Capital lifecycle services","itemListElement":[' + $svcSchemaItems + "]}</script>"
$services = (Head 'Services - 35+ services from incorporation to IPO | Finchase Capital' 'Explore Build, Operate, Govern, Scale, and Exit services from Finchase Capital in Indore.' 'services.html' $false $svcSchema 'lifecycle advisory services India, Build Operate Govern Scale Exit, incorporation services, audit ROC compliance, business valuation, ESOP fundraising, pre-IPO DRHP, end-to-end finance firm') + (ChromeStart $false 'services' $false $true) + @"
<section class="page-hero"><div class="container">
  <span class="section-label">Services</span>
  <h1>One firm. Every chapter.</h1>
  <p>Five phases, 37 services, one context window. Scroll the timeline, the axis lights up as each phase branches open.</p>
  <p>No second consultant needed between incorporation and IPO.</p>
</div></section>
<section class="section svc-timeline-section" aria-label="Services timeline">
  <div class="container">
    <div class="svc-util">
      <div>
        <span class="section-label svc-eyebrow">Service timeline</span>
        <p class="svc-util-sub">Day 0 → IPO, top to bottom, or filter to jump straight in.</p>
      </div>
      <div class="svc-search"><input id="svc-search" type="search" placeholder="Filter Services" aria-label="Filter services" autocomplete="off"><kbd>Ctrl K</kbd></div>
      <p class="svc-count" id="svc-count" aria-live="polite"></p>
      <a class="svc-link" href="contact.html">Book Consultation <span aria-hidden="true">→</span></a>
    </div>
    <div class="svc-timeline" id="svc-timeline">
      <div class="tl-rail" aria-hidden="true"><div class="tl-fill" id="tl-fill"></div></div>
$tlPhases
    </div>
  </div>
</section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content "$root\services.html" $services -Encoding UTF8

# --- CONTACT ---
# BOOKING SETUP: paste a Calendly/Cal.com scheduling link below to enable embedded
# self-serve booking on contact.html#book. Until then a graceful email fallback shows.
if (-not $BOOKING_URL) { $BOOKING_URL = "https://calendly.com/YOUR-SCHEDULING-LINK" }
$bookBlock = if ($BOOKING_URL -like "*YOUR-SCHEDULING-LINK*") {
@"
<section id="book" class="section" style="padding-top:0"><div class="container"><div class="glass-card" style="padding:32px;text-align:center">
  <span class="section-label">Self-serve booking</span>
  <h2>Prefer to pick a time?</h2>
  <p style="max-width:520px;margin:10px auto 20px">Online scheduling opens soon. Meanwhile, email two slots that suit you, confirmed within one business day.</p>
  <a class="btn btn-primary" href="mailto:finchasecapital@gmail.com?subject=Consultation%20booking%20request">Request a slot by email</a>
</div></div></section>
"@
} else {
@"
<section id="book" class="section" style="padding-top:0"><div class="container"><div class="glass-card" style="padding:32px">
  <span class="section-label" style="display:block;text-align:center">Self-serve booking</span>
  <h2 style="text-align:center">Pick a time that suits you.</h2>
  <p style="text-align:center;max-width:520px;margin:10px auto 20px">Lock in a 30-minute consultation directly, no email wait.</p>
  <iframe src="$BOOKING_URL" style="width:100%;height:700px;border:0;border-radius:12px" title="Book a consultation with Finchase Capital" loading="lazy"></iframe>
</div></div></section>
"@
}
# FORMS BACKEND: Google Apps Script (google-apps-script/Code.gs) bound to the
# Finchase Leads Sheet. Deploy as Web App and paste the /exec URL into
# js/main.js + js/start-conversation.js (FC_BACKEND_URL).
$contact = (Head 'Contact Finchase Capital - Book a consultation in Indore' 'Talk to a senior advisor within one business day. Confidential consultation for founders and finance leaders.' 'contact.html' $false '') + (ChromeStart $false 'contact' $true) + @"
<style id="contact-tweaks">
.map-bleed{position:relative;width:100vw;max-width:100vw;margin-left:calc(50% - 50vw);margin-right:calc(50% - 50vw);margin-top:20px;line-height:0}
.map-bleed iframe{width:100%;height:440px;border:0;display:block}
.map-contact-card{position:absolute;top:24px;right:24px;background:#fff;line-height:1.6;padding:22px 24px;max-width:360px;z-index:2;border-radius:0}
@media(max-width:900px){.map-bleed iframe{height:300px}.map-contact-card{position:static;max-width:none;margin:12px 16px 16px}}
</style>
<section class="section"><div class="container">
  <div style="margin-bottom:0">
    <h1 style="margin:0">Let's talk about the next chapter.</h1>
    <p style="margin:12px 0 0">A 30-minute diagnostic with a senior advisor. No deck required.</p>
    <p style="margin:12px 0 0">One conversation reaches all 37 services. You never re-explain your business.</p>
  </div>
  <div class="map-bleed" id="studio-map">
    <iframe title="Finchase Capital studio location map" src="https://maps.google.com/maps?q=22.723027,75.882480&z=17&output=embed" style="width:100%;height:440px;border:0;display:block" loading="lazy" referrerpolicy="no-referrer-when-downgrade" allowfullscreen></iframe>
    <div class="glass-card map-contact-card">
      <div style="display:grid;gap:8px;font-size:15px">
        <span><strong>Phone:</strong> <a href="tel:+919090600001">+91 90906 00001</a>, <a href="tel:+919324260027">+91 9324260027</a></span>
        <span><strong>Email:</strong> <a href="mailto:finchasecapital@gmail.com">finchasecapital@gmail.com</a></span>
        <span><strong>Address:</strong> 4th floor, Aru Plaza, MG Road, Indore</span>
      </div>
    </div>
  </div>
</div></section>
$bookBlock
"@ + (ChromeEnd $false)
Set-Content "$root\contact.html" $contact -Encoding UTF8

# --- TOOLS ---
$tools = (Head 'Free instruments - tax, equity, compliance, loans, budgets, diagnostics | Finchase Capital' 'Free self-serve instruments: tax, equity, compliance, valuation, loans, budgets and diagnostics, assumptions stated and dated.' 'tools.html' $false '') + (ChromeStart $false 'tools' $false) + @"
<section class="page-hero" id="tool-hub"><div class="container"><span class="section-label">Tools</span><h1>Instruments, not widgets.</h1><p>9 self-serve instruments across tax, equity, compliance, capital and everyday money. Each states its assumptions and the date they were verified.</p>
<p class="micro" id="rates-note" aria-live="polite">Rates baseline: FY 2025-26 (Apr 2026), showing built-in figures.</p>
<nav class="tool-toc" aria-label="Tools on this page">
<a class="toc-link" href="#sec-profit-tax">Business Tax</a>
<a class="toc-link" href="#sec-msme">MSME Check</a>
<a class="toc-link" href="#sec-valuation">Valuation</a>
<a class="toc-link" href="#sec-vest">Vesting</a>
<a class="toc-link" href="#sec-ipo">IPO Readiness</a>
<a class="toc-link" href="#sec-bankloan-q">Bank-Loan Readiness</a>
<a class="toc-link" href="#sec-compliance">Compliance</a>
<a class="toc-link" href="#sec-emi">EMI</a>
<a class="toc-link" href="#sec-cma">CMA Finance</a>
</nav>
</div></section>
<section class="section" style="padding-top:0"><div class="container tools-stack" id="tool-sections"></div></section>
$(Cta $false)
<script src="js/tools.js?v=2"></script>
"@ + (ChromeEnd $false)
Set-Content "$root\tools.html" $tools -Encoding UTF8

# --- 404 ---
$nf = (Head 'Page not found | Finchase Capital' 'The page you requested is not on Finchase Capital.' '404.html' $false '') + (ChromeStart $false '' $false) + @"
<section class="notfound"><div>
  <span class="section-label">404</span>
  <h1>This filing was never made.</h1>
  <p>The URL does not map to a service, insight, or case study.</p>
  <a class="btn btn-primary" href="index.html">Return home</a>
  <a class="btn btn-ghost" href="sitemap.html">View sitemap -></a>
</div></section>
"@ + (ChromeEnd $false)
Set-Content "$root\404.html" $nf -Encoding UTF8

# --- CASE STUDIES INDEX ---
$casesMeta = @(
  @{ slug="series-a-saas-raise"; title="A SaaS round that closed without a cleanup sprint"; tags="startups fundraising"; sector="B2B SaaS"; stage="Seed → Series A"; m1="₹28 Cr"; l1="Raised (representative)"; m2="21"; l2="Days in diligence"; m3="0"; l3="Unexplained items";
     problem="Revenue recognition ran on invoices, not contracts. Deferred revenue, GST on SaaS exports and founder ESOP accounting each told a different story, exactly what a Series A data room exposes.";
     work="Rebuilt the revenue file from contracts, aligned GST refunds on exports, restated two years of MIS and wrote the QoE-style memo the lead fund's diligence team actually read.";
     svcs="Financial Modeling · Valuation · Fundraising Advisory"; quote="They did not decorate the numbers. They made the numbers survivable."; quoteby="Founder, B2B SaaS" },
  @{ slug="gst-optimization-sme"; title="GST leakage found in a mid-market manufacturer"; tags="smes tax"; sector="Mid-market manufacturing"; stage="Growth"; m1="₹1.2 Cr"; l1="Annual leakage stopped"; m2="14"; l2="Months of returns restated"; m3="100%"; l3="E-way bill match";
     problem="GSTR-1, GSTR-3B and the books disagreed every month. E-way bills, job-work challans and ITC claims formed three versions of the same turnover.";
     work="Ran a 14-month reconciliation spine, fixed classification and job-work documentation, restated returns and installed a monthly three-way match the accounts team now runs alone.";
     svcs="GST Filing · Indirect Tax Advisory · Internal Audit"; quote="The first time our GST, books and dispatches agreed with each other."; quoteby="Director, manufacturing SME" },
  @{ slug="ipo-readiness-nbfc"; title="Pre-IPO restatements a merchant banker did not send back"; tags="enterprise ipo"; sector="Lending business"; stage="Pre-IPO track"; m1="3"; l1="Years restated"; m2="12"; l2="Related-party maps"; m3="2"; l3="Comment cycles";
     problem="Three years of financials, twelve related-party relationships and provisioning policies written for a private lender, not for restatement under listing scrutiny.";
     work="Drove restatement policies, mapped every related-party transaction to arm's-length evidence, built the KPI pack and sat through banker comment cycles with working papers ready.";
     svcs="Pre-IPO Restructuring · Statutory Audit · DRHP Drafting"; quote="Pre-IPO restatements that our merchant banker did not send back. That is rare."; quoteby="CFO, lending business" },
  @{ slug="esop-structuring-startup"; title="An ESOP employees could explain without a lawyer"; tags="startups"; sector="Consumer tech"; stage="Seed → Series A"; m1="12%"; l1="Pool"; m2="4"; l2="Year vest"; m3="1"; l3="Board sitting";
     problem="A handshake pool, grants on email and no valuation on record, the exact mix that blows up a priced round's 56(2)(viib) discussion.";
     work="Sized a 12% pool, wrote the scheme with cliff and exercise windows, secured the valuation report and passed it in a single board sitting, with a one-page explainer for employees.";
     svcs="ESOP Structuring · Valuation · ROC Compliance"; quote="ESOPs our engineers finally understood."; quoteby="Founder, consumer tech" },
  @{ slug="tax-planning-enterprise"; title="Group tax cadence for a multi-entity operator"; tags="enterprise tax"; sector="Multi-entity operator"; stage="Growth"; m1="6"; l1="Entities, one calendar"; m2="4"; l2="Advance-tax cycles"; m3="0"; l3="Missed deadlines";
     problem="Six entities, six accountants, one group cash pool. Advance tax was guessed, TDS positions drifted and nobody owned the calendar.";
     work="Consolidated the group tax calendar, re-timed advance tax to cash flows, standardised TDS logic and put one partner on the thread for every deadline.";
     svcs="Tax Planning · TDS Compliance · ITR Filing"; quote="Six entities stopped behaving like six different companies."; quoteby="Group finance head" },
  @{ slug="due-diligence-acquisition"; title="Buy-side QoE that repriced the deal"; tags="enterprise fundraising"; sector="Industrial acquisition"; stage="Acquisition"; m1="11%"; l1="Price adjustment"; m2="9"; l2="Weeks"; m3="1"; l3="SPA schedule";
     problem="The target's EBITDA looked clean until working capital, related-party sales and contingent GST were normalised. The buyer needed a number, not a narrative.";
     work="Delivered a quality-of-earnings report with a net-debt bridge and pegged working capital in nine weeks, the adjustment went straight into the SPA schedule.";
     svcs="Financial Due Diligence · Valuation · M&A Advisory"; quote="They priced the risk instead of hiding it."; quoteby="Acquirer board member" }
)

$caseImg = @{
  "series-a-saas-raise"=@{ img="case-saas-raise.png"; alt="Startup fundraising pitch, Finchase Capital case pattern" };
  "gst-optimization-sme"=@{ img="case-gst-sme.png"; alt="Manufacturing operations, GST case pattern" };
  "ipo-readiness-nbfc"=@{ img="case-ipo.png"; alt="Market listing charts, pre-IPO case pattern" };
  "esop-structuring-startup"=@{ img="case-esop.png"; alt="Startup team equity planning, ESOP case pattern" };
  "tax-planning-enterprise"=@{ img="case-tax.png"; alt="Tax working papers, group tax case pattern" };
  "due-diligence-acquisition"=@{ img="case-diligence.png"; alt="Board-level acquisition review, diligence case pattern" };
}

$caseCards = ($casesMeta | ForEach-Object {
@"
<article class="case-card" data-filter-item data-tags="$($_.tags)">
  <span class="deck-eyebrow">$(($_.tags -split ' ' | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) }) -join ' · ')</span>
  <h3>$($_.title)</h3>
  <div class="metrics3"><div><div class='n'>$($_.m1)</div><div class='l'>$($_.l1)</div></div><div><div class='n'>$($_.m2)</div><div class='l'>$($_.l2)</div></div><div><div class='n'>$($_.m3)</div><div class='l'>$($_.l3)</div></div></div>
  <a class="deck-link" href="case-studies/$($_.slug).html">Read case study -></a>
</article>
"@
}) -join "`n"

$cases = (Head 'Case studies - outcomes for founders and enterprises | Finchase Capital' 'Selected work: fundraising, GST, IPO readiness, ESOPs, tax, and diligence.' 'case-studies.html' $false '') + (ChromeStart $false 'cases' $false) + @"
<section class="page-hero"><div class="container">
  <h1>Decisions we sat in the room for.</h1>
  <p>Representative outcomes across fundraising, tax, IPO readiness, ESOPs and diligence. Client names withheld for confidentiality; figures are representative patterns, not audited claims.</p>
  <!-- Filters hidden for now; uncomment to revive.
  <div class="filters">
    <button class="filter active" data-filter="all" type="button">All</button>
    <button class="filter" data-filter="startups" type="button">Startups</button>
    <button class="filter" data-filter="smes" type="button">SMEs</button>
    <button class="filter" data-filter="enterprise" type="button">Enterprise</button>
    <button class="filter" data-filter="fundraising" type="button">Fundraising</button>
    <button class="filter" data-filter="ipo" type="button">IPO</button>
    <button class="filter" data-filter="tax" type="button">Tax Optimization</button>
  </div>
  -->
  <div class="case-deck" data-animate="fade-up">$caseCards</div>
</div></section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content "$root\case-studies.html" $cases -Encoding UTF8

New-Item -ItemType Directory -Force -Path "$root\case-studies","$root\insights","$root\services" | Out-Null

foreach ($c in $casesMeta) {
  $html = (Head "$($c.title) | Finchase Capital" "Case study: $($c.title). Representative metrics only." "case-studies/$($c.slug).html" $true '') + (ChromeStart $true "cases" $false) + @"
<section class="page-hero"><div class="container">
  <p class="breadcrumb"><a href="../index.html">Home</a> › <a href="../case-studies.html">Proof</a> › $($c.title)</p>
  <h1>$($c.title)</h1>
  <p>$($c.sector) · $($c.stage). The books, tax, or capital process were not ready for the decision the board had already made.</p>
  <div class="kpis-row">
    <div class="glass-card"><strong>$($c.m1)</strong>$($c.l1)</div>
    <div class="glass-card"><strong>$($c.m2)</strong>$($c.l2)</div>
    <div class="glass-card"><strong>$($c.m3)</strong>$($c.l3)</div>
  </div>
</div></section>
<section class="section"><div class="container two-col">
  <div>
    <h2>What was broken</h2>
    <p>$($c.problem)</p>
    <h2>What we did</h2>
    <p>$($c.work)</p>
    <blockquote class="pull">"$($c.quote)" - $($c.quoteby)</blockquote>
    <p>Services used: $($c.svcs) · delivered by a single team.</p>
    <p class="micro">Representative pattern. Figures illustrate the shape of the outcome, not a client P&L.</p>
  </div>
  <aside class="glass-card" style="padding:24px">
    <div class="ph case-side-img"><img src="../images/$($caseImg[$c.slug].img)" alt="$($caseImg[$c.slug].alt)" loading="lazy" onerror="this.closest('.case-side-img').remove()"></div>
    <h3>Key facts</h3>
    <p>Sector: $($c.sector)<br>Stage: $($c.stage)<br>Team: Finchase Capital, Indore<br>Coverage: PAN-India remote</p>
  </aside>
</div></section>
<section class="section"><div class="container">
  <h2>Related case studies</h2>
  <p><a href="../case-studies.html">View all -></a></p>
</div></section>
$(Cta $true)
"@ + (ChromeEnd $true)
  Set-Content "$root\case-studies\$($c.slug).html" $html -Encoding UTF8
}

# --- INSIGHTS ---
$arts = @(
  @{ slug="incorporation-structure"; cat="Build"; title="Choosing a Company Structure Is a Ten-Year Decision, Not a Form"; ctitle='Choosing a <span class="grad-em">Company Structure</span> Is a Ten-Year Decision, Not a Form'; excerpt="Private limited, LLP, or OPC, the box you tick on SPICe+ outlives the reason you ticked it."; mins="7"; pull="The cheapest incorporation and the cheapest mistake are usually the same filing.";
     body=@("Most incorporations fail quietly, not at the ROC but eighteen months later, when an investor's diligence team finds a structure that can't take preference shares, or a founder discovers an LLP can't issue ESOPs. SPICe+ bundles PAN, TAN, EPFO, ESIC and GST registration into one filing, but the form doesn't ask whether you'll raise venture money in year two.","Udyam registration, professional tax, shops & establishment, and trade licenses each carry separate renewal clocks. Missing one doesn't stop operations immediately, it surfaces as a qualification in someone else's audit report, at the worst possible moment.","The DIN, digital signature and MOA object clause decisions made in week one define what the company can legally do in year five without a fresh special resolution.");
     closing="This note reflects patterns Finchase Capital sees across incorporation mandates that later needed unwinding before a raise or a licence application. Getting the structure right once costs a conversation; correcting it after allotment costs a fresh set of ROC filings and a nervous investor." },
  @{ slug="bookkeeping-is-the-file"; cat="Operate"; title="Bookkeeping Is Not Data Entry, It's the File Everyone Else Reads"; ctitle='<span class="grad-em">Bookkeeping</span> Is Not Data Entry, It''s the File Everyone Else Reads'; excerpt="Your bank, your auditor, and your acquirer all form their first opinion of you from the same ledger."; mins="7"; pull="Clean books are cheap insurance nobody notices until the claim.";
     body=@("Under the Companies Act, books of account must be kept on an accrual basis and reflect a true and fair view, a standard higher than the GST return matched the bank statement. Reconciling bank, GST and TDS returns monthly, rather than at year-end, is what keeps a statutory audit from becoming a forensic one.","Chart of accounts decisions made by a generalist bookkeeper, clubbing directors' remuneration with consultancy fees, or misclassifying capital expenditure as revenue, don't break anything in real time. They break comparability the year a lender or investor asks for three years of trend data.","Section 128 requires books to be retained for eight years and, since 2021, in accessible electronic form with a daily backup, a requirement most founders learn about only when asked to produce it.");
     closing="Finchase Capital's bookkeeping mandates typically start with a clean-up, not a fresh start, because the errors sitting in twelve months of entries are usually more expensive to leave than to fix now." },
  @{ slug="direct-tax-beyond-return"; cat="Tax"; title="The Tax Return Is the Least Risky Part of Direct Tax"; ctitle='The <span class="grad-em">Tax Return</span> Is the Least Risky Part of Direct Tax'; excerpt="Assessments, TDS defaults, and Section 56 valuations are where the real exposure sits."; mins="8"; pull="The return you file is a summary. The position you can defend is the asset.";
     body=@("Filing ITR on time avoids a penalty; it does not avoid scrutiny. Section 143(1) intimations, TDS mismatches under Section 200A, and Section 56(2)(viib) angel-tax exposure on share premium are all triggered by patterns visible only across multiple filings, patterns a once-a-year filer rarely checks for.","Advance tax under Section 208, and the interest under Sections 234B/234C for underpaying it, punishes founders who treat tax as a March activity rather than a quarterly one. A DTAA claim, a Section 80-IAC startup exemption, or a capital-gains computation on ESOP sale each need documentation contemporaneous with the transaction, not reconstructed a year later.","Transfer pricing documentation under Sections 92D/92E applies the moment two related entities transact, a threshold far lower than conglomerate, and one most founders cross without noticing.");
     closing="Tax positions built with foresight survive an assessment; tax positions built to file on time rarely do. This is the gap Finchase Capital's advisory work is generally engaged to close before the notice arrives, not after." },
  @{ slug="gst-monthly-discipline"; cat="Tax"; title="GST Compliance Is a Monthly Discipline, Not an Annual Filing"; ctitle='<span class="grad-em">GST Compliance</span> Is a Monthly Discipline, Not an Annual Filing'; excerpt="GSTR-1, 3B, and the books drifting apart is how input credit gets reversed with interest."; mins="7"; pull="GST is a product system that runs every month whether or not anyone is watching it.";
     body=@("Section 16(2) of the CGST Act conditions input tax credit on the supplier actually filing their return, meaning your credit depends on a vendor's compliance, not just your invoice. Rule 36(4) and the GSTR-2B auto-population mean a mismatch isn't cosmetic; it's a cash-flow event when credit gets blocked.","E-invoicing thresholds have progressively lowered, pulling more mid-sized businesses into mandatory compliance with penalties for non-generation that apply per invoice, not per return. Reverse charge on legal fees, import of services, and unregistered vendor purchases is the most commonly missed liability in founder-run compliance.","Annual return (GSTR-9) and reconciliation statement obligations mean a full-year drift is only visible, and only reconcilable, once a year, by which time interest under Section 50 has already accrued.");
     closing="A three-way match between sales register, e-way bills and returns, done monthly, is the single habit that prevents most GST adjustments raised in due diligence, the kind of habit a structured indirect-tax mandate builds in from month one." },
  @{ slug="audit-qualification-record"; cat="Govern"; title="An Audit Qualification Is Not a Formality, It's a Permanent Record"; ctitle='An <span class="grad-em">Audit Qualification</span> Is Not a Formality, It''s a Permanent Record'; excerpt="CARO 2020 and Ind AS reporting turn internal weaknesses into disclosures that follow the company."; mins="8"; pull="An unqualified opinion is not a formality. It's the only opinion a lender or acquirer will actually read.";
     body=@("Statutory audit under Section 143 requires auditors to report on internal financial controls, not just the numbers, meaning a control gap gets documented even if no fraud occurred. CARO 2020 additionally mandates specific commentary on related-party transactions, loans to directors, and undisclosed income, items that read very differently to a lender than to a founder.","Internal audit, mandatory for companies crossing specified turnover or borrowing thresholds under Section 138, exists precisely to catch these issues before the statutory auditor has to report them. Businesses that treat it as optional often discover the difference only when a qualified opinion appears in a document shared with a bank or investor.","Auditor rotation rules, audit committee requirements for larger companies, and the increasing use of data analytics in audit sampling all mean fewer things stay unnoticed than they did a decade ago.");
     closing="Businesses that build internal controls ahead of the statutory cycle generally get a clean audit as a byproduct, not as the goal. That sequencing is where most of Finchase Capital's audit-readiness engagements begin." },
  @{ slug="bank-finance-documentation"; cat="Capital"; title="Banks Underwrite Documentation as Much as They Underwrite the Business"; ctitle='Banks <span class="grad-em">Underwrite Documentation</span> as Much as They Underwrite the Business'; excerpt="A strong balance sheet with a weak CMA data file gets a smaller sanction, not a faster one."; mins="8"; pull="A sanction letter is a negotiation you already lost or won before the meeting.";
     body=@("Working capital limits are typically assessed against the RBI's turnover or cash-budget methods, and the CMA (Credit Monitoring Arrangement) data, projected balance sheets, fund flow, and ratio analysis, is what a credit committee actually scores, not the pitch. Inconsistent projections between the CMA data and the audited financials is the single most common reason sanctions get delayed or scaled down.","Collateral, personal guarantees, and DSCR covenants are negotiated at the term-sheet stage, and renegotiating them after drawdown is materially harder than getting them right the first time. CIBIL and company credit scores are checked at every renewal, not just at onboarding, meaning a single delayed EMI has a longer shelf life than the cash-flow problem that caused it.","Project financing for capex or expansion additionally requires a techno-economic viability report, and lenders increasingly ask for third-party validation of promoter projections rather than accepting management's own numbers.");
     closing="CMA data prepared to withstand scrutiny, not just to look complete, is what turns a bank meeting into a formality. That preparation is a large share of what a financial advisory mandate at Finchase Capital actually produces." },
  @{ slug="valuation-defensible-number"; cat="Capital"; title="A Valuation Is a Defensible Number, Not a Confident One"; ctitle='A <span class="grad-em">Valuation</span> Is a Defensible Number, Not a Confident One'; excerpt="Rule 11UA, DCF, and comparable multiples each answer a different question, using the wrong one is the risk."; mins="8"; pull="A valuation nobody can defend is a number, not an opinion.";
     body=@("Income Tax Rule 11UA prescribes specific methods (NAV or DCF, or the more recent comparable-transaction options) for valuing unquoted equity shares, and using an internally prepared spreadsheet instead of a registered valuer's report is what triggers Section 56(2)(viib) angel-tax exposure. The valuation report needs to be dated before the transaction, not produced to justify it afterward.","For fundraising, discounted cash flow, comparable company multiples, and precedent transactions each tell a different story to an investor, and inconsistency between the valuation used to price a round and the one filed with the ROC or in tax returns is a red flag that shows up in later diligence.","SEBI's ICDR framework, for a very different purpose, requires similar rigor for IPO pricing, a reminder that valuation discipline compounds rather than resets at each stage of a company's life.");
     closing="A valuation built to hold up under a tax officer's or an investor's counter-question is a different exercise from one built to hit a target number, and it's usually the exercise most founders under-invest in until they're asked to justify it." },
  @{ slug="equity-fundraising-termsheet"; cat="Capital"; title="The Term Sheet Is the Cheapest Document in the Entire Raise"; ctitle='The <span class="grad-em">Term Sheet</span> Is the Cheapest Document in the Entire Raise'; excerpt="Liquidation preference, anti-dilution, and board rights cost nothing to negotiate and everything to reverse."; mins="9"; pull="The valuation is the headline. The term sheet is the contract.";
     body=@("A term sheet is non-binding on most commercial terms but binding on exclusivity and confidentiality, and founders who skim it because the lawyers will fix it later often find the economic terms (1x participating preference, full-ratchet anti-dilution, protective provisions) are the parts that survive into the definitive Shareholders' Agreement unchanged.","Cap table modeling, pre-money vs post-money, ESOP pool timing, and pro-rata rights, determines actual founder dilution far more than the headline valuation does. A pool created inside the pre-money valuation dilutes only existing shareholders; created after, it dilutes the incoming investor too, a distinction worth a meaningful percentage of the company.","RBI's FEMA pricing guidelines and reporting requirements (Form FC-GPR) apply the moment a foreign investor participates, with penalties for late filing that scale with delay, an administrative step frequently deprioritized in the excitement of closing.");
     closing="Rounds negotiated with full visibility into cap-table mechanics and compliance timelines close faster and cost founders less equity than rounds negotiated on momentum alone, which is the difference a structured fundraising advisory typically makes." },
  @{ slug="management-consultancy-reporting"; cat="Build"; title="Most Operational Problems Are Reporting Problems in Disguise"; ctitle='Most <span class="grad-em">Operational Problems</span> Are Reporting Problems in Disguise'; excerpt="You can't fix a margin you can't see, segmented the way a decision actually requires."; mins="7"; pull="You don't scale the business you have. You scale the systems that describe it.";
     body=@("MIS built around what accounting software exports by default, rather than around the specific decisions a founder needs to make monthly, is the most common reason growing companies feel like they're flying blind despite having complete books. Contribution margin by product line, channel, or cohort is a different report from a P&L, and most ERPs don't produce it without deliberate configuration.","Working capital cycles, days sales outstanding, days payable outstanding, and inventory turns, compound quietly; a five-day slippage in collections is rarely visible until it shows up as a cash crunch two quarters later. Process documentation and SOPs, dismissed as bureaucracy by many founder-led teams, are exactly what a lender, investor, or acquirer checks for as evidence the business runs without the founder in every decision.","Board reporting cadence and KPI definitions, set early and kept consistent, are what let a growing company add professional directors or institutional investors without a governance overhaul.");
     closing="Building the reporting and process layer before it's forced by an investor's checklist is, in practice, most of what a management consultancy mandate at this stage involves." },
  @{ slug="ma-diligence-pricing"; cat="Scale-Exit"; title="Diligence Doesn't Create Problems, It Prices the Ones Already There"; ctitle='<span class="grad-em">Diligence</span> Doesn''t Create Problems, It Prices the Ones Already There'; excerpt="Every unresolved compliance gap becomes a negotiating chip for the other side, not a surprise for you."; mins="9"; pull="A deal is priced on the numbers. It's won or lost on what diligence finds underneath them.";
     body=@("Buyers price risk, not intent. Under the Companies Act's related-party transaction provisions (Section 188) and SEBI's disclosure norms where applicable, an undocumented arrangement between promoter entities isn't illegal by default, but in diligence it becomes an indemnity clause, a price adjustment, or an escrow holdback.","Representations and warranties in a share purchase agreement shift risk contractually, meaning a tax position, a labour compliance gap, or an IP assignment left ambiguous in the target company doesn't disappear at signing; it survives as a warranty claim with a survival period, sometimes years long. SEBI's Takeover Code (SAST) triggers open-offer obligations at specific shareholding thresholds, a mechanical rule that has derailed deals structured without it in mind.","Integration planning, of finance systems, tax registrations, and employee contracts, is typically underweighted relative to deal-sourcing, yet it's what determines whether the value modeled in the deal actually materializes post-close.");
     closing="Businesses that run clean books, current filings and documented related-party dealings as a matter of course go into diligence negotiating from the numbers, not defending the paperwork, which is generally the difference between a smooth close and a re-traded one." },
  @{ slug="pre-ipo-three-year-process"; cat="IPO"; title="The DRHP Is the Last Document in a Three-Year Process, Not the First"; ctitle='<span class="grad-em">The DRHP</span> Is the Last Document in a Three-Year Process, Not the First'; excerpt="Restated financials, related-party cleanup, and KPI definitions all have to be settled long before the banker is appointed."; mins="10"; pull="The filing is a lagging indicator. The three years of decisions before it are the actual product.";
     body=@("SEBI's ICDR Regulations require three years of restated financial statements on consistent accounting policies, meaning an accounting policy changed in year two of the lookback period forces a restatement that can delay the entire filing. Related-party transactions need arm's-length benchmarking with contemporaneous evidence, not intent explained after the fact, because SEBI's scrutiny and later shareholder litigation both test the same documentation.","Since 2021, SEBI has required issuers to disclose Key Performance Indicators used in investor pitches within the DRHP itself, computed consistently, a rule introduced specifically because pre-IPO KPI definitions used to shift conveniently between the fundraising deck and the prospectus. Promoter shareholding, ESOP pool documentation, and group structure simplification typically take longer to clean up than the drafting itself.","The comment-cycle process with SEBI and the stock exchanges penalizes inconsistency far more than complexity, a clearly wrong number is faster to fix than a number that keeps changing definition.");
     closing="Companies that start restating, documenting and standardizing years before they engage a banker spend the DRHP process filing paperwork instead of rebuilding history under a deadline, which is usually the difference between an IPO timeline that holds and one that slips a year." }
)
# retired September 2026: esop-for-indian-startups, gst-mistakes-founders-make, unit-economics-before-raise, pre-ipo-checklist, transfer-pricing-smes, founders-agreement-essentials

$artImg = @{
  "incorporation-structure"=@{ img="art-founders.png"; alt="Founder alignment on company structure, Finchase Capital insight" };
  "bookkeeping-is-the-file"=@{ img="phase-operate.png"; alt="Monthly bookkeeping discipline, Finchase Capital insight" };
  "direct-tax-beyond-return"=@{ img="case-tax.png"; alt="Direct tax working papers, Finchase Capital insight" };
  "gst-monthly-discipline"=@{ img="art-gst.png"; alt="GST monthly discipline, Finchase Capital insight" };
  "audit-qualification-record"=@{ img="case-diligence.png"; alt="Audit readiness review, Finchase Capital insight" };
  "bank-finance-documentation"=@{ img="art-unit-economics.png"; alt="Bank finance documentation dashboards, Finchase Capital insight" };
  "valuation-defensible-number"=@{ img="art-tp.png"; alt="Defensible business valuation, Finchase Capital insight" };
  "equity-fundraising-termsheet"=@{ img="phase-scale.png"; alt="Equity fundraising round, Finchase Capital insight" };
  "management-consultancy-reporting"=@{ img="art-esop.png"; alt="Management reporting cadence, Finchase Capital insight" };
  "ma-diligence-pricing"=@{ img="case-saas-raise.png"; alt="M&A diligence process, Finchase Capital insight" };
  "pre-ipo-three-year-process"=@{ img="art-ipo.png"; alt="Pre-IPO listing preparation, Finchase Capital insight" };
}

$artCards = ($arts | ForEach-Object {
@"
<article class="glass-card article-card" data-filter-item data-tags="$($_.cat.ToLower())" data-animate="fade-up">
  <span class="cat">$($_.cat)</span>
  <h3>$($_.ctitle)</h3>
  <p>$($_.excerpt)</p>
  <img class="thumb" src="images/$($artImg[$_.slug].img)" alt="$($artImg[$_.slug].alt)" loading="lazy" onerror="this.remove()">
  <footer><a href="insights/$($_.slug).html">Read -></a></footer>
</article>
"@
}) -join "`n"

$insSchemaItems = ($arts | ForEach-Object { '{"@type":"BlogPosting","headline":"' + $_.title + '","url":"https://finchasecapital.in/insights/' + $_.slug + '.html"}' }) -join ","
$insSchema = '<script type="application/ld+json">{"@context":"https://schema.org","@type":"Blog","name":"Finchase Capital insights","blogPost":[' + $insSchemaItems + "]}</script>"
$insights = (Head 'Insights - operator notes from Finchase Capital' 'Essays on incorporation, bookkeeping, direct and indirect tax, audit, bank finance, valuation, fundraising, M&A and IPO readiness.' 'insights.html' $false $insSchema) + (ChromeStart $false 'insights' $false) + @"
<section class="page-hero insights-hero"><div class="container">
  <div class="two-col" style="align-items:center;gap:20px;margin-bottom:6px;grid-template-columns:1.3fr 0.7fr">
    <div>
      <h1 style="max-width:30ch;text-wrap:balance">Notes for people who sign both the term sheet and the 3CD.</h1>
      <p style="max-width:640px">Operator-grade notes on tax, equity, capital and compliance, written for the decisions that show up on a cap table and a balance sheet at the same time.</p>
    </div>
    <div style="justify-self:center;width:min(100%,504px);display:grid;place-items:center"><img src="images/insights.jpg" alt="Planning tomorrow, today neon sign, Finchase Capital insights" loading="eager" style="width:86%;height:auto;display:block;transform:scale(1.25);transform-origin:center;border-radius:0;box-shadow:0 24px 80px rgba(0,0,0,0.35),0 8px 32px rgba(2,104,232,0.18)" onerror="this.remove()"></div>
</div></section>
<section class="section insights-list"><div class="container">
  <div class="filters">
    <button class="filter active" data-filter="all" type="button">All</button>
    <button class="filter" data-filter="build" type="button">Build</button>
    <button class="filter" data-filter="operate" type="button">Operate</button>
    <button class="filter" data-filter="tax" type="button">Tax</button>
    <button class="filter" data-filter="govern" type="button">Govern</button>
    <button class="filter" data-filter="capital" type="button">Capital</button>
    <button class="filter" data-filter="scale-exit" type="button">Scale-Exit</button>
    <button class="filter" data-filter="ipo" type="button">IPO</button>
  </div>
  <div class="article-grid">$artCards</div>
</div></section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content "$root\insights.html" $insights -Encoding UTF8

foreach ($a in $arts) {
  $html = (Head "$($a.title) | Finchase Capital" $a.excerpt "insights/$($a.slug).html" $true '') + (ChromeStart $true "insights" $false) + @"
<div class="read-progress"></div>
<article class="article-body">
  <p class="breadcrumb"><a href="../index.html">Home</a> › <a href="../insights.html">Notes</a> › $($a.cat)</p>
  <span class="cat">$($a.cat)</span>
  <h1>$($a.title)</h1>
  <p style="color:var(--mid-gray)">Finchase Capital · $($a.mins) minute read · Indore</p>
  <div class="ph article-hero"><img src="../images/$($artImg[$a.slug].img)" alt="$($artImg[$a.slug].alt)" loading="lazy" onerror="this.closest('.article-hero').remove()"></div>
  <p>$($a.excerpt)</p>
  $((($a.body | ForEach-Object { "<p>$_</p>" }) -join "`n"))
  <blockquote class="pull">$($a.pull)</blockquote>
  <p>$($a.closing)</p>
  <div class="glass-card" style="padding:24px;margin-top:24px">
    <h3>Newsletter</h3>
    <form class="news" data-fc-form="newsletter" method="post"><input type="hidden" name="form_type" value="newsletter"><input type="email" name="email" required placeholder="Work email" aria-label="Work email"><button class="btn btn-primary" type="submit">Subscribe</button></form>
  </div>
  <p style="margin-top:24px"><a href="../insights.html">More insights -></a></p>
</article>
$(Cta $true)
"@ + (ChromeEnd $true)
  Set-Content "$root\insights\$($a.slug).html" $html -Encoding UTF8
}

# --- SERVICE PAGES ---
$phaseName = @{ build="Build"; operate="Operate"; govern="Govern"; scale="Scale"; exit="Exit" }
$phaseIntro = @{
  build="Build-phase work is cheap now and expensive later: every shortcut in identity, equity or registration compounds into a Year-3 cleanup. We over-invest here on purpose.";
  operate="Operate-phase work is monthly truth: close the books, pay people correctly, file taxes on time, so diligence never finds a surprise you already knew about.";
  govern="Govern-phase work is what lenders, regulators and future buyers read. Audits, ROC filings and forecasts are written to be reopened without you in the room.";
  scale="Scale-phase work changes the cap table: valuation, ESOPs, models, rounds, diligence and deals, each priced on numbers that survive scrutiny.";
  exit="Exit-phase work is public-market hygiene: restructure, restate, draft, price, then live as a listed company. The calendar is the product."
}
$phaseCase = @{ build="esop-structuring-startup"; operate="gst-optimization-sme"; govern="tax-planning-enterprise"; scale="series-a-saas-raise"; exit="ipo-readiness-nbfc" }
$phaseImg = @{ build="phase-build.png"; operate="phase-operate.png"; govern="phase-govern.png"; scale="phase-scale.png"; exit="phase-exit.png" }
$svcImg = @{ incorporation="services/final/incorporation.jpg"; "startup-india"="services/final/startup-india.jpg"; "founders-agreement"="services/final/founders-agreement.jpg"; gst="services/final/gst.jpg"; bookkeeping="services/final/bookkeeping.jpg"; payroll="services/final/payroll.jpg"; "financial-statements"="services/final/financial-statements.jpg"; tds="services/final/tds.jpg"; itr="services/final/itr.jpg"; "tax-planning"="services/final/tax-planning.jpg"; "indirect-tax"="services/final/indirect-tax.jpg"; "statutory-audit"="services/final/statutory-audit.jpg"; "tax-audit"="services/final/tax-audit.jpg"; "internal-audit"="services/final/internal-audit.jpg"; roc="services/final/roc.jpg"; budgeting="services/final/budgeting.jpg"; "unit-economics"="services/final/unit-economics.jpg"; "project-report"="services/final/project-report.jpg"; "stock-audit"="services/final/stock-audit.jpg"; "bank-branch-audit"="services/final/bank-branch-audit.jpg"; "concurrent-audit"="services/final/concurrent-audit.jpg"; "international-tax"="services/final/international-tax.jpg"; "transfer-pricing"="services/final/transfer-pricing.jpg"; certifications="services/final/certifications.jpg"; valuation="services/final/valuation.jpg"; esop="services/final/esop.jpg"; "financial-modeling"="services/final/financial-modeling.jpg"; "strategic-mentorship"="services/final/strategic-mentorship.jpg"; fundraising="services/final/fundraising.jpg"; "due-diligence"="services/final/due-diligence.jpg"; ma="services/final/ma.jpg"; "capital-restructuring"="services/final/capital-restructuring.jpg"; "debt-syndication"="services/final/debt-syndication.jpg"; "pre-ipo"="services/final/pre-ipo.jpg"; drhp="services/final/drhp.jpg"; "ipo-pricing"="services/final/ipo-pricing.jpg"; "post-ipo"="services/final/post-ipo.jpg" }
$phaseWhy = @{
  build=@(@{t="Clean start";d="Identity, equity and registrations done once, no Year-3 rebuild tax.";i="sparkles"};@{t="Founder alignment";d="Agreements signed while everyone is still generous.";i="handshake"};@{t="Investor-ready";d="DPIIT, GST and books a future diligence team can open.";i="file-check"});
  operate=@(@{t="Monthly truth";d="A close calendar that never slips, the board pack becomes a by-product.";i="calendar-check"};@{t="No leakage";d="TDS, GST and payroll reconciled before interest and penalties find them.";i="shield-check"};@{t="Banker-ready";d="Statements and filings a lender can underwrite without queries.";i="landmark"});
  govern=@(@{t="Lender trust";d="Audit-grade working papers behind every number you submit.";i="landmark"};@{t="Regulator calm";d="ROC and tax filings on one calendar, no compounding surprises.";i="scale"};@{t="Diligence premium";d="Clean governance files price directly into valuation later.";i="badge-check"});
  scale=@(@{t="Priced right";d="Valuations with bridged assumptions, no spreadsheet folklore.";i="calculator"};@{t="Closed fast";d="Data rooms and term mechanics run to a calendar, not to luck.";i="zap"};@{t="Defensible";d="Every claim in the deck traces back to a working paper.";i="shield-check"});
  exit=@(@{t="No restatement shock";d="Policies and related parties cleaned before the banker opens the file.";i="file-search"};@{t="Banker confidence";d="DRHP numbers that survive comment cycles.";i="briefcase"};@{t="Listed discipline";d="LODR and investor-relations rhythms installed before listing day.";i="trending-up"})
}
$clusterKpi = @{
  regform=@(@{v="2-5 days";l="72-hour express on request"};@{v="100%";l="client satisfaction commitment"};@{v="Filed once, right";l="no Year-3 rebuild"});
  recurring=@(@{v="7-10 days";l="typical turnaround"};@{v="100%";l="client satisfaction commitment"};@{v="One calendar";l="every due date, tracked"});
  audits=@(@{v="15 days";l="7-day express on request"};@{v="100%";l="client satisfaction commitment"};@{v="Working papers";l="you can defend"});
  govrep=@(@{v="7 days";l="72-hour express on request"};@{v="100%";l="client satisfaction commitment"};@{v="Board-ready";l="not just compliant"});
  xborder=@(@{v="7-14 days";l="typical turnaround"};@{v="100%";l="client satisfaction commitment"};@{v="DTAA-mapped";l="before money moves"});
  capital=@(@{v="3-5 days";l="72-hour express on request"};@{v="100%";l="client satisfaction commitment"};@{v="One named advisor";l="start to close"});
  ipo=@(@{v="3-6 months";l="3-month express on request"};@{v="100%";l="client satisfaction commitment"};@{v="Built for the comment cycle";l="not just the filing"})
}
$svcCluster = @{
  incorporation="regform"; "startup-india"="regform"; "founders-agreement"="regform"; gst="regform";
  bookkeeping="recurring"; payroll="recurring"; "financial-statements"="recurring"; tds="recurring"; itr="recurring"; "tax-planning"="recurring"; "indirect-tax"="recurring";
  "statutory-audit"="audits"; "tax-audit"="audits"; "internal-audit"="audits"; "stock-audit"="audits"; "concurrent-audit"="audits"; "bank-branch-audit"="audits";
  roc="govrep"; budgeting="govrep"; "unit-economics"="govrep"; "project-report"="govrep"; certifications="govrep";
  "international-tax"="xborder"; "transfer-pricing"="xborder";
  valuation="capital"; esop="capital"; "financial-modeling"="capital"; "strategic-mentorship"="capital"; fundraising="capital"; "due-diligence"="capital"; ma="capital"; "capital-restructuring"="capital"; "debt-syndication"="capital";
  "pre-ipo"="ipo"; drhp="ipo"; "ipo-pricing"="ipo"; "post-ipo"="ipo"
}
$emdash = [char]0x2014
$rs = [char]0x20B9
$clusterTime = @{
  regform="Most registrations close in 2-5 days once documents are complete, with a 72-hour express track on request.";
  recurring="Recurring mandates run on a fixed calendar $emdash first close inside 7-10 days, then like clockwork every cycle.";
  audits="Fieldwork to report in 15 days once evidence is complete, with a 7-day express track on request.";
  govrep="Most mandates close in 7 days once inputs are complete, with a 72-hour express track on request.";
  xborder="Most mandates close in 7-14 days once facts are complete.";
  capital="First outputs in 3-5 days once inputs are complete, with a 72-hour express track on request.";
  ipo="IPO tracks run 3-6 months to a transaction calendar, with an accelerated 3-month track where the cleanup allows."
}
$svcDuoSub = @{
  incorporation=@{ws="Name approval to certificate, typically inside a week.";ls="MOA-AOA, DIN, PAN-TAN included."};
  "startup-india"=@{ws="Recognition first, holiday mapped alongside.";ls="Benefits tracker included."};
  "founders-agreement"=@{ws="Plain words before legalese.";ls="Vesting schedule included."};
  gst=@{ws="Liability tested before registering.";ls="HSN and e-invoice set up."};
  bookkeeping=@{ws="Opening balances taken over as they are.";ls="MIS the board can read."};
  payroll=@{ws="Registrations, structuring and first run covered.";ls="Challans archived, Form 16s on time."};
  "financial-statements"=@{ws="Trial balance to board pack.";ls="Query-response annexure included."};
  tds=@{ws="Sections mapped per payment type.";ls="No interest leakage, demands resolved."};
  itr=@{ws="Regime computed, not guessed.";ls="E-verified with notices handled."};
  "tax-planning"=@{ws="Positions decided before the year closes.";ls="Documented for assessment."};
  "indirect-tax"=@{ws="Positions defended with working papers.";ls="Refunds pre-audited before filing."};
  "statutory-audit"=@{ws="Planned around materiality, not last year's file.";ls="Opinion plus fixable control points."};
  "tax-audit"=@{ws="44AB triggers tested first.";ls="ICDS memo included."};
  "internal-audit"=@{ws="Scope follows risk, not routine.";ls="Findings rated with owners named."};
  roc=@{ws="Annual plus event filings on one calendar.";ls="Registers inspection-ready."};
  budgeting=@{ws="Built driver by driver, with owners.";ls="Variance reviewed monthly."};
  "unit-economics"=@{ws="Cohort data in, payback math out.";ls="Go/no-go memo included."};
  "project-report"=@{ws="CMA or TEV, exactly what the bank asked.";ls="Query responses included."};
  "stock-audit"=@{ws="Cut-off to certificate.";ls="Shortages reported plainly."};
  "bank-branch-audit"=@{ws="Advances to LFAR in one pass.";ls="NPA testing with evidence."};
  "concurrent-audit"=@{ws="Monthly testing, in-year.";ls="Systems notes the branch can use."};
  "international-tax"=@{ws="Residency to structure before money moves.";ls="Documentation ready for assessment."};
  "transfer-pricing"=@{ws="Profiled while facts are fresh.";ls="APA support on call."};
  certifications=@{ws="Format captured exactly as demanded.";ls="UDIN logged for next time."};
  valuation=@{ws="Round, ESOP, 56(2)(viib), FEMA or dispute.";ls="Assumptions bridged, not buried."};
  esop=@{ws="Pool sized to the hiring plan.";ls="Tax memo secured."};
  "financial-modeling"=@{ws="History cleaned first.";ls="Scenarios included."};
  "strategic-mentorship"=@{ws="Fixed quarterly fee.";ls="Board narrative included."};
  fundraising=@{ws="Process run to close, not launch.";ls="FEMA and 56(2)(viib) filings done."};
  "due-diligence"=@{ws="Three to nine weeks by data quality.";ls="Red flags ranked by price impact."};
  ma=@{ws="Tax outcomes modelled first.";ls="NCLT approvals run."};
  "capital-restructuring"=@{ws="Tax priced before you choose.";ls="Registers updated."};
  "debt-syndication"=@{ws="All-in cost compared.";ls="Charge filings completed."};
  "pre-ipo"=@{ws="Two clean comparatives needed.";ls="Banker handoff ready."};
  drhp=@{ws="KPIs defined once, used everywhere.";ls="Comment responses with papers."};
  "ipo-pricing"=@{ws="Model bridged to multiples.";ls="Listing-day readiness."};
  "post-ipo"=@{ws="LODR as habit, not event.";ls="Earnings rhythm run."}
}
$svcCase = @{
  gst="gst-optimization-sme"; "indirect-tax"="gst-optimization-sme"; bookkeeping="gst-optimization-sme";
  esop="esop-structuring-startup"; "tax-planning"="tax-planning-enterprise";
  fundraising="series-a-saas-raise"; "due-diligence"="due-diligence-acquisition"; ma="due-diligence-acquisition";
  "pre-ipo"="ipo-readiness-nbfc"; drhp="ipo-readiness-nbfc"
}
$svcAngle = @{
  incorporation=@{ when="You are forming the entity this quarter."; leaves="An incorporated entity with a bank-ready kit." };
  "startup-india"=@{ when="You want DPIIT perks before the priced round."; leaves="Recognition certificate plus a benefits tracker." };
  "founders-agreement"=@{ when="Two or more founders and nothing signed yet."; leaves="A signed agreement with a vesting schedule." };
  gst=@{ when="You are near the threshold or credits look messy."; leaves="Registration plus a clean monthly cadence." };
  bookkeeping=@{ when="The books close late, or never."; leaves="A monthly close inside five working days." };
  payroll=@{ when="The team is past ten or PF notices arrived."; leaves="Compliant payroll with zero leakage." };
  "financial-statements"=@{ when="A bank or investor asked for statements."; leaves="A Schedule III pack with notes." };
  tds=@{ when="Many vendors and uncertain sections."; leaves="A deduction map with filed returns." };
  itr=@{ when="Deadlines approach and books are unreconciled."; leaves="Filed ITRs that tie to the books." };
  "tax-planning"=@{ when="It is Q3 and there is no advance-tax plan."; leaves="A year-long tax calendar." };
  "indirect-tax"=@{ when="A GST notice landed or a refund is stuck."; leaves="Position papers and drafted responses." };
  "statutory-audit"=@{ when="The board needs a signed opinion."; leaves="An audit report with a management letter." };
  "tax-audit"=@{ when="Turnover crossed the audit threshold."; leaves="Filed 3CA/3CB with a clean 3CD." };
  "internal-audit"=@{ when="Leakage is suspected or a committee formed."; leaves="A quarterly control report." };
  roc=@{ when="Filings are overdue or events went unfiled."; leaves="A clean MCA record." };
  budgeting=@{ when="The board asks where the money goes."; leaves="A budget with a variance pack." };
  "unit-economics"=@{ when="A raise is planned but margins are unclear."; leaves="Validated unit math." };
  "project-report"=@{ when="The bank asked for CMA and projections."; leaves="A credit-committee-ready report." };
  "stock-audit"=@{ when="A limit renewal needs DP verification."; leaves="A verified stock certificate." };
  "bank-branch-audit"=@{ when="The audit season circular arrives."; leaves="Branch documentation that survives review." };
  "concurrent-audit"=@{ when="High-volume operations need a watch."; leaves="Monthly exception reports." };
  "international-tax"=@{ when="Money is crossing borders."; leaves="A withholding and DTAA map." };
  "transfer-pricing"=@{ when="Group transactions have begun."; leaves="A benchmarked TP file with 3CEB." };
  certifications=@{ when="A bank or authority wants a certificate."; leaves="A signed certificate within 48 hours." };
  valuation=@{ when="A round, ESOP or dispute needs a number."; leaves="A signed, bridgeable valuation report." };
  esop=@{ when="You are hiring seniors before Series A."; leaves="A board-approved ESOP scheme." };
  "financial-modeling"=@{ when="The deck numbers do not tie."; leaves="A model and deck that match." };
  "strategic-mentorship"=@{ when="Big calls need a finance brain."; leaves="A quarterly operating cadence." };
  fundraising=@{ when="A raise is due in two quarters."; leaves="A data room and a term sheet." };
  "due-diligence"=@{ when="You are buying or selling a business."; leaves="A QoE report with SPA inputs." };
  ma=@{ when="A merger or demerger is on the table."; leaves="A registered scheme with closing accounts." };
  "capital-restructuring"=@{ when="The balance sheet needs surgery."; leaves="A clean, simple capital structure." };
  "debt-syndication"=@{ when="You have outgrown current limits."; leaves="Sanctioned, covenant-safe debt." };
  "pre-ipo"=@{ when="Listing is 12–24 months out."; leaves="A quarter-by-quarter clean-up plan." };
  drhp=@{ when="The banker is appointed and drafting is live."; leaves="DRHP-ready financial sections." };
  "ipo-pricing"=@{ when="The price-band discussion starts."; leaves="A defensible band with an anchor plan." };
  "post-ipo"=@{ when="You are listed and LODR applies."; leaves="A running compliance calendar." };
}
$svcProcess = @{
  incorporation=@(@{t="Name & structure";d="SPICe+ name reservation and a Pvt Ltd vs LLP call, matched to how you will raise."};@{t="Dossier";d="DIN, identity proofs and registered-office papers assembled once, correctly."};@{t="Filing";d="SPICe+ filed with MOA-AOA; resubmissions handled, not forwarded to you."};@{t="Kit";d="PAN, TAN, bank kit and first board minutes issued together."};@{t="Handover";d="Compliance calendar set: GST, ROC and first-audit dates locked in."});
  "startup-india"=@(@{t="Eligibility";d="Incorporation date, turnover and innovation test checked before a page is filed."};@{t="Dossier";d="Pitch-deck summary, entity documents and briefs a fund's counsel would accept."};@{t="Filing";d="DPIIT recognition filed; queries answered with evidence, not adjectives."};@{t="Tax holiday";d="80-IAC mapping and inter-ministerial board application where eligible."};@{t="Tracker";d="Certificate plus a benefits tracker: tenders, holidays, compliance relaxations."});
  "founders-agreement"=@(@{t="Facts";d="Equity splits, vesting expectations and IP ownership laid out per founder."};@{t="Term points";d="Vesting, cliff, roles, IP assignment and deadlock agreed in plain words first."};@{t="Draft";d="Agreement drafted in founder English: lawyer-reviewable, not lawyer-dependent."};@{t="Alignment";d="Hard conversations facilitated before money makes everyone bitter."};@{t="Signing";d="Signed, stamped and filed, with statutory registers updated."});
  gst=@(@{t="Liability";d="Threshold, interstate supply and reverse-charge tested: register only if you must, the moment you must."};@{t="Registration";d="GSTIN with principal-place documentation that survives scrutiny."};@{t="Setup";d="HSN mapping, e-invoice readiness and invoice formats fixed on day one."};@{t="Cadence";d="GSTR-1/3B filed monthly and reconciled to the books, not just submitted."};@{t="Hygiene";d="ITC ledger review, GSTR-9 annual return and refund positions defended."});
  bookkeeping=@(@{t="Takeover";d="Trial balance, ledgers and pending items taken over as they are."};@{t="Design";d="Chart of accounts rebuilt for MIS, not just for filing."};@{t="Close";d="Accrual monthly close inside five working days, every month."};@{t="Reconcile";d="Vendors, customers, banks and GST ledgers tied out; differences chased."};@{t="Report";d="Trial balance plus a founder-readable MIS; the board pack becomes a by-product."});
  payroll=@(@{t="Structure";d="CTC split for tax efficiency: basic, HRA and allowances set per employee."};@{t="Registrations";d="PF/ESI codes, PT and LWF where applicable."};@{t="Payroll run";d="Attendance to payslips; arrears and full-and-final handled monthly."};@{t="Deposits";d="PF, ESI, TDS and PT deposited before due dates, challans archived."};@{t="Year-end";d="Quarterly TDS returns, annual filings and Form 16s issued on time."});
  "financial-statements"=@(@{t="Base";d="Trial balance frozen; prior-period errors isolated first."};@{t="Adjustments";d="Provisions, depreciation, gratuity and tax positions booked with evidence."};@{t="Schedules";d="Schedule III balance sheet, P&L and notes drafted to the letter."};@{t="Cash-flow";d="Indirect-method cash-flow reconciled to the last rupee."};@{t="Pack";d="Banker-ready pack: statements, ratios and a query-response annexure."});
  tds=@(@{t="Mapping";d="Every payment type mapped to its section: 194C, 194J, 192 and the rest."};@{t="Logic";d="Rate, threshold and lower-deduction certificates applied per vendor."};@{t="Deposits";d="Monthly TDS deposited on time; interest leakage killed at source."};@{t="Returns";d="24Q/26Q filed quarterly with challan matching."};@{t="Closure";d="Corrections, demand resolution and Form 16/16A issuance."});
  itr=@(@{t="Reconcile";d="Books, TDS credits (26AS/AIS) and GST turnover matched first."};@{t="Regime";d="Old vs new regime computed from your books, never by thumb rule."};@{t="Compute";d="Depreciation, carry-forward losses and deductions scheduled."};@{t="File";d="Company, LLP and founder ITRs filed and e-verified."};@{t="Notices";d="Scrutiny and defective-return notices drafted and replied."});
  "tax-planning"=@(@{t="Review";d="Books, salaries, capex and related-party flows reviewed in Q3, not March."};@{t="Design";d="Entity, regime and timing positions decided before the year closes."};@{t="Calendar";d="Advance-tax instalments timed to actual cash flows."};@{t="Incentives";d="80-IAC, R&D, depreciation and set-off positions mapped."};@{t="Lock";d="Positions documented so assessment needs no archaeology."});
  "indirect-tax"=@(@{t="Classify";d="HSN/SAC, place of supply and rate positions nailed down per line."};@{t="Defend";d="Refund and ITC claims backed by working papers, not hope."};@{t="Reconcile";d="GSTR-2B vs books matched monthly; mismatches fixed at vendor level."};@{t="Respond";d="Departmental notices replied with evidence annexures."};@{t="Argue";d="Hearing preparation with case law briefed for counsel."});
  "statutory-audit"=@(@{t="Plan";d="Materiality, risk areas and timelines agreed with the board upfront."};@{t="Understand";d="Process walkthroughs and control design checks $emdash not tick-mark tourism."};@{t="Test";d="Vouching, verification, confirmations and subsequent-events review."};@{t="Report";d="Audit opinion drafted; qualifications debated early, never sprung."};@{t="Letter";d="Management letter with fixable control points, tracked to closure."});
  "tax-audit"=@(@{t="Trigger";d="44AB threshold and 44AD/44ADA opt-outs tested before work starts."};@{t="Prepare";d="3CD built clause by clause from the books, not last year's file."};@{t="Align";d="ICDS positions documented where books and tax diverge."};@{t="File";d="3CA/3CB with 3CD uploaded before the due date, never on it."};@{t="Support";d="Rectifications and assessing-officer queries handled after filing."});
  "internal-audit"=@(@{t="Scope";d="Risk universe agreed with the audit committee; scope follows risk, not routine."};@{t="Matrix";d="Risk-and-control matrix with owners and test procedures."};@{t="Test";d="Quarterly transaction testing and leakage analytics."};@{t="Report";d="Committee pack: findings rated, rupees attached, owners named."};@{t="Track";d="Action tracker reviewed every quarter until closure."});
  roc=@(@{t="Calendar";d="One MCA calendar: AOC-4, MGT-7, ADT-1 and event deadlines."};@{t="Annual";d="AOC-4 and MGT-7 filed, with XBRL where applicable."};@{t="Events";d="Allotments, director changes and charges filed within statutory windows."};@{t="Registers";d="Statutory registers and minutes kept inspection-ready."};@{t="Clean";d="Pending delays compounded and closed; record verified clean."});
  budgeting=@(@{t="Baseline";d="Last twelve months normalised; one-time items stripped out."};@{t="Budget";d="Annual operating budget built driver by driver, with owners."};@{t="Cash";d="13-week cash forecast tied to payroll, vendors and debt."};@{t="Track";d="Monthly variance review; forecasts reforecast, not filed away."};@{t="Report";d="Board pack with a headroom view on covenants and burn."});
  "unit-economics"=@(@{t="Capture";d="Cohort, order and cost data pulled clean from systems."};@{t="Build";d="Contribution margin per unit, channel and cohort."};@{t="Payback";d="CAC, LTV and payback math with honest churn."};@{t="Price";d="Pricing-power test: what breaks if you raise 10%."};@{t="Memo";d="Go/no-go memo the model can defend to a board."});
  "project-report"=@(@{t="Brief";d="Loan type, amount and the bank's checklist captured first."};@{t="Build";d="CMA data with 3-5 year projections grounded in history."};@{t="Stress";d="DSCR, break-even and sensitivity annexures."};@{t="Draft";d="Narrative a credit committee finishes, not skims."};@{t="Defend";d="Bank queries answered with working papers attached."});
  "stock-audit"=@(@{t="Plan";d="Cut-off procedures and sampling plan agreed with the lender."};@{t="Verify";d="Physical count at godowns and shops $emdash surprise where needed."};@{t="Value";d="Valuation with ageing; obsolete stock flagged honestly."};@{t="Reconcile";d="Book stock vs physical vs DP statement bridged."};@{t="Certify";d="Lender-format certificate with qualifications stated plainly."});
  "bank-branch-audit"=@(@{t="Mandate";d="RBI circular and central-office instructions mapped to the branch."};@{t="Advances";d="Borrower files, documentation and drawing power verified."};@{t="Classify";d="NPA recognition and provisioning tested against norms."};@{t="Controls";d="Cash, clearing and system controls walkthrough."};@{t="Report";d="LFAR plus statutory report, documented to survive review."});
  "concurrent-audit"=@(@{t="Scope";d="High-risk areas and coverage calendar fixed with the bank."};@{t="Test";d="Monthly transaction and control testing, in-year."};@{t="Flag";d="Exceptions reported within days, leakage quantified."};@{t="Improve";d="Systems-improvement notes the branch can actually implement."};@{t="Pack";d="Monthly concurrent-audit pack with action tracker."});
  "international-tax"=@(@{t="Facts";d="Residency, entity map and cash-flow routes documented first."};@{t="Risk";d="Permanent-establishment and substance tests per jurisdiction."};@{t="Treaty";d="DTAA benefits, withholding rates and TRC requirements mapped."};@{t="Structure";d="Holding, invoicing and ECB/FEMA positions designed before money moves."};@{t="File";d="15CA/CB support and assessment-ready documentation."});
  "transfer-pricing"=@(@{t="Analyse";d="Functions, assets and risks profiled per entity while facts are fresh."};@{t="Method";d="Most-appropriate method chosen and defended in writing."};@{t="Benchmark";d="Comparable search with documented rejections; arm's-length range set."};@{t="Document";d="Local file plus master-file inputs assembled."};@{t="File";d="Form 3CEB filed; audit and APA support on call."});
  certifications=@(@{t="Ask";d="Banker or authority format captured exactly as demanded."};@{t="Verify";d="Books, returns and bank statements tied to the figure."};@{t="Draft";d="Certificate worded to match the format, no creative extras."};@{t="Sign";d="Partner-signed on letterhead with UDIN."};@{t="Record";d="Copy logged for the next time anyone asks."});
  valuation=@(@{t="Mandate";d="Purpose fixed first: round, ESOP, 56(2)(viib), FEMA or dispute $emdash each needs a different standard."};@{t="Diligence";d="Financials, contracts and management assumptions stress-tested."};@{t="Triangulate";d="DCF, comparables and asset approaches bridged, not averaged."};@{t="Report";d="Signed report with every assumption on the page."};@{t="Defend";d="Board, buyer and tax-officer queries answered from the working file."});
  esop=@(@{t="Size";d="Pool sized to the hiring plan through the next round; dilution modelled before promises."};@{t="Draft";d="Scheme with cliff, vesting and exercise windows in employee English."};@{t="Clear";d="Valuation report and perquisite-tax memo secured."};@{t="Approve";d="Board and shareholder approvals passed in one sitting."};@{t="Grant";d="Grant letters issued; vesting tracker handed to HR."});
  "financial-modeling"=@(@{t="Clean";d="History restated so the base year is actually true."};@{t="Assume";d="Revenue, margin and working-capital drivers agreed with founders."};@{t="Build";d="P&L, balance sheet and cash-flow that balance $emdash literally."};@{t="Stress";d="Downside, base and upside layers with sensitivity tables."};@{t="Tie";d="Deck numbers locked to the model; data room matches both."});
  "strategic-mentorship"=@(@{t="Diagnose";d="Runway, margins and org gaps scored in week one."};@{t="Rhythm";d="Weekly or monthly operating cadence installed."};@{t="Decide";d="Pricing, hiring and spend calls made with numbers attached."};@{t="Narrate";d="Board narrative prepared before the meeting, not after."};@{t="Score";d="Quarterly review: what moved, what didn't, what's next."});
  fundraising=@(@{t="Strategy";d="Round size, instrument and investor list matched to traction."};@{t="Room";d="Data room built: financials, contracts, compliance and cap table."};@{t="Outreach";d="Introductions sequenced; diligence questions pre-answered."};@{t="Terms";d="Valuation, liquidation preference and control terms negotiated."};@{t="Close";d="SHA/SSA to share certificates; 56(2)(viib) and FEMA filings done."});
  "due-diligence"=@(@{t="Scope";d="Buy-side or sell-side fenced before files open."};@{t="Earnings";d="EBITDA normalised: one-offs, related parties and accounting choices stripped."};@{t="Bridge";d="Net-debt and working-capital peg computed to the rupee."};@{t="Flags";d="Red-flag memo ranked by price impact, not page count."};@{t="Price";d="Findings converted into SPA adjustments and warranties."});
  ma=@(@{t="Structure";d="Merger, demerger or slump sale modelled with tax outcomes."};@{t="Terms";d="Swap ratio and consideration supported by valuation."};@{t="Check";d="Diligence on the other side before signatures."};@{t="Approve";d="Scheme drafted; NCLT, MCA and shareholder approvals run."};@{t="Close";d="Closing accounts and handover calendar completed."});
  "capital-restructuring"=@(@{t="Diagnose";d="Reserves, share classes and debt mapped for room to move."};@{t="Options";d="Bonus, buyback, reduction or merger paths compared with tax costs."};@{t="Approve";d="Board, shareholder and tribunal approvals sequenced."};@{t="Execute";d="Filings, payouts and register updates completed."};@{t="Reset";d="Clean capital structure with a compliance calendar for it."});
  "debt-syndication"=@(@{t="Need";d="Amount, tenure and end-use fixed; CMA-ready financials pulled."};@{t="Map";d="Bank, NBFC and structured-debt options compared on all-in cost."};@{t="Negotiate";d="Rate, security, covenants and prepayment terms pushed."};@{t="Document";d="Sanction documentation and charge filings completed."};@{t="Draw";d="Drawdown schedule with a covenant-compliance calendar."});
  "pre-ipo"=@(@{t="Audit";d="Group structure, RPTs, policies and KMP gaps scored against listing norms."};@{t="Plan";d="Quarter-by-quarter cleanup plan with owners and dates."};@{t="Restate";d="Prior periods restated; policies rewritten for scrutiny."};@{t="Govern";d="Board composition, committees and KMP readiness closed out."};@{t="Hand";d="Banker-ready file: KPIs defined, papers indexed, story straight."});
  drhp=@(@{t="Scope";d="Banker checklist mapped to restated periods and KPIs."};@{t="Restate";d="Restated financials with policy notes that hold up."};@{t="Define";d="KPIs defined once and used consistently everywhere."};@{t="Draft";d="Objects-of-issue, risk factors and MD&A financial inputs."};@{t="Survive";d="SEBI comment cycles answered with working papers ready."});
  "ipo-pricing"=@(@{t="Ground";d="Model and peer multiples bridged into one valuation story."};@{t="Band";d="Price-band analytics with subscription scenarios."};@{t="Anchor";d="Anchor allocation plan and cornerstone conversations."};@{t="Build";d="Book-building support through pricing day."};@{t="List";d="Post-pricing filings and listing-day readiness."});
  "post-ipo"=@(@{t="Calendar";d="LODR event calendar installed from day one of listing."};@{t="Results";d="Quarterly results packs: Ind-AS numbers, clean notes."};@{t="Disclose";d="Price-sensitive disclosures drafted and filed on time."};@{t="Engage";d="Earnings calls and shareholder communication run professionally."};@{t="Sustain";d="Annual cycle review: what listed life taught, systematized."})
}
$svcFaq = @{
  incorporation=@(@{q="Pvt Ltd, LLP or OPC $emdash which should I pick?";a="Depends on how you will raise and split equity: Pvt Ltd for venture funding, LLP for professional firms with shared profits, OPC for solo founders. We model the tax and compliance cost of each before you choose."};@{q="How long does MCA approval take?";a="Name reservation in 1-2 working days; the certificate typically within a week of a complete dossier. Resubmissions are the real delay $emdash we file to avoid them."});
  "startup-india"=@(@{q="Does DPIIT recognition give an automatic tax holiday?";a="No $emdash recognition and the 80-IAC holiday are separate applications. We file recognition first, then map and claim the holiday where you qualify."};@{q="My company is 3 years old. Am I too late?";a="No $emdash entities up to 10 years from incorporation with turnover under $($rs)100 crore can apply. Age matters less than documentation."});
  "founders-agreement"=@(@{q="Can't we just download a template?";a="Templates don't know your vesting, IP ownership or deadlock formula $emdash the three clauses that actually get litigated. We draft around your facts, in language you and a lawyer can both use."};@{q="When should we sign $emdash before or after funding?";a="Before. Every priced round discounts unsigned founder terms as risk."});
  gst=@(@{q="Do I need GST below $($rs)40 lakh turnover?";a="Usually not for intra-state goods $emdash but interstate supply, reverse charge and e-commerce can trigger it at rupee one. We test your exact position first."};@{q="What causes ITC mismatches?";a="Vendor GSTR-1 vs your GSTR-2B differences, wrong HSNs and missed reverse-charge. We fix it at vendor level, not with year-end adjustments."});
  bookkeeping=@(@{q="My CA only needs year-end books. Why a monthly close?";a="Because year-end books reconstruct twelve mysteries at once. Monthly close catches leakage while it is reversible $emdash and makes audits, rounds and loans dramatically cheaper."};@{q="Tally, Zoho or Excel $emdash what should we use?";a="Whatever your team will actually maintain. We design the chart of accounts first; the software follows the discipline, not the other way around."});
  payroll=@(@{q="At what headcount do PF/ESI become mandatory?";a="PF at 20+ employees, ESI at 10+ in implemented areas on wages up to $($rs)21,000. We register before the inspector explains it to you."};@{q="Contractors or employees $emdash does it matter for compliance?";a="Enormously: misclassified contractors attract PF demands plus penalties. We review your contractor stack during onboarding."});
  "financial-statements"=@(@{q="Can my bookkeeper prepare these?";a="Trial balance, yes. Schedule III statements with notes and cash-flow that survive a bank or audit review $emdash that is a different craft."};@{q="How long does preparation take?";a="Two to three weeks from a clean trial balance; longer if we first have to fix one."});
  tds=@(@{q="What triggers TDS interest and penalties?";a="Late deposit (1-1.5% per month), late filing ($($rs)200/day), and wrong sections. The fix is a monthly rhythm, not year-end heroics."};@{q="Do 15G/15H and lower-deduction certificates matter?";a="Yes $emdash honoring a valid certificate avoids deductions you cannot painlessly reverse. We track their validity per vendor."});
  itr=@(@{q="Old vs new regime $emdash how do you decide?";a="By computing both from your actual books, including carry-forward losses and deductions $emdash never by thumb rule."};@{q="What if I get a defective-return notice?";a="Section 139(9) notices usually mean mismatched TDS or AIS data. We reconcile and refile; most close without a hearing."});
  "tax-planning"=@(@{q="Isn't tax planning something you do in March?";a="March is where bad planning gets documented. The real levers $emdash regime, timing, advance tax, incentives $emdash close by Q3."};@{q="Will this survive scrutiny?";a="Every position ships with its section reference and working paper. Aggressive without evidence isn't planning, it's gambling."});
  "indirect-tax"=@(@{q="When should we fight a GST notice vs pay it?";a="Fight when the classification or ITC position is documented; pay-and-close when interest compounds on a weak position. We give you the math both ways."};@{q="How do refunds get stuck?";a="Usually GSTR-1/3B mismatches or inverted-duty documentation gaps. We pre-audit the refund file before it reaches the department."});
  "statutory-audit"=@(@{q="Will you qualify our accounts?";a="Only if the books require it $emdash and you will hear about it in week two, with a path to avoid it, never in the final report."};@{q="Can the audit finish before our board meeting?";a="Yes, if fieldwork starts on the agreed date. We plan backwards from your board calendar."});
  "tax-audit"=@(@{q="What turnover triggers a tax audit?";a="Under section 44AB: $($rs)1 crore for business ($($rs)10 crore with 95%+ digital receipts), $($rs)50 lakh for profession, plus presumptive-scheme opt-outs. We test your exact trigger first."};@{q="Books vs 3CD mismatch $emdash how bad is it?";a="It is the single most-scrutinized reconciliation in assessment. We build the 3CD from the books so they cannot diverge."});
  "internal-audit"=@(@{q="We already have a statutory audit. Why internal audit?";a="Statutory audit opines on truth-and-fairness once a year. Internal audit finds leakage and control gaps quarterly, while they are fixable."};@{q="Who sees the reports?";a="Your audit committee and board $emdash never the operations team alone. Independence of reporting is the point."});
  roc=@(@{q="What happens if AOC-4/MGT-7 go late?";a="$($rs)100 per day per form, compounding until filed $emdash plus director-disqualification risk on long delays. We file before the clock matters."};@{q="We allotted shares but never filed PAS-3. Now what?";a="File it late with additional fees, then verify the register. Unfiled allotments haunt every future round $emdash fix it before diligence finds it."});
  budgeting=@(@{q="Annual budget or rolling forecast $emdash which one?";a="Both: annual budget for board accountability, 13-week cash for survival. One without the other is theater."};@{q="Our actuals never match budget. What's wrong?";a="Usually driverless budgets $emdash totals without owners or drivers. We build from hiring, pricing and burn drivers, then track variance monthly."});
  "unit-economics"=@(@{q="When is a startup ready for unit economics?";a="The moment you spend to acquire a customer. Pre-revenue, we validate the math on paper; post-launch, on cohorts."};@{q="What CAC/LTV ratio do investors want?";a="Rules of thumb vary by model; what investors actually test is whether your inputs survive questions. We build payback math you can defend line by line."});
  "project-report"=@(@{q="CMA vs TEV $emdash which does my bank want?";a="Working-capital limits need CMA; term loans need TEV with DSCR. Tell us the facility and we build exactly that pack."};@{q="The bank raised queries. Is the proposal dead?";a="No $emdash queries are normal. We answer with working papers, and most files move after one disciplined response round."});
  "stock-audit"=@(@{q="Why does the bank distrust our stock figures?";a="Because book stock drifts from physical stock without monthly discipline. An independent count resets that trust every quarter."};@{q="What if physical stock is short?";a="We report it plainly with ageing and reasons. Concealed shortages become fraud findings; disclosed ones become DP adjustments."});
  "bank-branch-audit"=@(@{q="What does LFAR scrutiny actually check?";a="Whether advances, NPA recognition and controls were tested with evidence $emdash not just reported. Our documentation is built for that reviewer."};@{q="Can branch audits finish in the RBI window?";a="Yes $emdash branches are staffed to the central-office calendar, with long-form reports drafted concurrently, not after."});
  "concurrent-audit"=@(@{q="How is this different from internal audit?";a="Concurrent audit is in-year, monthly, and bank-mandated $emdash exceptions surface within days. Internal audit is quarterly and board-directed."};@{q="What happens to exceptions we can't fix immediately?";a="They sit on a tracked action log with owners and dates $emdash visible to the bank, which is precisely what the bank wants to see."});
  "international-tax"=@(@{q="Do I need a foreign entity to go global?";a="Not always $emdash contracting, PE exposure and withholding often decide it. We map the routes before you incorporate anywhere."};@{q="What triggers PE risk for Indian founders?";a="Dependent agents, fixed places of business or effective management abroad. Substance and documentation decide it, not intentions."});
  "transfer-pricing"=@(@{q="When does transfer pricing apply to us?";a="The moment Indian and foreign group entities transact $emdash services, royalties, loans or goods. Thresholds decide documentation depth, not applicability."};@{q="Can we use safe harbour instead of benchmarking?";a="Sometimes $emdash check eligibility first. Safe harbour is simpler but often costs more tax than a proper benchmark. We compute both."});
  certifications=@(@{q="How fast can you issue a certificate?";a="Signed within 48 hours of complete evidence. The evidence is the timeline $emdash formats we already hold ship same-day."};@{q="Will banks accept your certificate?";a="Yes $emdash net-worth, turnover and utilisation formats match what credit committees ask for, on letterhead with UDIN."});
  valuation=@(@{q="DCF or comparables $emdash which governs?";a="Neither alone. We triangulate DCF, multiples and asset approaches, then bridge the differences $emdash that bridge is what boards sign."};@{q="Will this valuation hold for 56(2)(viib)?";a="That is a separate report with its own standard. We issue both together so the round never stalls on tax."});
  esop=@(@{q="How big should the pool be?";a="Sized to your hiring plan through the next round $emdash typically 10-15% pre-Series A. We model dilution before you promise."};@{q="Do employees get taxed at grant?";a="No $emdash perquisite tax hits at exercise, on the spread. We memo the timing so nobody learns this from a demand notice."});
  "financial-modeling"=@(@{q="Our deck and model disagree. Which is right?";a="The model $emdash then we fix the deck to match it. Investors diligence the model; the deck just gets you the meeting."};@{q="How many scenarios do we need?";a="Three: base, a downside that still survives, and an upside you can hire against. More scenarios signal you don't know which business you're in."});
  "strategic-mentorship"=@(@{q="Is this a retainer or hourly advice?";a="A quarterly rhythm with a fixed fee $emdash weekly or monthly operating cadence, not billable-hour roulette."};@{q="What decisions do you actually sit in on?";a="Pricing, hiring, runway and board narrative $emdash the calls where a finance brain changes the answer."});
  fundraising=@(@{q="When should we start the raise process?";a="Two quarters before money runs out. Data rooms take a month to build properly; desperation discounts valuation."};@{q="What kills Indian rounds most often?";a="Cap-table surprises and 56(2)(viib) exposure discovered in diligence. We clear both before outreach."});
  "due-diligence"=@(@{q="Buy-side or sell-side $emdash what's the difference in scope?";a="Buy-side prices the target's risk for negotiation; sell-side cleans your own file before buyers arrive. Same craft, opposite objective."};@{q="How long does QoE take?";a="Three to nine weeks depending on data quality. Messy books extend it $emdash which is itself a finding."});
  ma=@(@{q="Merger, demerger or slump sale $emdash how do we choose?";a="By tax outcome, stamp duty, carried losses and timeline. We model all three with MCA registrability checked, not assumed."};@{q="What delays NCLT approvals most?";a="Creditor objections and valuation disputes. We front-load both instead of discovering them at the hearing."});
  "capital-restructuring"=@(@{q="Buyback vs bonus $emdash which cleans the cap table better?";a="Different tools: bonus capitalizes reserves without cash, buyback returns cash and concentrates holding. We model both against your reserves and tax position."};@{q="Will this trigger tax?";a="It can $emdash buyback tax, deemed dividend and capital gains each lurk in different paths. The options memo prices the tax before you choose."});
  "debt-syndication"=@(@{q="Bank, NBFC or structured debt?";a="Banks for cheap secured limits, NBFCs for speed and flexibility, structured for special situations. We compare all-in cost, not just rates."};@{q="What covenants should we fight?";a="Dividend locks, promoter-pledge triggers and cross-defaults. We negotiate the covenants that actually bite in a downturn."});
  "pre-ipo"=@(@{q="How far out should cleanup start?";a="12-24 months before the DRHP. Restatements need two clean comparatives; RPT unwinding can't be rushed."};@{q="What fails pre-IPO hygiene most often?";a="Related-party transactions without arm's-length evidence, and KPIs defined three different ways in three documents."});
  drhp=@(@{q="Who writes the financial sections?";a="We draft restated financials, KPI definitions and MD&A financial inputs; your bankers own the narrative. The seam between the two is where filings die $emdash we sit on it."};@{q="How many SEBI comment rounds are normal?";a="Two to four. Each round gets answered with working papers, not adjectives."});
  "ipo-pricing"=@(@{q="How is the price band actually set?";a="Peer multiples bridged to your model, then tested against subscription scenarios and anchor appetite. One story, three validations."};@{q="What role do anchors play?";a="They de-risk the book and signal quality $emdash but allocation strategy matters as much as the names. We plan both."});
  "post-ipo"=@(@{q="What changes on day one of listing?";a="Everything becomes calendared: results, disclosures, insider-trading windows. LODR as a habit starts before listing, not after."};@{q="Do you run investor relations too?";a="We run the numbers side $emdash results packs, earnings inputs, shareholder communication. Your bankers and PR own the market side."})
}
$clusterWho = @{
  regform=@{ s=@{p="Revenue: pre-revenue to ₹25 Cr. You're setting up the structure before you've made a single mistake in it — this is the cheapest this work will ever be.";b=@("First-time incorporation","Founders splitting equity for the first time")}; m=@{p="Revenue: ₹25-250 Cr. You're adding a second entity, a GST registration, or a founders' agreement you should have signed years ago.";b=@("Multi-entity structuring","Retroactive documentation cleanup")}; e=@{p="Revenue: ₹250 Cr+. A subsidiary, a carve-out, or a JV needs the same rigor your original incorporation had — this time under diligence pressure.";b=@("Subsidiary/JV formation","Pre-transaction structuring")} };
  recurring=@{ s=@{p="Revenue: pre-revenue to ₹25 Cr. Your books are still in a spreadsheet or an app nobody reconciles monthly — this is where a future round or audit gets delayed.";b=@("First payroll run","First GST return cycle")}; m=@{p="Revenue: ₹25-250 Cr. Monthly filings are happening, but nobody's checking whether GSTR-1, GSTR-3B and the ledger actually agree.";b=@("Multi-state GST reconciliation","TDS across vendor categories")}; e=@{p="Revenue: ₹250 Cr+. Filings at this scale aren't the risk — the drift between entities, and between what's filed and what's booked, is.";b=@("Multi-entity consolidation","Group-wide filing calendar")} };
  audits=@{ s=@{p="Revenue: pre-revenue to ₹25 Cr. Your first statutory audit is coming and you don't yet know what 'audit-ready' actually looks like.";b=@("First statutory audit","Building the working-paper habit early")}; m=@{p="Revenue: ₹25-250 Cr. Lenders or promoters are pulling the numbers in different directions, and an unqualified opinion is no longer optional.";b=@("Bank covenant compliance","Multi-location stock verification")}; e=@{p="Revenue: ₹250 Cr+. IPO, PE, or a carve-out just made good-enough compliance genuinely expensive.";b=@("CARO 2020 disclosures","Internal controls testing at scale")} };
  govrep=@{ s=@{p="Revenue: pre-revenue to ₹25 Cr. You're applying for your first working capital loan and don't have a project report a bank will actually accept.";b=@("First bank loan application","First board-ready budget")}; m=@{p="Revenue: ₹25-250 Cr. Your ROC filings, budgets, and unit economics live in three different spreadsheets that don't talk to each other.";b=@("Annual ROC filings","Contribution-margin visibility")}; e=@{p="Revenue: ₹250 Cr+. Board reporting needs to hold up to a professional director or institutional investor's scrutiny, not just your own.";b=@("Statutory certifications on letterhead","Multi-entity ROC compliance calendar")} };
  xborder=@{ s=@{p="Revenue: pre-revenue to ₹25 Cr. You've onboarded your first overseas client or contractor and suddenly have a withholding question nobody in-house can answer.";b=@("First DTAA question","First cross-border invoice")}; m=@{p="Revenue: ₹25-250 Cr. A second entity now shares your founder's salary, office, or customers — that's an associated-enterprise problem, not a conglomerate one.";b=@("Related-party benchmarking","PE/residency exposure")}; e=@{p="Revenue: ₹250 Cr+. Master file, local file, and Form 3CEB thresholds are crossed, and the economic analysis needs to survive scrutiny, not just exist.";b=@("Master file + local file documentation","Multi-jurisdiction structuring")} };
  capital=@{ s=@{p="Revenue: pre-revenue to ₹25 Cr. You're heading into a seed or Series A round with a model built to impress, not to survive diligence.";b=@("First priced round","First real investor deck")}; m=@{p="Revenue: ₹25-250 Cr. You need working capital, a restructured cap table, or a credible valuation — and the CMA data has to match the audited financials.";b=@("Working capital / bank finance","Cap table cleanup before a raise")}; e=@{p="Revenue: ₹250 Cr+. An acquisition, a buyout, or a debt syndication needs a data room that survives someone else's diligence team.";b=@("Buy-side or sell-side diligence","Multi-lender debt syndication")} };
  ipo=@{ s=@{p="Revenue: pre-revenue to ₹25 Cr. IPO is years away, but the restated-financials habit starts now — a policy changed in year two forces a restatement later.";b=@("Early accounting-policy discipline","Cap table built to simplify, not complicate")}; m=@{p="Revenue: ₹25-250 Cr. You're two to three years from a listing and need related-party transactions and promoter holding cleaned up now, not under a banker's deadline.";b=@("Related-party benchmarking","Promoter/group structure simplification")}; e=@{p="Revenue: ₹250 Cr+. You're inside the DRHP process, and inconsistency — not complexity — is what costs you a comment cycle.";b=@("DRHP financial drafting","Post-IPO investor relations cadence")} }
}
$clusterPara2 = @{
  regform="Build-phase work is cheap now and expensive later: every shortcut in identity, equity or registration compounds into a Year-3 cleanup. We over-invest here on purpose. A founders' agreement signed in month one costs a conversation; the same agreement negotiated after a disagreement costs a relationship.";
  recurring="Operate-phase work is what keeps every later phase honest — a bank, an auditor, or an acquirer forms their first opinion of you from the same ledger you file from every month. A return filed on time and a return that reconciles to the books are two different achievements — we treat both as the job.";
  audits="Govern-phase work is what lenders, regulators and future buyers read. Audits, ROC filings and forecasts are written to be reopened without you in the room. An unqualified opinion isn't a formality — it's the only opinion a lender or acquirer will actually read.";
  govrep="Govern-phase work is what lenders, regulators and future buyers read. Audits, ROC filings and forecasts are written to be reopened without you in the room. A budget nobody checks against actuals isn't governance — it's a document that existed once.";
  xborder="Govern-phase work is what lenders, regulators and future buyers read. Audits, ROC filings and forecasts are written to be reopened without you in the room. Document the price when you set it, not when you're asked — reconstructing arm's-length evidence after a notice is how adjustments happen.";
  capital="Scale-phase work is what turns a growing company into a fundable, sellable, or borrow-worthy one — the model is a letter to a sceptical partner, not a pitch. A valuation nobody can defend is a number, not an opinion — we build ours to survive the question that comes right after it.";
  ipo="Exit-phase work treats the filing as a lagging indicator — the three years of decisions before it are the actual product. KPIs defined, computed, and assured the same way across the DRHP save a comment cycle; changing a definition mid-process costs one."
}
$clusterInside = @{
  regform=@(@{g="Formation";items=@("Certificate of Incorporation / DPIIT Recognition")};@{g="Equity & Governance";items=@("Founders' agreement or cap table set at day one")};@{g="Registrations";items=@("GST/PAN/TAN and other statutory registrations completed")};@{g="Handover";items=@("Founder briefing note + calendar of next due dates")});
  recurring=@(@{g="Books";items=@("Monthly reconciliation across bank, GST, and TDS")};@{g="Filings";items=@("Returns filed to calendar, not chased at deadline")};@{g="Payroll";items=@("Structuring, disbursal, and statutory deductions")};@{g="Handover";items=@("Founder briefing note + calendar of next due dates")});
  audits=@(@{g="Fieldwork";items=@("Testing, sampling, and control walkthroughs")};@{g="Findings";items=@("Risk and control matrix, documented as it's found")};@{g="Opinion";items=@("Signed report, ready for the board or the bank")};@{g="Handover";items=@("Working papers you can defend + calendar of next due dates")});
  govrep=@(@{g="Filings";items=@("Annual and event-based ROC compliance")};@{g="Reporting";items=@("Budget, forecast, or unit-economics pack")};@{g="Certification";items=@("Signed certificate on letterhead, where required")};@{g="Handover";items=@("Founder briefing note + calendar of next due dates")});
  xborder=@(@{g="Analysis";items=@("Residency, PE, and DTAA position")};@{g="Documentation";items=@("Benchmarking and transfer pricing study")};@{g="Filing";items=@("Form 3CEB and related compliance")};@{g="Handover";items=@("Working papers you can defend + calendar of next due dates")});
  capital=@(@{g="Analysis";items=@("Valuation, model, or diligence findings")};@{g="Structuring";items=@("Cap table, deal terms, or debt structure")};@{g="Materials";items=@("Investor-ready deck, memo, or data room")};@{g="Handover";items=@("Founder briefing note + next-step calendar")});
  ipo=@(@{g="Restatement";items=@("Three years of financials on consistent policy")};@{g="Disclosure";items=@("Related-party benchmarking and KPI definitions")};@{g="Filing";items=@("DRHP drafting or IPO pricing coordination")};@{g="Handover";items=@("Founder briefing note + post-IPO compliance calendar")})
}
$svcMeta = @{
  incorporation="Company and LLP Incorporation: SPICe+ filing, MOA-AOA and bank kit, structured so a term sheet won't unwind it. Advisory from Finchase Capital in Indore.";
  "startup-india"="Startup India Recognition and DPIIT Registration: recognition with 80-IAC mapping, filed so a fund's counsel won't send it back. Advisory from Finchase Capital in Indore.";
  "founders-agreement"="Founders' Agreement and Equity Splitting Advisory: vesting, IP and deadlock signed early, structured so a disagreement won't cost a relationship. Advisory from Finchase Capital in Indore.";
  gst="GST Registration and Return Filing: GSTIN with monthly GSTR-1/3B reconciled to the books, structured so input credit never becomes a diligence adjustment. Advisory from Finchase Capital in Indore.";
  bookkeeping="Financial Record Keeping and Bookkeeping: monthly close and reconciliations that match the books, not just the deadline. Advisory from Finchase Capital in Indore.";
  payroll="Payroll Management: monthly payslips, PF/ESI and TDS that match the books, not just the deadline. Advisory from Finchase Capital in Indore.";
  "financial-statements"="Financial Statement Preparation: monthly and annual Schedule III packs that match the books, not just the deadline. Advisory from Finchase Capital in Indore.";
  tds="TDS Compliance and Filing: monthly deduction, deposit and 24Q/26Q rhythm that matches the books, not just the deadline. Advisory from Finchase Capital in Indore.";
  itr="Income Tax Return (ITR) Filing: company and promoter returns reconciled to the trial balance, not just the deadline. Advisory from Finchase Capital in Indore.";
  "tax-planning"="Tax Planning and Advisory: Q3 positions with an advance-tax calendar timed to cash flows, not just the deadline. Advisory from Finchase Capital in Indore.";
  "indirect-tax"="Indirect Tax Advisory: classification, refund and notice positions that match the books, not just the deadline. Advisory from Finchase Capital in Indore.";
  "statutory-audit"="Statutory Audit: fieldwork to signed opinion, with working papers a lender or acquirer can actually reopen. Advisory from Finchase Capital in Indore.";
  "tax-audit"="Tax Audit: fieldwork to signed opinion, with working papers a lender or acquirer can actually reopen. Advisory from Finchase Capital in Indore.";
  "internal-audit"="Internal Audit: fieldwork to signed opinion, with working papers a lender or acquirer can actually reopen. Advisory from Finchase Capital in Indore.";
  roc="Registrar of Companies (ROC) Compliance: annual and event-based MCA filings, built to survive a lender's or director's second look. Advisory from Finchase Capital in Indore.";
  budgeting="Budgeting and Forecasting: driver-built budgets with 13-week cash, built to survive a lender's or director's second look. Advisory from Finchase Capital in Indore.";
  "unit-economics"="Business Model Validation and Unit Economics Advisory: contribution and payback math, built to survive a lender's or director's second look. Advisory from Finchase Capital in Indore.";
  "project-report"="Project Report Preparation for Bank Loans: CMA data and projections a credit committee finishes, built to survive a lender's or director's second look. Advisory from Finchase Capital in Indore.";
  certifications="Statutory Certifications: net-worth and turnover certificates on letterhead, built to survive a lender's or director's second look. Advisory from Finchase Capital in Indore.";
  "international-tax"="International Taxation Advisory: residency, PE and DTAA position, documented before money crosses the border, not after. Advisory from Finchase Capital in Indore.";
  "transfer-pricing"="Transfer Pricing Documentation: arm's-length benchmarking and local file, documented before money crosses the border, not after. Advisory from Finchase Capital in Indore.";
  valuation="Business Valuation: triangulated DCF, multiples and 56(2)(viib) reports, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  esop="ESOP Structuring and Compliance: pool, scheme and valuation memo, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  "financial-modeling"="Financial Modeling and Pitch Deck Preparation: three-statement model tied to the deck, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  "strategic-mentorship"="Strategic Mentorship and Growth Advisory: quarterly operating cadence with numbers attached, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  fundraising="Venture Capital and Private Equity Fundraising Advisory: round strategy with a diligence-ready data room, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  "due-diligence"="Financial Due Diligence: quality-of-earnings with net-debt bridge, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  ma="Mergers and Acquisitions Advisory: structure modelled with tax outcomes, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  "capital-restructuring"="Capital Restructuring and Financial Reengineering: bonus, buyback and merger paths priced with tax, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  "debt-syndication"="Debt Syndication and Corporate Loan Structuring: lender landscape with negotiated covenants, built to hold up under an investor's or lender's counter-question. Advisory from Finchase Capital in Indore.";
  "pre-ipo"="Pre-IPO Restructuring and Compliance: quarter-by-quarter cleanup with restated comparatives, built to clear the comment cycle in fewer rounds. Advisory from Finchase Capital in Indore.";
  drhp="Draft Red Herring Prospectus (DRHP) Financial Drafting: restated financials with consistent KPIs, built to clear the comment cycle in fewer rounds. Advisory from Finchase Capital in Indore.";
  "ipo-pricing"="IPO Pricing and Underwriting Coordination: peer-bridged band with anchor plan, built to clear the comment cycle in fewer rounds. Advisory from Finchase Capital in Indore.";
  "post-ipo"="Post-IPO Compliance and Investor Relations Support: LODR calendar with quarterly results packs, built to clear the comment cycle in fewer rounds. Advisory from Finchase Capital in Indore.";
  "stock-audit"="Stock Audit: fieldwork to signed opinion, with working papers a lender or acquirer can actually reopen. Advisory from Finchase Capital in Indore.";
  "bank-branch-audit"="Bank Branch Audit: fieldwork to signed opinion, with working papers a lender or acquirer can actually reopen. Advisory from Finchase Capital in Indore.";
  "concurrent-audit"="Concurrent Audit: fieldwork to signed opinion, with working papers a lender or acquirer can actually reopen. Advisory from Finchase Capital in Indore."
}
$svcDetail = @{
  incorporation=@{ detail="Private Limited, LLP or Section 8, chosen for how you will raise, hire and sell, not just how fast you can file. SPICe+ or FiLLiP run end-to-end with MOA-AOA, DIN, PAN-TAN and a first board pack."; inside=@("Entity choice memo: Pvt Ltd vs LLP vs Section 8","SPICe+ / FiLLiP filing with MOA-AOA","DIN, PAN, TAN, bank kit + first board minutes") };
  "startup-india"=@{ detail="DPIIT recognition that actually pays: 80-IAC mapping, tender and compliance benefits, filed so a fund's counsel will not send it back."; inside=@("Eligibility + document dossier","80-IAC tax-holiday mapping","Recognition certificate + benefits tracker") };
  "founders-agreement"=@{ detail="Vesting, roles, IP assignment and deadlock, in founder English, signed before money makes everyone generous or bitter."; inside=@("4-year vest + cliff schedule","IP assignment + roles matrix","Deadlock + exit formula") };
  gst=@{ detail="Registration plus a filing cadence (GSTR-1/3B/9) reconciled to the books every month, so input credit never becomes a diligence adjustment."; inside=@("Registration + HSN mapping","Monthly GSTR-1/3B + reconciliation","Annual GSTR-9 + ITC hygiene") };
  bookkeeping=@{ detail="Accrual monthly close with a chart of accounts built for MIS, the board pack becomes a by-product, not a fire drill."; inside=@("Chart of accounts + monthly close","Vendor / customer reconciliations","MIS-ready trial balance") };
  payroll=@{ detail="Payslips, PF/ESI and TDS that employees and inspectors both accept, salary structuring included."; inside=@("Salary structuring + payslips","PF/ESI registration + deposits","Form 16 coordination") };
  "financial-statements"=@{ detail="Schedule III packs with notes and cash-flow that bankers can underwrite and auditors can sign."; inside=@("Monthly / annual statements","Notes + cash-flow schedules","Banker-ready reporting pack") };
  tds=@{ detail="Deduction logic mapped per payment type, deposits on time, 24Q/26Q filed, no interest leakage."; inside=@("Section-wise deduction map","Deposits + challan tracking","24Q/26Q returns + corrections") };
  itr=@{ detail="Company, LLP and founder ITRs that reconcile to the trial balance, carry-forward tracked, not guessed."; inside=@("Corporate / LLP ITR","Promoter ITRs","Loss + depreciation schedules") };
  "tax-planning"=@{ detail="Structure, timing and incentives decided before the year closes, advance-tax calendar included."; inside=@("Entity + regime review","Advance-tax calendar","Incentive + depreciation plan") };
  "indirect-tax"=@{ detail="Classification, place-of-supply and refund positions defended with working papers, plus departmental responses."; inside=@("HSN/SAC classification memo","Refund + ITC position papers","Notice responses + hearing prep") };
  "statutory-audit"=@{ detail="An opinion lenders, boards and future buyers can rely on, planned around materiality, not last year's file."; inside=@("Audit plan + materiality memo","Vouching, verification + confirmations","Report + management letter") };
  "tax-audit"=@{ detail="Form 3CA/3CB with a 3CD that matches reality, ICDS positions documented clause by clause."; inside=@("Clause-wise 3CD preparation","ICDS alignment memo","Filing + rectification support") };
  "internal-audit"=@{ detail="Controls, revenue leakage and a cycle the audit committee can actually use, quarterly, not ornamental."; inside=@("Risk + control matrix","Quarterly testing + leakage report","Audit-committee pack") };
  roc=@{ detail="Annual and event-based MCA filings on one calendar, AOC-4, MGT-7, registers, without compounding surprises."; inside=@("AOC-4 + MGT-7 filing","Statutory registers","Event filings: allotment, director changes") };
  budgeting=@{ detail="Board packs tied to hiring, burn and covenant headroom, 13-week cash plus the annual operating budget."; inside=@("13-week cash forecast","Annual budget + variance pack","Covenant-headroom view") };
  "unit-economics"=@{ detail="Contribution, CAC payback and a story the model can defend, validation before scale spend."; inside=@("Contribution-margin build","CAC/LTV + payback math","Pricing-power test") };
  "project-report"=@{ detail="CMA data, TEV and DSCR with sensitivity annexures, the exact pack credit committees ask for."; inside=@("CMA data + projections","DSCR + sensitivity annexures","Bank-query responses") };
  "stock-audit"=@{ detail="Physical verification and valuation that working-capital lenders trust, quarterly drawing-power support."; inside=@("Physical verification","Valuation + ageing review","DP-statement reconciliation") };
  "bank-branch-audit"=@{ detail="Branch-level advances and control review with documentation that survives LFAR scrutiny."; inside=@("Advances verification","NPA + control testing","LFAR-ready documentation") };
  "concurrent-audit"=@{ detail="In-year control testing for banks, NBFCs and high-volume operations, a monthly rhythm."; inside=@("Monthly transaction testing","Exception + leakage reporting","Systems-improvement notes") };
  "international-tax"=@{ detail="Residency, PE, DTAA and substance for cross-border founders, structured before money moves."; inside=@("Residency + PE analysis","DTAA + withholding map","ECB / FEMA coordination note") };
  "transfer-pricing"=@{ detail="Local file, Form 3CEB and methods that match how you actually operate, benchmarked while facts are fresh."; inside=@("Functional + benchmarking study","Local file + 3CEB","Safe-harbour review") };
  certifications=@{ detail="Net-worth, turnover and special-purpose certificates on letterhead, in the formats bankers ask for."; inside=@("Net-worth certificates","Turnover / utilisation certificates","Banker-format certificates") };
  valuation=@{ detail="DCF, comparables and 56(2)(viib)/FEMA reports boards can sign, assumptions bridged, not buried."; inside=@("DCF + multiple triangulation","56(2)(viib) / FEMA report","ESOP-valuation support") };
  esop=@{ detail="Pool, trust, grants and tax that employees can explain at dinner, passed in a single board sitting."; inside=@("Pool sizing + scheme draft","Grant letters + vesting tracker","Valuation + tax memo") };
  "financial-modeling"=@{ detail="Three-statement models and a deck whose numbers match the data room, scenario layers included."; inside=@("3-statement operating model","Scenario + sensitivity layers","Investor deck, numbers-tied") };
  "strategic-mentorship"=@{ detail="A finance lead in the weekly operating rhythm, pricing, hiring and runway calls with numbers attached."; inside=@("Quarterly operating cadence","Runway + hiring decisions","Board-narrative preparation") };
  fundraising=@{ detail="Process, data room and term-sheet mechanics for Indian rounds, run to close, not to launch."; inside=@("Round strategy + investor list","Data-room build","Term-sheet + closure support") };
  "due-diligence"=@{ detail="Buy-side and sell-side quality-of-earnings that prices risk instead of hiding it, net-debt bridge included."; inside=@("Quality-of-earnings report","Net-debt + working-capital peg","Red-flag + SPA-input memo") };
  ma=@{ detail="Structure, synergy and closing accounts for Indian deals, schemes the MCA will register."; inside=@("Structure + synergy note","Valuation + swap-ratio support","Scheme + closing accounts") };
  "capital-restructuring"=@{ detail="Bonus, buyback, merger and debt-equity re-engineering that cleans the balance sheet for whatever comes next."; inside=@("Restructure options memo","Buyback / bonus execution","Debt-recast coordination") };
  "debt-syndication"=@{ detail="Bank, NBFC and structured debt with covenant design, multi-lender coordination handled end to end."; inside=@("Lender landscape + term sheet","Security + covenant negotiation","Drawdown + compliance calendar") };
  "pre-ipo"=@{ detail="Group cleanup, related parties and restatements before the DRHP, a quarter-by-quarter plan, not a tracker."; inside=@("Group + RPT cleanup plan","Restatement policy memo","Board / KMP readiness map") };
  drhp=@{ detail="MD&A-ready numbers and notes that survive banker comments, KPIs defined and assured consistently."; inside=@("Restated financials","KPI definition + assurance","Objects-of-issue + risk inputs") };
  "ipo-pricing"=@{ detail="The bridge between the model, comparables and the book-building room, anchor and allocation support."; inside=@("Price-band analytics","Peer-multiple bridge","Anchor / allocation coordination") };
  "post-ipo"=@{ detail="Results calendar, Ind-AS packs and investor relations that listed life requires, LODR as a habit, not an event."; inside=@("LODR compliance calendar","Quarterly results pack","Earnings + shareholder communication") };
}
$svcKeywords = @{
  "project-finance"="project finance India, project report CMA data, TEV report term loan, DSCR 1.25x, credit committee sanction, first project loan India, bank query response working papers";
  "bank-funding"="debt syndication India, consortium lending, covenant negotiation, multi-lender debt, NBFC vs bank growth debt, working capital limits, drawdown covenant calendar"
}
$svcFaqJson = @{
  "project-finance"='<script type="application/ld+json">{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"We already have a CA — why a separate project report?","acceptedAnswer":{"@type":"Answer","text":"Your CA reports history; a project report underwrites the future — CMA, DSCR and end-use viability in the exact format a credit committee scores. Most first-time proposals stall on format, not on the business."}},{"@type":"Question","name":"How much can we borrow against the project?","acceptedAnswer":{"@type":"Answer","text":"Banks typically fund 70-80% of project cost with promoter contribution for the rest, and DSCR above ~1.25x keeps the sanction smooth. We size the ask before the bank sizes you down."}},{"@type":"Question","name":"What if the bank raises queries?","acceptedAnswer":{"@type":"Answer","text":"Normal — most files move after one disciplined response round with working papers attached. A query is not a rejection."}}]}</script>';
  "bank-funding"='<script type="application/ld+json">{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"When does one bank stop being enough?","acceptedAnswer":{"@type":"Answer","text":"When limits cap your growth, covenants bite on every decision, or tenure mismatches the asset. That''s the moment a second lender — or a consortium — pays for itself."}},{"@type":"Question","name":"Bank, NBFC or consortium?","acceptedAnswer":{"@type":"Answer","text":"Banks for cheap secured limits, NBFCs for speed, consortiums for size. We compare all-in cost, not just rates."}},{"@type":"Question","name":"What covenants should we fight?","acceptedAnswer":{"@type":"Answer","text":"Dividend locks, promoter-pledge triggers and cross-defaults. We negotiate the covenants that actually bite in a downturn."}}]}</script>'
}
for ($i=0; $i -lt $svc.Count; $i++) {
  $s = $svc[$i]
  $d = $svcDetail[$s.slug]
  $a = $svcAngle[$s.slug]
  $rel = @()
  foreach ($j in @(-1,1,2)) {
    $k = $i + $j
    if ($k -ge 0 -and $k -lt $svc.Count -and $k -ne $i) { $rel += $svc[$k] }
  }
  $rel = $rel | Select-Object -First 3
  $relHtml = ($rel | ForEach-Object { "<a class='glass-card svc-card' href='$($_.slug).html'><h3>$($_.name)</h3><p>$($_.blurb)</p><span class='arrow'>-></span></a>" }) -join ""
  $sub = $svcDuoSub[$s.slug]
  $cmSlug = $svcCase[$s.slug]
  $caseLine = ""
  if ($cmSlug) { $cm2 = $casesMeta | Where-Object { $_.slug -eq $cmSlug } | Select-Object -First 1; $caseLine = "<p style=`"margin-top:16px`">See it in practice: <a href=`"../case-studies/$($cm2.slug).html`" style=`"text-decoration:underline;text-underline-offset:3px`">$($cm2.title) -></a></p>" }
  $whyN = 0
  $whyHtml = (($phaseWhy[$s.phase] | ForEach-Object { $w = $_; $whyN++; $nn = "{0:D2}" -f $whyN; "<li><span class='ed-num'>$nn</span><div><h3>$($w.t)</h3><p>$($w.d)</p></div></li>" }) -join "")
  $whyTiles = (($phaseWhy[$s.phase] | ForEach-Object { "<div class='tile tile-why'><h3>$($_.t)</h3><p>$($_.d)</p></div>" }) -join "`n      ")
  $kpiHtml = (($clusterKpi[$svcCluster[$s.slug]] | ForEach-Object { "<span><strong>$($_.v)</strong> $($_.l)</span>" }) -join "")
  $wh = $clusterWho[$svcCluster[$s.slug]]
  $escS = $wh.s.p -replace '&','&amp;' -replace '"','&quot;' -replace '<','&lt;' -replace '>','&gt;' -replace "'",'&#39;'
  $escM = $wh.m.p -replace '&','&amp;' -replace '"','&quot;' -replace '<','&lt;' -replace '>','&gt;' -replace "'",'&#39;'
  $escE = $wh.e.p -replace '&','&amp;' -replace '"','&quot;' -replace '<','&lt;' -replace '>','&gt;' -replace "'",'&#39;'
  $whoHtml = "<div class='ed-who-item'><small>Startup <span class='who-tip' tabindex='0' data-tip='$escS'>?</span></small><ul><li>$($wh.s.b[0])</li><li>$($wh.s.b[1])</li></ul></div><div class='ed-who-item'><small>SME <span class='who-tip' tabindex='0' data-tip='$escM'>?</span></small><ul><li>$($wh.m.b[0])</li><li>$($wh.m.b[1])</li></ul></div><div class='ed-who-item'><small>Enterprise <span class='who-tip' tabindex='0' data-tip='$escE'>?</span></small><ul><li>$($wh.e.b[0])</li><li>$($wh.e.b[1])</li></ul></div>"
  $inHtml = ""
   $inN = 0
   foreach ($gr in $clusterInside[$svcCluster[$s.slug]]) { foreach ($it in $gr.items) { $inN++; $nn = "{0:D2}" -f $inN; $inHtml += "<div class='flip4-card' tabindex='0'><div class='flip4-inner'><div class='flip4-face flip4-front'><span class='flip4-index'>$nn</span><h3>$($gr.g)</h3><span class='flip4-hint'>Hover to reveal</span></div><div class='flip4-face flip4-back'><i data-lucide=`"check`"></i><p>$it</p></div></div></div>" } }
  $meta = $svcMeta[$s.slug]
  $procHtml = ""
  $pp = $svcProcess[$s.slug]
  for ($k=0; $k -lt $pp.Count; $k++) { $nn = "{0:D2}" -f ($k+1); $procHtml += "<li><span class='ed-num'>$nn</span><div><h3>$($pp[$k].t)</h3><p>$($pp[$k].d)</p></div></li>" }
  $faqHtml = "<div class='faq-item'><button type='button'>How long does $($s.name) take? <span class='plus'>+</span></button><div class='ans'>$($clusterTime[$svcCluster[$s.slug]])</div></div>"
  $faqHtml += "<div class='faq-item'><button type='button'>How are fees structured? <span class='plus'>+</span></button><div class='ans'>Fixed for defined filings; retainers for lifecycle. Quotes in writing before work starts.</div></div>"
  $faqHtml += "<div class='faq-item'><button type='button'>Do you work remotely outside Indore? <span class='plus'>+</span></button><div class='ans'>Yes. Portals are national. On-site stock or branch work is scheduled explicitly.</div></div>"
  $faqHtml += "<div class='faq-item'><button type='button'>Who signs? <span class='plus'>+</span></button><div class='ans'>A named senior advisor from our 20-professional bench. You will not meet someone new every filing.</div></div>"
  foreach ($fq in $svcFaq[$s.slug]) { $faqHtml += "<div class='faq-item'><button type='button'>$($fq.q) <span class='plus'>+</span></button><div class='ans'>$($fq.a)</div></div>" }
  $schema = "<script type=`"application/ld+json`">{`"@context`":`"https://schema.org`",`"@type`":`"Service`",`"name`":`"$($s.name)`",`"description`":`"$meta`",`"serviceType`":`"$($phaseName[$s.phase])`",`"areaServed`":{`"@type`":`"Country`",`"name`":`"IN`"},`"provider`":{`"@type`":`"ProfessionalService`",`"name`":`"Finchase Capital Private Limited`",`"email`":`"finchasecapital@gmail.com`",`"address`":{`"@type`":`"PostalAddress`",`"addressLocality`":`"Indore`",`"addressRegion`":`"Madhya Pradesh`",`"addressCountry`":`"IN`"}}}</script>"
  $html = (Head "$($s.name) | Finchase Capital" $meta "services/$($s.slug).html" $true ($schema + $svcFaqJson[$s.slug]) $svcKeywords[$s.slug]) + (ChromeStart $true "services" $false) + @"
<section class="page-hero"><div class="container" data-animate="fade-up">
  <p class="breadcrumb"><a href="../index.html">Home</a> › <a href="../services.html">Practice</a> › <a href="../services.html#$($s.phase)">$($phaseName[$s.phase])</a> › $($s.name)</p>
  <h1>$($s.name)</h1>
  <p>$($s.blurb)</p>
  <div class="hero-ctas"><a class="btn btn-primary" href="../contact.html">Get Started</a></div>
  <div class="svc-meta">
    $kpiHtml
  </div>
</div></section>
<section class="section"><div class="container two-col" data-stagger>
  <div>
    <span class="section-label">What it is</span>
    <h2>Plain language, then the law.</h2>
    <p>$($d.detail)</p>
    <p>$($clusterPara2[$svcCluster[$s.slug]])</p>
    <p>The output is not a PDF dump. It is a file a future investor, banker, or officer can reopen without you in the room.</p>
  </div>
  <div class="glass-card svc-side"><span class="svc-fallback" role="img" aria-label="$($s.name) illustration"><i data-lucide="$($s.icon)"></i></span><img src="../images/$($svcImg[$s.slug])" alt="$($s.name), Finchase Capital" loading="lazy" onerror="this.remove()"></div>
</div></section>
<section class="section" style="padding-top:0;padding-bottom:0"><div class="container"><div class="svc-duo" data-stagger>
  <div class="svc-duo-item"><span class="section-label">What you walk away with</span><strong>$($a.leaves)</strong><span>$($sub.ls)</span><span>Filed, audited, funded without leaving the building.</span></div>
  <div class="svc-duo-item"><span class="section-label">When to call us</span><strong>$($a.when)</strong><span>$($sub.ws)</span></div>
</div></div></section>
<section class="section"><div class="container">
  <div class="ed-split ed-tiles">
    <div class="ed-split-main">
      <span class="section-label">Our process</span>
      <div class="tile tile-main">
      <ol class="ed-steps tile-steps" data-stagger>
        $procHtml
      </ol>
      </div>
    </div>
    <div class="ed-split-side">
      <span class="section-label">Why it matters</span>
      <div class="tile-grid">
      $whyTiles
      </div>
    </div>
  </div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">Who needs this</span>
  <div class="ed-who" data-stagger>
    $whoHtml
  </div>
</div></section>
<section class="section"><div class="container">
  <div class="deliverables ed-inside" data-animate="fade-up">
    <span class="section-label">Deliverables</span>
    <h2>What's inside</h2>
    <div class="flip4-grid" data-stagger>
      $inHtml
    </div>
  </div>
</div></section>
<section class="section"><div class="container" style="max-width:800px" data-animate="fade-up">
  <span class="section-label">FAQ</span>
  $faqHtml
</div></section>
<section class="section"><div class="container" data-animate="fade-up">
  <h2>Related services</h2>
  <div class="svc-grid" style="margin-top:18px" data-stagger>$relHtml</div>
  $caseLine
</div></section>
$(Cta $true)
"@ + (ChromeEnd $true)
  Set-Content "$root\services\$($s.slug).html" $html -Encoding UTF8
}

# --- SITEMAP ---
$links = @("index.html|Home","about.html|About","services.html|Services hub","contact.html|Contact","case-studies.html|Case studies","insights.html|Insights","tools.html|Free tools","404.html|Not found","privacy-policy.html|Privacy Policy","terms-of-use.html|Terms of Use","grievance-redressal.html|Grievance Redressal Policy","professional-conduct.html|Professional & Ethical Conduct Policy")
$links += $svc | ForEach-Object { "services/$($_.slug).html|$($_.name)" }
$links += $casesMeta | ForEach-Object { "case-studies/$($_.slug).html|$($_.title)" }
$links += $arts | ForEach-Object { "insights/$($_.slug).html|$($_.title)" }
$list = ($links | ForEach-Object { $p,$n = $_.Split('|'); "<li><a href='$p'>$n</a> - $n at Finchase Capital.</li>" }) -join "`n"
$sm = (Head 'Sitemap | Finchase Capital' 'All public pages for Finchase Capital, including 35+ service mandates.' 'sitemap.html' $false '') + (ChromeStart $false '' $false) + @"
<section class="section"><div class="container sitemap">
  <h1>Sitemap</h1>
  <p>Every public URL on this site.</p>
  <ul>$list</ul>
</div></section>
"@ + (ChromeEnd $false)
Set-Content "$root\sitemap.html" $sm -Encoding UTF8

Write-Host "All pages written"


