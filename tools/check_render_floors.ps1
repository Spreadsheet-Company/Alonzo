<#
check_render_floors.ps1 - the viewport's frame floors: the owner's measured
baseline, held to the roadmap's bars and never lowered.

WHY: KERNEL.5's oracle names the floors (ROADMAP.md): on the 10,000-line
record, the scroll p95 under one and a half display intervals and the max
under two, the first draw of the normal window under 100 ms. Those are
timings, and a timing is a measurement in a real browser on a real screen
(AD-4): a shared runner's headless clock is virtual, and on the day of the
scoping it delivered thirty animation frames in 10 ms, a number that is not
a measurement and must not be a floor. So the instrument is the page's
?bench=1 mode (the harness of KERNEL.3 over the viewport, 120 steps of three
rows and 20 page steps at the normal window and at full screen, each draw's
main-thread cost), run by the owner in Chrome in fullscreen, and the table it
prints is pasted below as the baseline, with the date and the environment
line. This check holds that baseline to the bars and to its shape on every
push, and holds it hand-maintained: a later run that is worse is a finding to
record in REARVIEW.md, not a number to paste over a better one, and lowering
a floor is a reviewed act with its reason in the commit message
(CONTRIBUTING.md). An empty baseline fails, since a floor with no number is
no floor.

WHAT IT HOLDS: the baseline names a date, an interval above zero and an
environment line; both cases are present once, 'normal' and 'full-screen';
each has at least 140 steps (the harness's 120 and 20; a smoke run has ten
and cannot be pasted) and at least 35 cells with text (the normal window
holds 39 rows under the tab strip, one text a row); and for each, the step
p95 under one and a half intervals, the max under two, the first draw under
100 ms, no step dropped, and the page's own verdict 'yes'.

-Control proves the judgment on tables made in memory: a clean table passes;
a p95 over the bar, a max over, a first draw over, a dropped step, the
full-screen case missing, a smoke run's ten steps and an empty table must
each fail.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no browser, no
network; a hardcoded, reviewable baseline; exit 0 clean, exit 1 with every
problem named.

Usage:  powershell -File tools\check_render_floors.ps1
        powershell -File tools\check_render_floors.ps1 -Control
#>
param(
    [switch]$Control
)
$ErrorActionPreference = 'Stop'

# --- the baseline, hand-maintained: the owner's run of web/index.html?bench=1 in Chrome in fullscreen ---
# Paste the lines the page prints under "the baseline lines" here, whole, and
# the date of the run; the page's environment line names the browser, the
# ratio, the screen and the frame interval.
# 2026-10-08, the first baseline: the owner's run, Google Chrome 154 in
# fullscreen on a 2560 by 1440 CSS screen at a ratio of 1.5, 60 Hz; the normal
# window's step p95 0.9 ms and the full-screen window's 1.4 ms against a bar
# of 24.9, the max 1.1 and 2.5 against 33.2, the first draw 8.2 and 8.3
# against 100, no step dropped (KERNEL.5, REARVIEW.md's build record). The
# crispness verdict by eye on the page's HiDPI panel at that ratio, the
# owner's the same day: crisp, which closes the clause PROTOCOL.md section
# 8.1 left open when canvas was chosen.
$baselineDate = '2026-10-08'
$baselineInterval = 16.6
$baselineEnvironment = 'Environment: Google Chrome 154.0.8037.93, Chromium 154.0.8037.93 on Windows | DPR 1.5 | screen 2560x1440 | fullscreen yes | frame interval 16.6 ms (about 60 Hz) | sparse record 20,006 lines, extent A1:B10000, 10,000 cells, read in 12.0 ms'
$baseline = @(
    @{ Case = 'normal'; Rows = 38; Cols = 15; Cells = 38; FirstDraw = 8.2; StepP50 = 0.7; StepP95 = 0.9; PageP95 = 0.9; Max = 1.1; SyncP50 = 0.4; Dropped = 0; N = 140; Holds = 'yes' },
    @{ Case = 'full-screen'; Rows = 69; Cols = 39; Cells = 69; FirstDraw = 8.3; StepP50 = 1.2; StepP95 = 1.4; PageP95 = 1.8; Max = 2.5; SyncP50 = 0.9; Dropped = 0; N = 140; Holds = 'yes' }
)

