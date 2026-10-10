<#
check_frame_floors.ps1 - the engine's first number: the owner's measured
baseline of Life's frames, the benchmark cartridge's two fixtures over the
native runner and the engine's module, held to floors that never go down;
and on every push where a runner is built, the frames held to a hand-written
Life and their allocations to ceilings that never go up.

WHY: CART.1 (ROADMAP.md; REARVIEW.md, its scoping, decisions 4 to 7).
CHARTER.md section 7 names the engine's measure, cells evaluated a second,
on the benchmark cartridge, Conway's Life at 320 by 200, against section 3's
line of two million a second; the honest comparison is a Life that computes
every cell every generation. This check holds that number where it can be
held. A timing is a measurement on the owner's machine (AD-4), so the timed
floors are the owner's run of tools/bench_frames.ps1, pasted below, as the
blit's and the render's floors are pasted. The allocations a frame makes are
a property of the code and not of the machine, exact on every run, and the
scoping's profile named allocation the step's largest cost, so they are held
on every push that builds the runner, where no time can be.

WHAT IT HOLDS, from the baseline pasted below:
  - a date, an environment line, the vla-lang pin it was measured at, and
    each fixture's SHA-256 over LF bytes; the pin equal to Cargo.toml's and
    each digest equal to the fixture's, so that a language moved or a
    fixture edited without a new measurement fails by name, and every change
    to the language is measured on the benchmark before it lands here;
  - four rows, native and wasm, life and gun, each once: at least 30 steady
    frames; the clock's spread and its drift from the run's start within
    10% (the instrument's own guard against Windows' power throttling,
    measured to slow a background run by about 40% three seconds in); cells
    a second equal to frames a second times the formula cells within half a
    percent, one measurement in two units;
  - the floors, a dated history: each entry's floor at least the entry
    before it, row by row, unless the entry gives its reason (a correctness
    fix that costs speed, say, which the commit message repeats); each row's
    cells a second at least the latest floor. The floor is the baseline less
    a margin of 10%, the spread measured between sessions (4% natively, 7%
    in wasm) rounded up; tools/bench_frames.ps1 prints the line to add.
  - the bars, 2,000,000 cells a second (CHARTER.md section 3) and Life's 30
    frames a second, printed with the distance; out of reach today, they are
    not gated, and a floor that reaches one makes it a gate from then on,
    since a floor never goes down.
An empty baseline fails, since a floor with no number is no floor.

WITH A BUILT RUNNER (target/release/examples/frames, or -Runner): its check
mode, each fixture four frames, every frame equal to the runner's own Life,
the gun held to its published facts, and the allocations and reallocations
of each fixture's second frame after a fresh load at most the ceilings
below; a count under its ceiling is printed so the ceiling can be lowered.
SKIPPED without a runner: the ratchets job builds none, and the crate job
builds it before this check runs.

-Control proves the judgment: a clean table passes, and a table with a floor
lowered for a written reason passes; an empty baseline, a row missing, a
smoke run's few frames, a row under its floor, a floor lowered with no
reason, no floor at all, the pin moved, a fixture's digest changed, a clock
that moved and frames a second that disagree with cells a second must each
fail; then fake runners: a clean one passes, and one whose frame differs,
one whose allocations pass the ceiling, one that never holds the gun's facts
and one that leaves out a fixture must each fail.

House style (tools/check_*.ps1): PowerShell 5.1 and pwsh alike, host-free,
no browser, no network; a hardcoded, reviewable baseline; exit 0 clean,
exit 1 with every problem named.

Usage:  powershell -File tools\check_frame_floors.ps1
        powershell -File tools\check_frame_floors.ps1 -Runner target\release\examples\frames.exe
        powershell -File tools\check_frame_floors.ps1 -Control
