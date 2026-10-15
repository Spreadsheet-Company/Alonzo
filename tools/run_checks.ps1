<#
run_checks.ps1 - runs every tools\check_*.ps1 and reports one total.

WHY: in Frazaro's shape, where there are fifty-two of them. Running checks one
at a time is a page of scrollback in which a single red line is easy to walk
past, and "they all seemed to pass" is not a result anybody can quote in a
commit message. This prints one line per check and one total, and its own
exit code is the answer. CONTRIBUTING.md names it as what to run before a
pull request, and .github/workflows/checks.yml runs it on every push, once
under Windows PowerShell 5.1 and once under pwsh beside the wasm it builds;
.github/workflows/controls.yml runs it with -WithExtras the same two ways,
nightly and by hand.

IT IS NOT NAMED check_*.ps1, deliberately: this file would otherwise match
its own glob and run itself forever. It also skips itself by name as a belt
to that brace, in case it is ever copied under a different name.

THE FLOOR IS A CHECK OF ITS OWN. A check that is deleted, renamed out of the
glob, or moved to another folder does not fail - it simply stops running, and
nothing notices. So the count discovered is compared against a hardcoded
floor below, in the same hand-maintained, reviewable shape every other scan
in this folder uses. Lowering it is a deliberate, reviewed act.

THE SHELL. Each check runs in its own process under Windows PowerShell 5.1
(powershell.exe) where that exists, the house's floor for every check, and
under pwsh where it does not, which is the ubuntu job; the shell is named in
the header, so a run under each is the oracle's "under both" (REPO.2,
decision 6).

-WithExtras runs the hardcoded list below of the verifiers that take
arguments, today the thirteen controls, each proving its check on mutants, and
says so separately: pretending a control is interchangeable with a plain
pass/fail scan would hide what each one asserts.

Usage:
  powershell -File tools\run_checks.ps1
  powershell -File tools\run_checks.ps1 -Filter spdx         # only matching names
  powershell -File tools\run_checks.ps1 -ShowAll             # print passing output too
  powershell -File tools\run_checks.ps1 -WithExtras          # also the controls

Exit code: 0 if every check passed AND at least the floor were found;
1 otherwise.
#>

param(
    [string]$Filter = '',
    [switch]$ShowAll,
    [switch]$WithExtras,
    [int]$Floor = 0,
    # A folder to scan instead of this script's own. Its only purpose is to
    # make THIS script testable: a runner that cannot be pointed at a broken
    # tree cannot be shown to go red, and an unverified runner reporting
    # "ALL GREEN" is worse than no runner.
    [string]$ToolsDir = ''
)

$ErrorActionPreference = 'Stop'

$toolsDir = if ($ToolsDir -ne '') { $ToolsDir } else { $PSScriptRoot }
$selfName = Split-Path -Leaf $PSCommandPath

