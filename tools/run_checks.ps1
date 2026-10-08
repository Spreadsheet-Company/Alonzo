<#
run_checks.ps1 - runs every tools\check_*.ps1 and reports one total.

WHY: in Frazaro's shape, where there are fifty-two of them. Running checks one
at a time is a page of scrollback in which a single red line is easy to walk
past, and "they all seemed to pass" is not a result anybody can quote in a
commit message. This prints one line per check and one total, and its own
exit code is the answer. CONTRIBUTING.md names it as what to run before a
pull request, and .github/workflows/checks.yml runs it on every push, once
under Windows PowerShell 5.1 and once under pwsh beside the wasm it builds.

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
arguments, today the two controls, each proving its check on mutants, and
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
# licence through REUSE.toml, every licence has its text, every cartridge
# carries its 0BSD header).
$expectedAtLeast = 2
if ($Floor -gt 0) { $expectedAtLeast = $Floor }

# --- The other verifiers, each with the arguments it needs. ---
# Hand-maintained for the same reason: a list that discovers itself would
# quietly stop covering something the day a file was renamed.
$extras = @(
    @{ Script = 'check_host_imports.ps1'; Args = @('-Control'); What = 'REPO.2 import reader and judgment: twelve modules built in memory, an unknown kind, a non-module' },
    @{ Script = 'check_spdx.ps1';         Args = @('-Control'); What = 'REPO.2 licence map: a clean scratch tree passes, four mutants fail' }
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