#>
param(
    [string]$Root = '',
    [string]$Runner = '',
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if ($Root -eq '') { $Root = $repoRoot }
$onWindows = [System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT

# --- the baseline, hand-maintained: the owner's run of tools/bench_frames.ps1 ---
# Paste the block the instrument prints over the six lines below, whole, and
# add its floor line at the end of $floorHistory. A later run that is slower
# than the floor is a finding to record in REARVIEW.md, never a number to
# paste over a faster one.
# 2026-10-09, the first baseline: the owner's run, over vla-lang at c0686a9,
# both halves opted out of Windows' power throttling and every clock within
# 2.3% (CART.1's first slice). Copied from the terminal, whose line wrap
# dropped two spaces, one in the environment line and one in the last row,
# put back before the commit, and the floor entry set inside the history's
# parentheses; no value was touched.
$baselineDate = '2026-10-09'
$baselineEnvironment = 'Intel(R) Core(TM) Ultra 7 265KF, 20 cores | Microsoft Windows 11 Home 10.0.26200 | rustc 1.99.0 (b940084d7 2026-09-28) | chrome 154.0.8037.98 headless | the engine''s module 458,702 bytes | vla-lang at c0686a9 | power throttling opted out: the runner yes, 41 browser process(es)'
$baselinePin = 'c0686a9'
$baselineFixtures = @{ 'life' = '90B24FF2E98530FF530C9E573DAC0E2FB4F5968ABE378D0A673C3E9DCA8D70DB'; 'gun' = '0BD138CBE43825F93EA2235F755DE6A46F18CCF7B7DAEC33B6D38D8365E64234' }
$baseline = @(
    @{ Runner = 'native'; Fixture = 'life'; Cells = 62964; Frames = 30; Load = 165.4; FirstFrame = 228.1; FrameP50 = 288.8; FrameMin = 273.2; FrameMax = 295.8; CellsPerSecond = 217984; FramesPerSecond = 3.462; ClockMs = 0.181; ClockSpread = 2.3; ClockDrift = -0.0 },
    @{ Runner = 'native'; Fixture = 'gun'; Cells = 62964; Frames = 30; Load = 149.0; FirstFrame = 57.7; FrameP50 = 303.2; FrameMin = 296.0; FrameMax = 310.8; CellsPerSecond = 207634; FramesPerSecond = 3.298; ClockMs = 0.181; ClockSpread = 1.8; ClockDrift = 0.0 },
    @{ Runner = 'wasm'; Fixture = 'life'; Cells = 62964; Frames = 30; Load = 149.3; FirstFrame = 188.6; FrameP50 = 275.3; FrameMin = 265.5; FrameMax = 304.7; CellsPerSecond = 228710; FramesPerSecond = 3.632; ClockMs = 0.260; ClockSpread = 1.9; ClockDrift = -1.9 },
    @{ Runner = 'wasm'; Fixture = 'gun'; Cells = 62964; Frames = 30; Load = 109.7; FirstFrame = 44.6; FrameP50 = 286.6; FrameMin = 276.3; FrameMax = 308.4; CellsPerSecond = 219731; FramesPerSecond = 3.490; ClockMs = 0.260; ClockSpread = 1.9; ClockDrift = -1.9 }
)

# --- the floors, in cells a second, a dated history that never goes down ---
# One entry a measurement, one a line inside the parentheses, a comma after
# the entry before it: @{ Date = 'yyyy-mm-dd'; Pin = '<vla-lang pin>';
# Reason = ''; Floors = @{ 'native life' = n; 'native gun' = n; 'wasm life' =
# n; 'wasm gun' = n } }. An entry lower than the one before it in any row
# needs its Reason.
$floorHistory = @(
    @{ Date = '2026-10-09'; Pin = 'c0686a9'; Reason = ''; Floors = @{ 'native life' = 196000; 'native gun' = 186000; 'wasm life' = 205000; 'wasm gun' = 197000 } }
)

# --- the allocation ceilings, the second frame after a fresh load, exact ---
# 2026-10-09, CART.1's first slice, the runner's check mode over vla-lang at
# c0686a9: Life's soup 4,470,549 allocations and 1,129,229 reallocations, 71.0
# and 17.9 a formula cell; the gun 4,848,335 and 1,129,229, 77.0 a cell, its
# Seed sheet making each reference fold one sheet's name more (REARVIEW.md,
# the scoping's profile). The same integers on every run and every machine:
# no step calls the platform. Lowered when the language allocates less;
# raised only by a reviewed act with its reason in the commit message.
$allocationCeilings = @{
    'life' = @{ Allocs = 4470549; Reallocs = 1129229 }
    'gun'  = @{ Allocs = 4848335; Reallocs = 1129229 }
}

# --- the rules ---
$requiredRows = @('native life', 'native gun', 'wasm life', 'wasm gun')
$fixtureFiles = [ordered]@{ 'life' = 'cartridges/life/life.vla'; 'gun' = 'cartridges/gun/gun.vla' }
$minFrames = 30
$clockMax = 10.0
$unitsTolerance = 0.005
$barCells = 2000000
$barFrames = 30

function Get-LfDigest([string]$path) {
    $text = [System.IO.File]::ReadAllText($path) -replace "`r`n", "`n"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($text)) } finally { $sha.Dispose() }
    return (($hash | ForEach-Object { $_.ToString('X2') }) -join '')
}

