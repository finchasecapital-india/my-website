$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
function P($n) { if ($n) { "../" } else { "" } }

function Head($title, $desc, $path, $nested, $schema) {
  $pre = P $nested
  $canon = 'https://[FIRM NAME].com/' + $path
  $h = @'
<!DOCTYPE html>
<html lang="en-IN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>__TITLE__</title>
  <meta name="description" content="__DESC__">
  <link rel="canonical" href="__CANON__">
  <meta property="og:title" content="__TITLE__">
  <meta property="og:description" content="__DESC__">
  <meta property="og:image" content="https://[FIRM NAME].com/og.jpg">
  <meta property="og:type" content="website">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="__TITLE__">
  <meta name="twitter:description" content="__DESC__">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="__PRE__css/style.css">
  __SCHEMA__
</head>
'@
  $h.Replace('__TITLE__', $title).Replace('__DESC__', $desc).Replace('__CANON__', $canon).Replace('__PRE__', $pre).Replace('__SCHEMA__', [string]$schema)
}

function ChromeStart($nested, $active, $noWa) {
  $pre = P $nested
  $body = if ($noWa) { '<body class="no-wa">' } else { "<body>" }
  $cur = { param($n) if ($n -eq $active) { ' aria-current="page"' } else { "" } }
  @"
$body
  <a class="skip-link" href="#main">Skip to content</a>
  <div class="ambient-canvas" aria-hidden="true"><div class="orb orb-blue"></div><div class="orb orb-purple"></div><div class="orb orb-green"></div><div class="grid-overlay"></div></div>
  <div class="page">
    <div class="announce"><span class="pulse-dot"></span><span class="full">[FIRM NAME] is now onboarding FY 2026-27 retainers - limited seats.</span> <a href="$($pre)contact.html">Book a strategy call -></a></div>
    <header class="site-header">
      <div class="container nav-inner">
        <a class="logo" href="$($pre)index.html"><span class="logo-mark">F</span>[FIRM NAME]</a>
        <nav class="nav-links" aria-label="Primary">
          <a class="nav-link" href="$($pre)index.html"$(& $cur 'home')>Home</a>
          <div class="nav-item">
            <a class="nav-link" href="$($pre)services.html"$(& $cur 'services')>Services</a>
            <div class="mega">
              <div><h4>Build</h4><a href="$($pre)services/incorporation.html">Incorporation</a><a href="$($pre)services/startup-india.html">Startup India</a><a href="$($pre)services/founders-agreement.html">Founders' Agreement</a><a href="$($pre)services/gst.html">GST</a></div>
              <div><h4>Operate</h4><a href="$($pre)services/bookkeeping.html">Bookkeeping</a><a href="$($pre)services/payroll.html">Payroll</a><a href="$($pre)services/itr.html">ITR Filing</a><a href="$($pre)services/tax-planning.html">Tax Planning</a></div>
              <div><h4>Govern</h4><a href="$($pre)services/statutory-audit.html">Statutory Audit</a><a href="$($pre)services/roc.html">ROC Compliance</a><a href="$($pre)services/internal-audit.html">Internal Audit</a><a href="$($pre)services/certifications.html">Certifications</a></div>
              <div><h4>Scale-Exit</h4><a href="$($pre)services/fundraising.html">Fundraising</a><a href="$($pre)services/valuation.html">Valuation</a><a href="$($pre)services/ma.html">M&amp;A</a><a href="$($pre)services/pre-ipo.html">Pre-IPO</a></div>
            </div>
          </div>
          <a class="nav-link" href="$($pre)about.html"$(& $cur 'about')>About</a>
          <a class="nav-link" href="$($pre)case-studies.html"$(& $cur 'cases')>Case Studies</a>
          <a class="nav-link" href="$($pre)insights.html"$(& $cur 'insights')>Insights</a>
          <a class="nav-link" href="$($pre)tools.html"$(& $cur 'tools')>Tools</a>
        </nav>
        <div class="nav-actions">
          <a class="btn btn-primary" href="$($pre)contact.html">Book Consultation</a>
          <button class="hamburger" type="button" aria-label="Open menu" aria-expanded="false"><span></span><span></span><span></span></button>
        </div>
      </div>
    </header>
    <div class="drawer-overlay"></div>
    <aside class="drawer"><a href="$($pre)index.html">Home</a><details><summary>Services</summary><a href="$($pre)services.html">All services</a><a href="$($pre)services.html#build">Build</a><a href="$($pre)services.html#operate">Operate</a><a href="$($pre)services.html#govern">Govern</a><a href="$($pre)services.html#scale">Scale</a><a href="$($pre)services.html#exit">Exit</a></details><a href="$($pre)about.html">About</a><a href="$($pre)case-studies.html">Case Studies</a><a href="$($pre)insights.html">Insights</a><a href="$($pre)tools.html">Tools</a><a href="$($pre)contact.html">Contact</a><p style="margin-top:20px;font-size:13px;color:var(--mid-gray)">[PHONE]<br>[EMAIL]<br>[CITY]</p></aside>
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
          <div class="ft-brand"><a class="logo" href="$($pre)index.html" style="color:#fff"><span class="logo-mark">F</span>[FIRM NAME]</a><p>The financial backbone India's next generation companies are built on. [CITY].</p>
            <div class="socials"><a href="#" aria-label="LinkedIn"><i data-lucide="linkedin"></i></a><a href="#" aria-label="X"><i data-lucide="twitter"></i></a><a href="#" aria-label="Instagram"><i data-lucide="instagram"></i></a></div></div>
          <form class="news"><input type="email" required placeholder="Work email" aria-label="Email"><button class="btn btn-primary" type="submit">Subscribe</button></form>
        </div>
        <div class="ft-grid">
          <div><h4>Build</h4><a href="$($pre)services/incorporation.html">Incorporation</a><a href="$($pre)services/startup-india.html">Startup India</a><a href="$($pre)services/founders-agreement.html">Founders' Agreement</a><a href="$($pre)services/gst.html">GST</a></div>
          <div><h4>Operate</h4><a href="$($pre)services/bookkeeping.html">Bookkeeping</a><a href="$($pre)services/payroll.html">Payroll</a><a href="$($pre)services/itr.html">ITR</a><a href="$($pre)services/tax-planning.html">Tax planning</a></div>
          <div><h4>Govern</h4><a href="$($pre)services/statutory-audit.html">Statutory audit</a><a href="$($pre)services/roc.html">ROC</a><a href="$($pre)services/budgeting.html">Budgeting</a><a href="$($pre)services/certifications.html">Certifications</a></div>
          <div><h4>Scale</h4><a href="$($pre)services/valuation.html">Valuation</a><a href="$($pre)services/fundraising.html">Fundraising</a><a href="$($pre)services/esop.html">ESOP</a><a href="$($pre)services/ma.html">M&amp;A</a></div>
          <div><h4>Exit</h4><a href="$($pre)services/pre-ipo.html">Pre-IPO</a><a href="$($pre)services/drhp.html">DRHP</a><a href="$($pre)services/ipo-pricing.html">IPO pricing</a><a href="$($pre)services/post-ipo.html">Post-IPO</a></div>
        </div>
        <div class="ft-bot"><span>© [YEAR FOUNDED]-2026 [FIRM NAME]. ICAI [ICAI REG].</span><span><a href="$($pre)sitemap.html">Sitemap</a> · <a href="$($pre)contact.html">Privacy</a> · <a href="$($pre)contact.html">Terms</a></span></div>
      </div>
    </footer>
  </div>
  <a class="wa-float" href="https://wa.me/91XXXXXXXXXX?text=Hello%20[FIRM%20NAME]%2C%20I%20would%20like%20to%20book%20a%20consultation." aria-label="WhatsApp"><i data-lucide="message-circle"></i></a>
  <div class="mobile-cta"><a class="btn btn-primary" href="$($pre)contact.html">Book Consultation</a><a class="btn btn-secondary" href="tel:[PHONE]">[PHONE]</a></div>
  <div class="modal-bg" id="exit-modal" role="dialog"><div class="glass-card modal"><button class="x" type="button" aria-label="Close">×</button><h3>Before you go - a 30-minute diagnostic.</h3><p>Leave your email. [CA NAME] will send a one-page lifecycle map.</p><form id="exit-form" class="field" style="margin-top:16px"><input type="email" required placeholder="Founder email"><button class="btn btn-primary" type="submit" style="margin-top:10px">Send the map</button></form></div></div>
  <div class="modal-bg" id="gate-modal" role="dialog"><div class="glass-card modal"><button class="x" type="button" aria-label="Close">×</button><h3>Where should we send it?</h3><form id="gate-form"><label class="field">Work email <input type="email" required></label><button class="btn btn-primary" type="submit">Continue</button></form></div></div>
  <script src="https://unpkg.com/lucide@latest"></script>
  <script src="$($pre)js/main.js"></script>
</body></html>
"@
}

