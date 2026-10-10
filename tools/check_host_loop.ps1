<#
check_host_loop.ps1 - the host's loop does what SPEC.md section 5 says, over
a fixed input log against the fake module: the page's loop oracle, run
under a headless browser at two pixel ratios, every case OK and its counts
at their floors.

WHY: ENGINE.1's oracle (REARVIEW.md, the scoping's decision 12). The built
page, web/index.html, carries the host shim (web/host.js), the fake module
(web/fake.js) and the Life cartridge; opened with ?loop=1 it drives the host
tick by tick with synthetic timestamps and a frozen clock over a fixed log of
keys, pointer moves, wheel notches and edits, and holds it to expectations
it computes itself, never by asking the host: the accumulator's arithmetic
re-done over the timestamps (a stall of a second runs seven frames at 30
and no more), the Input rows from the key events, the derived writes from
the fake module's declared rule, issued before the inputs so that a
person's edit wins, and the end state from a second fake module the page
drives with no host between, compared by digest. Twelve cases: rate30 (the
Camera moved by an edit and the window following, a derived write refused
and printed, a refused edit, a Camera cell that is not a number, a save
edge, the stall), rate0 (four edits, four steps, the Input sheet never
written), yield (a budget of 1,000 over 64,000 cells, the progress a
sentence, an edit held until the frame is done), memory (every allocation
detaches the buffer and the host keeps no view), abi (a module at ABI 2 and
two without an export refused, and the engine's module built into the page
attached at ABI 1 with its version), the refusals by id, scale (the backing
store at a whole number of device pixels a cell, and pixels read back
through the palette, magenta past it), and since ENGINE.1's second slice
two over the engine's own module when the page holds one: engine (the same
host loads Life on the real module and steps it eleven frames, the plane at
frames 1 and 11 equal byte for byte to a reference Life the page computes,
generations 0 and 10, frame 2 again on a second host in budgets of 2,000
cells equal to the unchunked frame, the module's memory grown at the load)
and parity (eleven refusals issued to the fake module and the engine's,
each answered with the same status and id); and since ENGINE.2 plane (the
plane the host draws held to the record of the same window, byte for value,
by the page's own reading of SPEC.md section 3.1, at frame 0 and after every
frame: the window to the Camera's, the bytes to the record, and the canvas's
pixels at a cell of each kind to the Palette's colour or magenta; over the
double, its Camera moved by edits and a formula without a value written
outside its declared size; over the engine's module, when the page holds
one, the test card, cartridges/testcard/testcard.vla, twenty-four frames
under a Camera that pans a column a frame, with two edits seen in their
frame); and since SPEC.3's second slice pass (the pass in the page: over the
double, a build declined in words and marked as a refusal, the double
holding no pass; over the engine's module, when the page holds one, every
source the page holds expanded by the host's expand into its cartridge
byte for byte as the command line wrote it, CRLF, a source whose include is
not handed in refused at the include's line, the first load after the pass
handle 1, and a build between two frames leaving the loop running); and
since ENGINE.3's first slice input, over the engine's module when the page
holds one (the input card, cartridges/inputcard/inputcard.vla, loaded with
its seed named and driven by events dispatched to the canvas: keys held
across frames, player 2's press, a key no button binds, the pointer with a
click and a right click, three notches of the wheel that pan the Camera, an
edit of the Clock's frame refused, the Clock's rate written to 1 and back;
the window the host draws equal at every frame to the card computed by hand
from the log, the Tally's counts, the seed in the Clock and in the dice, the
ticks following the rate), with rate30 pinning the pointer written through
the double's Camera and parity holding fourteen refusals. It
prints one line a case into
<pre id="loop"> and a last line, 'loop ok cases=N'. This check runs the
page under a headless Chromium at a device scale factor of 1 and of 1.5,
reads that element off the dump, and holds every case to OK and its counts
to the floors below; the floors over the engine's module apply when the page
holds one, as abi's module count says, and a page built beside the engine's
artifact must hold that artifact, byte count for byte count, or it is stale.

THE BROWSER, as tools/check_render_oracle.ps1 finds and launches it:
-Browser, else $env:ALONZO_BROWSER, else Google Chrome, Microsoft Edge or
Chromium at their known paths on Windows and by name on the PATH elsewhere;
the KERNEL.3 recipe's flags; Start-Process with redirected output, since
Edge's launcher detaches from a shell pipe. The oracle awaits no animation
frame, so the virtual-time budget only bounds the run. SKIPPED with exit 0
without a built page or without a browser: CI builds the page before the
runner and has the browser.