# The pin of vla-lang as Cargo.toml writes it: a git rev, or a registry version.
function Get-Pin([string]$dir) {
    $toml = [System.IO.File]::ReadAllText((Join-Path $dir 'Cargo.toml'))
    $m = [regex]::Match($toml, '(?m)^vla-lang\s*=\s*\{[^}\r\n]*rev\s*=\s*"([0-9a-f]+)"')
    if ($m.Success) { return $m.Groups[1].Value }
    $m = [regex]::Match($toml, '(?m)^vla-lang\s*=\s*"=?([0-9][0-9.]*)"')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}

function Format-Count([double]$n) { return ([long][math]::Round($n)).ToString('N0', [System.Globalization.CultureInfo]::InvariantCulture) }

# The static judgment of a pasted baseline: the problems, and the lines to print.
function Test-Baseline($rows, [string]$date, [string]$environment, [string]$pin, [string]$currentPin, $fixtures, $currentDigests, $history) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    if ($null -eq $rows -or @($rows).Count -eq 0) {
        $problems.Add('the baseline is empty: run tools/bench_frames.ps1 on the owner''s machine and paste the block it prints into this file, with its floor line')
        return @{ Problems = $problems; Lines = $lines }
    }
    if ($date -notmatch '^\d{4}-\d{2}-\d{2}$') { $problems.Add("the baseline has no date (yyyy-mm-dd): '$date'") }
    if ($environment -eq '') { $problems.Add('the baseline has no environment line') }
    if ($pin -eq '') { $problems.Add('the baseline names no pin of vla-lang') }
    elseif ($pin -ne $currentPin) { $problems.Add("the baseline was measured at vla-lang $pin, and Cargo.toml pins $currentPin`: the language moved, so run tools/bench_frames.ps1 again and paste its block") }
    foreach ($name in @($currentDigests.Keys)) {
        if (-not $fixtures.ContainsKey($name)) { $problems.Add("the baseline names no SHA-256 for the fixture $name") }
        elseif ($fixtures[$name] -ne $currentDigests[$name]) { $problems.Add("the fixture $name is not the one measured: its SHA-256 over LF bytes is $($currentDigests[$name]), the baseline's $($fixtures[$name]); measure again") }
    }

    $byKey = @{}
    foreach ($r in @($rows)) {
        $key = ([string]$r.Runner) + ' ' + ([string]$r.Fixture)
        if ($byKey.ContainsKey($key)) { $problems.Add("the row $key is pasted twice") }
        $byKey[$key] = $r
    }
    foreach ($key in $byKey.Keys) { if ($requiredRows -notcontains $key) { $problems.Add("the row $key is none of the four the baseline holds") } }

    # The floors' history, entry by entry, row by row.
    $latest = $null
    if ($null -eq $history -or @($history).Count -eq 0) {
        $problems.Add('no floor yet: add the floor line tools/bench_frames.ps1 printed at the end of $floorHistory')
    } else {
        $prev = $null
        foreach ($e in @($history)) {
            if ([string]$e.Date -notmatch '^\d{4}-\d{2}-\d{2}$') { $problems.Add("a floor entry has no date: '$($e.Date)'") }
            if ($null -eq $e.Floors) { $problems.Add("the floor entry of $($e.Date) holds no floors"); continue }
            foreach ($key in $requiredRows) {
                if (-not $e.Floors.ContainsKey($key)) { $problems.Add("the floor entry of $($e.Date) has no floor for $key"); continue }
                if ($null -ne $prev -and $prev.Floors.ContainsKey($key) -and [double]$e.Floors[$key] -lt [double]$prev.Floors[$key] -and ([string]$e.Reason).Trim() -eq '') {
                    $problems.Add(("the floor of {0} went down at {1}, from {2} to {3}, with no reason written: a floor never goes down unless its entry says why" -f $key, $e.Date, (Format-Count $prev.Floors[$key]), (Format-Count $e.Floors[$key])))
                }
            }
            $prev = $e
        }
        $latest = @($history)[-1]
    }

    foreach ($key in $requiredRows) {
        if (-not $byKey.ContainsKey($key)) { $problems.Add("the row $key is missing from the baseline"); continue }
        $r = $byKey[$key]
        $cells = [double]$r.Cells; $cps = [double]$r.CellsPerSecond; $fps = [double]$r.FramesPerSecond
        if ($cells -le 0) { $problems.Add("the row $key names no formula cells"); continue }
        if ([int]$r.Frames -lt $minFrames) { $problems.Add("the row $key holds $($r.Frames) steady frames, under the instrument's $minFrames (a short run is not the baseline)") }
        if ([double]$r.ClockSpread -gt $clockMax -or [math]::Abs([double]$r.ClockDrift) -gt $clockMax) { $problems.Add(("the row {0}: the clock moved during its run, a spread of {1}% and a drift of {2}%, beyond {3}%: a throttled run is not the baseline" -f $key, $r.ClockSpread, $r.ClockDrift, $clockMax)) }
        if ($cps -le 0 -or [math]::Abs($cps - $fps * $cells) -gt $unitsTolerance * $cps) { $problems.Add(("the row {0}: {1} cells a second is not {2} frames a second times {3} formula cells" -f $key, (Format-Count $cps), $fps, (Format-Count $cells))) }
        $floorText = 'no floor'
        if ($null -ne $latest -and $null -ne $latest.Floors -and $latest.Floors.ContainsKey($key)) {
            $floor = [double]$latest.Floors[$key]
            $floorText = ("floor {0} ({1:N3} frames a second)" -f (Format-Count $floor), ($floor / $cells))
            if ($cps -lt $floor) { $problems.Add(("the row {0}: {1} cells a second, under its floor of {2}" -f $key, (Format-Count $cps), (Format-Count $floor))) }
            if ($floor -ge $barCells) { $floorText += ', the line a gate' }
        }
        $lines.Add(("  {0}: {1} cells a second, {2:N3} frames a second, frame p50 {3} ms; {4}; {5:N1}% of the line of {6}, {7:N1} times short; Life's rate {8} frames a second, {9:N1} times short; the clock's spread {10}%, drift {11}%" -f
            $key, (Format-Count $cps), $fps, $r.FrameP50, $floorText, (100.0 * $cps / $barCells), (Format-Count $barCells), ($barCells / $cps), $barFrames, ($barFrames / $fps), $r.ClockSpread, $r.ClockDrift))
    }
    return @{ Problems = $problems; Lines = $lines }
}