function Cta($nested) {
  $pre = P $nested
  @"
<section class="section final-cta"><div class="container"><div class="glass-card cta-card"><div class="cta-orb b"></div><div class="cta-orb g"></div>
<div class="scarcity">🎯 Limited availability - Currently accepting 5 new clients</div>
<h2>Ready to build a company that lasts generations?</h2>
<p style="margin:12px 0 22px">A free 30-minute consultation. Response within 4 hours.</p>
<a class="btn btn-primary btn-lg" href="$($pre)contact.html">Book Free Consultation</a>
<a class="btn btn-secondary" href="tel:[PHONE]">Call Us Now</a>
<p class="micro">No spam · 100% confidential.</p></div></div></section>
"@
}

# --- ABOUT ---
$about = (Head 'About [FIRM NAME] - [CA NAME] and the practice' 'The story, team, values, and credentials behind [FIRM NAME], a premium corporate finance advisory in [CITY].' 'about.html' $false '') + (ChromeStart $false 'about' $false) + @"
<section class="page-hero" style="background:var(--off-white)"><div class="container">
  <span class="section-label">About</span>
  <h1>We don't just file your returns. We <em class="italic gradient-text">architect</em> your future.</h1>
  <p class="sub" style="max-width:640px">[FIRM NAME] exists for founders who outgrew a compliance vendor and still refuse a 40-person account team. Led by [CA NAME] from [CITY] since [YEAR FOUNDED].</p>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">01 - STORY</span>
  <h2>A practice built on one idea: context compounds.</h2>
  <div class="timeline" data-animate="fade-in" style="margin-top:36px">
    <div class="tl-row"><div class="yr">[YEAR FOUNDED]</div><div><h3>The first mandate</h3><p>[CA NAME] left a Big-4 desk to file one company's first return - and stayed for the raise.</p></div></div>
    <div class="tl-row"><div class="yr">+2 yrs</div><div><h3>Lifecycle, not ledgers</h3><p>Incorporation, GST, and ESOP work collapsed into one retainer so founders stopped repeating themselves.</p></div></div>
    <div class="tl-row"><div class="yr">+4 yrs</div><div><h3>Capital work</h3><p>Valuation, diligence, and debt syndication joined the audit bench. Capital Deployed crossed the representative ₹500 Cr+ mark.</p></div></div>
    <div class="tl-row"><div class="yr">Today</div><div><h3>Day 0 through IPO</h3><p>120+ companies. One doctrine: the person who signs the Form 3CD should also understand the cap table.</p></div></div>
  </div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">02 - TEAM</span>
  <h2>Operators who happen to be CAs.</h2>
  <div class="team-grid" style="margin-top:28px" data-stagger>
    <article class="glass-card team-card"><div class="av" role="img" aria-label="Portrait of [CA NAME]"></div><h3>[CA NAME]</h3><p>FCA · CA Final AIR Top 10</p><span class="tag">Founder</span><p class="hover-extra">"If it cannot be explained on a whiteboard, it is not ready for the ROC."</p><a href="#" aria-label="LinkedIn"><i data-lucide="linkedin"></i></a></article>
    <article class="glass-card team-card"><div class="av"></div><h3>[CA NAME]</h3><p>ACA · Indirect tax</p><span class="tag">Partner, Tax</span><p class="hover-extra">"GST is a product system. Treat it like one."</p><a href="#" aria-label="LinkedIn"><i data-lucide="linkedin"></i></a></article>
    <article class="glass-card team-card"><div class="av"></div><h3>[CA NAME]</h3><p>CFA · Valuation</p><span class="tag">Capital markets</span><p class="hover-extra">"A model is a letter to a sceptical partner."</p><a href="#" aria-label="LinkedIn"><i data-lucide="linkedin"></i></a></article>
  </div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">03 - VALUES</span>
  <div class="values" data-stagger>
    <article class="glass-card pillar"><div class="icon-box"><i data-lucide="eye"></i></div><h3>Transparency First</h3><p>Fees, scope, and findings in writing. No surprise invoices after the hearing.</p></article>
    <article class="glass-card pillar"><div class="icon-box"><i data-lucide="message-square"></i></div><h3>Founders' Language</h3><p>Runway and dilution first. Section numbers only when they change a decision.</p></article>
    <article class="glass-card pillar"><div class="icon-box"><i data-lucide="target"></i></div><h3>Outcome-Driven</h3><p>A filing is a means. Clean diligence and lower leakages are the ends.</p></article>
    <article class="glass-card pillar"><div class="icon-box"><i data-lucide="hourglass"></i></div><h3>Long-Term Partnership</h3><p>We would rather keep a client through IPO than win a one-time 3CD.</p></article>
  </div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">04 - CREDENTIALS</span>
  <div class="cred-grid" style="position:relative">
    <span class="cred" style="color:var(--ink);border-color:var(--light-gray);background:#fff">ICAI Member · [ICAI REG]</span>
    <span class="cred" style="color:var(--ink);border-color:var(--light-gray);background:#fff">DPIIT / Startup India practitioner</span>
    <span class="cred" style="color:var(--ink);border-color:var(--light-gray);background:#fff">Big-4 alumni bench</span>
    <span class="cred" style="color:var(--ink);border-color:var(--light-gray);background:#fff">NBFC and bank-branch audit</span>
    <span class="cred" style="color:var(--ink);border-color:var(--light-gray);background:#fff">120+ clients retained</span>
    <span class="cred" style="color:var(--ink);border-color:var(--light-gray);background:#fff">[CITY] · PAN-India remote</span>
  </div>
