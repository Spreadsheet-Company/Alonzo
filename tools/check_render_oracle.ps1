<#
check_render_oracle.ps1 - the viewport draws every cell where the record puts
it: the page's render oracle, run under a headless browser at two pixel
ratios, every case OK and its counts at their floors.

WHY: KERNEL.5's deterministic oracle, the half CI gates (docs/REARVIEW.md, the
scoping's decision 4). The built page, web/index.html, carries the viewport
and nine records the door printed; opened with ?oracle=1 it loads each
record into the viewport at a fixed size, draws, and holds the viewport's own
draw list - every text, fill, gridline, header, selection and mark with its
device-pixel position - equal to an expectation the page computes from the
record and the rules alone, both ways: every cell drawn once where the record
puts it with its text and its fill, nothing drawn that the record does not
hold, every coordinate on a device pixel (a line at a half), and a pixel
probe through getImageData for a fill, a plain cell and a gridline. It prints
one line a case into <pre id="oracle"> and a last line, 'oracle ok cases=N'.
This check runs the page under a headless Chromium twice, at a device scale
factor of 1 and of 1.5 (the owner's screen), reads that element off the
dump, and holds every case to OK and its asserted counts to the floors
below, so that a renderer that drifts, or a page whose oracle stops
asserting, fails on every push.

THE BROWSER: -Browser, else $env:ALONZO_BROWSER, else Google Chrome,
Microsoft Edge or Chromium at their known paths on Windows and by name on the
PATH elsewhere (the GitHub runner images carry Chrome and Edge on both). The
flags are the KERNEL.3 recipe's, proven on the day on Chrome and Edge:
--headless=new --disable-gpu --run-all-compositor-stages-before-draw
--disable-frame-rate-limit --disable-gpu-vsync --virtual-time-budget
--force-device-scale-factor --dump-dom, a scratch user data dir, and on
Linux --no-sandbox and --disable-dev-shm-usage. The browser is launched
through Start-Process with its output redirected to a file: launched from a
shell pipe, Edge's launcher detaches and the dump is empty. SKIPPED with exit
0 without a built page or without a browser, as the import check skips
without an artifact: CI builds the page before the runner and has the
browser, so that is where this bites.

-Control builds four mutant pages from mutated sources through
tools/build_web.ps1 and runs each: a viewport whose text padding is 5 and not
4, which the oracle must fail naming cells at the wrong position, the page's
header proving the mutant applied by printing pad=5; a viewport that drops
the last visible column's texts, which the oracle must fail as cells not
drawn; a template whose oracle element is cut, which this check must fail
for want of the block; and (ENGINE.14) a viewport that draws a number too
wide for its column cut again, its leading digits lost, which sparse_hashes
must fail at a three-digit number; (ENGINE.26) a viewport whose widths
are one map for every sheet again, keyed by a column's letters alone, which
sheets_other must fail by name, the Output keeping the Frazaro sheet's B;
and (ENGINE.28) a viewport that passes over a format row's groups, which
appearance must fail at A1 drawn in the default font, and one whose look
replaces the cell's own format whole, which appearance must fail at C1,
centered by its own format under its look, and against its drawn twin.
Seven mutants; the real page must pass first. Since ENGINE.28's second slice
twelve, the appearance case failing each of five more by name: a shared edge
drawn twice, its loser's op beside its winner's; the fills laid as they were,
not over their gridlines; an edge stroked rather than filled, its pixels
blended; a pattern phased on the edge's start and not on the sheet's; and an
edge cut at its corners, the reach of the lines across it there lost.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network;
exit 0 clean, exit 1 with every problem named. A page's dump is read
whole and the one element judged; a headless run's clock is virtual, so
nothing here is a timing.

Usage:  powershell -File tools\check_render_oracle.ps1
        powershell -File tools\check_render_oracle.ps1 -Browser "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        powershell -File tools\check_render_oracle.ps1 -Page C:\somewhere\index.html
        powershell -File tools\check_render_oracle.ps1 -Control
#>
param(
    [string]$Page = '',
    [string]$Browser = '',
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if ($Page -eq '') { $Page = Join-Path $repoRoot 'web/index.html' }
elseif (-not [System.IO.Path]::IsPathRooted($Page)) { $Page = Join-Path $repoRoot $Page }
# Not $IsWindows: that name is a read-only automatic variable under PowerShell 7, and the crate job runs this under pwsh.
$onWindows = ($env:OS -eq 'Windows_NT')

# --- the floors: the cells each case asserts, never lowered; the scales the oracle runs at ---
# 2026-10-08, KERNEL.5: twelve cases, the six goldens at 1100 by 400 CSS px
# (every cell of each in view), the 10,000-line record at the normal window
# (40 rows by 15 columns: 39 rows draw under the tab strip) at the top, the
# middle and the end, with two rows and one column frozen, and with a column
# resized; the first golden again with a selection and a mark. Texts counts
# the cell texts asserted, wrapped the wrapped cells, fills the declared
# fills, lines the gridlines, headers the row and column headers, probes the
# pixels read back. A floor is a lower bound: the tab strip's height varies
# by a pixel between platforms, and so may the rows in view.
# 2026-10-14, ENGINE.14: thirteen cases, the twelve's counts unchanged, and
# every line counts its #s: sparse_hashes, the sparse record with column A
# narrowed to 26 CSS px and scrolled to row 89, its six two-digit numbers
# fitting and its fourteen three-digit ones drawn as #s, at both ratios under
# headless Chrome 155 on Windows (39 texts); the floor holds a row's margin,
# and a wider font on another platform draws more #s, never fewer.
# 2026-10-19, ENGINE.26: fifteen cases, the thirteen's counts unchanged, and
# two of the fixture program's sheets apart: sheets_other, the Output drawn
# after the Frazaro sheet's B was set to 300 px, at its own default B; and
# sheets_back, the Output's B set to 26 px, the Frazaro sheet's and the data
# sheet's B set to 300 and 90, and the Output shown again at its own 26. Each
# draws fixture_output's 7 texts, with 35 and 36 lines and headers at both
# ratios under headless Chrome 155 on Windows, held at fixture_output's floors.
# 2026-10-24, ENGINE.28: seventeen cases, every line counting its fonts, the texts asserted in a font or color other
# than the default or a wrapped block placed by a said vertical alignment, and its twin, 2 where the record with its
# looks drew op for op and pixel for pixel as its drawn twin: appearance, the painter's fixture (vla-lang 0.11.0's
# testdata/appearance/, Frazaro's KERNEL.50), the look's rule over cells with groups of their own, 19 texts and 7
# wrapped, 12 of them dressed by a format, 2 fills (the look of 1 taking B1's own fill away with its none), no
# gridline, held to the oracle's own rule and to the twin; and appearance_drawn, the twin itself, each cell's style
# the format the language gives it. The fifteen earlier cases keep their counts, their fonts and twin at 0.
$scales = @('1', '1.5')
$floors = @(
    @{ Case = 'fixture_frazaro';          Texts = 18; Fills = 34; Lines = 0;   Headers = 20; Selection = 1; Marks = 0; Probes = 3; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'fixture_output';           Texts = 7;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'fixture_output_b2_c3';     Texts = 4;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'fixture_data';             Texts = 1;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'into_output';              Texts = 2;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'into_checks';              Texts = 1;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sparse_top';               Texts = 38; Fills = 0;  Lines = 50;  Headers = 50; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sparse_middle';            Texts = 38; Fills = 0;  Lines = 50;  Headers = 50; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sparse_end';               Texts = 38; Fills = 0;  Lines = 50;  Headers = 50; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sparse_frozen';            Texts = 38; Fills = 0;  Lines = 100; Headers = 50; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sparse_resized';           Texts = 38; Fills = 0;  Lines = 48;  Headers = 48; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'fixture_frazaro_selected'; Texts = 18; Fills = 34; Lines = 0;   Headers = 20; Selection = 1; Marks = 1; Probes = 3; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sparse_hashes';            Texts = 38; Fills = 0;  Lines = 50;  Headers = 50; Selection = 1; Marks = 0; Probes = 2; Hashes = 13; Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sheets_other';             Texts = 7;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'sheets_back';              Texts = 7;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2; Hashes = 0;  Fonts = 0; Twin = 0; Edges = 0 },
    @{ Case = 'appearance';               Texts = 26; Fills = 2;  Lines = 0;   Headers = 33; Selection = 1; Marks = 0; Probes = 80; Hashes = 0;  Fonts = 12; Twin = 2; Edges = 57 },
    @{ Case = 'appearance_drawn';         Texts = 26; Fills = 2;  Lines = 0;   Headers = 33; Selection = 1; Marks = 0; Probes = 80; Hashes = 0;  Fonts = 12; Twin = 0; Edges = 57 }
)
$expectedCases = 17

# The browser: named, from the environment, or found.
function Find-Browser([string]$named) {
    if ($named -ne '') { if (Test-Path -LiteralPath $named) { return $named }; return '' }
    if ($env:ALONZO_BROWSER) { if (Test-Path -LiteralPath $env:ALONZO_BROWSER) { return $env:ALONZO_BROWSER }; return '' }
    if ($onWindows) {
        $candidates = @(
            (Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'),
            (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'),
            (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
            (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe'),
            (Join-Path $env:ProgramFiles 'Chromium\Application\chrome.exe')
        )
        foreach ($c in $candidates) { if ($c -and (Test-Path -LiteralPath $c)) { return $c } }
        return ''
    }
    foreach ($name in @('google-chrome', 'google-chrome-stable', 'chromium-browser', 'chromium', 'microsoft-edge', 'microsoft-edge-stable')) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    return ''
}
# The page as a file: URL, with the oracle's mode.
function Get-PageUrl([string]$path) {
    $full = [System.IO.Path]::GetFullPath($path)
    $slashed = $full -replace '\\', '/'
    if ($slashed.StartsWith('/')) { return 'file://' + $slashed + '?oracle=1' }
    return 'file:///' + $slashed + '?oracle=1'
}
# One headless run: the oracle element's text, or '' with the reason.
function Invoke-Oracle([string]$browser, [string]$page, [string]$scale) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_oracle_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $dump = Join-Path $tmp 'dump.html'
        $err = Join-Path $tmp 'err.txt'
        $userData = Join-Path $tmp 'profile'
        $argList = @('--headless=new', '--disable-gpu', '--run-all-compositor-stages-before-draw', '--disable-frame-rate-limit', '--disable-gpu-vsync',
                     '--virtual-time-budget=20000', ('--force-device-scale-factor=' + $scale), '--window-size=1600,1200', '--no-first-run', '--no-default-browser-check',
                     ('--user-data-dir="' + $userData + '"'))
        if (-not $onWindows) { $argList += @('--no-sandbox', '--disable-dev-shm-usage') }
        $argList += @('--dump-dom', ('"' + (Get-PageUrl $page) + '"'))
        # -Wait waits for the browser and its descendants, which hold the dump open after the first process exits;
        # a browser that never exits is held in check by its virtual-time budget, after which it dumps and quits.
        # -NoNewWindow is Windows' own; elsewhere there is never a new window.
        $start = @{ FilePath = $browser; ArgumentList = $argList; RedirectStandardOutput = $dump; RedirectStandardError = $err; Wait = $true }
        if ($onWindows) { $start['NoNewWindow'] = $true }
        Start-Process @start
        if (-not (Test-Path -LiteralPath $dump)) { return @{ Text = ''; Reason = 'the browser wrote no dump' } }
        $html = [System.IO.File]::ReadAllText($dump)
        $m = [regex]::Match($html, '(?s)<pre id="oracle"[^>]*>(.*?)</pre>')
        if (-not $m.Success) { return @{ Text = ''; Reason = ("no oracle block in the dump ({0:N0} characters)" -f $html.Length) } }
        $text = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value).Trim()
        if ($text -eq '') { return @{ Text = ''; Reason = 'the oracle block is empty' } }
        return @{ Text = $text; Reason = '' }
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}
# The judgment of one run's text at one scale: problems, and the case lines.
function Test-Oracle([string]$text, [string]$scale) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = @($text -split "`n" | ForEach-Object { $_.TrimEnd("`r") })
    $header = $lines[0]
    if ($header -notlike 'oracle: viewport *') { $problems.Add("the first line is not the oracle's header: $header") }
    $dm = [regex]::Match($header, 'dpr=([0-9.]+)')
    if (-not $dm.Success -or $dm.Groups[1].Value -ne $scale) { $problems.Add("the page saw a ratio of '$($dm.Groups[1].Value)', the run asked for $scale") }
    $cases = @{}
    $caseLines = New-Object System.Collections.Generic.List[string]
    foreach ($l in $lines) {
        $m = [regex]::Match($l, '^case (\S+) \[[^\]]*\]: texts (\d+), wrapped (\d+), fills (\d+), lines (\d+), headers (\d+), selection (\d+), marks (\d+), probes (\d+), hashes (\d+), fonts (\d+), twin (\d+), edges (\d+): (OK|FAIL.*)$')
        if (-not $m.Success) { continue }
        $name = $m.Groups[1].Value
        $cases[$name] = @{ Texts = [int]$m.Groups[2].Value + [int]$m.Groups[3].Value; Fills = [int]$m.Groups[4].Value; Lines = [int]$m.Groups[5].Value; Headers = [int]$m.Groups[6].Value; Selection = [int]$m.Groups[7].Value; Marks = [int]$m.Groups[8].Value; Probes = [int]$m.Groups[9].Value; Hashes = [int]$m.Groups[10].Value; Fonts = [int]$m.Groups[11].Value; Twin = [int]$m.Groups[12].Value; Edges = [int]$m.Groups[13].Value; Verdict = $m.Groups[14].Value }
        $caseLines.Add(("  {0}: {1}" -f $name, ($l -replace '^case \S+ \[[^\]]*\]: ', '')))
    }
    foreach ($f in $floors) {
        $c = $cases[$f.Case]
        if ($null -eq $c) { $problems.Add("the case $($f.Case) was not run"); continue }
        if ($c.Verdict -ne 'OK') { $problems.Add("the case $($f.Case) at a ratio of $scale`: $($c.Verdict)") }
        foreach ($k in @('Texts', 'Fills', 'Lines', 'Headers', 'Selection', 'Marks', 'Probes', 'Hashes', 'Fonts', 'Twin', 'Edges')) {
            if ($c[$k] -lt $f[$k]) { $problems.Add("the case $($f.Case) at a ratio of $scale asserted $($c[$k]) $($k.ToLower()), below its floor of $($f[$k])") }
        }
    }
    $last = $lines[$lines.Count - 1]
    if ($last -notmatch '^oracle ok cases=(\d+)') { $problems.Add("the last line is not 'oracle ok': $last") }
    elseif ([int]$Matches[1] -ne $expectedCases) { $problems.Add("the oracle ran $($Matches[1]) case(s), not the $expectedCases pinned here") }
    return @{ Problems = $problems; Lines = $caseLines; Header = $header }
}

$browser = Find-Browser $Browser
if ($Control) {
    if (-not (Test-Path -LiteralPath $Page)) { Write-Output ("SKIPPED: no built page at {0}; the control builds nothing without the real page to start from (tools/build_web.ps1 writes it)" -f $Page); exit 0 }
    if ($browser -eq '') { Write-Output 'SKIPPED: no browser found for the control (set ALONZO_BROWSER, or -Browser)'; exit 0 }
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_oracle_control_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $shell = if (Get-Command powershell.exe -ErrorAction SilentlyContinue) { 'powershell.exe' } else { 'pwsh' }
        $builder = Join-Path $PSScriptRoot 'build_web.ps1'
        $template = Join-Path $repoRoot 'web/index.template.html'
        $viewport = Join-Path $repoRoot 'web/viewport.js'
        $js = [System.IO.File]::ReadAllText($viewport)
        $tpl = [System.IO.File]::ReadAllText($template)
        function New-MutantPage([string]$name, [string]$tplPath, [string]$jsPath) {
            $out = Join-Path $tmp ($name + '.html')
            $prev = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            try { $null = & $shell -NoProfile -ExecutionPolicy Bypass -File $builder -Template $tplPath -ViewportJs $jsPath -Out $out 2>&1; $code = $LASTEXITCODE } finally { $ErrorActionPreference = $prev }
            if ($code -ne 0 -or -not (Test-Path -LiteralPath $out)) { throw "the builder could not build the mutant page $name" }
            return $out
        }
        # the real page first
        $r0 = Invoke-Oracle $browser $Page '1'
        $j0 = if ($r0.Text -ne '') { Test-Oracle $r0.Text '1' } else { @{ Problems = @($r0.Reason) } }
        # mutant A: the text padding changed, the header must say so and the cells land at the wrong x
        $anchorA = 'var TEXT_PAD_PX = 4;'
        if (([regex]::Matches($js, [regex]::Escape($anchorA))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorA' is not in web/viewport.js exactly once"; exit 1 }
        $jsA = Join-Path $tmp 'a.js'; [System.IO.File]::WriteAllText($jsA, $js.Replace($anchorA, 'var TEXT_PAD_PX = 5;'), $utf8)
        $pageA = New-MutantPage 'a' $template $jsA
        $rA = Invoke-Oracle $browser $pageA '1'
        $aApplied = ($rA.Text -ne '') -and ($rA.Text.Split("`n")[0] -like '*pad=5*')
        $jA = if ($rA.Text -ne '') { Test-Oracle $rA.Text '1' } else { @{ Problems = @($rA.Reason) } }
        $aPosition = @($jA.Problems | Where-Object { $_ -like '*expected*' }).Count
        # mutant B: the last visible column's texts dropped
        $anchorB = "if (!cell || cell.text === '') continue;"
        if (([regex]::Matches($js, [regex]::Escape($anchorB))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorB' is not in web/viewport.js exactly once"; exit 1 }
        $jsB = Join-Path $tmp 'b.js'; [System.IO.File]::WriteAllText($jsB, $js.Replace($anchorB, "if (!cell || cell.text === '' || c === colEnd) continue;"), $utf8)
        $pageB = New-MutantPage 'b' $template $jsB
        $rB = Invoke-Oracle $browser $pageB '1'
        $jB = if ($rB.Text -ne '') { Test-Oracle $rB.Text '1' } else { @{ Problems = @($rB.Reason) } }
        $bNotDrawn = @($jB.Problems | Where-Object { $_ -like '*not drawn*' }).Count
        # mutant C: the oracle's element cut from the template
        $anchorC = '<pre id="oracle" class="result">'
        if (([regex]::Matches($tpl, [regex]::Escape($anchorC))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorC' is not in the template exactly once"; exit 1 }
        $tplC = Join-Path $tmp 'c.template.html'; [System.IO.File]::WriteAllText($tplC, $tpl.Replace($anchorC, '<pre id="oracle-cut" class="result">'), $utf8)
        $pageC = New-MutantPage 'c' $tplC $viewport
        $rC = Invoke-Oracle $browser $pageC '1'
        $cNoBlock = ($rC.Text -eq '') -and ($rC.Reason -like 'no oracle block*')
        # mutant D (ENGINE.14): a viewport that draws a number too wide for its column cut again, its leading
        # digits lost, as KERNEL.5 drew it; the sparse_hashes case must fail it by name at a three-digit number
        $anchorD = '    if (hashes !== null) {'
        if (([regex]::Matches($js, [regex]::Escape($anchorD))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorD' is not in web/viewport.js exactly once"; exit 1 }
        $mutD = $js.Replace($anchorD, '    if (false) {')
        $dApplied = $mutD -cne $js
        $jsD = Join-Path $tmp 'd.js'; [System.IO.File]::WriteAllText($jsD, $mutD, $utf8)
        $pageD = New-MutantPage 'd' $template $jsD
        $rD = Invoke-Oracle $browser $pageD '1'
        $jD = if ($rD.Text -ne '') { Test-Oracle $rD.Text '1' } else { @{ Problems = @($rD.Reason) } }
        $dFailed = @($jD.Problems | Where-Object { $_ -cmatch 'case sparse_hashes.*cell body:\d+,1 shows \d{3}, a number too wide for its column, which draws #+' }).Count
        # mutant E (ENGINE.26): a viewport whose widths are one map for every sheet, a column's letters alone, as they were
        # until Buffet's hand tests found one view's drag widening every view's column; sheets_other must fail it by name
        $anchorE = '    return this.widths[key] || (this.widths[key] = {});'
        if (([regex]::Matches($js, [regex]::Escape($anchorE))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorE' is not in web/viewport.js exactly once"; exit 1 }
        $mutE = $js.Replace($anchorE, "    return this.widths[''] || (this.widths[''] = {});")
        $eApplied = $mutE -cne $js
        $jsE = Join-Path $tmp 'e.js'; [System.IO.File]::WriteAllText($jsE, $mutE, $utf8)
        $pageE = New-MutantPage 'e' $template $jsE
        $rE = Invoke-Oracle $browser $pageE '1'
        $jE = if ($rE.Text -ne '') { Test-Oracle $rE.Text '1' } else { @{ Problems = @($rE.Reason) } }
        $eFailed = @($jE.Problems | Where-Object { $_ -cmatch 'case sheets_other.*the sheet Output keeps the widths \{"B":300\}, where its own are \{\}' }).Count
        # mutant F (ENGINE.28): a viewport that passes over a format row's groups, as the viewport did until this item,
        # so that no font, alignment or edge is drawn; appearance must fail it naming a cell of row 1 drawn in the
        # default font where its look says bold 22 points (B1, whose place its own right alignment keeps; A1 fails on
        # its place first, the look's centering lost)
        $anchorF = '      if (!readGroups(f, fmt)) { m.counts.malformed++; return; }'
        if (([regex]::Matches($js, [regex]::Escape($anchorF))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorF' is not in web/viewport.js exactly once"; exit 1 }
        $mutF = $js.Replace($anchorF, '      // the groups passed over, by the control')
        $fApplied = $mutF -cne $js
        $jsF = Join-Path $tmp 'f.js'; [System.IO.File]::WriteAllText($jsF, $mutF, $utf8)
        $pageF = New-MutantPage 'f' $template $jsF
        $rF = Invoke-Oracle $browser $pageF '1'
        $jF = if ($rF.Text -ne '') { Test-Oracle $rF.Text '1' } else { @{ Problems = @($rF.Reason) } }
        $fFailed = @($jF.Problems | Where-Object { $_ -cmatch 'case appearance.*cell body:1,\d in the font 13px .*, expected bold 26px' }).Count
        # mutant G (ENGINE.28): a look's format replacing the cell's own whole, as it did until this item, so that a cell's
        # own alignment and edges fall under its look; appearance must fail it at C1, centered by its own format under the
        # look of 2, and against the twin, its draw list differing; since the second slice the edges lost to the look fill
        # the six problems a case's line lists, so the twin's own line may be cut, and its count, both holds failed, 0 below
        # its floor, says the same
        $anchorG = '        if (!model.styled && !model.bordered) return lf;'
        if (([regex]::Matches($js, [regex]::Escape($anchorG))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorG' is not in web/viewport.js exactly once"; exit 1 }
        $mutG = $js.Replace($anchorG, '        if (true) return lf;   // the look whole, by the control')
        $gApplied = $mutG -cne $js
        $jsG = Join-Path $tmp 'g.js'; [System.IO.File]::WriteAllText($jsG, $mutG, $utf8)
        $pageG = New-MutantPage 'g' $template $jsG
        $rG = Invoke-Oracle $browser $pageG '1'
        $jG = if ($rG.Text -ne '') { Test-Oracle $rG.Text '1' } else { @{ Problems = @($rG.Reason) } }
        $gFailed = @($jG.Problems | Where-Object { $_ -cmatch 'case appearance.*cell body:1,3 (at \d+,\d+, expected|aligned right, expected center)' }).Count
        $gTwin = @($jG.Problems | Where-Object { $_ -cmatch 'case appearance.*the draw list differs from the drawn twin' -or $_ -ceq 'the case appearance at a ratio of 1 asserted 0 twin, below its floor of 2' }).Count
        # mutants H to L (ENGINE.28's second slice), each the appearance case's by name: a shared edge drawn twice, its
        # loser's op beside its winner's; the fills laid as they were, inside their cells and not over their gridlines; an
        # edge stroked rather than filled, its pixels blended; a pattern phased on the edge's start and not the sheet's; and
        # an edge cut at its corners, the reach of the lines across it there lost
        $edgeMutants = @(
            @{ L = 'h'; Name = 'a shared edge drawn twice'; Anchor = "        p.ops.push({ op: 'edge', at: 'v' + r + ',' + b, row: r, col: l.near ? b : nb, side: l.near ? 'right' : 'left', line: l.line, color: l.color,"
               With = "        p.ops.push({ op: 'edge', at: 'v' + r + ',' + b, row: r, col: l.near ? nb : b, side: l.near ? 'left' : 'right', line: l.line, color: l.color, x: 0, y: 0, w: 0, h: 0, quadrant: name });`n        p.ops.push({ op: 'edge', at: 'v' + r + ',' + b, row: r, col: l.near ? b : nb, side: l.near ? 'right' : 'left', line: l.line, color: l.color,"
               Want = 'case appearance.*the edge body:v\d+,\d+ drawn twice' },
            @{ L = 'i'; Name = 'the fills as they were'; Anchor = 'if (fmt.fill) p.fillRect(ox + g.colX[c] - sx - 1, y - 1, w + 1, rh + 1, fmt.fill,'; With = 'if (fmt.fill) p.fillRect(ox + g.colX[c] - sx, y, w, rh, fmt.fill,'
               Want = 'case appearance.*fill body:1,\d+ at \d+,\d+ \d+x\d+, expected' },
            @{ L = 'j'; Name = 'an edge stroked'; Anchor = '      if (w > 0 && h > 0) ctx.fillRect(x, y, w, h);'; With = '      if (w > 0 && h > 0) { ctx.strokeStyle = ctx.fillStyle; ctx.lineWidth = 1; ctx.strokeRect(x, y, w, h); }'
               Want = 'case appearance.*the pixel \d+,\d+ of the edge body:[vh]\d+,\d+, (drawn|a gap), is (?!0,0,0,|255,255,255,)\d+,\d+,\d+, expected' },
            @{ L = 'k'; Name = 'a pattern phased on its edge'; Anchor = '        var on = u <= u1 && mask.charAt((((u - origin) % n) + n) % n) === want;'; With = '        var on = u <= u1 && mask.charAt((((u - u0) % n) + n) % n) === want;'
               Want = 'case appearance.*the pixel \d+,\d+ of the edge body:[vh]\d+,\d+, (drawn|a gap), is' },
            @{ L = 'l'; Name = 'an edge cut at its corners'; Anchor = '        var y0 = t0 + Math.min(0, low(lineH(above, b)), low(lineH(above, nb))), y1 = t1 + Math.max(0, high(lineH(r, b)), high(lineH(r, nb)));'; With = '        var y0 = t0, y1 = t1;'
               Want = 'case appearance.*the edge body:v\d+,\d+ at \d+,\d+ \d+x\d+, expected' }
        )
        $edgeNotes = New-Object System.Collections.Generic.List[string]
        $edgeJudged = New-Object System.Collections.Generic.List[object]
        $edgeOk = $true
        foreach ($mu in $edgeMutants) {
            if (([regex]::Matches($js, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/viewport.js exactly once"; exit 1 }
            $mutX = $js.Replace($mu.Anchor, $mu.With)
            $xApplied = $mutX -cne $js
            $jsX = Join-Path $tmp ($mu.L + '.js'); [System.IO.File]::WriteAllText($jsX, $mutX, $utf8)
            $rX = Invoke-Oracle $browser (New-MutantPage $mu.L $template $jsX) '1'
            $jX = if ($rX.Text -ne '') { Test-Oracle $rX.Text '1' } else { @{ Problems = @($rX.Reason) } }
            $xFailed = @($jX.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $edgeJudged.Add(@{ Name = $mu.Name; Problems = @($jX.Problems) })
            $edgeNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $xApplied, $xFailed))
            if (-not ($xApplied -and $xFailed -ge 1)) { $edgeOk = $false }
        }
        Write-Output ("control: the real page has {0} problem(s); the padding mutant applied ({1}) and failed on {2} position(s); the dropped column failed as {3} cell(s) not drawn; the cut element left no block ({4}); the number cut again applied ({5}) and failed sparse_hashes ({6}); the widths one map applied ({7}) and failed sheets_other ({8}); the groups passed over applied ({9}) and failed appearance ({10}); the look whole applied ({11}) and failed appearance at C1 ({12}) and against the twin ({13})" -f @($j0.Problems).Count, $aApplied, $aPosition, $bNotDrawn, $cNoBlock, $dApplied, $dFailed, $eApplied, $eFailed, $fApplied, $fFailed, $gApplied, $gFailed, $gTwin)
        Write-Output ('control: ' + ($edgeNotes -join '; '))
        if (@($j0.Problems).Count -eq 0 -and $aApplied -and $aPosition -ge 1 -and $bNotDrawn -ge 1 -and $cNoBlock -and $dApplied -and $dFailed -ge 1 -and $eApplied -and $eFailed -ge 1 -and $fApplied -and $fFailed -ge 1 -and $gApplied -and $gFailed -ge 1 -and $gTwin -ge 1 -and $edgeOk) {
            Write-Output 'OK: the check passes the real page and fails each of the twelve mutants for its own reason, each proving it applied'
            exit 0
        }
        Write-Output 'FAIL: the control did not behave as the header says'
        foreach ($p in @($j0.Problems)) { Write-Output ('  real: ' + $p) }
        foreach ($p in @($jA.Problems) | Select-Object -First 3) { Write-Output ('  padding mutant: ' + $p) }
        foreach ($p in @($jB.Problems) | Select-Object -First 3) { Write-Output ('  dropped column mutant: ' + $p) }
        Write-Output ('  cut element: ' + $rC.Reason)
        foreach ($p in @($jD.Problems) | Select-Object -First 3) { Write-Output ('  number cut again: ' + $p) }
        foreach ($p in @($jE.Problems) | Select-Object -First 3) { Write-Output ('  widths one map: ' + $p) }
        foreach ($p in @($jF.Problems) | Select-Object -First 3) { Write-Output ('  groups passed over: ' + $p) }
        foreach ($p in @($jG.Problems) | Select-Object -First 3) { Write-Output ('  the look whole: ' + $p) }
        foreach ($ej in $edgeJudged) { foreach ($p in @($ej.Problems) | Select-Object -First 3) { Write-Output ('  ' + $ej.Name + ': ' + $p) } }
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

Write-Output '=== THE RENDER ORACLE: EVERY CELL DRAWN WHERE THE RECORD PUTS IT, UNDER A HEADLESS BROWSER AT TWO RATIOS (KERNEL.5) ==='
if (-not (Test-Path -LiteralPath $Page)) { Write-Output ("  SKIPPED: no built page at {0} (tools/build_web.ps1 writes it; CI builds it before the runner)" -f $Page); exit 0 }
if ($browser -eq '') { Write-Output '  SKIPPED: no browser found (Google Chrome, Microsoft Edge or Chromium at their known paths or on the PATH; set ALONZO_BROWSER, or -Browser, to name one)'; exit 0 }
if ($floors.Count -ne $expectedCases) { Write-Output ("FAIL: the floors table holds {0} case(s), not the {1} pinned here" -f $floors.Count, $expectedCases); exit 1 }
Write-Output ("  the browser: {0}" -f $browser)
Write-Output ("  the page: {0}" -f $Page)
$failed = New-Object System.Collections.Generic.List[string]
foreach ($scale in $scales) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $r = Invoke-Oracle $browser $Page $scale
    $sw.Stop()
    if ($r.Text -eq '') { $failed.Add("at a ratio of $scale`: $($r.Reason)"); Write-Output ("  ratio {0}: {1}  FAIL" -f $scale, $r.Reason); continue }
    $j = Test-Oracle $r.Text $scale
    Write-Output ("  ratio {0} ({1:N1} s): {2}" -f $scale, $sw.Elapsed.TotalSeconds, $j.Header)
    foreach ($l in $j.Lines) { Write-Output ('  ' + $l) }
    foreach ($p in $j.Problems) { $failed.Add($p); Write-Output ("    {0}  FAIL" -f $p) }
}
Write-Output ''
if ($failed.Count -eq 0) {
    Write-Output "=== CHECK: clean - every case OK at both ratios, every count at or above its floor ==="
    exit 0
}
Write-Output "=== CHECK: $($failed.Count) problem(s) ==="
$failed | ForEach-Object { Write-Output "  $_" }
exit 1