# The shell a fake runner's script runs under.
function Get-Shell { if (Get-Command powershell -ErrorAction SilentlyContinue) { return 'powershell' }; return 'pwsh' }

# A runner's check mode: its rows, or why not; a runner may be the program or
# a script standing in for it (-Control's fakes).
function Invoke-Runner([string]$runner, $paths) {
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        if ($runner -like '*.ps1') { $out = & (Get-Shell) -NoProfile -ExecutionPolicy Bypass -File $runner --check @paths 2>$null }
        else { $out = & $runner --check @paths 2>$null }
        $code = $LASTEXITCODE
    } finally { $ErrorActionPreference = $old }
    return @{ Text = (@($out) -join "`n"); Code = $code }
}

# The dynamic judgment: the runner's check mode over both fixtures.
function Test-Runner([string]$runner, $paths, $ceilings) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    $run = Invoke-Runner $runner $paths
    if ($run.Code -ne 0) {
        $problems.Add(("the runner's check failed (exit {0}): {1}" -f $run.Code, (($run.Text -split "`n") | Select-Object -First 3) -join ' | '))
        return @{ Problems = $problems; Lines = $lines }
    }
    if ($run.Text -notmatch '\(frames-check-done 2\)') { $problems.Add('the runner''s check did not finish both fixtures: ' + $run.Text) }
    foreach ($name in @($ceilings.Keys)) {
        $m = [regex]::Match($run.Text, '\(frames-check "' + $name + '" \(frames (\d+)\) \(equal (\d+)\) \(cells (\d+)\) \(allocs (\d+)\) \(reallocs (\d+)\)(?: \(facts (\d+)\))?\)')
        if (-not $m.Success) { $problems.Add("the runner's check printed no row for the fixture $name"); continue }
        $frames = [int]$m.Groups[1].Value; $equal = [int]$m.Groups[2].Value; $cells = [double]$m.Groups[3].Value
        $allocs = [long]$m.Groups[4].Value; $reallocs = [long]$m.Groups[5].Value
        if ($frames -lt 2 -or $equal -ne $frames) { $problems.Add("$name`: $equal of $frames frames equal to the hand-written Life") }
        if ($name -eq 'gun' -and -not $m.Groups[6].Success) { $problems.Add('gun: the runner did not hold the gun to its published facts') }
        $c = $ceilings[$name]
        $note = ''
        if ($allocs -gt [long]$c.Allocs) { $problems.Add(("{0}: the second frame's allocations rose to {1}, above the ceiling of {2}: a change made the evaluator allocate more" -f $name, (Format-Count $allocs), (Format-Count $c.Allocs))) }
        elseif ($allocs -lt [long]$c.Allocs) { $note += (", under the ceiling of {0}: lower it in this file" -f (Format-Count $c.Allocs)) }
        if ($reallocs -gt [long]$c.Reallocs) { $problems.Add(("{0}: the second frame's reallocations rose to {1}, above the ceiling of {2}" -f $name, (Format-Count $reallocs), (Format-Count $c.Reallocs))) }
        elseif ($reallocs -lt [long]$c.Reallocs) { $note += (", reallocations under the ceiling of {0}: lower it in this file" -f (Format-Count $c.Reallocs)) }
        $facts = if ($m.Groups[6].Success) { ', the gun''s facts held ' + $m.Groups[6].Value + ' periods' } else { '' }
        $lines.Add(("  {0}: {1} of {2} frames equal to the hand-written Life{3}; the second frame {4} allocations ({5:N1} a cell) and {6} reallocations{7}" -f $name, $equal, $frames, $facts, (Format-Count $allocs), ($allocs / [math]::Max(1, $cells)), (Format-Count $reallocs), $note))
    }
    return @{ Problems = $problems; Lines = $lines }
}