# --- The floor, hand-maintained. ---
# 2026-10-08, REPO.2: 2 - check_host_imports.ps1 (the engine imports exactly
# its allowlist, read off the wasm artifact; the forbidden names first, fetch
# first among them) and check_spdx.ps1 (every tracked file resolves to one
# license through REUSE.toml, every license has its text, every cartridge
# carries its 0BSD header).
# 2026-10-08, KERNEL.5 (laid here): 6 - check_web_offline.ps1 (the page and
# the viewport's source load nothing and link nowhere, the placeholders in
# their places), check_view_fixtures.ps1 (the fixtures are the door's
# records, pinned by hash, never shorter, in oracle 11's order, the
# 10,000-line record the rule's), check_render_oracle.ps1 (the viewport draws
# every cell where the record puts it, under a headless browser at two
# ratios; SKIPPED without a built page or a browser) and
# check_render_floors.ps1 (the owner's measured baseline held to the bars).
# 2026-10-08, ENGINE.1's first slice: 9 - check_cartridge.ps1 (every
# cartridge under cartridges/ holds to docs/SPEC.md section 7, read without an
# engine; the count and each one's rows pinned), check_host_loop.ps1 (the
# host's loop over a fixed log against the fake module, under a headless
# browser at two ratios; SKIPPED without a built page or a browser) and
# check_blit_floors.ps1 (the owner's measured baseline of the blit, the
# engine's second number, held to its bars; empty, and so failing, until the
# owner's first fullscreen run is pasted in).
# 2026-10-09, ENGINE.1's second slice: 11 - check_host_exports.ps1 (the
# engine exports exactly docs/SPEC.md section 8.1's eleven names, read off the
# wasm artifact, the twin of the import check; SKIPPED without one) and
# check_engine_deps.ps1 (AD-5's second sentence on the manifests and the
# lock: the language crate and nothing else, pinned to one commit, never
# frazaro-core).
# 2026-10-09, ENGINE.2: 11 still, no check added - check_host_loop.ps1 holds
# a tenth case, the plane held to the record of the same window, and
# check_blit_floors.ps1 a third case, the frame path over the engine's module,
# failing until the owner's next fullscreen run is pasted in.
# 2026-10-09, CART.1's first slice: 12 - check_frame_floors.ps1 (the owner's
# measured baseline of Life's frames, the soup and the glider gun, natively
# and in the browser, held to floors that never go down, the pin and the
# fixtures the measured ones; empty, and so failing, until the owner's run of
# tools/bench_frames.ps1 is pasted in; and with a built runner, every frame
# held to a hand-written Life and the allocations to their ceilings).
# 2026-10-10, SPEC.3's first slice: 12 still, no check added -
# check_cartridge.ps1 tells a cartridge from its source and a library and
# holds each source to its cartridge's banner, and check_frame_floors.ps1
# carries a fixture rebuilt with the measured rows; the golden, every
# cartridge the pass's expansion of its source, is cargo test's.
# 2026-10-10, SPEC.3's second slice: 12 still, no check added -
# check_host_exports.ps1 holds twelve names, alonzo_expand the twelfth;
# check_web_offline.ps1 holds the sources' and the library's places; and
# check_host_loop.ps1's eleventh case, pass, holds the page's pass to the
# command line's bytes.
# 2026-10-10, ENGINE.3's first slice: 12 still, no check added -
# check_host_loop.ps1's twelfth case, input, holds the Input and Clock
# devices over the input card on the engine's module, its control fifteen
# mutant pages; check_cartridge.ps1 pins four cartridges and four sources.
# 2026-10-10, ENGINE.3's second slice: 12 still, no check added -
# check_host_loop.ps1's thirteenth case, replay, holds the host's recorder and
# player, its control eighteen mutant pages; check_cartridge.ps1 reads a
# cartridge's replay and its golden, its control twenty-nine mutants; and
# check_web_offline.ps1 holds their places, its control thirteen.
# 2026-10-10, ENGINE.4's first slice: 12 still, no check added -
# check_host_loop.ps1's fourteenth case, audio, holds the host's schedule of
# the Audio sheet's four voices to the page's own arithmetic over a double of
# the Web Audio graph, its control twenty-three mutant pages;
# check_cartridge.ps1 pins five cartridges and five sources and judges the
# Audio sheet's value cells, its control thirty-two mutants; and
# check_web_offline.ps1 holds the host to the graph's oscillators and gains,
# its control twenty-one.
# 2026-10-10, ENGINE.4's second slice: 12 still, no check added -
# check_host_loop.ps1's fifteenth case, sound, renders the host's voices into
# an OfflineAudioContext and measures each frame's pitch, loudness, rest and
# onset, its control twenty-four mutant pages, the time constant written in
# milliseconds in the host and the page alike the one only the render hears;
# its replay case and check_cartridge.ps1 hold two replays and two goldens,
# the sound card's beside the input card's; and cargo test plays every
# committed replay to its golden.
# 2026-10-10, CART.1's frame timer, after ENGINE.4's close: 12 still, no check
# added - check_frame_floors.ps1 refuses a row whose rates are no finite
# number above 0, its control fifteen mutants, since the page now times a
# frame quicker than its clock in runs.
# 2026-10-10, ENGINE.1's panel, after ENGINE.4's close: 12 still, no check
# added - the host says when a running loop stops, the replay case holds it,
# and check_host_loop.ps1's control is twenty-five mutant pages.
# 2026-10-11, the pin at vla-lang 0.9.0: 12 still, no check added -
# check_engine_deps.ps1's baseline names 0.9.0 and its checksum;
# check_frame_floors.ps1's allocation ceilings fall to 80 and 5 a frame, and
# its floors are the owner's run over 0.9.0.
# 2026-10-11, CART.2's first slice: 12 still, no check added -
# check_cartridge.ps1 pins six cartridges and six sources, Sand beside them;
# check_frame_floors.ps1 holds six rows, Sand's opening natively and in the
# browser, a row entering the history at the first entry holding it, Sand's
# frames held to a sand by hand and its grains kept, its control seventeen
# mutants of the table and six fake runners; and check_host_loop.ps1's pass
# case holds six sources.
# 2026-10-12, CART.2's third slice and its playtest pass: 12 still, no check
# added - check_host_loop.ps1 holds seventeen cases, slice and pace among
# them, and its control is twenty-seven mutant pages, Z the slice at a half
# and AA the tick on no grid.
# 2026-10-12, CART.2's second slice: 12 still, no check added -
# check_cartridge.ps1 pins three replays and three goldens, Sand's beside the
# cards'; check_host_loop.ps1's replay case plays Sand's to its golden, every
# frame held to the page's sand, and its control is twenty-eight mutant pages,
# AB the brush without its rim.
# 2026-10-12, ENGINE.8's first slice: 12 still, no check added -
# check_host_loop.ps1 holds eighteen cases, grid among them, the grid a grid
# cartridge's Screen draws through the host's viewport held to the record of
# the same window, and its control is thirty-four mutant pages, AC to AH;
# check_cartridge.ps1 pins seven cartridges and seven sources, the grid card's.
# 2026-10-12, CART.4's first slice: 12 still, no check added -
# check_cartridge.ps1 pins eight cartridges and eight sources, Kairos's, and
# check_host_loop.ps1's pass case holds eight sources to the command line.
# 2026-10-12, CART.4's second slice: 12 still, no check added -
# check_cartridge.ps1 pins four replays and four goldens, Kairos's beside
# Sand's and the cards'; check_host_loop.ps1's replay case plays Kairos's to
# its golden, every frame held to the page's Kairos, and its control is
# thirty-five mutant pages, AI the turn a column early.
# 2026-10-14, ENGINE.9, the size ladder: 12 still, no check added -
# check_frame_floors.ps1 holds fourteen rows, the ladder's eight beside the
# six, every row's memory, each rung's cartridge by its digest and every
# fixture's heap bytes under a ceiling, its control twenty mutants of the
# table and nine fake runners.
# 2026-10-14, REPO.4, the first release: 13 - check_crate_package.ps1 (the
# engine crate's package carries the root's LICENSE and NOTICE byte for byte,
# every build-time include of engine/src/ and engine/examples/ stays inside
# the crate, so the package's own tests build, and the manifest names what
# crates.io shows a visitor, with no publish = false); and the pin at
# vla-lang 0.9.3 moves check_engine_deps.ps1's baseline and
# check_frame_floors.ps1's tenth.
$expectedAtLeast = 13
if ($Floor -gt 0) { $expectedAtLeast = $Floor }

