<#
check_blit_floors.ps1 - the engine's second number: the owner's measured
baseline of the blit, a 320 by 200 plane drawn through the host's whole
frame, held to its bars and never lowered.

WHY: ENGINE.1's scoping, decision 9 (REARVIEW.md). The frame path minus the
evaluator is the engine's second number (CHARTER.md section 7): the host's
frame over the fake module, whose step computes nothing, so that what is
timed is the writes, the reads, the plane's view and the blit, the bytes
through the palette into an ImageData drawn at a whole number of device
pixels a cell. Those are timings, and a timing is a measurement in a real
browser on a real screen (AD-4): a shared runner's headless clock is
virtual. So the instrument is the page's ?blit=1 mode, 120 frames at the
scale that fits the screen and 120 at a scale of 1, each frame's main-thread
cost from before the frame to a task queued after its rendering, a dropped
frame the next animation frame later than one and a half intervals, run by
the owner in Chrome in fullscreen; the table it prints is pasted below as
the baseline with the date and the environment line. This check holds that
baseline to the bars and to its shape on every push. A later run that is
worse is a finding to record in REARVIEW.md, never a number to paste over a
better one, and lowering a bar is a reviewed act with its reason in the
commit message (CONTRIBUTING.md). An empty baseline fails, since a floor
with no number is no floor.

THE BARS, from the charter's frame budget (the scoping's decision 9): at 30
frames a second a step at the two-million line takes the whole 33.3 ms
interval and at 60 the interval is 16.7 ms, so the draw must be a small
share of either: the frame p95 under 2.0 ms, an eighth of a 60 Hz interval
and a sixteenth of a 30 Hz one; the max under 4.0 ms; no frame dropped; and
the page's own verdict that the frame held. The prediction written before
the first run (2026-10-08): the view's copy of 64,000 bytes under 0.1 ms,
the palette fill under 0.5 ms, the two draws under 1 ms at the fitting scale,
which is 10 device pixels a cell on the owner's 2560 by 1440 screen at a
ratio of 1.5 (3,200 by 2,000 device pixels), so a p50 under 1.5 ms and a
p95 under 2.0.

WHAT IT HOLDS: a date, an interval above zero and an environment line; both
cases once, 'fit' and 'scale-1'; each with at least 120 frames (a smoke run
has 8 and cannot be pasted); the fit case at a scale of at least 2, so a run
in a small window is not the baseline, and the scale-1 case at 1; and for
each the bars above.

-Control proves the judgment on tables made in memory: a clean table passes;
a p95 over the bar, a max over, a dropped frame, the scale-1 case missing, a
smoke run's 8 frames, an empty table and a fit case at a scale of 1 must
each fail.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no browser, no
network; a hardcoded, reviewable baseline; exit 0 clean, exit 1 with every
problem named.

Usage:  powershell -File tools\check_blit_floors.ps1
        powershell -File tools\check_blit_floors.ps1 -Control
#>
param(
    [switch]$Control
)
$ErrorActionPreference = 'Stop'

# --- the baseline, hand-maintained: the owner's run of web/index.html?blit=1 in Chrome in fullscreen ---
# Paste the lines the page prints under "the baseline lines" here, whole, and
# the date of the run.
# 2026-10-09, the first baseline: the owner's run, Google Chrome 154 in
# fullscreen on a 2560 by 1440 CSS screen at a ratio of 1.5, 60 Hz; the plane
# fitted at 10 device pixels a cell, 3,200 by 2,000, as the corrected
# prediction said; the frame p95 0.9 ms at that scale and 1.1 at a scale of 1
# against a bar of 2.0, the max 1.6 and 2.1 against 4.0, no frame dropped; the
# prediction (a p50 under 1.5 ms and a p95 under 2.0) met at 0.7 and 0.9
# (ENGINE.1, REARVIEW.md's build record).
$baselineDate = '2026-10-09'
$baselineInterval = 16.7
$baselineEnvironment = 'Environment: Google Chrome 154.0.8037.93, Chromium 154.0.8037.93 on Windows | DPR 1.5 | screen 2560x1440 | fullscreen yes | frame interval 16.7 ms (about 60 Hz) | the fake module, the Life cartridge, 120 frames a case'
$baseline = @(
    @{ Case = 'fit'; Scale = 10; Width = 3200; Height = 2000; FirstFrame = 1.3; ViewP50 = 0.1; BlitP50 = 0.1; SyncP50 = 0.6; FrameP50 = 0.7; FrameP95 = 0.9; Max = 1.6; Dropped = 0; N = 120; Holds = 'yes' },
    @{ Case = 'scale-1'; Scale = 1; Width = 320; Height = 200; FirstFrame = 0.8; ViewP50 = 0.2; BlitP50 = 0.1; SyncP50 = 0.6; FrameP50 = 0.7; FrameP95 = 1.1; Max = 2.1; Dropped = 0; N = 120; Holds = 'yes' }
)

# --- the bars ---
$frameP95Bar = 2.0
$maxBar = 4.0
$requiredCases = @('fit', 'scale-1')
$minFrames = 120
$minFitScale = 2