# --- the bars (ROADMAP.md, KERNEL.5's oracle) ---
$stepP95Intervals = 1.5
$maxIntervals = 2
$firstDrawBar = 100
$requiredCases = @('normal', 'full-screen')
$minSteps = 140
$minCells = 35

function Test-Baseline($table, [double]$interval, [string]$date, [string]$environment) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    if ($null -eq $table -or @($table).Count -eq 0) {
        $problems.Add('the baseline is empty: open web/index.html?bench=1 in Chrome, press Fullscreen, press Copy when it is done, and paste the baseline lines into this file with the date')
        return @{ Problems = $problems; Lines = $lines }
    }
    if ($date -notmatch '^\d{4}-\d{2}-\d{2}$') { $problems.Add("the baseline has no date (yyyy-mm-dd): '$date'") }
    if ($interval -le 0) { $problems.Add("the baseline's frame interval is $interval ms, not above zero") }
    if ($environment -eq '') { $problems.Add('the baseline has no environment line') }
    $seen = @{}
    foreach ($row in @($table)) {
        $name = [string]$row.Case
        if ($seen.ContainsKey($name)) { $problems.Add("the case $name is pasted twice") }
        $seen[$name] = $row
    }
    foreach ($name in $requiredCases) {
        if (-not $seen.ContainsKey($name)) { $problems.Add("the case $name is missing from the baseline"); continue }
        $r = $seen[$name]
        $p95Bar = $stepP95Intervals * $interval
        $maxBar = $maxIntervals * $interval
        $note = ("  {0} ({1} x {2}, {3} cells): first draw {4} ms, step p95 {5} ms, page p95 {6} ms, max {7} ms, {8} of {9} dropped, holds {10}" -f $name, $r.Rows, $r.Cols, $r.Cells, $r.FirstDraw, $r.StepP95, $r.PageP95, $r.Max, $r.Dropped, $r.N, $r.Holds)
        if ([int]$r.N -lt $minSteps) { $problems.Add("the case $name has $($r.N) steps, under the harness's $minSteps (a smoke run cannot be the baseline)") }
        if ([int]$r.Cells -lt $minCells) { $problems.Add("the case $name drew $($r.Cells) cells with text, under $minCells") }
        if ([double]$r.StepP95 -ge $p95Bar) { $problems.Add(("the case {0}: step p95 {1} ms is not under {2} intervals ({3:N1} ms)" -f $name, $r.StepP95, $stepP95Intervals, $p95Bar)) }
        if ([double]$r.Max -ge $maxBar) { $problems.Add(("the case {0}: max {1} ms is not under {2} intervals ({3:N1} ms)" -f $name, $r.Max, $maxIntervals, $maxBar)) }
        if ([double]$r.FirstDraw -ge $firstDrawBar) { $problems.Add("the case $name`: first draw $($r.FirstDraw) ms is not under $firstDrawBar ms") }
        if ([int]$r.Dropped -ne 0) { $problems.Add("the case $name dropped $($r.Dropped) step(s)") }
        if ([string]$r.Holds -ne 'yes') { $problems.Add("the case $name does not hold the frame by the page's own verdict") }
        $lines.Add($note)
    }
    return @{ Problems = $problems; Lines = $lines }
}