# --- The other verifiers, each with the arguments it needs. ---
# Hand-maintained for the same reason: a list that discovers itself would
# quietly stop covering something the day a file was renamed.
$extras = @(
    @{ Script = 'check_host_imports.ps1';  Args = @('-Control'); What = 'REPO.2 import reader and judgment: twelve modules built in memory, an unknown kind, a non-module' },
    @{ Script = 'check_spdx.ps1';          Args = @('-Control'); What = 'REPO.2 license map: a clean scratch tree passes, four mutants fail' },
    @{ Script = 'check_web_offline.ps1';   Args = @('-Control'); What = 'KERNEL.5, ENGINE.1, SPEC.3, ENGINE.3, ENGINE.4 and ENGINE.15 offline doctrine: the template, the three scripts and a page built from them pass, twenty-one mutants fail, eight of them a Web Audio name planted in the host and six a place or a block' },
    @{ Script = 'check_view_fixtures.ps1'; Args = @('-Control'); What = 'KERNEL.5 fixtures: a clean scratch folder passes, four mutants fail each for its own reason' },
    @{ Script = 'check_render_oracle.ps1'; Args = @('-Control'); What = 'KERNEL.5 render oracle: the real page passes, three mutant pages fail under the browser (SKIPPED without one)' },
    @{ Script = 'check_render_floors.ps1'; Args = @('-Control'); What = 'KERNEL.5 render floors: a clean table passes, seven mutants fail' },
    @{ Script = 'check_cartridge.ps1';     Args = @('-Control'); What = 'ENGINE.1, SPEC.3, ENGINE.3, ENGINE.4, CART.2, ENGINE.8, CART.4 and ENGINE.18 cartridges: a clean scratch copy of eight cartridges, Life written to (spec 3) and Life written to (spec 4) with its Camera''s third row pass, thirty-five mutants fail, version 4''s rows a (spec 4) cartridge''s alone, the cartridge, its source, its replay and golden, and the library told apart, the Audio sheet''s values judged, four replays and four goldens' },
    @{ Script = 'check_host_loop.ps1';     Args = @('-Control'); What = 'ENGINE.1, ENGINE.2, SPEC.3, ENGINE.3, ENGINE.4, CART.2, ENGINE.8, CART.4, ENGINE.14, ENGINE.15, ENGINE.16, ENGINE.17, ENGINE.18 and ENGINE.19 host loop: the real page and a game''s page pass, seventy-three mutant pages fail under the browser, thirty-seven of them only over the engine''s module, and the time constant''s only by the sound case''s render (SKIPPED without a browser)' },
    @{ Script = 'check_blit_floors.ps1';   Args = @('-Control'); What = 'ENGINE.1, ENGINE.2, ENGINE.8 and ENGINE.17 blit floors: a clean table of five cases passes, sixteen mutants fail' },
    @{ Script = 'check_host_exports.ps1';  Args = @('-Control'); What = 'ENGINE.1 and SPEC.3 export reader and judgment: nine modules built in memory, a non-module' },
    @{ Script = 'check_engine_deps.ps1';   Args = @('-Control'); What = 'ENGINE.1 dependencies: a scratch copy of the three files passes, its mutants fail (seven for a git pin, eight for a registry pin); of five baselines, a git one and a registry one pass and three fail' },
    @{ Script = 'check_frame_floors.ps1';  Args = @('-Control'); What = 'CART.1, SPEC.3, CART.2 and ENGINE.9 frame floors: a clean table, a reasoned lowering, a row entering the history, a machine of one kind of core, a release of the measured source and a fixture rebuilt with the measured rows pass, twenty mutants fail, a frame read as 0 ms, a row dropped from the history and a rung with no digest among them; an entry added passes, an entry pasted over and one edited fail; nine fake runners, the clean one passes and eight fail, a heap past its ceiling and a rung of another cartridge among them' },
    @{ Script = 'check_crate_package.ps1'; Args = @('-Control'); What = 'REPO.4 the crate''s package: a scratch copy passes, seven mutants fail, a license copy drifted or missing, an include of cartridges/ in a test, a #[path] out of the crate, a manifest without its description or its own readme, and publish = false put back' }
)