</div></section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content -Path "$root\about.html" -Value $about -Encoding UTF8

# --- SERVICES HUB ---
$phases = @(
  @{ id="build"; n="01"; title="Build"; d="Legal identity, equity, and tax registration before the first invoice."; count="4" },
  @{ id="operate"; n="02"; title="Operate"; d="Books, people costs, and tax that keep the company honest every month."; count="7" },
  @{ id="govern"; n="03"; title="Govern"; d="Audit, ROC, forecasts, and certifications lenders and boards require."; count="13" },
  @{ id="scale"; n="04"; title="Scale"; d="Valuation, capital, ESOPs, and transactions that change the cap table."; count="9" },
  @{ id="exit"; n="05"; title="Exit"; d="Public-market hygiene from restructuring through post-listing IR."; count="4" }
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
  @{ slug="project-report"; phase="govern"; name="Project Report Preparation for Bank Loans"; icon="scroll"; blurb="CMA data, DSCR, and a narrative credit committees finish." },
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
  @{ slug="debt-syndication"; phase="scale"; name="Debt Syndication and Corporate Loan Structuring"; icon="landmark"; blurb="Bank, NBFC, and structured debt with covenant design." },
  @{ slug="pre-ipo"; phase="exit"; name="Pre-IPO Restructuring and Compliance"; icon="building"; blurb="Group cleanup, related parties, and restatements before the DRHP." },
  @{ slug="drhp"; phase="exit"; name="Draft Red Herring Prospectus (DRHP) Financial Drafting"; icon="file-stack"; blurb="MD and A-ready numbers and notes that survive SEBI comments." },
  @{ slug="ipo-pricing"; phase="exit"; name="IPO Pricing and Underwriting Coordination"; icon="badge-indian-rupee"; blurb="Bridge between the model, comps, and the book-building room." },
  @{ slug="post-ipo"; phase="exit"; name="Post-IPO Compliance and Investor Relations Support"; icon="megaphone"; blurb="Results calendar, IND AS packs, and IR that listed life requires." }
)

$cards = ""
foreach ($ph in $phases) {
  $list = $svc | Where-Object { $_.phase -eq $ph.id }
  $grid = ($list | ForEach-Object {
    "<a class='glass-card svc-card' href='services/$($_.slug).html'><div class='icon-box'><i data-lucide='$($_.icon)'></i></div><h3>$($_.name)</h3><p>$($_.blurb)</p><span class='arrow'>-></span></a>"
  }) -join "`n"
  $cards += @"
<section class="section" id="$($ph.id)">
  <div class="container">
    <span class="section-label">$($ph.n) - $($ph.title.ToUpper())</span>
    <h2>$($ph.title)</h2>
    <p style="max-width:560px;margin:8px 0 28px">$($ph.d)</p>
    <div class="svc-grid">$grid</div>
  </div>
</section>
<div class="container"><p class="phase-div">Transition · next phase</p></div>
"@
}

