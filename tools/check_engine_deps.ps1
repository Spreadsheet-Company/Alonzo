<#
check_engine_deps.ps1 - the engine crate depends on the language crate and
nothing else, pinned to one commit or one version, and never on Frazaro's
core.

WHY (ENGINE.1's second slice, 2026-10-09): AD-5's second sentence, "the
engine crate depends on the language crate and nothing else", and AD-1's
"alonzo consumes vla-lang and never frazaro-core", are facts of three files,
the workspace's Cargo.toml, the engine's engine/Cargo.toml and Cargo.lock,
and this check holds them there on every push, as tools/check_host_imports.ps1
holds AD-5's first sentence on the artifact. The slice that wrote the first
dependency wrote this check with it. A second dependency, a build script's,
a test's, or one pulled in by the language crate itself (it has none, its
own contract), shows in the lock and fails here by name.

THE PIN, the owner's route of 2026-10-09: vla-lang by git, at a commit of
Frazaro's, KERNEL.24's since ENGINE.2's second slice (the plane kept at the
frame's end; KERNEL.22's before it), until vla-lang is on crates.io; a move
of the pin is the two baseline lines below, which the control's mutants are
read off, raised in the same commit as Cargo.toml's line and the lock; then
at crates.io the baseline below
becomes the exact registry pin "=0.9.0" with the registry's source and a
checksum, in the same commit as Cargo.toml's line (REARVIEW.md, ENGINE.1's
second slice, decision 1). A rev and never a branch or a tag, since a branch
moves; an exact version and never a range, since a range moves too.

