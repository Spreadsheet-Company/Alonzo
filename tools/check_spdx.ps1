<#
check_spdx.ps1 - the licence map, REUSE.toml, verified against the tree.

WHY: one repository, three licence territories, no directory moves. The map
is REUSE.toml (reuse.software, specification 3.3): path globs resolve every
file to one SPDX identifier, Apache-2.0 for the engine, 0BSD for the
cartridges, CC-BY-4.0 for the documents (CHARTER.md section 9; REARVIEW.md,
REPO.1, decision 2). A map is worth what the last check of it was worth,
and the day a file lands at a path the map does not name it has no licence
at all. This script is Frazaro's tools/check_spdx.ps1 adapted to the three
territories, as REUSE.toml's own comment promised at REPO.2.

WHAT IT HOLDS, four things, none needing a host:
  1. Every tracked file, except the licence texts themselves (LICENSE and
     LICENSES/*), resolves to exactly one identifier through REUSE.toml's
     [[annotations]] tables, later tables winning (the specification's
     ordering rule), a glob's * staying within one path segment and **
     crossing them. Every file and not only those of a listed extension:
     the tree is small, the specification's own lint asks for every file,
     and a file at a new path then fails until the map names it, which is
     the review the map wants.
  2. Every identifier the map uses has its full text in LICENSES/<id>.txt.
  3. Every text file under cartridges/ carries `SPDX-License-Identifier:
     0BSD` in its first twelve lines: a cartridge is made to be copied, and
     the notice travels with the copy, as the 0BSD runtime module's header
     travels into customers' workbooks in Frazaro. Vacuous today; it bites
     at CART.1. Rust sources carry no header, as Frazaro's do not: a Rust
     file's licence is the map's alone.
  4. A header never disagrees with the map.

-Control proves the check on a scratch tree with a synthetic file list, so it
needs no repository: the clean copy passes; a file at a path the map does
not name fails; a licence text removed fails; a cartridge without its header
fails; a cartridge whose territory the map moves fails as a disagreement.
Each mutant proves it applied before the check is asked.

House style (tools/check_*.ps1): PowerShell 5.1 and pwsh alike, host-free, a
hardcoded and reviewable baseline. Exit 0 clean, exit 1 with every failure
listed.

Usage:  powershell -File tools\check_spdx.ps1
        powershell -File tools\check_spdx.ps1 -Control
#>
param(
    [switch]$Control
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

# ---- baseline: the territories whose files carry a load-bearing header ----
$headerRules = @(
    @{ Under = 'cartridges/'; Id = '0BSD'; Why = 'a cartridge is made to be copied, and the notice travels with the copy' }
)
# The files a header can live in; the rest of a territory (an image, a sound)
# resolves through the map alone.
$headerExt = @('.vla', '.md', '.txt', '.toml', '.json', '.js', '.html', '.css', '.ps1', '.rs', '.csv')
$headerLines = 12

function ConvertTo-GlobRegex([string]$glob) {
    $r = [regex]::Escape($glob)
    $r = $r -replace '\\\*\\\*/', '(.*/)?'   # **/  -> any directory depth
    $r = $r -replace '\\\*\\\*', '.*'         # **   -> anything
    $r = $r -replace '\\\*', '[^/]*'          # *    -> within one segment
    return '^' + $r + '$'
}