function Test-Baseline($table, [double]$interval, [string]$date, [string]$environment) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    if ($null -eq $table -or @($table).Count -eq 0) {
        $problems.Add('the baseline is empty: open web/index.html?blit=1 in Chrome, press Fullscreen, press Copy when it is done, and paste the baseline lines into this file with the date')
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
        $lines.Add(("  {0} (scale {1}, {2} x {3} device px): first {4} ms, view p50 {5}, blit p50 {6}, frame p50 {7}, p95 {8}, max {9}, {10} of {11} dropped, holds {12}" -f $name, $r.Scale, $r.Width, $r.Height, $r.FirstFrame, $r.ViewP50, $r.BlitP50, $r.FrameP50, $r.FrameP95, $r.Max, $r.Dropped, $r.N, $r.Holds))
        if ([int]$r.N -lt $minFrames) { $problems.Add("the case $name has $($r.N) frames, under the instrument's $minFrames (a smoke run cannot be the baseline)") }
        if ($name -eq 'fit' -and [int]$r.Scale -lt $minFitScale) { $problems.Add("the fit case drew at a scale of $($r.Scale), under ${minFitScale}; run it in fullscreen") }
        if ($name -eq 'scale-1' -and [int]$r.Scale -ne 1) { $problems.Add("the scale-1 case drew at a scale of $($r.Scale), not 1") }
        if ([double]$r.FrameP95 -ge $frameP95Bar) { $problems.Add(("the case {0}: frame p95 {1} ms is not under {2} ms" -f $name, $r.FrameP95, $frameP95Bar)) }
        if ([double]$r.Max -ge $maxBar) { $problems.Add(("the case {0}: max {1} ms is not under {2} ms" -f $name, $r.Max, $maxBar)) }
        if ([int]$r.Dropped -ne 0) { $problems.Add("the case $name dropped $($r.Dropped) frame(s)") }
        if ([string]$r.Holds -ne 'yes') { $problems.Add("the case $name does not hold the frame by the page's own verdict") }
    }
    return @{ Problems = $problems; Lines = $lines }
}

if ($Control) {
    $clean = @(
        @{ Case = 'fit'; Scale = 10; Width = 3200; Height = 2000; FirstFrame = 1.6; ViewP50 = 0.1; BlitP50 = 0.4; SyncP50 = 0.7; FrameP50 = 1.0; FrameP95 = 1.4; Max = 2.2; Dropped = 0; N = 120; Holds = 'yes' },
        @{ Case = 'scale-1'; Scale = 1; Width = 320; Height = 200; FirstFrame = 1.1; ViewP50 = 0.1; BlitP50 = 0.2; SyncP50 = 0.4; FrameP50 = 0.6; FrameP95 = 0.9; Max = 1.5; Dropped = 0; N = 120; Holds = 'yes' }
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
    $r0 = Test-Baseline $clean 16.6 '2026-10-08' 'a control environment'
    $r1 = Test-Baseline (Mutate $clean 0 'FrameP95' 2.5) 16.6 '2026-10-08' 'a control environment'
    $r2 = Test-Baseline (Mutate $clean 1 'Max' 4.2) 16.6 '2026-10-08' 'a control environment'
    $r3 = Test-Baseline (Mutate $clean 0 'Dropped' 2) 16.6 '2026-10-08' 'a control environment'
    $r4 = Test-Baseline @($clean[0]) 16.6 '2026-10-08' 'a control environment'
    $r5 = Test-Baseline (Mutate $clean 1 'N' 8) 16.6 '2026-10-08' 'a control environment'
    $r6 = Test-Baseline @() 16.6 '2026-10-08' 'a control environment'
    $r7 = Test-Baseline (Mutate $clean 0 'Scale' 1) 16.6 '2026-10-08' 'a control environment'
    $p1 = @($r1.Problems | Where-Object { $_ -like '*frame p95*' }).Count
    $p2 = @($r2.Problems | Where-Object { $_ -like '*max*' }).Count
    $p3 = @($r3.Problems | Where-Object { $_ -like '*dropped*' }).Count
    $p4 = @($r4.Problems | Where-Object { $_ -like '*scale-1 is missing*' }).Count
    $p5 = @($r5.Problems | Where-Object { $_ -like '*frames, under*' }).Count
    $p6 = @($r6.Problems | Where-Object { $_ -like '*empty*' }).Count
    $p7 = @($r7.Problems | Where-Object { $_ -like '*fit case drew at a scale of 1*' }).Count
    Write-Output ("control: the clean table has {0} problem(s); the p95 over the bar {1}, the max over {2}, the dropped frame {3}, the missing case {4}, the smoke run {5}, the empty table {6}, the unfitted scale {7}" -f $r0.Problems.Count, $p1, $p2, $p3, $p4, $p5, $p6, $p7)
    if ($r0.Problems.Count -eq 0 -and $p1 -ge 1 -and $p2 -ge 1 -and $p3 -ge 1 -and $p4 -ge 1 -and $p5 -ge 1 -and $p6 -ge 1 -and $p7 -ge 1) {
        Write-Output 'OK: the judgment passes the clean table and fails each of the seven mutants for its own reason'
        exit 0
    }
    Write-Output 'FAIL: the control did not behave as the header says'
    foreach ($p in $r0.Problems) { Write-Output ('  clean: ' + $p) }
    exit 1
}

Write-Output "=== THE BLIT FLOORS: THE OWNER'S BASELINE OF THE FRAME PATH MINUS THE EVALUATOR, HELD TO THE BARS (ENGINE.1) ==="
$t = Test-Baseline $baseline $baselineInterval $baselineDate $baselineEnvironment
if ($baselineDate -ne '') { Write-Output ("  measured {0}: {1}" -f $baselineDate, $baselineEnvironment) }
$t.Lines | ForEach-Object { Write-Output $_ }
Write-Output ''
if ($t.Problems.Count -eq 0) {
    Write-Output ("=== CHECK: clean - both cases hold the frame: frame p95 under {0} ms, max under {1} ms, no frame dropped ===" -f $frameP95Bar, $maxBar)
    exit 0
}
Write-Output "=== CHECK: $($t.Problems.Count) problem(s) ==="
$t.Problems | ForEach-Object { Write-Output "  $_" }
exit 1