$nodes = ""
foreach ($ph in $phases) {
  $nodes += "<a class='life-node' href='#$($ph.id)'><span class='dot'></span><span>$($ph.title)</span><span style='color:var(--mid-gray);font-weight:500'>$($ph.count) services</span></a>"
  if ($ph.id -ne "exit") { $nodes += "<div class='life-line'></div>" }
}

$services = (Head 'Services - 37 mandates from incorporation to IPO | [FIRM NAME]' 'Explore Build, Operate, Govern, Scale, and Exit services from [FIRM NAME] in [CITY].' 'services.html' $false '') + (ChromeStart $false 'services' $false) + @"
<section class="page-hero"><div class="container">
  <span class="section-label">Services</span>
  <h1>One firm. Every chapter.</h1>
  <p>Five phases, thirty-seven services, one context window.</p>
  <div class="life-bar" style="margin-top:32px">$nodes</div>
</div></section>
$cards
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content "$root\services.html" $services -Encoding UTF8

# --- CONTACT ---
$contact = (Head 'Contact [FIRM NAME] - Book a consultation in [CITY]' 'Talk to a practising CA within 4 hours. Confidential consultation for founders and finance leaders.' 'contact.html' $false '') + (ChromeStart $false 'contact' $true) + @"
<section class="section"><div class="container contact-grid">
  <div>
    <h1>Let's talk about the next chapter.</h1>
    <p style="margin:12px 0 22px">A 30-minute diagnostic with [CA NAME] or a partner. No deck required.</p>
    <div class="contact-methods">
      <a class="glass-card" href="tel:[PHONE]"><i data-lucide="phone"></i><div><strong>Phone</strong><div>[PHONE]</div></div></a>
      <a class="glass-card" href="mailto:[EMAIL]"><i data-lucide="mail"></i><div><strong>Email</strong><div>[EMAIL]</div></div></a>
      <div class="glass-card"><i data-lucide="map-pin"></i><div><strong>Studio</strong><div>[CITY], India</div></div></div>
    </div>
    <ul class="trust-list">
      <li>✓ Response within 4 hours</li>
      <li>✓ 100% confidential</li>
      <li>✓ No obligation</li>
      <li>✓ Talk to a CA directly</li>
    </ul>
  </div>
  <div class="glass-card" style="padding:32px">
    <div class="steps"><span class="step-dot on">1</span><span class="step-line"></span><span class="step-dot">2</span></div>
    <form id="consult-form">
      <div id="step-1">
        <label class="field">Full Name <input name="name" required></label>
        <div class="row-2">
          <label class="field">Email <input type="email" name="email" required></label>
          <label class="field">Phone <input type="tel" name="phone" required></label>
        </div>
        <label class="field">Company Name <input name="company" required></label>
        <button class="btn btn-primary" type="button" id="to-step-2">Continue -></button>
      </div>
      <div id="step-2" class="hidden">
        <p style="font-weight:600;margin-bottom:8px">Company stage</p>
        <div class="pills">
          <label class="pill-opt"><input type="radio" name="stage" value="pre"> Pre-Incorporation</label>
          <label class="pill-opt"><input type="radio" name="stage" value="early"> Early Stage</label>
          <label class="pill-opt"><input type="radio" name="stage" value="growth"> Growth Stage</label>
          <label class="pill-opt"><input type="radio" name="stage" value="ent"> Enterprise</label>
        </div>
        <p style="font-weight:600;margin:16px 0 8px">Services of interest</p>
        <div class="pills">
          <label class="pill-opt"><input type="checkbox" name="svc" value="inc"> Incorporation</label>
          <label class="pill-opt"><input type="checkbox" name="svc" value="tax"> Tax Planning</label>
          <label class="pill-opt"><input type="checkbox" name="svc" value="audit"> Audit</label>
          <label class="pill-opt"><input type="checkbox" name="svc" value="fund"> Fundraising</label>
          <label class="pill-opt"><input type="checkbox" name="svc" value="ipo"> IPO</label>
          <label class="pill-opt"><input type="checkbox" name="svc" value="val"> Valuation</label>
          <label class="pill-opt"><input type="checkbox" name="svc" value="comp"> Compliance</label>
          <label class="pill-opt"><input type="checkbox" name="svc" value="model"> Financial Modeling</label>
        </div>
        <label class="field" style="margin-top:14px">Message (optional) <textarea name="msg" rows="4"></textarea></label>
        <button class="btn btn-ghost" type="button" id="to-step-1">← Back</button>
        <button class="btn btn-primary" type="submit">Book Consultation</button>
      </div>
      <div id="form-success" class="hidden" style="text-align:center;padding:24px 0">
        <svg class="success-check" viewBox="0 0 72 72" aria-hidden="true"><circle cx="36" cy="36" r="34"/><path d="M20 37 l12 12 22-24"/></svg>
        <h2>We'll be in touch within 4 hours.</h2>
        <p><a class="btn btn-ghost" href="insights.html">Meanwhile, read the insights -></a></p>
      </div>
    </form>
  </div>
</div></section>
"@ + (ChromeEnd $false)
Set-Content "$root\contact.html" $contact -Encoding UTF8