if ($Control) {
    $ok = $true
    $verdicts = New-Object System.Collections.Generic.List[string]
    $digests = @{ 'life' = ('A' * 64); 'gun' = ('B' * 64) }
    function Row([string]$runner, [string]$fixture, [double]$cps) {
        return @{ Runner = $runner; Fixture = $fixture; Cells = 62964; Frames = 30; Load = 160.0; FirstFrame = 200.0; FrameP50 = [math]::Round(62964 / $cps * 1000, 1); FrameMin = 270.0; FrameMax = 290.0;
                  CellsPerSecond = $cps; FramesPerSecond = [math]::Round($cps / 62964, 3); ClockMs = 0.180; ClockSpread = 5.0; ClockDrift = -1.0 }
    }
    function Clean { return @((Row 'native' 'life' 225000), (Row 'native' 'gun' 214000), (Row 'wasm' 'life' 233000), (Row 'wasm' 'gun' 223000)) }
    function Floors([double]$a, [double]$b, [double]$c, [double]$d) { return @{ 'native life' = $a; 'native gun' = $b; 'wasm life' = $c; 'wasm gun' = $d } }
    $history = @(@{ Date = '2026-10-09'; Pin = 'abc1234'; Reason = ''; Floors = (Floors 202000 192000 209000 200000) })
    function Judge($rows, $hist, [string]$currentPin, $current) { return Test-Baseline $rows '2026-10-09' 'a control environment' 'abc1234' $currentPin $digests $current $hist }
    function Expect([string]$name, $result, [string]$want) {
        $hit = @($result.Problems | Where-Object { $_ -like "*$want*" }).Count
        if ($want -eq '') {
            if ($result.Problems.Count -eq 0) { $verdicts.Add("$name`: passes, as it should") }
            else { $script:ok = $false; $verdicts.Add("$name`: FAILED but should pass: " + ($result.Problems -join ' | ')) }
        } elseif ($hit -ge 1) { $verdicts.Add("$name`: fails, as it should") }
        elseif ($result.Problems.Count -eq 0) { $script:ok = $false; $verdicts.Add("$name`: PASSED but should fail with '$want'") }
        else { $script:ok = $false; $verdicts.Add("$name`: fails, but without '$want': " + ($result.Problems -join ' | ')) }
    }
    Expect 'the clean table' (Judge (Clean) $history 'abc1234' $digests) ''
    $lowered = @($history[0], @{ Date = '2026-10-10'; Pin = 'abc1234'; Reason = 'a correctness fix that costs a frame 3%'; Floors = (Floors 196000 192000 209000 200000) })
    Expect 'a floor lowered for a written reason' (Judge (Clean) $lowered 'abc1234' $digests) ''
    Expect 'an empty baseline' (Judge @() $history 'abc1234' $digests) 'empty'
    Expect 'a row missing' (Judge @((Clean)[0..2]) $history 'abc1234' $digests) 'wasm gun is missing'
    $smoke = Clean; $smoke[1].Frames = 3
    Expect 'a smoke run' (Judge $smoke $history 'abc1234' $digests) 'steady frames, under'
    $slow = Clean; $slow[2] = Row 'wasm' 'life' 199000
    Expect 'a row under its floor' (Judge $slow $history 'abc1234' $digests) 'under its floor'
    $down = @($history[0], @{ Date = '2026-10-10'; Pin = 'abc1234'; Reason = ''; Floors = (Floors 196000 192000 209000 200000) })
    Expect 'a floor lowered with no reason' (Judge (Clean) $down 'abc1234' $digests) 'went down'
    Expect 'no floor at all' (Judge (Clean) @() 'abc1234' $digests) 'no floor yet'
    Expect 'the pin moved' (Judge (Clean) $history 'def5678' $digests) 'the language moved'
    $edited = @{ 'life' = ('A' * 64); 'gun' = ('C' * 64) }
    Expect 'a fixture edited' (Judge (Clean) $history 'abc1234' $edited) 'is not the one measured'
    $moved = Clean; $moved[0].ClockSpread = 12.5
    Expect 'a clock that moved' (Judge $moved $history 'abc1234' $digests) 'the clock moved'
    $units = Clean; $units[3].FramesPerSecond = [math]::Round($units[3].FramesPerSecond * 1.02, 3)
    Expect 'frames a second against cells a second' (Judge $units $history 'abc1234' $digests) 'is not'

    # The fake runners: scripts printing what a runner's check prints.
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_frame_floors_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $lifeRow = '(frames-check "life" (frames 4) (equal 4) (cells 62964) (allocs 4470549) (reallocs 1129229))'
        $gunRow = '(frames-check "gun" (frames 4) (equal 4) (cells 62964) (allocs 4848335) (reallocs 1129229) (facts 24))'
        $fakes = @(
            @{ Name = 'a clean runner'; Lines = @($lifeRow, $gunRow, '(frames-check-done 2)'); Exit = 0; Want = '' },
            @{ Name = 'a runner whose frame differs'; Lines = @('(frames-differ "life" (frame 3) (cell "B5") (engine 1) (reference 0))'); Exit = 1; Want = 'check failed' },
            @{ Name = 'a runner allocating more'; Lines = @($lifeRow.Replace('4470549', '4470550'), $gunRow, '(frames-check-done 2)'); Exit = 0; Want = 'rose to' },
            @{ Name = 'a runner without the gun''s facts'; Lines = @($lifeRow, $gunRow.Replace(' (facts 24)', ''), '(frames-check-done 2)'); Exit = 0; Want = 'published facts' },
            @{ Name = 'a runner leaving out a fixture'; Lines = @($lifeRow, '(frames-check-done 1)'); Exit = 0; Want = 'no row for the fixture gun' }
        )
        $i = 0
        foreach ($f in $fakes) {
            $i++
            $path = Join-Path $tmp ("fake$i.ps1")
            $body = (@($f.Lines | ForEach-Object { "Write-Output '" + ($_ -replace "'", "''") + "'" }) -join "`r`n") + "`r`nexit " + $f.Exit + "`r`n"
            [System.IO.File]::WriteAllText($path, $body, (New-Object System.Text.UTF8Encoding($false)))
            Expect $f.Name (Test-Runner $path @('life.vla', 'gun.vla') $allocationCeilings) $f.Want
        }
    } finally {
        Remove-Item -Recurse -Force -LiteralPath $tmp -ErrorAction SilentlyContinue
    }
    foreach ($v in $verdicts) { Write-Output ('control: ' + $v) }
    if ($ok) {
        Write-Output ("OK: control: the judgment passes the clean table and a reasoned lowering, fails ten mutants of the table, and over five fake runners passes the clean one and fails four, each for its own reason")
        exit 0
    }
    Write-Output 'FAIL: control: the judgment did not behave as the header says'
    exit 1
}

