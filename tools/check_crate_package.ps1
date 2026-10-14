<#
check_crate_package.ps1 - what keeps the engine crate publishable: its
package carries the License and the NOTICE, every build-time include stays
inside the crate, and the manifest names what crates.io shows a visitor.

WHY (REPO.4, the first release, 2026-10-14): a package is the crate's
directory and nothing beside it. The repository's LICENSE and NOTICE sit at
its root, beside the crate, so a package published without copies holds
neither, and whoever passes a crate on owes the next recipient the License
and the NOTICE's attributions (Apache-2.0 section 4); every package of
vla-lang before 0.9.3 held neither, as this release's assessment found
(Frazaro's 8993a7e copied them in). And the engine's tests read the
repository's cartridges/, which a package does not carry: nine include_str!
calls of cartridges/ in the test modules kept `cargo test` over the package
from building at all, though `cargo package` verifies the library alone and
passed. Since REPO.4 those tests read cartridges/ at run time and stand down
by name without it (engine/src/repository.rs, the owner's second way), and
this check keeps a new include from bringing the failure back; CI's crate
job runs the package's own tests beside it. The twin of Frazaro's
check_crate_package.ps1, with the licence half of its check_crate_data.ps1.

WHAT IT HOLDS:
  1. engine/LICENSE and engine/NOTICE are the root's LICENSE and NOTICE byte
     for byte; a drift is named with the Copy-Item that mends it, never an
     edit of the copy.
  2. No include_str!, include_bytes! or #[path] in engine/src/ or
     engine/examples/ names a file outside engine/: each path, resolved
     against the file that names it, as rustc resolves it, stays under the
     crate's directory.
  3. engine/Cargo.toml's [package] names a description, a readme the crate's
     directory holds, keywords and categories, and its license and
     repository by the workspace's, which Cargo.toml's [workspace.package]
     gives; and it says no `publish = false`, since the crate is published
     from 0.1.0.

-Control proves the reading on a scratch copy of the files it reads: the
copy passes, then seven mutants each fail for their own reason, each
asserting its anchor and that it applied: a NOTICE copy one byte longer, a
LICENSE copy missing, an include_str! of the repository's cartridges/ in a
test module, a #[path] out of the crate in an example, a manifest with no
description, a readme outside the crate, and `publish = false` put back.

House style (tools/check_*.ps1): PowerShell 5.1 and pwsh alike, host-free,
no cargo and no network; exit 0 clean, exit 1 with every problem named.

Usage:  powershell -File tools\check_crate_package.ps1
        powershell -File tools\check_crate_package.ps1 -Control
#>
param(
    [string]$Root = '',
    [switch]$Control
)

$ErrorActionPreference = 'Stop'
if ($Root -eq '') { $Root = Split-Path -Parent $PSScriptRoot }

# --- The copies the package carries, each its source at the root. ---
$copies = @(
    @{ Copy = 'engine/LICENSE'; Source = 'LICENSE' },
    @{ Copy = 'engine/NOTICE'; Source = 'NOTICE' }
)
$expectedCopies = 2   # the License's text and the NOTICE (REPO.4, 2026-10-14)

# The key = value lines of each table, keyed by the table's header, comments
# and blank lines dropped (check_engine_deps.ps1's reading).
function Get-Tables([string]$path) {
    $tables = [ordered]@{}
    $current = ''
    $tables[$current] = New-Object System.Collections.Generic.List[string]
    foreach ($raw in ([System.IO.File]::ReadAllText($path) -split "`r?`n")) {
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

# The value of a key in a table's lines, or $null.
function Get-Key($lines, [string]$key) {
    foreach ($l in $lines) {
        if ($l -match ('^' + [regex]::Escape($key) + '\s*=\s*(.+)$')) { return $Matches[1].Trim() }
    }
    return $null
}

# Every problem of the tree at $dir, one line each.
function Get-Problems([string]$dir) {
    $out = New-Object System.Collections.Generic.List[string]
    $full = [System.IO.Path]::GetFullPath($dir).TrimEnd('\', '/')
    $crateDir = [System.IO.Path]::GetFullPath((Join-Path $full 'engine')).TrimEnd('\', '/')

    # 1. The copies, byte for byte.
    if ($copies.Count -ne $expectedCopies) { $out.Add("the table holds $($copies.Count) copies, not the $expectedCopies pinned here") }
    foreach ($c in $copies) {
        $src = Join-Path $full $c.Source
        $dst = Join-Path $full $c.Copy
        $mend = "Copy-Item -LiteralPath $($c.Source) -Destination $($c.Copy)"
        if (-not (Test-Path -LiteralPath $src)) { $out.Add("$($c.Source) is missing, the source of $($c.Copy)"); continue }
        if (-not (Test-Path -LiteralPath $dst)) { $out.Add("$($c.Copy) is missing, so the package would carry no $($c.Source); mend with $mend"); continue }
        $a = [System.IO.File]::ReadAllBytes($src)
        $b = [System.IO.File]::ReadAllBytes($dst)
        if ([Convert]::ToBase64String($a) -cne [Convert]::ToBase64String($b)) {
            $out.Add("$($c.Copy) is not $($c.Source) byte for byte ($($b.Length) bytes against $($a.Length)); mend with $mend, never an edit of the copy")
        }
    }

    # 2. Every build-time include inside the crate.
    $includes = 0
    foreach ($sub in @('src', 'examples')) {
        $folder = Join-Path $crateDir $sub
        if (-not (Test-Path -LiteralPath $folder)) { continue }
        foreach ($f in @(Get-ChildItem -LiteralPath $folder -Recurse -File -Filter '*.rs')) {
            $rel = $f.FullName.Substring($full.Length + 1).Replace('\', '/')
            $lines = [System.IO.File]::ReadAllLines($f.FullName)
            for ($i = 0; $i -lt $lines.Count; $i++) {
                foreach ($m in [regex]::Matches($lines[$i], '(include_str|include_bytes)!\s*\(\s*"([^"]+)"|#\[path\s*=\s*"([^"]+)"\]')) {
                    $includes++
                    $named = if ($m.Groups[2].Success) { $m.Groups[2].Value } else { $m.Groups[3].Value }
                    $kind = if ($m.Groups[1].Success) { $m.Groups[1].Value + '!' } else { '#[path]' }
                    $resolved = [System.IO.Path]::GetFullPath((Join-Path $f.DirectoryName $named))
                    $inside = $resolved.StartsWith($crateDir + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)
                    if (-not $inside) {
                        $out.Add("${rel}:$($i + 1): $kind names $named, outside the crate's directory, which a package does not carry; a test reads the repository at run time through engine/src/repository.rs and stands down without it")
                    }
                }
            }
        }
    }

    # 3. The manifest.
    $eng = Join-Path $crateDir 'Cargo.toml'
    $ws = Join-Path $full 'Cargo.toml'
    foreach ($m in @($eng, $ws)) { if (-not (Test-Path -LiteralPath $m)) { $out.Add("missing file: $m"); return ,$out } }
    $pkg = @((Get-Tables $eng)['package'])
    $wsTables = Get-Tables $ws
    $wsPkg = @(if ($wsTables.Contains('workspace.package')) { $wsTables['workspace.package'] })
    foreach ($key in @('description', 'keywords', 'categories')) {
        if ($null -eq (Get-Key $pkg $key)) { $out.Add("engine/Cargo.toml names no $key, which crates.io shows a visitor") }
    }
    $readme = Get-Key $pkg 'readme'
    if ($null -eq $readme) { $out.Add('engine/Cargo.toml names no readme, which crates.io shows a visitor') }
    else {
        $name = $readme.Trim('"')
        $path = [System.IO.Path]::GetFullPath((Join-Path $crateDir $name))
        if (-not $path.StartsWith($crateDir + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $path)) {
            $out.Add("engine/Cargo.toml's readme, $name, is not a file of the crate's directory, where the crate's page is written for crates.io")
        }
    }
    foreach ($key in @('license', 'repository')) {
        $own = Get-Key $pkg $key
        $inherited = Get-Key $pkg "$key.workspace"
        if ($null -ne $own) { continue }
        if ($inherited -ne 'true') { $out.Add("engine/Cargo.toml names no $key, its own or the workspace's"); continue }
        if ($null -eq (Get-Key $wsPkg $key)) { $out.Add("engine/Cargo.toml takes its $key from the workspace, and Cargo.toml's [workspace.package] gives none") }
    }
    $publish = Get-Key $pkg 'publish'
    if ($null -ne $publish -and ($publish -replace '\s', '') -match '^(false|\[\])$') {
        $out.Add("engine/Cargo.toml says publish = $publish, where the crate is published from 0.1.0 (REPO.4)")
    }
    if ($includes -eq 0) { $out.Add("no build-time include was read in engine/src/ or engine/examples/, where the catalog's include_str! and the runner's #[path] stand: the reading is broken") }
    return ,$out
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_package_' + [System.IO.Path]::GetRandomFileName())
    $verdicts = New-Object System.Collections.Generic.List[string]
    $ok = $true
    try {
        # The scratch copy: the files this check reads, as they stand.
        $rels = New-Object System.Collections.Generic.List[string]
        foreach ($r in @('LICENSE', 'NOTICE', 'Cargo.toml', 'engine/Cargo.toml', 'engine/LICENSE', 'engine/NOTICE', 'engine/README.md')) { $rels.Add($r) }
        foreach ($sub in @('engine/src', 'engine/examples')) {
            foreach ($f in @(Get-ChildItem -LiteralPath (Join-Path $Root $sub) -Recurse -File -Filter '*.rs')) {
                $rels.Add($f.FullName.Substring(([System.IO.Path]::GetFullPath($Root)).TrimEnd('\', '/').Length + 1).Replace('\', '/'))
            }
        }
        function Write-Copy {
            if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force }
            foreach ($r in $rels) {
                $dst = Join-Path $tmp $r
                New-Item -ItemType Directory -Path (Split-Path -Parent $dst) -Force | Out-Null
                Copy-Item -LiteralPath (Join-Path $Root $r) -Destination $dst
            }
        }
        Write-Copy
        $clean = Get-Problems $tmp
        if ($clean.Count -eq 0) { $verdicts.Add('the copy as it stands: passes, as it should') }
        else { $ok = $false; $verdicts.Add("the copy as it stands: FAILED but should pass: $($clean -join ' | ')") }

        # Each mutant: a file, an anchor that must be there once at least, and
        # what it becomes ($null deletes the file); and the words its failure says.
        $mutants = @(
            @{ Name = 'a NOTICE copy one byte longer'; File = 'engine/NOTICE'; From = $null; Append = 'x'; Want = 'engine/NOTICE is not NOTICE byte for byte' },
            @{ Name = 'a LICENSE copy missing'; File = 'engine/LICENSE'; Delete = $true; Want = 'engine/LICENSE is missing' },
            @{ Name = 'an include of the repository''s cartridges/ in a test module'; File = 'engine/src/cartridge.rs'; From = 'mod tests {'; To = "mod tests {`n    const LIFE: &str = include_str!(`"../../cartridges/life/life.vla`");"; Want = 'include_str! names ../../cartridges/life/life.vla, outside the crate''s directory' },
            @{ Name = 'a #[path] out of the crate in an example'; File = 'engine/examples/frames.rs'; From = '#[path = "../src/sand.rs"]'; To = '#[path = "../../tools/sand.rs"]'; Want = '#[path] names ../../tools/sand.rs, outside the crate''s directory' },
            @{ Name = 'a manifest with no description'; File = 'engine/Cargo.toml'; From = 'description = '; To = '# description = '; Want = 'engine/Cargo.toml names no description' },
            @{ Name = 'a readme outside the crate'; File = 'engine/Cargo.toml'; From = 'readme = "README.md"'; To = 'readme = "../README.md"'; Want = 'is not a file of the crate''s directory' },
            @{ Name = 'publish = false put back'; File = 'engine/Cargo.toml'; From = 'readme = "README.md"'; To = "readme = `"README.md`"`npublish = false"; Want = 'says publish = false' }
        )
        foreach ($m in $mutants) {
            Write-Copy
            $path = Join-Path $tmp $m.File
            $before = if (Test-Path -LiteralPath $path) { [System.IO.File]::ReadAllText($path) } else { $null }
            if ($m.Delete) {
                Remove-Item -LiteralPath $path -Force
                if (Test-Path -LiteralPath $path) { $ok = $false; $verdicts.Add("$($m.Name): the file was not deleted"); continue }
            } elseif ($m.Append) {
                [System.IO.File]::AppendAllText($path, $m.Append)
            } else {
                $idx = $before.IndexOf($m.From)
                if ($idx -lt 0) { $ok = $false; $verdicts.Add("$($m.Name): the anchor is not in $($m.File)"); continue }
                [System.IO.File]::WriteAllText($path, $before.Substring(0, $idx) + $m.To + $before.Substring($idx + $m.From.Length), (New-Object System.Text.UTF8Encoding($false)))
            }
            if (-not $m.Delete -and [System.IO.File]::ReadAllText($path) -ceq $before) { $ok = $false; $verdicts.Add("$($m.Name): the mutant did not apply"); continue }
            $problems = Get-Problems $tmp
            $hit = @($problems | Where-Object { $_.Contains($m.Want) }).Count -gt 0
            if ($problems.Count -gt 0 -and $hit) { $verdicts.Add("$($m.Name): fails, as it should ($($problems.Count): $($problems -join ' | '))") }
            elseif ($problems.Count -eq 0) { $ok = $false; $verdicts.Add("$($m.Name): PASSED but should fail") }
            else { $ok = $false; $verdicts.Add("$($m.Name): fails, but without '$($m.Want)': $($problems -join ' | ')") }
        }
    } finally {
        if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force }
    }
    $verdicts | ForEach-Object { Write-Host "control: $_" }
    if ($ok) { Write-Host "OK: control: the copy passes and $($mutants.Count) mutants fail, each for its own reason"; exit 0 }
    Write-Host 'FAIL: control: the reading or the judgment is broken'
    exit 1
}

$problems = Get-Problems $Root
if ($problems.Count -gt 0) {
    Write-Host "FAIL: the engine crate's package, $($problems.Count) problem(s):"
    $problems | ForEach-Object { Write-Host "  - $_" }
    exit 1
}
Write-Host "OK: the package carries LICENSE and NOTICE byte for byte, every build-time include of engine/src/ and engine/examples/ stays inside the crate, and the manifest names what crates.io shows (REPO.4)"
exit 0
