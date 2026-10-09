<#
check_render_oracle.ps1 - the viewport draws every cell where the record puts
it: the page's render oracle, run under a headless browser at two pixel
ratios, every case OK and its counts at their floors.

WHY: KERNEL.5's deterministic oracle, the half CI gates (REARVIEW.md, the
scoping's decision 4). The built page, web/index.html, carries the viewport
and seven records the door printed; opened with ?oracle=1 it loads each
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

-Control builds three mutant pages from mutated sources through
tools/build_web.ps1 and runs each: a viewport whose text padding is 5 and not
4, which the oracle must fail naming cells at the wrong position, the page's
header proving the mutant applied by printing pad=5; a viewport that drops
the last visible column's texts, which the oracle must fail as cells not
drawn; and a template whose oracle element is cut, which this check must fail
for want of the block. The real page must pass first.

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
$scales = @('1', '1.5')
$floors = @(
    @{ Case = 'fixture_frazaro';          Texts = 18; Fills = 34; Lines = 0;   Headers = 20; Selection = 1; Marks = 0; Probes = 3 },
    @{ Case = 'fixture_output';           Texts = 7;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'fixture_output_b2_c3';     Texts = 4;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'fixture_data';             Texts = 1;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'into_output';              Texts = 2;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'into_checks';              Texts = 1;  Fills = 0;  Lines = 30;  Headers = 30; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'sparse_top';               Texts = 38; Fills = 0;  Lines = 50;  Headers = 50; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'sparse_middle';            Texts = 38; Fills = 0;  Lines = 50;  Headers = 50; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'sparse_end';               Texts = 38; Fills = 0;  Lines = 50;  Headers = 50; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'sparse_frozen';            Texts = 38; Fills = 0;  Lines = 100; Headers = 50; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'sparse_resized';           Texts = 38; Fills = 0;  Lines = 48;  Headers = 48; Selection = 1; Marks = 0; Probes = 2 },
    @{ Case = 'fixture_frazaro_selected'; Texts = 18; Fills = 34; Lines = 0;   Headers = 20; Selection = 1; Marks = 1; Probes = 3 }
)
$expectedCases = 12

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
        $m = [regex]::Match($l, '^case (\S+) \[[^\]]*\]: texts (\d+), wrapped (\d+), fills (\d+), lines (\d+), headers (\d+), selection (\d+), marks (\d+), probes (\d+): (OK|FAIL.*)$')
        if (-not $m.Success) { continue }
        $name = $m.Groups[1].Value
        $cases[$name] = @{ Texts = [int]$m.Groups[2].Value + [int]$m.Groups[3].Value; Fills = [int]$m.Groups[4].Value; Lines = [int]$m.Groups[5].Value; Headers = [int]$m.Groups[6].Value; Selection = [int]$m.Groups[7].Value; Marks = [int]$m.Groups[8].Value; Probes = [int]$m.Groups[9].Value; Verdict = $m.Groups[10].Value }
        $caseLines.Add(("  {0}: {1}" -f $name, ($l -replace '^case \S+ \[[^\]]*\]: ', '')))
    }
    foreach ($f in $floors) {
        $c = $cases[$f.Case]
        if ($null -eq $c) { $problems.Add("the case $($f.Case) was not run"); continue }
        if ($c.Verdict -ne 'OK') { $problems.Add("the case $($f.Case) at a ratio of $scale`: $($c.Verdict)") }
        foreach ($k in @('Texts', 'Fills', 'Lines', 'Headers', 'Selection', 'Marks', 'Probes')) {
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
        Write-Output ("control: the real page has {0} problem(s); the padding mutant applied ({1}) and failed on {2} position(s); the dropped column failed as {3} cell(s) not drawn; the cut element left no block ({4})" -f @($j0.Problems).Count, $aApplied, $aPosition, $bNotDrawn, $cNoBlock)
        if (@($j0.Problems).Count -eq 0 -and $aApplied -and $aPosition -ge 1 -and $bNotDrawn -ge 1 -and $cNoBlock) {
            Write-Output 'OK: the check passes the real page and fails each of the three mutants for its own reason, each proving it applied'
            exit 0
        }
        Write-Output 'FAIL: the control did not behave as the header says'
        foreach ($p in @($j0.Problems)) { Write-Output ('  real: ' + $p) }
        foreach ($p in @($jA.Problems) | Select-Object -First 3) { Write-Output ('  padding mutant: ' + $p) }
        foreach ($p in @($jB.Problems) | Select-Object -First 3) { Write-Output ('  dropped column mutant: ' + $p) }
        Write-Output ('  cut element: ' + $rC.Reason)
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