WHAT IT READS, line by line, no TOML library (none ships with PowerShell):
  1. Cargo.toml: the [workspace.dependencies] table holds one entry, vla-lang,
     whose value is the baseline's text, spaces aside.
  2. engine/Cargo.toml: the [dependencies] table holds one line,
     `vla-lang.workspace = true`, and the file has no other table of
     dependencies ([dev-dependencies], [build-dependencies], a target's).
  3. Cargo.lock: exactly two [[package]] entries, alonzo with no source (the
     workspace's own) and vla-lang at the baseline's source; alonzo depends
     on vla-lang alone.
  4. frazaro-core named by no table line of the two manifests and by no
     locked package (AD-1), told in its own line; the manifests' comments
     name it to say why, and are not read.

-Control proves the reading on a scratch copy of the three files: the copy
passes, then seven mutants each fail for their own reason, each asserting its
anchor once and proving it applied before the check is asked: a second
dependency in the engine's table, a [dev-dependencies] table, the pin moved
to a branch, a range pin, the lock at another commit, frazaro-core in the
lock, and a second entry in the workspace's table.

House style (tools/check_*.ps1): PowerShell 5.1 and pwsh alike, host-free, a
hardcoded and reviewable baseline; no cargo needed. Exit 0 clean; exit 1 with
every problem named.

Usage:  powershell -File tools\check_engine_deps.ps1
        powershell -File tools\check_engine_deps.ps1 -Control
#>
param(
    [string]$Root = '',
    [switch]$Control
)

$ErrorActionPreference = 'Stop'
if ($Root -eq '') { $Root = Split-Path -Parent $PSScriptRoot }

# --- The baseline: the language crate's pin, as Cargo.toml writes it and as
#     Cargo.lock resolves it. The two lines are one fact, raised together. ---
$langSpec = '{ git = "https://github.com/Spreadsheet-Company/Frazaro", rev = "c0686a9" }'
$langSource = 'git+https://github.com/Spreadsheet-Company/Frazaro?rev=c0686a9#c0686a90a977323bd27220034734d4af46ee884d'

function Get-Lines([string]$path) {
    $text = [System.IO.File]::ReadAllText($path)
    return ,($text -split "`r?`n")
}

# The key = value lines of each table, keyed by the table's header, comments
# and blank lines dropped; a header seen twice keeps both tables' lines.
function Get-Tables([string]$path) {
    $tables = [ordered]@{}
    $current = ''
    $tables[$current] = New-Object System.Collections.Generic.List[string]
    foreach ($raw in (Get-Lines $path)) {
        $line = $raw.Trim()
        if ($line -eq '' -or $line.StartsWith('#')) { continue }
        if ($line -match '^\[\[?([^\]]+)\]\]?$') {
            $current = $Matches[1].Trim()
            if (-not $tables.Contains($current)) { $tables[$current] = New-Object System.Collections.Generic.List[string] }
            continue
        }
        $tables[$current].Add($line)
    }
    return $tables
}

function Squeeze([string]$s) { return ($s -replace '\s+', '') }

# The [[package]] entries of a lock file: name, version, source, checksum and
# dependencies, one record each.
function Get-Packages([string]$path) {
    $packages = New-Object System.Collections.Generic.List[object]
    $p = $null; $inDeps = $false
    foreach ($raw in (Get-Lines $path)) {
        $line = $raw.Trim()
        if ($line -eq '[[package]]') {
            $p = [pscustomobject]@{ Name = ''; Version = ''; Source = ''; Checksum = ''; Deps = (New-Object System.Collections.Generic.List[string]) }
            $packages.Add($p); $inDeps = $false; continue
        }
        if ($null -eq $p) { continue }
        if ($inDeps) {
            if ($line -eq ']') { $inDeps = $false; continue }
            $d = $line.Trim(',').Trim().Trim('"')
            if ($d -ne '') { $p.Deps.Add($d) }
            continue
        }
        if ($line -match '^name\s*=\s*"([^"]*)"$') { $p.Name = $Matches[1] }
        elseif ($line -match '^version\s*=\s*"([^"]*)"$') { $p.Version = $Matches[1] }
        elseif ($line -match '^source\s*=\s*"([^"]*)"$') { $p.Source = $Matches[1] }
        elseif ($line -match '^checksum\s*=\s*"([^"]*)"$') { $p.Checksum = $Matches[1] }
        elseif ($line -match '^dependencies\s*=\s*\[\s*$') { $inDeps = $true }
        elseif ($line -match '^dependencies\s*=\s*\[(.*)\]$') {
            foreach ($d in ($Matches[1] -split ',')) { $d = $d.Trim().Trim('"'); if ($d -ne '') { $p.Deps.Add($d) } }
        }
    }
    return ,$packages
}

# Every problem of the tree at $dir, one line each.
function Get-Problems([string]$dir) {
    $out = New-Object System.Collections.Generic.List[string]
    $ws = Join-Path $dir 'Cargo.toml'
    $eng = Join-Path (Join-Path $dir 'engine') 'Cargo.toml'
    $lock = Join-Path $dir 'Cargo.lock'
    foreach ($f in @($ws, $eng, $lock)) {
        if (-not (Test-Path -LiteralPath $f)) { $out.Add("missing file: $f"); return ,$out }
    }

    # 1. The workspace's table.
    $wsTables = Get-Tables $ws
    # @() around the if: a list of one returned through an expression is
    # unrolled to its string, and [0] would then read a character.
    $wsDeps = @(if ($wsTables.Contains('workspace.dependencies')) { $wsTables['workspace.dependencies'] })
    if ($wsDeps.Count -ne 1) {
        $out.Add("Cargo.toml: [workspace.dependencies] holds $($wsDeps.Count) entr$(if ($wsDeps.Count -eq 1) { 'y' } else { 'ies' }); AD-5 allows one, vla-lang: $($wsDeps -join ' | ')")
    }
    $lang = @($wsDeps | Where-Object { $_ -match '^vla-lang\s*=' })
    if ($lang.Count -ne 1) {
        $out.Add('Cargo.toml: [workspace.dependencies] does not pin vla-lang once')
    } else {
        $spec = ($lang[0] -replace '^vla-lang\s*=\s*', '')
        if ((Squeeze $spec) -cne (Squeeze $langSpec)) {
            $shape = if ($spec -match 'branch\s*=') { 'a branch, which moves' } elseif ($spec -match 'tag\s*=') { 'a tag, which can be moved' } elseif ($spec -match '^"[^=]') { 'a range of versions, which moves' } else { 'another pin' }
            $out.Add("Cargo.toml: vla-lang is pinned as $spec, $shape; the baseline is $langSpec")
        }
    }

    # 2. The engine's tables.
    $engTables = Get-Tables $eng
    $engDeps = @(if ($engTables.Contains('dependencies')) { $engTables['dependencies'] })
    if ($engDeps.Count -ne 1 -or (Squeeze $engDeps[0]) -cne 'vla-lang.workspace=true') {
        $out.Add("engine/Cargo.toml: [dependencies] holds $($engDeps.Count) line(s), where AD-5 allows one, vla-lang.workspace = true: $($engDeps -join ' | ')")
    }
    foreach ($t in $engTables.Keys) {
        if ($t -ne 'dependencies' -and $t -match 'dependencies') { $out.Add("engine/Cargo.toml: a [$t] table; the engine depends on the language crate and nothing else, its tests and its build included") }
    }

    # 3. The lock.
    $packages = Get-Packages $lock
    $names = @($packages | ForEach-Object { $_.Name })
    if ($packages.Count -ne 2) { $out.Add("Cargo.lock: $($packages.Count) package(s), $($names -join ', '); AD-5 allows two, alonzo and vla-lang") }
    $alonzo = @($packages | Where-Object { $_.Name -ceq 'alonzo' })
    if ($alonzo.Count -ne 1) { $out.Add('Cargo.lock: no single alonzo package') }
    else {
        if ($alonzo[0].Source -ne '') { $out.Add("Cargo.lock: alonzo has a source, $($alonzo[0].Source); it is the workspace's own") }
        if (($alonzo[0].Deps -join ',') -cne 'vla-lang') { $out.Add("Cargo.lock: alonzo depends on $($alonzo[0].Deps -join ', '); AD-5 allows vla-lang alone") }
    }
    $vla = @($packages | Where-Object { $_.Name -ceq 'vla-lang' })
    if ($vla.Count -ne 1) { $out.Add('Cargo.lock: no single vla-lang package') }
    else {
        if ($vla[0].Source -cne $langSource) { $out.Add("Cargo.lock: vla-lang resolves to $($vla[0].Source); the baseline is $langSource") }
        if ($vla[0].Deps.Count -gt 0) { $out.Add("Cargo.lock: vla-lang depends on $($vla[0].Deps -join ', '); the language crate has no dependency") }
        if ($vla[0].Source.StartsWith('registry+') -and $vla[0].Checksum -eq '') { $out.Add('Cargo.lock: vla-lang comes from a registry with no checksum') }
    }

    # 4. AD-1, told in its own line: a table's line or a locked package, never
    #    a comment, since the manifests' comments name the core to say why.
    foreach ($pair in @(@('Cargo.toml', $wsTables), @('engine/Cargo.toml', $engTables))) {
        foreach ($t in $pair[1].Keys) {
            foreach ($l in $pair[1][$t]) {
                if ($l -match 'frazaro-core') { $out.Add("$($pair[0]): [$t] names frazaro-core, $l; the engine consumes vla-lang and never Frazaro's core (AD-1)") }
            }
        }
    }
    if ($names -contains 'frazaro-core') { $out.Add("Cargo.lock: locks frazaro-core; the engine consumes vla-lang and never Frazaro's core (AD-1)") }
    return ,$out
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_deps_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path (Join-Path $tmp 'engine') -Force | Out-Null
    $verdicts = New-Object System.Collections.Generic.List[string]
    $ok = $true
    try {
        $files = @{ 'Cargo.toml' = 'Cargo.toml'; 'engine/Cargo.toml' = 'engine/Cargo.toml'; 'Cargo.lock' = 'Cargo.lock' }
        $texts = @{}
        foreach ($k in $files.Keys) { $texts[$k] = [System.IO.File]::ReadAllText((Join-Path $Root $files[$k])) }
        function Write-Copy($t) {
            foreach ($k in $t.Keys) { [System.IO.File]::WriteAllText((Join-Path $tmp $k), $t[$k], (New-Object System.Text.UTF8Encoding($false))) }
        }
        Write-Copy $texts
        $clean = Get-Problems $tmp
        if ($clean.Count -eq 0) { $verdicts.Add('the copy as it stands: passes, as it should') }
        else { $ok = $false; $verdicts.Add("the copy as it stands: FAILED but should pass: $($clean -join ' | ')") }

        $commit = ([regex]::Match($langSource, '#([0-9a-f]{40})$')).Groups[1].Value
        $revText = ([regex]::Match($langSpec, 'rev = "[0-9a-f]+"')).Value
        $mutants = @(
            @{ Name = 'a second dependency in the engine';  File = 'engine/Cargo.toml'; From = 'vla-lang.workspace = true'; To = "vla-lang.workspace = true`nserde = `"1`""; Want = 'engine/Cargo.toml: [dependencies] holds 2 line(s)' },
            @{ Name = 'a [dev-dependencies] table';         File = 'engine/Cargo.toml'; From = 'vla-lang.workspace = true'; To = "vla-lang.workspace = true`n`n[dev-dependencies]`nproptest = `"1`""; Want = 'a [dev-dependencies] table' },
            @{ Name = 'the pin moved to a branch';          File = 'Cargo.toml';        From = $revText;                   To = 'branch = "main"'; Want = 'a branch, which moves' },
            @{ Name = 'a range pin';                        File = 'Cargo.toml';        From = $langSpec;                  To = '"0.9"'; Want = 'a range of versions, which moves' },
            @{ Name = 'the lock at another commit';         File = 'Cargo.lock';        From = $commit;                    To = ('0' * 40); Want = 'Cargo.lock: vla-lang resolves to' },
            @{ Name = 'frazaro-core in the lock';           File = 'Cargo.lock';        From = '[[package]]';              To = "[[package]]`nname = `"frazaro-core`"`nversion = `"0.8.0`"`n`n[[package]]"; Want = "Cargo.lock: locks frazaro-core; the engine consumes vla-lang and never Frazaro's core (AD-1)" },
            @{ Name = 'a second entry in the workspace''s table'; File = 'Cargo.toml';   From = "vla-lang = $langSpec";     To = "vla-lang = $langSpec`nfrazaro-core = `"=0.8.0`""; Want = 'Cargo.toml: [workspace.dependencies] holds 2 entries' }
        )
        foreach ($m in $mutants) {
            $t = @{}
            foreach ($k in $texts.Keys) { $t[$k] = $texts[$k] }
            $hits = ([regex]::Matches($t[$m.File], [regex]::Escape($m.From))).Count
            if ($hits -lt 1) { $ok = $false; $verdicts.Add("$($m.Name): the anchor is not in $($m.File)"); continue }
            $idx = $t[$m.File].IndexOf($m.From)
            $t[$m.File] = $t[$m.File].Substring(0, $idx) + $m.To + $t[$m.File].Substring($idx + $m.From.Length)
            if ($t[$m.File] -ceq $texts[$m.File]) { $ok = $false; $verdicts.Add("$($m.Name): the mutant did not apply"); continue }
            Write-Copy $t
            $problems = Get-Problems $tmp
            $hit = @($problems | Where-Object { $_.Contains($m.Want) }).Count -gt 0
            if ($problems.Count -gt 0 -and $hit) { $verdicts.Add("$($m.Name): fails, as it should ($($problems.Count): $($problems -join ' | '))") }
            elseif ($problems.Count -eq 0) { $ok = $false; $verdicts.Add("$($m.Name): PASSED but should fail") }
            else { $ok = $false; $verdicts.Add("$($m.Name): fails, but without '$($m.Want)': $($problems -join ' | ')") }
        }
    } finally {
        Remove-Item -Recurse -Force -LiteralPath $tmp -ErrorAction SilentlyContinue
    }
    foreach ($v in $verdicts) { Write-Host ('control: ' + $v) }
    if ($ok) {
        Write-Host "OK: control: the copy passes and $($mutants.Count) mutants fail, each for its own reason"
        exit 0
    }
    Write-Host 'FAIL: control: the reading did not behave as the header says'
    exit 1
}

$problems = Get-Problems $Root
if ($problems.Count -gt 0) {
    Write-Host "FAIL: the engine's dependencies are not AD-5's; $($problems.Count) problem(s)"
    foreach ($p in $problems) { Write-Host "  ! $p" }
    exit 1
}
Write-Host "OK: the engine depends on vla-lang alone, pinned at $langSpec and locked at $langSource; frazaro-core named nowhere (AD-1, AD-5)"
exit 0