# --- TOOLS ---
$tools = (Head 'Free founder tools - tax, vesting, compliance, valuation | [FIRM NAME]' 'Interactive estimators for Indian founders: tax savings, ESOP vesting, compliance checklists, and valuation ranges.' 'tools.html' $false '') + (ChromeStart $false 'tools' $false) + @"
<section class="page-hero"><div class="container"><span class="section-label">Tools</span><h1>Instruments, not widgets.</h1><p>Live calculators. Email us for the full working papers.</p></div></section>
<section class="section" style="padding-top:0"><div class="container tools-stack">
  <article class="glass-card tool-card">
    <h2>Tax Savings Estimator</h2>
    <p>Indicative annual savings from entity choice and planning. Not advice.</p>
    <label class="field">Annual revenue <span id="tax-rev-live"></span><input class="range" id="tax-rev" type="range" min="1000000" max="10000000000" value="50000000"></label>
    <label class="field">Current tax paid (₹)<input id="tax-paid" type="number" value="0"></label>
    <div class="pills">
      <label class="pill-opt"><input type="radio" name="entity" value="pvt" checked> Pvt Ltd</label>
      <label class="pill-opt"><input type="radio" name="entity" value="llp"> LLP</label>
      <label class="pill-opt"><input type="radio" name="entity" value="prop"> Proprietorship</label>
    </div>
    <div class="glass-card" style="padding:20px;margin-top:16px">
      <div class="metrics3"><div><div class="n" id="tax-save">₹0</div><div class="l">Estimated annual tax savings</div></div><div><div class="n" id="tax-pot">●</div><div class="l">Optimization potential</div></div></div>
    </div>
    <form id="tax-report" class="row-2" style="margin-top:12px"><input type="email" required placeholder="Email for full report"><button class="btn btn-primary" type="submit">Get Full Report</button></form>
  </article>
  <article class="glass-card tool-card">
    <h2>Equity Vesting Calculator</h2>
    <p>Cliff then linear vest of a pool across co-founders.</p>
    <div class="row-2">
      <label class="field">Pool %<input id="vest-pool" type="number" value="20"></label>
      <label class="field">Cliff (months)<input id="vest-cliff" type="number" value="12"></label>
      <label class="field">Total vest (months)<input id="vest-total" type="number" value="48"></label>
      <label class="field">Co-founders<input id="vest-n" type="number" value="2"></label>
    </div>
    <svg id="vest-svg" viewBox="0 0 300 100" width="100%" height="120"></svg>
    <div style="max-height:240px;overflow:auto"><table class="vest-table"><thead><tr><th>Month</th><th>Pool vested</th><th>Per founder</th></tr></thead><tbody id="vest-body"></tbody></table></div>
  </article>
  <article class="glass-card tool-card checklist-app">
    <h2>Compliance Checklist</h2>
    <div class="row-2">
      <label class="field">Company type
        <select id="comp-type"><option value="pvt">Pvt Ltd</option><option value="llp">LLP</option><option value="opc">OPC</option><option value="startup">Startup</option></select>
      </label>
      <label class="field">Stage
        <select id="comp-stage"><option value="new">Newly Incorporated</option><option value="mid">1-3 Years</option><option value="late">3+ Years</option></select>
      </label>
    </div>
    <div id="comp-list"></div>
    <button class="btn btn-secondary" type="button" id="comp-pdf" data-gate="print">Download PDF</button>
  </article>
  <article class="glass-card tool-card">
    <h2>Business Valuation Estimator</h2>
    <div class="row-2">
      <label class="field">Annual revenue (₹)<input id="val-rev" type="number" value="80000000"></label>
      <label class="field">EBITDA (₹)<input id="val-ebitda" type="number" value="12000000"></label>
      <label class="field">Sector
        <select id="val-sector"><option value="saas">SaaS</option><option value="fintech">Fintech</option><option value="consumer">Consumer</option><option value="manufacturing">Manufacturing</option><option value="health">Health</option><option value="logistics">Logistics</option><option value="edtech">Edtech</option><option value="other">Other</option></select>
      </label>
      <label class="field">Stage
        <select id="val-stage"><option value="pre">Pre-revenue</option><option value="early">Early</option><option value="growth" selected>Growth</option><option value="ent">Enterprise</option></select>
      </label>
      <label class="field">3-year revenue CAGR %<input id="val-cagr" type="number" value="35"></label>
    </div>
    <div class="glass-card" style="padding:20px;margin-top:16px">
      <div class="n" id="val-range"> -</div><p>DCF-based range (indicative)</p>
      <div class="metrics3"><div><div class="n" id="val-rm"> -</div><div class="l">Revenue multiple</div></div><div><div class="n" id="val-em"> -</div><div class="l">EBITDA multiple</div></div><div><div class="n" id="val-conf"> -</div><div class="l">Confidence</div></div></div>
      <p class="micro">Disclaimer: educational estimate only. Not a 56(2)(viib), FEMA, or fairness opinion.</p>
    </div>
  </article>
</div></section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content "$root\tools.html" $tools -Encoding UTF8

# --- 404 ---
$nf = (Head 'Page not found | [FIRM NAME]' 'The page you requested is not on [FIRM NAME].' '404.html' $false '') + (ChromeStart $false '' $false) + @"
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
  @{ slug="series-a-saas-raise"; title="A SaaS round that closed without a cleanup sprint"; tags="startups fundraising"; m1="₹XX Cr"; l1="Raised"; m2="21"; l2="Days in diligence"; m3="0"; l3="Unexplained reconciling items" },
  @{ slug="gst-optimization-sme"; title="GST leakage found in a mid-market manufacturer"; tags="smes tax"; m1="₹X.X Cr"; l1="Annual leakage stopped"; m2="14"; l2="Months of returns restated"; m3="100%"; l3="E-way bill match" },
  @{ slug="ipo-readiness-nbfc"; title="Pre-IPO restatements a merchant banker did not send back"; tags="enterprise ipo"; m1="3"; l1="Years restated"; m2="12"; l2="Related-party maps"; m3="SEBI"; l3="Comment cycles: 2" },
  @{ slug="esop-structuring-startup"; title="An ESOP employees could explain without a lawyer"; tags="startups"; m1="12%"; l1="Pool"; m2="4"; l2="Year vest"; m3="1"; l3="Board sitting" },
  @{ slug="tax-planning-enterprise"; title="Group tax cadence for a multi-entity operator"; tags="enterprise tax"; m1="₹XX Cr"; l1="Cash tax timed"; m2="6"; l2="Entities"; m3="0"; l3="Missed advance tax" },
  @{ slug="due-diligence-acquisition"; title="Buy-side QoE that repriced the deal"; tags="enterprise fundraising"; m1="11%"; l1="Price adjustment"; m2="9"; l2="Weeks"; m3="1"; l3="SPA schedule" }
)