-Control builds fifteen mutant pages through tools/build_web.ps1 and runs
each: a host whose accumulator cap is 2,500 ms and not 250, whose header
proves the mutant applied by printing cap=2500 and whose stall must fail;
a host that issues the derived writes after the inputs, whose edit of
State!B1 must lose to the derived write and fail by name; a template
whose loop element is cut, which this check must fail for want of the
block; when the real page holds the engine's module, a template whose
reference Life lets a cell survive on three neighbours alone, which the
engine case must fail by name at frame 11, proving the comparison bites
(not applicable to a page without a module); a host that draws no frame 0
at a load, whose scale case must fail after its reload; a host that
leaves the canvas as it was at an unload, whose scale case must fail after
its refused load; a host that says a refusal without marking it one,
whose rate30 case must fail by name, since the page paints every marked
refusal red; and since ENGINE.2 three more, each failing the plane case by
name: a host that reads the Camera after it draws the plane, whose plane is
a frame late; a host whose blit masks a byte to the palette, so a byte past
it draws as a colour; and a double that reads a formula without a value as
255 again, which its own record says is 0; and since SPEC.3's second slice,
when the real page holds the engine's module, a page built from a scratch
copy of cartridges/ whose library writes the Palette's names to column D
and not C, so that the page's pass writes rows the command line did not,
which the pass case must fail by name (not applicable to a page without a
module); and since ENGINE.3's first slice three more: a host that writes
the pointer as the window's cell, without the Camera, which rate30 must
fail by name and, with the module, the input case at its window; and, when
the real page holds the module, a host that never reads the Clock's rate
after a step, whose ticks keep the manifest's rate where the input case
slowed it to 1, and a host that never writes its seed, whose Clock!B3 the
input case finds empty; and, found by the owner's hand test of ENGINE.3, a
host whose backlog is held to the quarter second whatever the rate, as it
was, so that at the teacher's rate of 1 no frame is ever owed, which the
input case must fail at the frame it never ran. The real page must pass
first.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network;
exit 0 clean, exit 1 with every problem named. A headless run's clock is
virtual, so nothing here is a timing.

Usage:  powershell -File tools\check_host_loop.ps1
        powershell -File tools\check_host_loop.ps1 -Browser "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        powershell -File tools\check_host_loop.ps1 -Page C:\somewhere\index.html
        powershell -File tools\check_host_loop.ps1 -Control
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