# --- The shell each check runs under. ---
$shell = if (Get-Command powershell.exe -ErrorAction SilentlyContinue) { 'powershell.exe' } else { 'pwsh' }

function Invoke-OneScript {
    param([string]$Path, [string[]]$Arguments)
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    # $ErrorActionPreference is 'Stop' for this script's own mistakes, but a
    # CHECK writing to stderr is this script's ordinary business, not an
    # error in it. In Windows PowerShell 5.1, `2>&1` on a native executable
    # wraps each stderr line in a NativeCommandError, which under 'Stop'
    # TERMINATES the runner - so a check that failed loudly would kill the
    # run instead of being reported as FAIL, and the total would never
    # print. Found in Frazaro by trying to make its runner go red.
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $out = & $shell -NoProfile -ExecutionPolicy Bypass -File $Path @Arguments 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $prev
    }
    $sw.Stop()
    return [pscustomobject]@{
        Code    = $code
        Output  = $out
        Seconds = $sw.Elapsed.TotalSeconds
    }
}

$scripts = @(Get-ChildItem -Path (Join-Path $toolsDir 'check_*.ps1') -File |
             Where-Object { $_.Name -ne $selfName } |
             Sort-Object Name)

if ($Filter -ne '') {
    $scripts = @($scripts | Where-Object { $_.Name -like "*$Filter*" })
}