$caseCards = ($casesMeta | ForEach-Object {
@"
<article class="glass-card case-card tiltable" data-filter-item data-tags="$($_.tags)" data-animate="fade-up">
  <div class="av" style="width:48px;height:48px;border-radius:12px;background:linear-gradient(135deg,var(--accent),var(--blue))"></div>
  <div class="pills" style="margin:10px 0">$(($_.tags -split ' ' | ForEach-Object { "<span class='cat'>$_</span>" }) -join '')</div>
  <h3>$($_.title)</h3>
  <div class="metrics3"><div><div class='n'>$($_.m1)</div><div class='l'>$($_.l1)</div></div><div><div class='n'>$($_.m2)</div><div class='l'>$($_.l2)</div></div><div><div class='n'>$($_.m3)</div><div class='l'>$($_.l3)</div></div></div>
  <a class="btn btn-ghost" href="case-studies/$($_.slug).html">Read case study -></a>
</article>
"@
}) -join "`n"

$cases = (Head 'Case studies - outcomes for founders and enterprises | [FIRM NAME]' 'Selected work: fundraising, GST, IPO readiness, ESOPs, tax, and diligence.' 'case-studies.html' $false '') + (ChromeStart $false 'cases' $false) + @"
<section class="page-hero"><div class="container">
  <h1>Decisions we sat in the room for.</h1>
  <p>Representative outcomes. Names are placeholders until clients approve disclosure.</p>
  <div class="filters">
    <button class="filter active" data-filter="all" type="button">All</button>
    <button class="filter" data-filter="startups" type="button">Startups</button>
    <button class="filter" data-filter="smes" type="button">SMEs</button>
    <button class="filter" data-filter="enterprise" type="button">Enterprise</button>
    <button class="filter" data-filter="fundraising" type="button">Fundraising</button>
    <button class="filter" data-filter="ipo" type="button">IPO</button>
    <button class="filter" data-filter="tax" type="button">Tax Optimization</button>
  </div>
  <div class="case-grid">$caseCards</div>
</div></section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content "$root\case-studies.html" $cases -Encoding UTF8

New-Item -ItemType Directory -Force -Path "$root\case-studies","$root\insights","$root\services" | Out-Null

foreach ($c in $casesMeta) {
  $html = (Head "$($c.title) | [FIRM NAME]" "Case study: $($c.title). Representative metrics only." "case-studies/$($c.slug).html" $true '') + (ChromeStart $true "cases" $false) + @"
<section class="page-hero"><div class="container">
  <p class="breadcrumb"><a href="../index.html">Home</a> › <a href="../case-studies.html">Case studies</a> › $($c.title)</p>
  <h1>$($c.title)</h1>
  <p>Client: [CLIENT NAME] at [COMPANY]. Challenge: the books, tax, or capital process were not ready for the decision the board had already made.</p>
  <div class="kpis-row">
    <div class="glass-card"><strong>$($c.m1)</strong>$($c.l1)</div>
    <div class="glass-card"><strong>$($c.m2)</strong>$($c.l2)</div>
    <div class="glass-card"><strong>$($c.m3)</strong>$($c.l3)</div>
  </div>
</div></section>
<section class="section"><div class="container two-col">
  <div>
    <h2>What was broken</h2>
    <p>The operating team was shipping. The financial stack was still a collection of filings. Diligence, a lender, or a listing calendar made that visible.</p>
    <h2>What we did</h2>
    <p>[FIRM NAME] rebuilt the narrative from source documents: ledgers, GST, ROC, and the cap table. We wrote the working papers [CLIENT NAME] could defend in a partner meeting.</p>
    <blockquote class="pull">"They did not decorate the numbers. They made the numbers survivable." - [CLIENT NAME], [COMPANY]</blockquote>
    <p>Services used:</p>
    <p><span class="cat">Advisory</span> <span class="cat">[FIRM NAME] lifecycle</span></p>
  </div>
  <aside class="glass-card" style="padding:24px">
    <h3>Key facts</h3>
    <p>Sector: [COMPANY]<br>Stage: as tagged<br>Lead: [CA NAME]<br>City: [CITY]</p>
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
  @{ slug="esop-for-indian-startups"; cat="Equity"; title="How Indian founders should think about ESOPs before Series A"; excerpt="Pool size, vesting, and 56(2)(viib) - without the folklore."; mins="8" },
  @{ slug="gst-mistakes-founders-make"; cat="Tax"; title="Seven GST mistakes that show up in diligence"; excerpt="The issues buyers price in - and how to close them this quarter."; mins="7" },
  @{ slug="unit-economics-before-raise"; cat="Capital"; title="Unit economics before the raise, not after the model"; excerpt="What investors actually underwrite when they say path to profit."; mins="9" },
  @{ slug="pre-ipo-checklist"; cat="IPO"; title="A pre-IPO checklist that is not a 400-row tracker"; excerpt="Structure, related parties, restatements, and the calendar that matters."; mins="10" },
  @{ slug="transfer-pricing-smes"; cat="Tax"; title="Transfer pricing is not only for conglomerates"; excerpt="When a second entity and a shared founder salary become a TP file."; mins="6" },
  @{ slug="founders-agreement-essentials"; cat="Build"; title="Founders' agreements that survive the first fight"; excerpt="Vesting, IP, and deadlock before anyone is angry."; mins="8" }
)