# --- the floors: each case's counts, never lowered; the scales the oracle runs at ---
# 2026-10-08, ENGINE.1: seven cases, measured under headless Chrome 154 and
# Edge 154 at both ratios, the counts a function of the log and so the same
# on every machine: rate30 42 frames, 41 derived writes landed and 11 refused
# (frames divisible by 7, 11 and 13), 4 edits written and one refused, 3
# windows, 111 detachments; rate0 4 frames for 4 edits, 3 windows; yield 9
# frames in 608 step calls and 599 yields; memory 14 frames and 637
# detachments, one an allocation; abi 4 refusals with the module built in (3
# without one); refusals 5; scale 2 at a ratio of 1 and 3 at 1.5, 6 pixels
# read back. Live allocations and misfrees are held at exactly zero.
# 2026-10-09, ENGINE.1's second slice: nine cases, under headless Chrome 154
# at both ratios over the engine's module of about 456 KB, the first seven's
# counts unchanged and their digests the same; abi 3 refusals and the module
# attached; engine 11 frames, 2 planes equal to the reference Life (23,683 and
# 14,482 live cells at generations 0 and 10), frame 2 equal in 64 calls of
# 2,000 cells, the memory grown, 5 devices; parity 11 of 11; 5.5 s a run.
# WithModule floors hold only when the page holds the engine's module. The
# same day, from the owner's hand test (a reload at rate 0 left the last run's
# picture on the canvas): scale's 6 cells read opaque black after a reload,
# frame 0 drawn at the load, and transparent after a refused load, the canvas
# emptied at the unload; engine's reload holds frame 0's empty plane.
# 2026-10-09, ENGINE.2: ten cases, the first nine's counts and digests
# unchanged; plane over the double 12 frames, 13 of them equal to the record
# (frame 0 with them), 2 windows, 40 pixels read back; over the engine's
# module 24 frames, 25 equal, 21 windows, 96 pixels, 31 distinct bytes.
# 2026-10-10, SPEC.3's second slice: eleven cases, the first ten's counts
# unchanged; pass over the double 1 build declined, and over the engine's
# module of 514,688 bytes 3 sources, 3 the same as the command line's (251
# rows after their manifests), the include refused at its line, handle 1 at
# the first load after the pass, the loop run on through a build.
# 2026-10-10, ENGINE.3's first slice: twelve cases, the first eleven's counts
# unchanged but for three: rate30 pins the pointer written through the
# double's Camera (pointer 1); parity 14 refusals, the Clock's three added;
# pass 4 sources the same, the input card's among them. input over the
# engine's module of 516,175 bytes: 26 frames, each window equal to the card
# computed by hand from the log, the seed named, 4 presses (1 of player 2's),
# 2 clicks, 3 notches, 4 key frames and the last code, the dice, the click's
# frame 11 carried by a derived write, the pointer's last column 8 through the
# Camera, the cursor seen in 16 frames, a button held in 6, the rate followed
# 3 ways, cart-write-clock said once. The same day, from the owner's hand
# test (the rate of 1 froze the loop, its backlog held under the interval):
# the case writes the rate of 1, and paces its ticks by its own arithmetic of
# section 5 as corrected, three frames at a second owed only after their
# waiting ticks ran none, so the rate is followed 5 ways.
$scales = @('1', '1.5')
$floors = @(
    @{ Case = 'rate30';   Min = @{ frames = 42; inputs = 42; applied = 41; refused = 11; edits = 4; windows = 3; detaches = 100; pointer = 1 } },
    @{ Case = 'rate0';    Min = @{ frames = 4; applied = 3; edits = 4; windows = 3 } },
    @{ Case = 'yield';    Min = @{ frames = 9; calls = 600; yields = 590; edits = 1 } },
    @{ Case = 'memory';   Min = @{ frames = 14; edits = 1; detaches = 600 } },
    @{ Case = 'abi';      Min = @{ refused = 3 }; WithModule = @{ attached = 1 } },
    @{ Case = 'refusals'; Min = @{ refused = 5; marked = 5 } },
    @{ Case = 'scale';    Min = @{ scale = 2; probes = 6; reloaded = 6; cleared = 6 } },
    @{ Case = 'engine';   Min = @{}; WithModule = @{ frames = 11; equal = 2; live1 = 23683; live11 = 14482; chunked = 1; grown = 1; devices = 5; reloaded = 1 } },
    @{ Case = 'parity';   Min = @{}; WithModule = @{ same = 14 } },
    @{ Case = 'plane';    Min = @{ fakeFrames = 12; fakeEqual = 13; fakeWindows = 2; fakeProbes = 40 }; WithModule = @{ frames = 24; equal = 25; windows = 21; probes = 96; kinds = 31 } },
    @{ Case = 'pass';     Min = @{ declined = 1 }; WithModule = @{ sources = 4; same = 4; refused = 1; handle = 1; ranOn = 1 } },
    @{ Case = 'input';    Min = @{}; WithModule = @{ frames = 26; equal = 26; seed = 1; presses = 4; players = 1; clicks = 2; wheel = 3; typed = 4; code = 1; dice = 1; clicked = 11; pointer = 8; cursor = 16; held = 6; rate = 5; refused = 1 } }
)
$zero = @('live', 'misfrees')
$expectedCases = 12
# The engine's artifact: a page built beside it must hold it.
$artifact = Join-Path $repoRoot 'target/wasm32-unknown-unknown/release/alonzo.wasm'

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
function Get-PageUrl([string]$path) {
    $slashed = [System.IO.Path]::GetFullPath($path) -replace '\\', '/'
    if ($slashed.StartsWith('/')) { return 'file://' + $slashed + '?loop=1' }
    return 'file:///' + $slashed + '?loop=1'
}
# One headless run: the loop element's text, or '' with the reason.
function Invoke-Loop([string]$browser, [string]$page, [string]$scale) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_loop_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $dump = Join-Path $tmp 'dump.html'
        $err = Join-Path $tmp 'err.txt'
        $argList = @('--headless=new', '--disable-gpu', '--run-all-compositor-stages-before-draw', '--disable-frame-rate-limit', '--disable-gpu-vsync',
                     '--virtual-time-budget=20000', ('--force-device-scale-factor=' + $scale), '--window-size=1600,1200', '--no-first-run', '--no-default-browser-check',
                     ('--user-data-dir="' + (Join-Path $tmp 'profile') + '"'))
        if (-not $onWindows) { $argList += @('--no-sandbox', '--disable-dev-shm-usage') }
        $argList += @('--dump-dom', ('"' + (Get-PageUrl $page) + '"'))
        $start = @{ FilePath = $browser; ArgumentList = $argList; RedirectStandardOutput = $dump; RedirectStandardError = $err; Wait = $true }
        if ($onWindows) { $start['NoNewWindow'] = $true }
        Start-Process @start
        if (-not (Test-Path -LiteralPath $dump)) { return @{ Text = ''; Reason = 'the browser wrote no dump' } }
        $html = [System.IO.File]::ReadAllText($dump)
        $m = [regex]::Match($html, '(?s)<pre id="loop"[^>]*>(.*?)</pre>')
        if (-not $m.Success) { return @{ Text = ''; Reason = ("no loop block in the dump ({0:N0} characters)" -f $html.Length) } }
        $text = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value).Trim()
        if ($text -eq '') { return @{ Text = ''; Reason = 'the loop block is empty' } }
        return @{ Text = $text; Reason = '' }
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}
# The judgment of one run's text at one scale: the problems, and the case lines to print.
function Test-Loop([string]$text, [string]$scale) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = @($text -split "`n" | ForEach-Object { $_.TrimEnd("`r") })
    $header = $lines[0]
    if ($header -notlike 'loop: host *') { $problems.Add("the first line is not the loop oracle's header: $header") }
    $dm = [regex]::Match($header, 'dpr=([0-9.]+)')
    if (-not $dm.Success -or $dm.Groups[1].Value -ne $scale) { $problems.Add("the page saw a ratio of '$($dm.Groups[1].Value)', the run asked for $scale") }
    $cases = @{}
    $caseLines = New-Object System.Collections.Generic.List[string]
    foreach ($l in $lines) {
        $m = [regex]::Match($l, '^case (\S+): ([^:]*): (OK|FAIL.*)$')
        if (-not $m.Success) { continue }
        $counts = @{}
        foreach ($pair in ($m.Groups[2].Value -split ',\s*')) { $kv = [regex]::Match($pair.Trim(), '^(\w+) (\S+)$'); if ($kv.Success) { $counts[$kv.Groups[1].Value] = $kv.Groups[2].Value } }
        $cases[$m.Groups[1].Value] = @{ Counts = $counts; Verdict = $m.Groups[3].Value }
        $caseLines.Add(("  {0}: {1}" -f $m.Groups[1].Value, ($l -replace '^case \S+: ', '')))
    }
    # The engine's module, as the abi case counts its bytes: 0 when the page holds none.
    $module = 0
    if ($cases.ContainsKey('abi') -and $cases['abi'].Counts.ContainsKey('module')) { $module = [double]$cases['abi'].Counts['module'] }
    if (Test-Path -LiteralPath $artifact) {
        $size = (Get-Item -LiteralPath $artifact).Length
        if ($module -ne $size) { $problems.Add("the page holds an engine module of $module bytes and $artifact is $size; a page built beside the artifact holds it, so rebuild the page (tools/build_web.ps1)") }
    }
    foreach ($f in $floors) {
        $c = $cases[$f.Case]
        if ($null -eq $c) { $problems.Add("the case $($f.Case) was not run"); continue }
        if ($c.Verdict -ne 'OK') { $problems.Add("the case $($f.Case) at a ratio of $scale`: $($c.Verdict)") }
        $mins = @{}
        foreach ($k in $f.Min.Keys) { $mins[$k] = $f.Min[$k] }
        if ($f.ContainsKey('WithModule') -and $module -gt 0) { foreach ($k in $f.WithModule.Keys) { $mins[$k] = $f.WithModule[$k] } }
        if ($f.ContainsKey('WithModule') -and $c.Counts.ContainsKey('module') -and [double]$c.Counts['module'] -ne $module) { $problems.Add("the case $($f.Case) ran over a module of $($c.Counts['module']) bytes and abi over $module") }
        foreach ($k in $mins.Keys) {
            if (-not $c.Counts.ContainsKey($k)) { $problems.Add("the case $($f.Case) printed no count of $k"); continue }
            if ([double]$c.Counts[$k] -lt $mins[$k]) { $problems.Add("the case $($f.Case) at a ratio of $scale counted $($c.Counts[$k]) $k, below its floor of $($mins[$k])") }
        }
        foreach ($k in $zero) { if ($c.Counts.ContainsKey($k) -and [double]$c.Counts[$k] -ne 0) { $problems.Add("the case $($f.Case) at a ratio of $scale counted $($c.Counts[$k]) $k, where it must count none") } }
    }
    $last = $lines[$lines.Count - 1]
    if ($last -notmatch '^loop ok cases=(\d+)') { $problems.Add("the last line is not 'loop ok': $last") }
    elseif ([int]$Matches[1] -ne $expectedCases) { $problems.Add("the oracle ran $($Matches[1]) case(s), not the $expectedCases pinned here") }
    return @{ Problems = $problems; Lines = $caseLines; Header = $header }
}