if ($Control) {
    $clean = @(
        @{ Case = 'normal'; Rows = 39; Cols = 15; Cells = 39; FirstDraw = 1.4; StepP50 = 0.4; StepP95 = 0.9; PageP95 = 0.7; Max = 1.0; SyncP50 = 0.2; Dropped = 0; N = 140; Holds = 'yes' },
        @{ Case = 'full-screen'; Rows = 70; Cols = 39; Cells = 70; FirstDraw = 1.7; StepP50 = 0.6; StepP95 = 1.1; PageP95 = 1.4; Max = 1.4; SyncP50 = 0.4; Dropped = 0; N = 140; Holds = 'yes' }
    )
    function Mutate($rows, [int]$which, [string]$key, $value) {
        $out = @()
        for ($i = 0; $i -lt $rows.Count; $i++) {
            $copy = @{}
            foreach ($k in $rows[$i].Keys) { $copy[$k] = $rows[$i][$k] }
            if ($i -eq $which) { $copy[$key] = $value }
            $out += $copy
        }
        return ,$out
    }
    $r0 = Test-Baseline $clean 16.7 '2026-10-08' 'a control environment'
    $r1 = Test-Baseline (Mutate $clean 0 'StepP95' 30) 16.7 '2026-10-08' 'a control environment'
    $r2 = Test-Baseline (Mutate $clean 1 'Max' 40) 16.7 '2026-10-08' 'a control environment'
    $r3 = Test-Baseline (Mutate $clean 0 'FirstDraw' 150) 16.7 '2026-10-08' 'a control environment'
    $r4 = Test-Baseline (Mutate $clean 1 'Dropped' 3) 16.7 '2026-10-08' 'a control environment'
    $r5 = Test-Baseline @($clean[0]) 16.7 '2026-10-08' 'a control environment'
    $r6 = Test-Baseline (Mutate $clean 0 'N' 10) 16.7 '2026-10-08' 'a control environment'
    $r7 = Test-Baseline @() 16.7 '2026-10-08' 'a control environment'
    $p1 = @($r1.Problems | Where-Object { $_ -like '*step p95*' }).Count
    $p2 = @($r2.Problems | Where-Object { $_ -like '*max*' }).Count
    $p3 = @($r3.Problems | Where-Object { $_ -like '*first draw*' }).Count
    $p4 = @($r4.Problems | Where-Object { $_ -like '*dropped*' }).Count
    $p5 = @($r5.Problems | Where-Object { $_ -like '*full-screen is missing*' }).Count
    $p6 = @($r6.Problems | Where-Object { $_ -like '*steps, under*' }).Count
    $p7 = @($r7.Problems | Where-Object { $_ -like '*empty*' }).Count
    Write-Output ("control: the clean table has {0} problem(s); the p95 over the bar {1}, the max over {2}, the first draw over {3}, the dropped step {4}, the missing case {5}, the smoke run {6}, the empty table {7}" -f $r0.Problems.Count, $p1, $p2, $p3, $p4, $p5, $p6, $p7)
    if ($r0.Problems.Count -eq 0 -and $p1 -ge 1 -and $p2 -ge 1 -and $p3 -ge 1 -and $p4 -ge 1 -and $p5 -ge 1 -and $p6 -ge 1 -and $p7 -ge 1) {
        Write-Output 'OK: the judgment passes the clean table and fails each of the seven mutants for its own reason'
        exit 0
    }
    Write-Output 'FAIL: the control did not behave as the header says'
    foreach ($p in $r0.Problems) { Write-Output ('  clean: ' + $p) }
    exit 1
}

Write-Output "=== THE RENDER FLOORS: THE OWNER'S BASELINE, HELD TO THE BARS AND NEVER LOWERED (KERNEL.5) ==="
$t = Test-Baseline $baseline $baselineInterval $baselineDate $baselineEnvironment
if ($baselineDate -ne '') { Write-Output ("  measured {0}: {1}" -f $baselineDate, $baselineEnvironment) }
$t.Lines | ForEach-Object { Write-Output $_ }
Write-Output ''
if ($t.Problems.Count -eq 0) {
    Write-Output ("=== CHECK: clean - both windows hold the frame: step p95 under {0} intervals, max under {1}, first draw under {2} ms ===" -f $stepP95Intervals, $maxIntervals, $firstDrawBar)
    exit 0
}
Write-Output "=== CHECK: $($t.Problems.Count) problem(s) ==="
$t.Problems | ForEach-Object { Write-Output "  $_" }
exit 1