Write-Output "=== ALL STATIC CHECKS (each under $shell) ==="
Write-Output ''

$results = New-Object System.Collections.Generic.List[object]
foreach ($s in $scripts) {
    $r = Invoke-OneScript -Path $s.FullName -Arguments @()
    $results.Add([pscustomobject]@{
        Name = $s.Name; Code = $r.Code; Output = $r.Output; Seconds = $r.Seconds
    })
    $tag = if ($r.Code -eq 0) { 'ok  ' } else { 'FAIL' }
    '  {0}  {1,-44} {2,6:N1}s' -f $tag, $s.Name, $r.Seconds | Write-Output
}

$passed = @($results | Where-Object { $_.Code -eq 0 })
$failed = @($results | Where-Object { $_.Code -ne 0 })

$extraResults = New-Object System.Collections.Generic.List[object]
if ($WithExtras) {
    Write-Output ''
    Write-Output '=== THE OTHER VERIFIERS ==='
    Write-Output ''
    foreach ($e in $extras) {
        $path = Join-Path $toolsDir $e.Script
        if (-not (Test-Path -LiteralPath $path)) {
            $extraResults.Add([pscustomobject]@{
                Name = $e.Script; Code = 1; Output = @("not found at $path"); Seconds = 0
            })
            '  {0}  {1,-44} {2}' -f 'FAIL', ($e.Script + ' ' + ($e.Args -join ' ')), 'NOT FOUND' | Write-Output
            continue
        }
        $r = Invoke-OneScript -Path $path -Arguments $e.Args
        $extraResults.Add([pscustomobject]@{
            Name = ($e.Script + ' ' + ($e.Args -join ' ')).Trim()
            Code = $r.Code; Output = $r.Output; Seconds = $r.Seconds
        })
        $tag = if ($r.Code -eq 0) { 'ok  ' } else { 'FAIL' }
        '  {0}  {1,-44} {2,6:N1}s   {3}' -f $tag, ($e.Script + ' ' + ($e.Args -join ' ')).Trim(), $r.Seconds, $e.What | Write-Output
    }
}

$extraFailed = @($extraResults | Where-Object { $_.Code -ne 0 })

# Anything that failed prints its own tail, so the answer does not need a
# second run to be actionable.
foreach ($f in ($failed + $extraFailed)) {
    Write-Output ''
    Write-Output ("--- $($f.Name) ---")
    $tail = @($f.Output) | Select-Object -Last 20
    foreach ($ln in $tail) { Write-Output "  $ln" }
}

if ($ShowAll) {
    foreach ($p in $passed) {
        Write-Output ''
        Write-Output ("--- $($p.Name) ---")
        foreach ($ln in @($p.Output)) { Write-Output "  $ln" }
    }
}

Write-Output ''
$total = $results.Count
$short = ($Filter -eq '') -and ($total -lt $expectedAtLeast)

if ($Filter -ne '') {
    Write-Output ("=== {0} check(s) matching '{1}': {2} passed, {3} failed ===" -f $total, $Filter, $passed.Count, $failed.Count)
    Write-Output '    (a filtered run does not test the floor - run it unfiltered for that)'
} else {
    Write-Output ("=== {0} checks: {1} passed, {2} failed ===" -f $total, $passed.Count, $failed.Count)
}
if ($WithExtras) {
    Write-Output ("=== {0} other verifier(s): {1} passed, {2} failed ===" -f $extraResults.Count, ($extraResults.Count - $extraFailed.Count), $extraFailed.Count)
}

if ($short) {
    Write-Output ''
    Write-Output ("FLOOR: {0} check(s) found, but {1} were expected. A check has been deleted," -f $total, $expectedAtLeast)
    Write-Output '  renamed out of the check_*.ps1 glob, or moved. That is not a failure any of'
    Write-Output '  them can report, which is why this floor exists. If the reduction is'
    Write-Output '  deliberate, lower $expectedAtLeast in this file and say why.'
}

if ($failed.Count -gt 0 -or $extraFailed.Count -gt 0 -or $short) { exit 1 }
Write-Output ''
Write-Output 'ALL GREEN.'
exit 0