$artCards = ($arts | ForEach-Object {
@"
<article class="glass-card article-card" data-filter-item data-tags="$($_.cat.ToLower())" data-animate="fade-up">
  <span class="cat">$($_.cat)</span>
  <h3>$($_.title)</h3>
  <p>$($_.excerpt)</p>
  <div class="av" style="height:120px;border-radius:12px;width:100%;background:var(--off-white)" role="img" aria-label="Article thumbnail placeholder"></div>
  <footer><span>[CA NAME] · $($_.mins) min</span><a href="insights/$($_.slug).html">Read -></a></footer>
</article>
"@
}) -join "`n"

$insights = (Head 'Insights - operator notes from [FIRM NAME]' 'Essays on ESOPs, GST, unit economics, IPO readiness, and founder agreements.' 'insights.html' $false '') + (ChromeStart $false 'insights' $false) + @"
<section class="page-hero"><div class="container">
  <h1>Notes for people who sign both the term sheet and the 3CD.</h1>
  <div class="filters">
    <button class="filter active" data-filter="all" type="button">All</button>
    <button class="filter" data-filter="equity" type="button">Equity</button>
    <button class="filter" data-filter="tax" type="button">Tax</button>
    <button class="filter" data-filter="capital" type="button">Capital</button>
    <button class="filter" data-filter="ipo" type="button">IPO</button>
    <button class="filter" data-filter="build" type="button">Build</button>
  </div>
  <div class="article-grid">$artCards</div>
</div></section>
$(Cta $false)
"@ + (ChromeEnd $false)
Set-Content "$root\insights.html" $insights -Encoding UTF8

foreach ($a in $arts) {
  $html = (Head "$($a.title) | [FIRM NAME]" $a.excerpt "insights/$($a.slug).html" $true '') + (ChromeStart $true "insights" $false) + @"
<div class="read-progress"></div>
<article class="article-body">
  <p class="breadcrumb"><a href="../index.html">Home</a> › <a href="../insights.html">Insights</a> › $($a.cat)</p>
  <span class="cat">$($a.cat)</span>
  <h1>$($a.title)</h1>
  <p style="color:var(--mid-gray)">[CA NAME] · $($a.mins) minute read · [CITY]</p>
  <p>$($a.excerpt) This piece is written for operators at [COMPANY]-stage businesses who need a decision, not a textbook. [FIRM NAME] sees the same patterns across 120+ mandates.</p>
  <p>Start with the economic fact, then find the section. If a structure cannot be drawn on a whiteboard in [CITY] over one coffee, it will not survive diligence.</p>
  <blockquote class="pull">The filing is a lagging indicator. The decision is the product.</blockquote>
  <p>We recommend a working session with [CA NAME] before you freeze numbers in a deck. The consultation is thirty minutes. The cost of reversing a pool, a GST position, or a related-party map is a year.</p>
  <p>Related reading sits at the end of this column. Subscribe if you want the next note before it is public.</p>
  <div class="glass-card" style="padding:24px;margin-top:32px">
    <h3>Newsletter</h3>
    <form class="news"><input type="email" required placeholder="Work email"><button class="btn btn-primary" type="submit">Subscribe</button></form>
  </div>
  <p style="margin-top:24px"><a href="../insights.html">More insights -></a></p>
</article>
$(Cta $true)
"@ + (ChromeEnd $true)
  Set-Content "$root\insights\$($a.slug).html" $html -Encoding UTF8
}