$browser = Find-Browser $Browser
if ($Control) {
    if (-not (Test-Path -LiteralPath $Page)) { Write-Output ("SKIPPED: no built page at {0}; the control builds nothing without the real page to start from (tools/build_web.ps1 writes it)" -f $Page); exit 0 }
    if ($browser -eq '') { Write-Output 'SKIPPED: no browser found for the control (set ALONZO_BROWSER, or -Browser)'; exit 0 }
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_loop_control_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $shell = if (Get-Command powershell.exe -ErrorAction SilentlyContinue) { 'powershell.exe' } else { 'pwsh' }
        $builder = Join-Path $PSScriptRoot 'build_web.ps1'
        $template = Join-Path $repoRoot 'web/index.template.html'
        $hostJs = Join-Path $repoRoot 'web/host.js'
        $js = [System.IO.File]::ReadAllText($hostJs)
        $tpl = [System.IO.File]::ReadAllText($template)
        $fakeJs = Join-Path $repoRoot 'web/fake.js'
        $fk = [System.IO.File]::ReadAllText($fakeJs)
        function New-MutantPage([string]$name, [string]$tplPath, [string]$jsPath, [string]$fakePath = '', [string]$cartsPath = '') {
            $out = Join-Path $tmp ($name + '.html')
            if ($fakePath -eq '') { $fakePath = $fakeJs }
            if ($cartsPath -eq '') { $cartsPath = Join-Path $repoRoot 'cartridges' }
            $prev = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            try { $null = & $shell -NoProfile -ExecutionPolicy Bypass -File $builder -Template $tplPath -HostJs $jsPath -FakeJs $fakePath -CartridgesDir $cartsPath -Out $out 2>&1; $code = $LASTEXITCODE } finally { $ErrorActionPreference = $prev }
            if ($code -ne 0 -or -not (Test-Path -LiteralPath $out)) { throw "the builder could not build the mutant page $name" }
            return $out
        }
        # the real page first
        $r0 = Invoke-Loop $browser $Page '1'
        $j0 = if ($r0.Text -ne '') { Test-Loop $r0.Text '1' } else { @{ Problems = @($r0.Reason) } }
        # mutant A: the accumulator's cap raised; the header must say so and the stall must fail
        $anchorA = 'var ACCUMULATOR_CAP_MS = 250;'
        if (([regex]::Matches($js, [regex]::Escape($anchorA))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorA' is not in web/host.js exactly once"; exit 1 }
        $jsA = Join-Path $tmp 'a.js'; [System.IO.File]::WriteAllText($jsA, $js.Replace($anchorA, 'var ACCUMULATOR_CAP_MS = 2500;'), $utf8)
        $rA = Invoke-Loop $browser (New-MutantPage 'a' $template $jsA) '1'
        $aApplied = ($rA.Text -ne '') -and ($rA.Text.Split("`n")[0] -like '*cap=2500*')
        $jA = if ($rA.Text -ne '') { Test-Loop $rA.Text '1' } else { @{ Problems = @($rA.Reason) } }
        $aStall = @($jA.Problems | Where-Object { $_ -like '*rate30*after tick 60 the host is at frame*' }).Count
        # mutant B: the derived writes issued after the inputs; the edit of State!B1 must lose and fail by name
        $anchorB = "    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs`n    this._issueInputs();    // step 3: the Input rows, then a person's edits, each its own write"
        $swapB = "    this._issueInputs();    // step 3: the Input rows, then a person's edits, each its own write`n    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs"
        if (([regex]::Matches($js, [regex]::Escape($anchorB))).Count -ne 1) { Write-Output "FAIL: the two lines of the frame's writes are not in web/host.js exactly once, in order"; exit 1 }
        $jsB = Join-Path $tmp 'b.js'; $mutB = $js.Replace($anchorB, $swapB); [System.IO.File]::WriteAllText($jsB, $mutB, $utf8)
        $bApplied = ([regex]::Matches($mutB, [regex]::Escape($swapB))).Count -eq 1
        $rB = Invoke-Loop $browser (New-MutantPage 'b' $template $jsB) '1'
        $jB = if ($rB.Text -ne '') { Test-Loop $rB.Text '1' } else { @{ Problems = @($rB.Reason) } }
        $bLost = @($jB.Problems | Where-Object { $_ -like '*must win over the derived write*' }).Count
        # mutant C: the loop element cut from the template
        $anchorC = '<pre id="loop" class="result">'
        if (([regex]::Matches($tpl, [regex]::Escape($anchorC))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorC' is not in the template exactly once"; exit 1 }
        $tplC = Join-Path $tmp 'c.template.html'; [System.IO.File]::WriteAllText($tplC, $tpl.Replace($anchorC, '<pre id="loop-cut" class="result">'), $utf8)
        $rC = Invoke-Loop $browser (New-MutantPage 'c' $tplC $hostJs) '1'
        $cNoBlock = ($rC.Text -eq '') -and ($rC.Reason -like 'no loop block*')
        # mutant D, when the real page holds the engine's module: the reference Life lets a cell
        # survive on three neighbours alone; the engine case must fail by name at frame 11
        $moduleReal = 0
        if ($r0.Text -ne '') { $am = [regex]::Match($r0.Text, 'case abi: [^\n]*module (\d+)'); if ($am.Success) { $moduleReal = [int]$am.Groups[1].Value } }
        $dApplied = $false; $dFailed = 0; $dNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorD = 'next[i] = (others === 3 || (me === 1 && others === 2)) ? 1 : 0;'
            if (([regex]::Matches($tpl, [regex]::Escape($anchorD))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorD' is not in the template exactly once"; exit 1 }
            $mutD = $tpl.Replace($anchorD, 'next[i] = (others === 3 || (me === 1 && others === 3)) ? 1 : 0;')
            $dApplied = $mutD -cne $tpl
            $tplD = Join-Path $tmp 'd.template.html'; [System.IO.File]::WriteAllText($tplD, $mutD, $utf8)
            $rD = Invoke-Loop $browser (New-MutantPage 'd' $tplD $hostJs) '1'
            $jD = if ($rD.Text -ne '') { Test-Loop $rD.Text '1' } else { @{ Problems = @($rD.Reason) } }
            $dFailed = @($jD.Problems | Where-Object { $_ -like '*case engine*frame 11 differs from the reference Life*' }).Count
            $dNote = "applied ($dApplied) and failed the engine case at frame 11 ($dFailed)"
        }
        $dOk = ($moduleReal -eq 0) -or ($dApplied -and $dFailed -ge 1)
        # mutant E: no frame 0 drawn at a load; the scale case's reload must fail by name
        $anchorE = "    if (c.mode === 'plane') this._drawPlane();   // frame 0, drawn at the load"
        if (([regex]::Matches($js, [regex]::Escape($anchorE))).Count -ne 1) { Write-Output "FAIL: the frame-0 draw is not in web/host.js exactly once"; exit 1 }
        $mutE = $js.Replace($anchorE, '    // the frame-0 draw cut by the control')
        $eApplied = $mutE -cne $js
        $jsE = Join-Path $tmp 'e.js'; [System.IO.File]::WriteAllText($jsE, $mutE, $utf8)
        $rE = Invoke-Loop $browser (New-MutantPage 'e' $template $jsE) '1'
        $jE = if ($rE.Text -ne '') { Test-Loop $rE.Text '1' } else { @{ Problems = @($rE.Reason) } }
        $eFailed = @($jE.Problems | Where-Object { $_ -like '*case scale*after the reload the cell*' }).Count
        # mutant F: the canvas left as it was at an unload; the scale case's refused load must fail by name
        $anchorF = '    this._clear();'
        if (([regex]::Matches($js, [regex]::Escape($anchorF))).Count -ne 1) { Write-Output "FAIL: the clear at an unload is not in web/host.js exactly once"; exit 1 }
        $mutF = $js.Replace($anchorF, '    // the clear cut by the control')
        $fApplied = $mutF -cne $js
        $jsF = Join-Path $tmp 'f.js'; [System.IO.File]::WriteAllText($jsF, $mutF, $utf8)
        $rF = Invoke-Loop $browser (New-MutantPage 'f' $template $jsF) '1'
        $jF = if ($rF.Text -ne '') { Test-Loop $rF.Text '1' } else { @{ Problems = @($rF.Reason) } }
        $fFailed = @($jF.Problems | Where-Object { $_ -like '*case scale*after a refused load the cell*' }).Count
        # mutant G: a refusal said without its mark; the rate30 case must fail, a refusal not marked as one
        $anchorG = "Host.prototype._refuse = function (text) { this._say(text, 'event', true); };"
        if (([regex]::Matches($js, [regex]::Escape($anchorG))).Count -ne 1) { Write-Output "FAIL: the refusal's mark is not in web/host.js exactly once"; exit 1 }
        $mutG = $js.Replace($anchorG, "Host.prototype._refuse = function (text) { this._say(text, 'event', false); };")
        $gApplied = $mutG -cne $js
        $jsG = Join-Path $tmp 'g.js'; [System.IO.File]::WriteAllText($jsG, $mutG, $utf8)
        $rG = Invoke-Loop $browser (New-MutantPage 'g' $template $jsG) '1'
        $jG = if ($rG.Text -ne '') { Test-Loop $rG.Text '1' } else { @{ Problems = @($rG.Reason) } }
        $gFailed = @($jG.Problems | Where-Object { $_ -like '*case rate30*a refusal is not marked as one*' }).Count
        # mutant H: the Camera read after the plane is drawn; the plane is a frame late and the plane case must fail by name
        $anchorH = "    if (d.camera) this._readCamera();`n    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();"
        $swapH = "    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();`n    if (d.camera) this._readCamera();"
        if (([regex]::Matches($js, [regex]::Escape($anchorH))).Count -ne 1) { Write-Output "FAIL: the three reads of a frame's effects are not in web/host.js exactly once, in order"; exit 1 }
        $mutH = $js.Replace($anchorH, $swapH)
        $hApplied = ([regex]::Matches($mutH, [regex]::Escape($swapH))).Count -eq 1
        $jsH = Join-Path $tmp 'h.js'; [System.IO.File]::WriteAllText($jsH, $mutH, $utf8)
        $rH = Invoke-Loop $browser (New-MutantPage 'h' $template $jsH) '1'
        $jH = if ($rH.Text -ne '') { Test-Loop $rH.Text '1' } else { @{ Problems = @($rH.Reason) } }
        $hFailed = @($jH.Problems | Where-Object { $_ -like "*case plane*in the host's plane and*by the record of*" }).Count
        # mutant I: the blit masks a byte to the palette; a byte past it draws as a colour, and the plane case's pixels must fail
        $anchorI = '    for (var i = 0; i < n; i++) px[i] = pal[bytes[i]];'
        if (([regex]::Matches($js, [regex]::Escape($anchorI))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorI' is not in web/host.js exactly once"; exit 1 }
        $mutI = $js.Replace($anchorI, '    for (var i = 0; i < n; i++) px[i] = pal[bytes[i] & 15];')
        $iApplied = $mutI -cne $js
        $jsI = Join-Path $tmp 'i.js'; [System.IO.File]::WriteAllText($jsI, $mutI, $utf8)
        $rI = Invoke-Loop $browser (New-MutantPage 'i' $template $jsI) '1'
        $jI = if ($rI.Text -ne '') { Test-Loop $rI.Text '1' } else { @{ Problems = @($rI.Reason) } }
        $iFailed = @($jI.Problems | Where-Object { $_ -like '*case plane*reads*not 255,0,255*' }).Count
        # mutant J: the double reads a formula without a value as 255 again; the plane case must fail over the double
        $anchorJ = '    if (!e || e.v === undefined) return 0;   // nothing here, or a formula with no value'
        if (([regex]::Matches($fk, [regex]::Escape($anchorJ))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorJ' is not in web/fake.js exactly once"; exit 1 }
        $mutJ = $fk.Replace($anchorJ, '    if (!e) return 0;')
        $jApplied = $mutJ -cne $fk
        $fkJ = Join-Path $tmp 'j.fake.js'; [System.IO.File]::WriteAllText($fkJ, $mutJ, $utf8)
        $rJ = Invoke-Loop $browser (New-MutantPage 'j' $template $hostJs $fkJ) '1'
        $jJ = if ($rJ.Text -ne '') { Test-Loop $rJ.Text '1' } else { @{ Problems = @($rJ.Reason) } }
        $jFailed = @($jJ.Problems | Where-Object { $_ -like "*case plane*fake frame*holds 255 in the host's plane and 0 by the record*" }).Count
        # mutant K, when the real page holds the engine's module: a scratch copy of cartridges/ whose
        # library writes the Palette's names to column D; the page's pass writes rows the command line
        # did not, and the pass case must fail by name
        $kApplied = $false; $kFailed = 0; $kNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $cartsK = Join-Path $tmp 'cartridges_k'
            Copy-Item -Recurse -LiteralPath (Join-Path $repoRoot 'cartridges') -Destination $cartsK
            $libK = Join-Path $cartsK 'console.vla'
            $lib = [System.IO.File]::ReadAllText($libK)
            $anchorK = '(cell "Palette" (symbol "\"C" (+expand index 1))'
            if (([regex]::Matches($lib, [regex]::Escape($anchorK))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorK' is not in cartridges/console.vla exactly once"; exit 1 }
            $mutK = $lib.Replace($anchorK, '(cell "Palette" (symbol "\"D" (+expand index 1))')
            $kApplied = $mutK -cne $lib
            [System.IO.File]::WriteAllText($libK, $mutK, $utf8)
            $rK = Invoke-Loop $browser (New-MutantPage 'k' $template $hostJs '' $cartsK) '1'
            $jK = if ($rK.Text -ne '') { Test-Loop $rK.Text '1' } else { @{ Problems = @($rK.Reason) } }
            $kFailed = @($jK.Problems | Where-Object { $_ -like "*case pass*the page's pass differs from*the command line's*" }).Count
            $kNote = "applied ($kApplied) and failed the pass case ($kFailed)"
        }
        $kOk = ($moduleReal -eq 0) -or ($kApplied -and $kFailed -ge 1)
        # mutant L (ENGINE.3): the pointer written as the window's cell, without the Camera; rate30's
        # pin over the double must fail by name, and, with the module, the input card's cursor too
        $anchorL = "    out.push('(cell `"Input`" `"B11`" ' + (on ? cam.col + pt.col - 1 : 0) + ')', '(cell `"Input`" `"B12`" ' + (on ? cam.row + pt.row - 1 : 0) + ')');"
        if (([regex]::Matches($js, [regex]::Escape($anchorL))).Count -ne 1) { Write-Output "FAIL: the pointer's two rows are not in web/host.js exactly once"; exit 1 }
        $mutL = $js.Replace($anchorL, "    out.push('(cell `"Input`" `"B11`" ' + (on ? pt.col : 0) + ')', '(cell `"Input`" `"B12`" ' + (on ? pt.row : 0) + ')');")
        $lApplied = $mutL -cne $js
        $jsL = Join-Path $tmp 'l.js'; [System.IO.File]::WriteAllText($jsL, $mutL, $utf8)
        $rL = Invoke-Loop $browser (New-MutantPage 'l' $template $jsL) '1'
        $jL = if ($rL.Text -ne '') { Test-Loop $rL.Text '1' } else { @{ Problems = @($rL.Reason) } }
        $lFailed = @($jL.Problems | Where-Object { $_ -like '*case rate30*the pointer at the window*' }).Count
        $lInput = @($jL.Problems | Where-Object { $_ -like '*case input*in the card by hand*' }).Count
        $lOk = $lApplied -and $lFailed -ge 1 -and (($moduleReal -eq 0) -or $lInput -ge 1)
        # mutants M and N (ENGINE.3), when the real page holds the engine's module: the Clock's rate
        # never read after a step, so the ticks keep the manifest's rate, and the host's seed never
        # written; the input case must fail each by name
        $mApplied = $false; $mFailed = 0; $nApplied = $false; $nFailed = 0; $oApplied = $false; $oFailed = 0
        $mnNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorM = '    if (d.clock) this._readClock();'
            if (([regex]::Matches($js, [regex]::Escape($anchorM))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorM' is not in web/host.js exactly once"; exit 1 }
            $mutM = $js.Replace($anchorM, '    // the rate read cut by the control')
            $mApplied = $mutM -cne $js
            $jsM = Join-Path $tmp 'm.js'; [System.IO.File]::WriteAllText($jsM, $mutM, $utf8)
            $rM = Invoke-Loop $browser (New-MutantPage 'm' $template $jsM) '1'
            $jM = if ($rM.Text -ne '') { Test-Loop $rM.Text '1' } else { @{ Problems = @($rM.Reason) } }
            $mFailed = @($jM.Problems | Where-Object { $_ -like '*case input*before its interval was owed*' }).Count
            $anchorN = "    if (c.seed === 'host') this._seed();"
            if (([regex]::Matches($js, [regex]::Escape($anchorN))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorN' is not in web/host.js exactly once"; exit 1 }
            $mutN = $js.Replace($anchorN, '    // the seed cut by the control')
            $nApplied = $mutN -cne $js
            $jsN = Join-Path $tmp 'n.js'; [System.IO.File]::WriteAllText($jsN, $mutN, $utf8)
            $rN = Invoke-Loop $browser (New-MutantPage 'n' $template $jsN) '1'
            $jN = if ($rN.Text -ne '') { Test-Loop $rN.Text '1' } else { @{ Problems = @($rN.Reason) } }
            $nFailed = @($jN.Problems | Where-Object { $_ -like '*case input*Clock!B3 holds*' }).Count
            # mutant O (ENGINE.3's hand test): the backlog held to the quarter second whatever the rate,
            # as it was, which starved the teacher's rate of 1; the input case must fail at the frame it never ran
            $anchorO = '    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), Math.max(ACCUMULATOR_CAP_MS, 1000 / c.rate));'
            if (([regex]::Matches($js, [regex]::Escape($anchorO))).Count -ne 1) { Write-Output "FAIL: the accumulator's line is not in web/host.js exactly once"; exit 1 }
            $mutO = $js.Replace($anchorO, '    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), ACCUMULATOR_CAP_MS);')
            $oApplied = $mutO -cne $js
            $jsO = Join-Path $tmp 'o.js'; [System.IO.File]::WriteAllText($jsO, $mutO, $utf8)
            $rO = Invoke-Loop $browser (New-MutantPage 'o' $template $jsO) '1'
            $jO = if ($rO.Text -ne '') { Test-Loop $rO.Text '1' } else { @{ Problems = @($rO.Reason) } }
            $oFailed = @($jO.Problems | Where-Object { $_ -like '*case input*ticks of 250 ms at the Clock*rate of 1 the host is at frame 18, not 19*' }).Count
            $mnNote = "the rate read cut applied ($mApplied) and failed the input case ($mFailed); the seed cut applied ($nApplied) and failed it ($nFailed); the backlog held to the quarter second applied ($oApplied) and failed it ($oFailed)"
        }
        $mnOk = ($moduleReal -eq 0) -or ($mApplied -and $mFailed -ge 1 -and $nApplied -and $nFailed -ge 1 -and $oApplied -and $oFailed -ge 1)
        Write-Output ("control: the real page has {0} problem(s); the raised cap applied ({1}) and failed the stall ({2}); the swapped writes applied ({3}) and lost the edit ({4}); the cut element left no block ({5}); the survival rule changed: {6}; the frame-0 draw cut applied ({7}) and failed the reload ({8}); the clear cut applied ({9}) and failed the refused load ({10}); the refusal's mark cut applied ({11}) and failed rate30 ({12}); the Camera read late applied ({13}) and failed the plane ({14}); the masked blit applied ({15}) and failed the pixels ({16}); the double's old 255 applied ({17}) and failed the plane ({18}); the library changed: {19}; the pointer without the Camera applied ({20}) and failed rate30 ({21}) and the input case ({22}); {23}" -f @($j0.Problems).Count, $aApplied, $aStall, $bApplied, $bLost, $cNoBlock, $dNote, $eApplied, $eFailed, $fApplied, $fFailed, $gApplied, $gFailed, $hApplied, $hFailed, $iApplied, $iFailed, $jApplied, $jFailed, $kNote, $lApplied, $lFailed, $lInput, $mnNote)
        if (@($j0.Problems).Count -eq 0 -and $aApplied -and $aStall -ge 1 -and $bApplied -and $bLost -ge 1 -and $cNoBlock -and $dOk -and $eApplied -and $eFailed -ge 1 -and $fApplied -and $fFailed -ge 1 -and $gApplied -and $gFailed -ge 1 -and $hApplied -and $hFailed -ge 1 -and $iApplied -and $iFailed -ge 1 -and $jApplied -and $jFailed -ge 1 -and $kOk -and $lOk -and $mnOk) {
            Write-Output ('OK: the check passes the real page and fails each of the ' + $(if ($moduleReal -gt 0) { 'fifteen' } else { 'ten applicable' }) + ' mutants for its own reason, each proving it applied')
            exit 0
        }
        Write-Output 'FAIL: the control did not behave as the header says'
        foreach ($p in @($j0.Problems)) { Write-Output ('  real: ' + $p) }
        foreach ($p in @($jA.Problems) | Select-Object -First 3) { Write-Output ('  raised cap: ' + $p) }
        foreach ($p in @($jB.Problems) | Select-Object -First 3) { Write-Output ('  swapped writes: ' + $p) }
        Write-Output ('  cut element: ' + $rC.Reason)
        if ($moduleReal -gt 0) { foreach ($p in @($jD.Problems) | Select-Object -First 3) { Write-Output ('  survival rule: ' + $p) } }
        foreach ($p in @($jE.Problems) | Select-Object -First 3) { Write-Output ('  frame-0 draw cut: ' + $p) }
        foreach ($p in @($jF.Problems) | Select-Object -First 3) { Write-Output ('  clear cut: ' + $p) }
        foreach ($p in @($jG.Problems) | Select-Object -First 3) { Write-Output ('  mark cut: ' + $p) }
        foreach ($p in @($jH.Problems) | Select-Object -First 3) { Write-Output ('  Camera read late: ' + $p) }
        foreach ($p in @($jI.Problems) | Select-Object -First 3) { Write-Output ('  masked blit: ' + $p) }
        foreach ($p in @($jJ.Problems) | Select-Object -First 3) { Write-Output ('  double''s old 255: ' + $p) }
        if ($moduleReal -gt 0) { foreach ($p in @($jK.Problems) | Select-Object -First 3) { Write-Output ('  library changed: ' + $p) } }
        foreach ($p in @($jL.Problems) | Select-Object -First 3) { Write-Output ('  pointer without the Camera: ' + $p) }
        if ($moduleReal -gt 0) {
            foreach ($p in @($jM.Problems) | Select-Object -First 3) { Write-Output ('  rate read cut: ' + $p) }
            foreach ($p in @($jN.Problems) | Select-Object -First 3) { Write-Output ('  seed cut: ' + $p) }
            foreach ($p in @($jO.Problems) | Select-Object -First 3) { Write-Output ('  backlog at the quarter second: ' + $p) }
        }
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

Write-Output "=== THE HOST'S LOOP: SECTION 5 OVER A FIXED LOG AGAINST THE FAKE MODULE, AND OVER THE ENGINE'S MODULE WHEN THE PAGE HOLDS ONE, UNDER A HEADLESS BROWSER AT TWO RATIOS (ENGINE.1) ==="
if (-not (Test-Path -LiteralPath $Page)) { Write-Output ("  SKIPPED: no built page at {0} (tools/build_web.ps1 writes it; CI builds it before the runner)" -f $Page); exit 0 }
if ($browser -eq '') { Write-Output '  SKIPPED: no browser found (Google Chrome, Microsoft Edge or Chromium at their known paths or on the PATH; set ALONZO_BROWSER, or -Browser, to name one)'; exit 0 }
if ($floors.Count -ne $expectedCases) { Write-Output ("FAIL: the floors table holds {0} case(s), not the {1} pinned here" -f $floors.Count, $expectedCases); exit 1 }
Write-Output ("  the browser: {0}" -f $browser)
Write-Output ("  the page: {0}" -f $Page)
$failed = New-Object System.Collections.Generic.List[string]
foreach ($scale in $scales) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $r = Invoke-Loop $browser $Page $scale
    $sw.Stop()
    if ($r.Text -eq '') { $failed.Add("at a ratio of $scale`: $($r.Reason)"); Write-Output ("  ratio {0}: {1}  FAIL" -f $scale, $r.Reason); continue }
    $j = Test-Loop $r.Text $scale
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