Write-Output '=== THE FRAME FLOORS: LIFE''S CELLS A SECOND, NATIVELY AND IN THE BROWSER, HELD TO FLOORS THAT NEVER GO DOWN (CART.1) ==='
$problems = New-Object System.Collections.Generic.List[string]
$currentDigests = @{}
foreach ($name in $fixtureFiles.Keys) {
    $path = Join-Path $Root $fixtureFiles[$name]
    if (Test-Path -LiteralPath $path) { $currentDigests[$name] = Get-LfDigest $path } else { $problems.Add("the fixture $($fixtureFiles[$name]) is missing") }
}
$static = Test-Baseline $baseline $baselineDate $baselineEnvironment $baselinePin (Get-Pin $Root) $baselineFixtures $currentDigests $floorHistory
if ($baselineDate -ne '') { Write-Output ("  measured {0}: {1}" -f $baselineDate, $baselineEnvironment) }
$static.Lines | ForEach-Object { Write-Output $_ }
foreach ($p in $static.Problems) { $problems.Add($p) }

if ($Runner -eq '') {
    $candidate = Join-Path $Root ('target/release/examples/frames' + $(if ($onWindows) { '.exe' } else { '' }))
    if (Test-Path -LiteralPath $candidate) { $Runner = $candidate }
}
if ($Runner -eq '') {
    Write-Output '  the runner: SKIPPED, none built (cargo build --release --example frames); the frames and the allocation ceilings are held where it is'
} elseif (-not (Test-Path -LiteralPath $Runner)) {
    $problems.Add("the runner $Runner does not exist")
} else {
    Write-Output ("  the runner: {0}, built {1}, in its check mode" -f $Runner, (Get-Item -LiteralPath $Runner).LastWriteTime.ToString('yyyy-MM-dd HH:mm'))
    $paths = @($fixtureFiles.Values | ForEach-Object { Join-Path $Root $_ })
    $dyn = Test-Runner $Runner $paths $allocationCeilings
    $dyn.Lines | ForEach-Object { Write-Output $_ }
    foreach ($p in $dyn.Problems) { $problems.Add($p) }
}
Write-Output ''
if ($problems.Count -eq 0) {
    Write-Output '=== CHECK: clean - the four rows at or above their floors, the pin and the fixtures the measured ones, and, with a runner, every frame equal and every count under its ceiling ==='
    exit 0
}
Write-Output "=== CHECK: $($problems.Count) problem(s) ==="
$problems | ForEach-Object { Write-Output "  $_" }
exit 1