# --- SERVICE PAGES ---
$phaseName = @{ build="Build"; operate="Operate"; govern="Govern"; scale="Scale"; exit="Exit" }
for ($i=0; $i -lt $svc.Count; $i++) {
  $s = $svc[$i]
  $rel = @()
  foreach ($j in @(-1,1,2)) {
    $k = $i + $j
    if ($k -ge 0 -and $k -lt $svc.Count -and $k -ne $i) { $rel += $svc[$k] }
  }
  $rel = $rel | Select-Object -First 3
  $relHtml = ($rel | ForEach-Object { "<a class='glass-card svc-card' href='$($_.slug).html'><h3>$($_.name)</h3><p>$($_.blurb)</p><span class='arrow'>-></span></a>" }) -join ""
  $html = (Head "$($s.name) | [FIRM NAME]" "$($s.blurb) Advisory from [FIRM NAME] in [CITY]." "services/$($s.slug).html" $true '') + (ChromeStart $true "services" $false) + @"
<section class="page-hero"><div class="container">
  <p class="breadcrumb"><a href="../index.html">Home</a> › <a href="../services.html">Services</a> › <a href="../services.html#$($s.phase)">$($phaseName[$s.phase])</a> › $($s.name)</p>
  <h1>$($s.name)</h1>
  <p>$($s.blurb)</p>
  <div class="hero-ctas"><a class="btn btn-primary" href="../contact.html">Get Started</a><a class="btn btn-secondary" href="#" data-gate="checklist">Download Checklist</a></div>
  <div class="kpis-row">
    <div class="glass-card"><strong>7-21 days</strong> typical turnaround</div>
    <div class="glass-card"><strong>99%</strong> on-time compliance</div>
    <div class="glass-card"><strong>Founder-ready</strong> working papers</div>
  </div>
</div></section>
<section class="section"><div class="container two-col">
  <div>
    <span class="section-label">What it is</span>
    <h2>Plain language, then the law.</h2>
    <p>$($s.name) is the work that sits between a board decision and a government portal. [FIRM NAME] runs it so [CA NAME] can still explain it on a call without a glossary.</p>
    <p>We start from how your company actually operates - customers, payroll, cap table, and cash - then map filings, opinions, or models onto that reality. Jargon is translated the first time it appears.</p>
    <p>The output is not a PDF dump. It is a file a future investor, banker, or AO can reopen without you in the room.</p>
  </div>
  <div class="glass-card" style="padding:40px;display:grid;place-items:center;min-height:240px"><i data-lucide="$($s.icon)" style="width:64px;height:64px;color:var(--accent)"></i></div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">Why it matters</span>
  <div class="pillars">
    <article class="glass-card pillar"><div class="icon-box"><i data-lucide="clock"></i></div><h3>Time</h3><p>Portals and counterparties wait for complete files. Incomplete work compounds interest, compounding fees, and lost rounds.</p></article>
    <article class="glass-card pillar featured"><div class="icon-box"><i data-lucide="shield"></i></div><h3>Diligence</h3><p>Buyers and funds price mess. Clean $($s.name.ToLower()) is cheaper than a price chip later.</p></article>
    <article class="glass-card pillar"><div class="icon-box"><i data-lucide="sparkles"></i></div><h3>Decisions</h3><p>Founders should choose structure and timing with numbers, not folklore from a WhatsApp group.</p></article>
  </div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">Our process</span>
  <div class="process">
    <div class="step"><div class="num">1</div><div><h3>Discovery</h3><p>Stage, entities, and the decision you are actually trying to make.</p></div></div>
    <div class="step"><div class="num">2</div><div><h3>Evidence</h3><p>Ledgers, contracts, prior filings, and the cap table - as they are, not as the deck claims.</p></div></div>
    <div class="step"><div class="num">3</div><div><h3>Design</h3><p>The position, model, or filing pack, written so a non-CA director can follow it.</p></div></div>
    <div class="step"><div class="num">4</div><div><h3>Execute</h3><p>Portal, opinion, or data room. We stay on the thread until the acknowledgement lands.</p></div></div>
    <div class="step"><div class="num">5</div><div><h3>Handover</h3><p>Working papers, calendar, and the next lifecycle trigger.</p></div></div>
  </div>
</div></section>
<section class="section"><div class="container">
  <span class="section-label">Who needs this</span>
  <div class="who-grid">
    <article class="glass-card pillar"><h3>Startup</h3><p>Revenue: pre-revenue to ₹25 Cr. This is for you if you are still explaining the company to a new advisor every quarter.</p><ul><li>• First-time filings</li><li>• Upcoming seed/Series A</li></ul></article>
    <article class="glass-card pillar featured"><h3>SME</h3><p>Revenue: ₹25-250 Cr. This is for you if lenders, GST, or promoters are pulling the numbers in different directions.</p><ul><li>• Working capital</li><li>• Group entities</li></ul></article>
    <article class="glass-card pillar"><h3>Enterprise</h3><p>Revenue: ₹250 Cr+. This is for you if IPO, PE, or a carve-out made "good enough" compliance expensive.</p><ul><li>• Restatements</li><li>• Controls</li></ul></article>
  </div>
</div></section>
<section class="section"><div class="container">
  <div class="glass-card deliverables">
    <h2>Deliverables</h2>
    <ul class="check-grid">
      <li><i data-lucide="check"></i> Scoped workplan</li>
      <li><i data-lucide="check"></i> Working papers</li>
      <li><i data-lucide="check"></i> Portal / opinion pack</li>
      <li><i data-lucide="check"></i> Founder briefing note</li>
      <li><i data-lucide="check"></i> Calendar of next due dates</li>
      <li><i data-lucide="check"></i> Data-room folder structure</li>
    </ul>
  </div>
</div></section>
<section class="section"><div class="container" style="max-width:800px">
  <span class="section-label">FAQ</span>
  <div class="faq-item"><button type="button">How long does $($s.name) take? <span class="plus">+</span></button><div class="ans">Most mandates close in 7-21 days once evidence is complete. IPO and diligence tracks run to a transaction calendar.</div></div>
  <div class="faq-item"><button type="button">Do you work remotely outside [CITY]? <span class="plus">+</span></button><div class="ans">Yes. Portals are national. On-site stock or branch work is scheduled explicitly.</div></div>
  <div class="faq-item"><button type="button">Who signs? <span class="plus">+</span></button><div class="ans">[CA NAME] or a named partner. You will not meet a new associate every filing.</div></div>
  <div class="faq-item"><button type="button">How are fees structured? <span class="plus">+</span></button><div class="ans">Fixed for defined filings; retainers for lifecycle. Quotes in writing before work starts.</div></div>
  <div class="faq-item"><button type="button">Is this a substitute for legal counsel? <span class="plus">+</span></button><div class="ans">No. We coordinate with your counsel. We do not practise law.</div></div>
  <div class="faq-item"><button type="button">Can you start mid-year? <span class="plus">+</span></button><div class="ans">Yes. We reconstruct the year to date before we file forward.</div></div>
</div></section>
<section class="section"><div class="container">
  <h2>Related services</h2>
  <div class="svc-grid" style="margin-top:18px">$relHtml</div>
</div></section>
$(Cta $true)
"@ + (ChromeEnd $true)
  Set-Content "$root\services\$($s.slug).html" $html -Encoding UTF8
}

# --- SITEMAP ---
$links = @("index.html|Home","about.html|About","services.html|Services hub","contact.html|Contact","case-studies.html|Case studies","insights.html|Insights","tools.html|Free tools","404.html|Not found")
$links += $svc | ForEach-Object { "services/$($_.slug).html|$($_.name)" }
$links += $casesMeta | ForEach-Object { "case-studies/$($_.slug).html|$($_.title)" }
$links += $arts | ForEach-Object { "insights/$($_.slug).html|$($_.title)" }
$list = ($links | ForEach-Object { $p,$n = $_.Split('|'); "<li><a href='$p'>$n</a> - $n at [FIRM NAME].</li>" }) -join "`n"
$sm = (Head 'Sitemap | [FIRM NAME]' 'All public pages for [FIRM NAME], including 37 service mandates.' 'sitemap.html' $false '') + (ChromeStart $false '' $false) + @"
<section class="section"><div class="container sitemap">
  <h1>Sitemap</h1>
  <p>Every public URL on this site.</p>
  <ul>$list</ul>
</div></section>
"@ + (ChromeEnd $false)
Set-Content "$root\sitemap.html" $sm -Encoding UTF8

Write-Host "All pages written"