# The subset of REUSE.toml this project writes: [[annotations]] tables, path
# as a list or one string, and the identifier. Returns one record per table.
function Read-Annotations([string]$ReusePath) {
    $annotations = New-Object System.Collections.Generic.List[object]
    $current = $null
    foreach ($line in [System.IO.File]::ReadAllLines($ReusePath)) {
        $t = $line.Trim()
        if ($t -eq '[[annotations]]') {
            if ($current) { $annotations.Add($current) }
            $current = @{ Paths = @(); Id = $null }
            continue
        }
        if (-not $current) { continue }
        if ($t -match '^path\s*=\s*\[(.*)\]$') {
            $current.Paths = @([regex]::Matches($Matches[1], '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value })
        } elseif ($t -match '^path\s*=\s*"([^"]+)"$') {
            $current.Paths = @($Matches[1])
        } elseif ($t -match '^SPDX-License-Identifier\s*=\s*"([^"]+)"$') {
            $current.Id = $Matches[1]
        }
    }
    if ($current) { $annotations.Add($current) }
    return ,$annotations
}

# The check itself over a root and the files to hold to it. Returns one
# record: Failures (one line each), Resolved (path to identifier), Headers
# (the files whose header was read).
function Get-Report([string]$Root, [string[]]$Files) {
    $failures = New-Object System.Collections.Generic.List[string]
    $resolved = New-Object System.Collections.Hashtable   # case-sensitive, unlike @{}
    $headers = New-Object System.Collections.Generic.List[string]

    $reusePath = Join-Path $Root 'REUSE.toml'
    if (-not (Test-Path -LiteralPath $reusePath)) {
        $failures.Add('REUSE.toml missing')
        return @{ Failures = $failures; Resolved = $resolved; Headers = $headers }
    }
    $annotations = Read-Annotations $reusePath
    if ($annotations.Count -eq 0) { $failures.Add('REUSE.toml: no [[annotations]] tables found') }

    # ---- 2. every identifier has its text ----
    $ids = @($annotations | ForEach-Object { $_.Id } | Where-Object { $_ } | Sort-Object -Unique)
    foreach ($id in $ids) {
        $p = Join-Path $Root ('LICENSES/' + $id + '.txt')
        if (-not (Test-Path -LiteralPath $p)) { $failures.Add("LICENSES/$id.txt missing (REUSE.toml names $id)") }
    }

    # ---- 1. every tracked file resolves to one licence ----
    if ($Files.Count -eq 0) { $failures.Add('no tracked files were listed; is this the repository?') }
    foreach ($f in $Files) {
        if ($f -ceq 'LICENSE' -or $f -clike 'LICENSES/*') { continue }
        $match = $null
        foreach ($a in $annotations) {
            foreach ($g in $a.Paths) {
                if ($f -cmatch (ConvertTo-GlobRegex $g)) { $match = $a.Id }   # later tables win
            }
        }
        if (-not $match) { $failures.Add("uncovered: $f matches no REUSE.toml annotation; name its path in the map") }
        else { $resolved[$f] = $match }
    }

    # ---- 3 and 4. the load-bearing headers, by territory ----
    foreach ($rule in $headerRules) {
        $want = 'SPDX-License-Identifier: ' + $rule.Id
        foreach ($f in $Files) {
            if (-not $f.StartsWith($rule.Under, [System.StringComparison]::Ordinal)) { continue }
            $ext = [System.IO.Path]::GetExtension($f).ToLowerInvariant()
            if ($headerExt -notcontains $ext) { continue }
            $p = Join-Path $Root $f
            if (-not (Test-Path -LiteralPath $p)) { $failures.Add("missing: $f is tracked and not on disk"); continue }
            $headers.Add($f)
            $head = @(Get-Content -LiteralPath $p -TotalCount $headerLines)
            $has = $false
            foreach ($l in $head) { if ($l.Contains($want)) { $has = $true } }
            if (-not $has) { $failures.Add("header: $f lacks '$want' in its first $headerLines lines ($($rule.Why))") }
            if ($resolved.ContainsKey($f) -and $resolved[$f] -cne $rule.Id) {
                $failures.Add("disagreement: $f must carry $($rule.Id) and REUSE.toml resolves it to $($resolved[$f])")
            }
        }
    }
    return @{ Failures = $failures; Resolved = $resolved; Headers = $headers }
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_spdx_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        Copy-Item -LiteralPath (Join-Path $repoRoot 'REUSE.toml') -Destination (Join-Path $tmp 'REUSE.toml')
        Copy-Item -LiteralPath (Join-Path $repoRoot 'LICENSES') -Destination (Join-Path $tmp 'LICENSES') -Recurse
        $tree = @{
            'README.md'                      = "# A readme`n"
            'engine/src/lib.rs'              = "//! the engine`n"
            'tools/check_x.ps1'              = "# a check`n"
            '.github/workflows/checks.yml'   = "name: checks`n"
            'cartridges/life/life.vla'       = "; SPDX-License-Identifier: 0BSD`n(life)`n"
            'cartridges/life/sprites.png'    = 'not a png; exempt from the header rule by its extension'
        }
        foreach ($rel in $tree.Keys) {
            $p = Join-Path $tmp $rel
            New-Item -ItemType Directory -Path (Split-Path -Parent $p) -Force | Out-Null
            [System.IO.File]::WriteAllText($p, $tree[$rel], $utf8)
        }
        $files = @('.gitignore', 'README.md', 'engine/src/lib.rs', 'tools/check_x.ps1', '.github/workflows/checks.yml', 'cartridges/life/life.vla', 'cartridges/life/sprites.png', 'LICENSE', 'LICENSES/0BSD.txt')

        $verdicts = New-Object System.Collections.Generic.List[string]
        $ok = $true
        $clean = Get-Report $tmp $files
        if ($clean.Failures.Count -eq 0 -and $clean.Resolved.Count -eq 7 -and $clean.Headers.Count -eq 1) {
            $verdicts.Add('the clean copy: passes, 7 files resolved, 1 header read')
        } else {
            $ok = $false
            $verdicts.Add("the clean copy: $($clean.Failures.Count) problem(s), $($clean.Resolved.Count) resolved, $($clean.Headers.Count) header(s); wanted 0, 7, 1: $($clean.Failures -join ' | ')")
        }

        $life = Join-Path $tmp 'cartridges/life/life.vla'
        $zero = Join-Path $tmp 'LICENSES/0BSD.txt'
        $reuse = Join-Path $tmp 'REUSE.toml'
        $life0 = [System.IO.File]::ReadAllText($life)
        $zero0 = [System.IO.File]::ReadAllBytes($zero)
        $reuse0 = [System.IO.File]::ReadAllText($reuse)
        $mutants = @(
            @{ Name = 'a file at a path the map does not name'
               Apply = { $p = Join-Path $tmp 'stray/thing.rs'; New-Item -ItemType Directory -Path (Split-Path -Parent $p) -Force | Out-Null; [System.IO.File]::WriteAllText($p, "// stray`n", $utf8); $script:mutFiles = $files + 'stray/thing.rs' }
               Applied = { (Test-Path -LiteralPath (Join-Path $tmp 'stray/thing.rs')) -and ($script:mutFiles -ccontains 'stray/thing.rs') }
               Want = 'uncovered: stray/thing.rs' },
            @{ Name = 'a licence text removed'
               Apply = { Remove-Item -LiteralPath $zero -Force; $script:mutFiles = $files }
               Applied = { -not (Test-Path -LiteralPath $zero) }
               Want = 'LICENSES/0BSD.txt missing' },
            @{ Name = 'a cartridge without its header'
               Apply = { [System.IO.File]::WriteAllText($life, "(life)`n", $utf8); $script:mutFiles = $files }
               Applied = { -not ([System.IO.File]::ReadAllText($life)).Contains('SPDX-License-Identifier') }
               Want = 'header: cartridges/life/life.vla lacks' },
            @{ Name = 'a cartridge whose territory the map moves'
               Apply = { [System.IO.File]::WriteAllText($reuse, $reuse0.Replace('SPDX-License-Identifier = "0BSD"', 'SPDX-License-Identifier = "Apache-2.0"'), $utf8); $script:mutFiles = $files }
               Applied = { ([regex]::Matches($reuse0, 'SPDX-License-Identifier = "0BSD"')).Count -eq 1 -and -not ([System.IO.File]::ReadAllText($reuse)).Contains('"0BSD"') }
               Want = 'disagreement: cartridges/life/life.vla must carry 0BSD and REUSE.toml resolves it to Apache-2.0' }
        )
        foreach ($mu in $mutants) {
            & $mu.Apply
            $applied = & $mu.Applied
            if (-not $applied) {
                $ok = $false
                $verdicts.Add("$($mu.Name): the mutation did not apply")
            } else {
                $r = Get-Report $tmp $script:mutFiles
                $hit = $false
                foreach ($x in $r.Failures) { if ($x.Contains($mu.Want)) { $hit = $true } }
                if ($hit) { $verdicts.Add("$($mu.Name): fails, as it should ($($r.Failures.Count): $($r.Failures[0]))") }
                elseif ($r.Failures.Count -gt 0) { $ok = $false; $verdicts.Add("$($mu.Name): fails, but without '$($mu.Want)': $($r.Failures -join ' | ')") }
                else { $ok = $false; $verdicts.Add("$($mu.Name): PASSED but should fail") }
            }
            # put the tree back
            [System.IO.File]::WriteAllText($life, $life0, $utf8)
            [System.IO.File]::WriteAllBytes($zero, $zero0)
            [System.IO.File]::WriteAllText($reuse, $reuse0, $utf8)
            if (Test-Path -LiteralPath (Join-Path $tmp 'stray')) { Remove-Item -LiteralPath (Join-Path $tmp 'stray') -Recurse -Force }
        }
        foreach ($v in $verdicts) { Write-Host ('control: ' + $v) }
        if ($ok) { Write-Host 'OK: control: the clean copy passes and each of the four mutants fails for its own reason'; exit 0 }
        Write-Host 'FAIL: control: the check did not behave as the header says'
        exit 1
    } finally {
        Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Push-Location $repoRoot
try { $tracked = @(git ls-files); $gitCode = $LASTEXITCODE } finally { Pop-Location }
if ($gitCode -ne 0) {
    Write-Host "FAIL: git ls-files exited $gitCode in $repoRoot; the check reads the tracked tree and needs the repository"
    exit 1
}
$report = Get-Report $repoRoot $tracked
$summary = ($report.Resolved.Values | Group-Object | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ', '
Write-Host "check_spdx: $($report.Resolved.Count) tracked files resolved ($summary); $($report.Headers.Count) cartridge header(s) read"
if ($report.Failures.Count -gt 0) {
    Write-Host "FAIL: $($report.Failures.Count) problem(s)"
    $report.Failures | ForEach-Object { Write-Host "  - $_" }
    exit 1
}
Write-Host 'OK: every tracked file has one licence, every licence has its text, every cartridge carries its header'
exit 0
