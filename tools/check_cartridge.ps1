<#
check_cartridge.ps1 - every cartridge under cartridges/ is a cartridge as
SPEC.md section 7 has it, read without an engine.

WHY: ENGINE.1's scoping, decision 11 (REARVIEW.md). The engine refuses a
defective cartridge at load, by name (SPEC.md section 4.2); but the language
crate's loader does not exist yet, and a cartridge in this repository is a
fixture of the floors and the demo a stranger copies first, so its shape is
held now, statically, on every push, and a defect fails here before any
engine reads the file. The reader of forms below is this script's own
(comments, strings with \" and \\, numbers, symbols, lists, each form's line),
since the engine reads no VLA and the language's reader lives in another
repository.

WHAT IT HOLDS, for each .vla under cartridges/, with the catalogue's ids:
  - the licence header as the first line, '; SPDX-License-Identifier: 0BSD'
    (section 7.1; tools/check_spdx.ps1 holds the map), and a (licence ...)
    directive, when given, the header's twin;
  - the manifest form first, (cartridge "name" ...), the name lowercase
    letters, digits and hyphens; every directive present once and in range
    (cart-manifest-invalid): (spec 1|2), (title "..."), (rate 0..120),
    (screen plane w h) at most 320 by 200 or (screen grid w h) at most 80 by
    50, (seed 1..2147483646|host); author, licence and notes optional and at
    most once; an unknown directive refused; a (spec n) past 2 refused as
    cart-spec-unsupported;
  - every row after it one of section 7.3's kinds in its shape (grid-row-
    unknown, grid-row-malformed); a (derived ...) row is the host's and never
    a cartridge's;
  - the reserved names (cart-sheet-reserved): no sheet ending in .last, no
    sheet name longer than 26 characters; a device sheet's cells inside its
    section 3 layout (cart-device-cell-outside), and no formula where the
    host writes (cart-device-cell-formula);
  - one write per cell, across rows and range fills, both lines named
    (cart-cell-written-twice), a value row after its formula row excepted;
  - the Screen's cells inside the declared size when no Camera sheet is
    written (cart-screen-outside);
  - in plane mode, the Palette's sixteen rows: A1 to A16 holding 0 to 15 in
    order and B1 to B16 a colour as #RRGGBB (cart-palette-invalid);
  - no NOW, TODAY, RAND or RANDBETWEEN in any formula, string literals
    aside (cart-formula-volatile, the Clock named).
And a baseline that pins how many: the cartridges counted, and each one's
rows as a floor that never goes down.

-Control copies cartridges/ to a scratch folder and proves the check on it:
the clean copy passes; thirteen mutants of life.vla must each fail for its
own reason, each asserting its anchor once and proving it applied before
the check is asked: a directive dropped, a rate of 121, a screen 321 wide,
a cell written twice, a cell outside the Screen, a Palette index out of
order, a colour that is not #RRGGBB, NOW() in the rule, a sheet named
Board.last, the header dropped, an unknown row kind, a formula into
Input!B1, and the file renamed out of the glob, which the count must catch.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network; a
hardcoded, reviewable baseline that pins how many; exit 0 clean, exit 1 with
every problem named.

Usage:  powershell -File tools\check_cartridge.ps1
        powershell -File tools\check_cartridge.ps1 -Control
#>
param(
    [string]$Root = '',
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if ($Root -eq '') { $Root = $repoRoot }

# --- the baseline: how many cartridges, and each one's rows as a floor ---
# 2026-10-08, ENGINE.1: one, Life, 51 rows (two sheet rows, the Palette's
# forty-eight cells, the rule over the interior in one formula row).
# 2026-10-09, ENGINE.2: two, the test card beside it, 112 rows (three sheet
# rows, the Palette's forty-eight cells, the Camera's four and its value row,
# the Screen's fifty-six: every kind of value and of formula, 960 cells).
# 2026-10-09, CART.1: three, Gosper's glider gun beside them, 88 rows (three
# sheet rows, the Palette's forty-eight cells, the Seed's thirty-six, Life's
# rule over the interior in one formula row, its first frame the Seed's).
$expectedCartridges = 3
$rowFloors = @{ 'cartridges/life/life.vla' = 51; 'cartridges/gun/gun.vla' = 88; 'cartridges/testcard/testcard.vla' = 112 }

# --- section 7 and section 3, as data ---
$requiredDirectives = @('spec', 'title', 'rate', 'screen', 'seed')
$optionalDirectives = @('author', 'licence', 'notes')
$rowKinds = @('sheet', 'cell', 'formula', 'value', 'name', 'column', 'format', 'style', 'gridlines', 'sentence', 'table', 'refers', 'look', 'row')
function New-Rect([int]$top, [int]$left, [int]$bottom, [int]$right) { return @{ T = $top; L = $left; B = $bottom; R = $right } }
$layouts = @{
    'palette' = @((New-Rect 1 1 16 3)); 'input' = @((New-Rect 1 1 10 5), (New-Rect 11 1 18 2)); 'keys' = @((New-Rect 1 1 10 5))
    'clock' = @((New-Rect 1 1 3 2)); 'audio' = @((New-Rect 1 1 5 4)); 'file' = @((New-Rect 1 1 3 2)); 'camera' = @((New-Rect 1 1 2 2))
    'write' = @((New-Rect 1 1 1048576 3))
}
$hostCells = @{ 'input' = @((New-Rect 1 2 10 5), (New-Rect 11 2 18 2)); 'clock' = @((New-Rect 1 2 3 2)); 'file' = @((New-Rect 1 2 2 2)) }
$header = '; SPDX-License-Identifier: 0BSD'

# ---- the reader: forms with their lines ----
function Read-Forms([string]$text) {
    $forms = New-Object System.Collections.Generic.List[object]
    $stack = New-Object System.Collections.Generic.List[object]
    $i = 0; $n = $text.Length; $line = 1
    while ($i -lt $n) {
        $ch = $text[$i]
        if ($ch -eq "`n") { $line++; $i++; continue }
        if ([char]::IsWhiteSpace($ch)) { $i++; continue }
        if ($ch -eq ';') { while ($i -lt $n -and $text[$i] -ne "`n") { $i++ }; continue }
        if ($ch -eq '(') { $stack.Add(@{ Kind = 'list'; Items = (New-Object System.Collections.Generic.List[object]); Line = $line }); $i++; continue }
        if ($ch -eq ')') {
            if ($stack.Count -eq 0) { throw "line ${line}: a closing parenthesis with nothing open" }
            $top = $stack[$stack.Count - 1]; $stack.RemoveAt($stack.Count - 1); $i++
            if ($stack.Count -eq 0) { $forms.Add($top) } else { $stack[$stack.Count - 1].Items.Add($top) }
            continue
        }
        if ($ch -eq '"') {
            $sb = New-Object System.Text.StringBuilder; $start = $line; $i++
            while ($true) {
                if ($i -ge $n) { throw "line ${start}: a string is not closed" }
                $c = $text[$i]
                if ($c -eq '\') { if ($i + 1 -lt $n) { [void]$sb.Append($text[$i + 1]) }; $i += 2; continue }
                if ($c -eq '"') { $i++; break }
                if ($c -eq "`n") { $line++ }
                [void]$sb.Append($c); $i++
            }
            $atom = @{ Kind = 'string'; Value = $sb.ToString(); Line = $start }
        } else {
            $j = $i
            while ($j -lt $n -and -not [char]::IsWhiteSpace($text[$j]) -and $text[$j] -ne '(' -and $text[$j] -ne ')' -and $text[$j] -ne '"' -and $text[$j] -ne ';') { $j++ }
            $tok = $text.Substring($i, $j - $i); $i = $j
            if ($tok -match '^-?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$') { $atom = @{ Kind = 'number'; Text = $tok; Value = [double]$tok; Line = $line } }
            else { $atom = @{ Kind = 'symbol'; Text = $tok; Line = $line } }
        }
        if ($stack.Count -eq 0) { $forms.Add($atom) } else { $stack[$stack.Count - 1].Items.Add($atom) }
    }
    if ($stack.Count -gt 0) { throw "line $($stack[0].Line): a form is not closed" }
    return ,$forms
}
function Test-Kind($d, [string]$kind) { return ($null -ne $d) -and ($d.Kind -eq $kind) }
function Test-Sym($d, [string]$text) { return (Test-Kind $d 'symbol') -and ($d.Text -ceq $text) }
function Test-Whole($d) { return (Test-Kind $d 'number') -and ($d.Text -match '^\d+$') }
function Test-Value($d) {
    if ($null -eq $d) { return $false }
    if ($d.Kind -eq 'string' -or $d.Kind -eq 'number') { return $true }
    if ($d.Kind -eq 'symbol') { return ($d.Text -ceq 'true') -or ($d.Text -ceq 'false') }
    if ($d.Kind -eq 'list') { return ($d.Items.Count -eq 2) -and ((Test-Sym $d.Items[0] 'error') -or (Test-Sym $d.Items[0] 'date')) -and (Test-Kind $d.Items[1] 'string') }
    return $false
}
function Show-Datum($d) {
    if ($null -eq $d) { return 'nothing' }
    if ($d.Kind -eq 'string') { return '"' + $d.Value + '"' }
    if ($d.Kind -eq 'list') { return 'a list' }
    return $d.Text
}

# ---- addresses ----
function ConvertFrom-Letters([string]$s) { $c = 0; foreach ($ch in $s.ToUpperInvariant().ToCharArray()) { $c = $c * 26 + ([int]$ch - 64) }; return $c }
function Get-Rect([string]$t) {
    $m = [regex]::Match($t, '^\$?([A-Za-z]{1,3})\$?(\d{1,7})(?::\$?([A-Za-z]{1,3})\$?(\d{1,7}))?$')
    if (-not $m.Success) { return $null }
    $row1 = [int]$m.Groups[2].Value; $col1 = ConvertFrom-Letters $m.Groups[1].Value
    if ($m.Groups[3].Success) { $row2 = [int]$m.Groups[4].Value; $col2 = ConvertFrom-Letters $m.Groups[3].Value } else { $row2 = $row1; $col2 = $col1 }
    $rect = New-Rect ([Math]::Min($row1, $row2)) ([Math]::Min($col1, $col2)) ([Math]::Max($row1, $row2)) ([Math]::Max($col1, $col2))
    if ($rect.T -lt 1 -or $rect.L -lt 1 -or $rect.B -gt 1048576 -or $rect.R -gt 16384) { return $null }
    return $rect
}
function Test-Inside($rects, [int]$row, [int]$col) {
    foreach ($q in $rects) { if ($row -ge $q.T -and $row -le $q.B -and $col -ge $q.L -and $col -le $q.R) { return $true } }
    return $false
}
# Every cell of a rectangle inside the union of the rectangles of a layout.
function Test-AllInside($rects, $rect) {
    foreach ($q in $rects) { if ($rect.T -ge $q.T -and $rect.B -le $q.B -and $rect.L -ge $q.L -and $rect.R -le $q.R) { return $true } }
    if (($rect.B - $rect.T + 1) * ($rect.R - $rect.L + 1) -gt 10000) { return $false }
    for ($row = $rect.T; $row -le $rect.B; $row++) { for ($col = $rect.L; $col -le $rect.R; $col++) { if (-not (Test-Inside $rects $row $col)) { return $false } } }
    return $true
}
function Test-AnyInside($rects, $rect) {
    foreach ($q in $rects) { if ($rect.T -le $q.B -and $rect.B -ge $q.T -and $rect.L -le $q.R -and $rect.R -ge $q.L) { return $true } }
    return $false
}
function Test-Overlap($a, $b) { return ($a.T -le $b.B) -and ($a.B -ge $b.T) -and ($a.L -le $b.R) -and ($a.R -ge $b.L) }

# ---- one cartridge ----
function Test-Cartridge([string]$path) {
    $problems = New-Object System.Collections.Generic.List[string]
    $raw = [System.IO.File]::ReadAllText($path)
    $text = $raw -replace "`r`n", "`n"
    $firstLine = ($text -split "`n", 2)[0]
    if ($firstLine -cne $header) { $problems.Add("line 1: the licence header is not the first line, '$header' (SPEC.md section 7.1)") }
    try { $forms = Read-Forms $text } catch { $problems.Add($_.Exception.Message); return @{ Problems = $problems; Rows = 0; Cells = 0; Formulas = 0 } }
    if ($forms.Count -eq 0) { $problems.Add('the file holds no form'); return @{ Problems = $problems; Rows = 0; Cells = 0; Formulas = 0 } }

    # -- the manifest --
    $man = $forms[0]
    $mode = ''; $width = 0; $height = 0
    if (-not (Test-Kind $man 'list') -or $man.Items.Count -lt 2 -or -not (Test-Sym $man.Items[0] 'cartridge') -or -not (Test-Kind $man.Items[1] 'string')) {
        $problems.Add("line $($man.Line): cart-manifest-invalid: the first form is not (cartridge `"name`" ...)")
    } else {
        $name = $man.Items[1].Value
        if ($name -cnotmatch '^[a-z0-9][a-z0-9-]*$') { $problems.Add("line $($man.Line): cart-manifest-invalid: the name `"$name`" is not lowercase letters, digits and hyphens") }
        $seen = @{}
        for ($k = 2; $k -lt $man.Items.Count; $k++) {
            $d = $man.Items[$k]
            if (-not (Test-Kind $d 'list') -or $d.Items.Count -eq 0 -or -not (Test-Kind $d.Items[0] 'symbol')) { $problems.Add("line $($d.Line): cart-manifest-invalid: $(Show-Datum $d) is not a directive"); continue }
            $dn = $d.Items[0].Text
            if (($requiredDirectives + $optionalDirectives) -cnotcontains $dn) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn ...) is not a directive this version knows"); continue }
            if ($seen.ContainsKey($dn)) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn ...) is given twice"); continue }
            $seen[$dn] = $d
            $args1 = $d.Items.Count - 1
            switch -CaseSensitive ($dn) {
                'spec' {
                    if ($args1 -ne 1 -or -not (Test-Whole $d.Items[1])) { $problems.Add("line $($d.Line): cart-manifest-invalid: (spec ...) holds one whole number") }
                    elseif ([int]$d.Items[1].Text -gt 2 -or [int]$d.Items[1].Text -lt 1) { $problems.Add("line $($d.Line): cart-spec-unsupported: (spec $($d.Items[1].Text)); this version reads 1 and 2") }
                }
                'title' { if ($args1 -ne 1 -or -not (Test-Kind $d.Items[1] 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: (title `"...`") holds one text") } }
                'rate' { if ($args1 -ne 1 -or -not (Test-Whole $d.Items[1]) -or [int]$d.Items[1].Text -gt 120) { $problems.Add("line $($d.Line): cart-manifest-invalid: (rate $(Show-Datum $d.Items[1])); a rate is a whole number from 0 to 120") } }
                'screen' {
                    if ($args1 -ne 3 -or -not (Test-Kind $d.Items[1] 'symbol') -or -not (Test-Whole $d.Items[2]) -or -not (Test-Whole $d.Items[3])) { $problems.Add("line $($d.Line): cart-manifest-invalid: (screen plane|grid width height)") }
                    else {
                        $mode = $d.Items[1].Text; $width = [int]$d.Items[2].Text; $height = [int]$d.Items[3].Text
                        $limit = if ($mode -ceq 'plane') { @(320, 200) } elseif ($mode -ceq 'grid') { @(80, 50) } else { $null }
                        if ($null -eq $limit) { $problems.Add("line $($d.Line): cart-manifest-invalid: the screen's mode is $mode, not plane or grid") }
                        elseif ($width -lt 1 -or $height -lt 1 -or $width -gt $limit[0] -or $height -gt $limit[1]) { $problems.Add("line $($d.Line): cart-manifest-invalid: the screen $mode $width by $height is past the limit of $($limit[0]) by $($limit[1]) (SPEC.md section 10)") }
                    }
                }
                'seed' {
                    $ok = ($args1 -eq 1) -and ((Test-Sym $d.Items[1] 'host') -or ((Test-Whole $d.Items[1]) -and [double]$d.Items[1].Text -ge 1 -and [double]$d.Items[1].Text -le 2147483646))
                    if (-not $ok) { $problems.Add("line $($d.Line): cart-manifest-invalid: (seed $(Show-Datum $d.Items[1])); a seed is a whole number from 1 to 2147483646, or host") }
                }
                'licence' {
                    if ($args1 -ne 1 -or -not (Test-Kind $d.Items[1] 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: (licence `"...`") holds one SPDX identifier") }
                    elseif ($d.Items[1].Value -cne '0BSD') { $problems.Add("line $($d.Line): cart-manifest-invalid: the licence directive says $($d.Items[1].Value) and the header 0BSD") }
                }
                default { if ($args1 -ne 1 -or -not (Test-Kind $d.Items[1] 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn `"...`") holds one text") } }
            }
        }
        foreach ($rd in $requiredDirectives) { if (-not $seen.ContainsKey($rd)) { $problems.Add("line $($man.Line): cart-manifest-invalid: the manifest has no ($rd ...) directive; every directive is given (SPEC.md section 7.2)") } }
    }

    # -- the rows --
    $writes = New-Object System.Collections.Generic.List[object]
    $formulaCells = @{}
    $sheetsNamed = @{}
    $cells = 0; $formulas = 0
    for ($k = 1; $k -lt $forms.Count; $k++) {
        $f = $forms[$k]
        if (-not (Test-Kind $f 'list') -or $f.Items.Count -eq 0 -or -not (Test-Kind $f.Items[0] 'symbol')) { $problems.Add("line $($f.Line): grid-row-unknown: $(Show-Datum $f) is not a row"); continue }
        $kind = $f.Items[0].Text
        if ($kind -ceq 'derived') { $problems.Add("line $($f.Line): grid-row-unknown: a (derived ...) row is the host's write, never a cartridge's (SPEC.md section 3.9)"); continue }
        if ($rowKinds -cnotcontains $kind) { $problems.Add("line $($f.Line): grid-row-unknown: ($kind ...) is not a row this version takes (SPEC.md section 7.3)"); continue }
        $it = $f.Items
        $shapeOk = switch -CaseSensitive ($kind) {
            'sheet' { $it.Count -eq 3 -and (Test-Kind $it[1] 'string') -and ((Test-Sym $it[2] 'visible') -or (Test-Sym $it[2] 'hidden')) }
            'cell' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Value $it[3]) }
            'formula' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Kind $it[3] 'string') -and $it[3].Value.StartsWith('=') }
            'value' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Value $it[3]) }
            'name' { $it.Count -eq 3 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') }
            'column' { $it.Count -eq 6 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') }
            'format' { $it.Count -eq 5 -and (Test-Whole $it[1]) }
            'style' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Whole $it[3]) }
            'gridlines' { $it.Count -eq 3 -and (Test-Kind $it[1] 'string') -and ((Test-Sym $it[2] 'on') -or (Test-Sym $it[2] 'off')) }
            'sentence' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Whole $it[3]) }
            'look' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Value $it[2]) -and (Test-Whole $it[3]) }
            'row' { $it.Count -eq 5 -and (Test-Kind $it[1] 'string') -and (Test-Whole $it[2]) }
            default { $true }
        }
        if (-not $shapeOk) { $problems.Add("line $($f.Line): grid-row-malformed: the ($kind ...) row is not in its shape (SPEC.md section 7.3)"); continue }
        # every sheet a row names: the reserved names
        if ($kind -cne 'name' -and $kind -cne 'format' -and $kind -cne 'table' -and $kind -cne 'refers' -and (Test-Kind $it[1] 'string')) {
            $sheet = $it[1].Value
            $sheetsNamed[$sheet.ToLowerInvariant()] = $sheet
            if ($sheet -match '(?i)\.last$') { $problems.Add("line $($f.Line): cart-sheet-reserved: the sheet $sheet ends in .last, the name of a twin (SPEC.md section 3.10)") }
            elseif ($sheet.Length -gt 26) { $problems.Add("line $($f.Line): cart-sheet-reserved: the sheet name $sheet is longer than 26 characters, so its twin would pass Excel's 31") }
        }
        if ($kind -cne 'cell' -and $kind -cne 'formula' -and $kind -cne 'value') { continue }
        $sheet = $it[1].Value; $key = $sheet.ToLowerInvariant()
        $rect = Get-Rect $it[2].Value
        if ($null -eq $rect) { $problems.Add("line $($f.Line): grid-row-malformed: `"$($it[2].Value)`" is not a cell or a range"); continue }
        if ($kind -ceq 'value') {
            if ($rect.T -ne $rect.B -or $rect.L -ne $rect.R) { $problems.Add("line $($f.Line): grid-row-malformed: a value row names one cell") }
            elseif (-not $formulaCells.ContainsKey($key + '|' + $rect.T + '|' + $rect.L)) { $problems.Add("line $($f.Line): grid-row-malformed: the value row of $sheet!$($it[2].Value) follows no formula row of that cell") }
            continue
        }
        $area = ($rect.B - $rect.T + 1) * ($rect.R - $rect.L + 1)
        $cells += $area
        if ($kind -ceq 'formula') {
            $formulas += $area
            if ($area -le 100000) { for ($row = $rect.T; $row -le $rect.B; $row++) { for ($col = $rect.L; $col -le $rect.R; $col++) { $formulaCells[$key + '|' + $row + '|' + $col] = $true } } }
            $bare = [regex]::Replace($it[3].Value, '"(?:[^"]|"")*"', '""')
            $vm = [regex]::Match($bare, '(?i)(?<![A-Za-z0-9_.!$])(NOW|TODAY|RANDBETWEEN|RAND)\s*\(')
            if ($vm.Success) { $problems.Add("line $($f.Line): cart-formula-volatile: the formula of $sheet!$($it[2].Value) calls $($vm.Groups[1].Value.ToUpperInvariant()), which reads the wall clock or the dice; the Clock sheet's frame and seed are the only clock and dice (SPEC.md section 3.5)") }
        }
        if ($layouts.ContainsKey($key) -and -not (Test-AllInside $layouts[$key] $rect)) { $problems.Add("line $($f.Line): cart-device-cell-outside: $sheet!$($it[2].Value) is outside the layout of the $sheet sheet (SPEC.md section 3)") }
        if ($kind -ceq 'formula' -and $hostCells.ContainsKey($key) -and (Test-AnyInside $hostCells[$key] $rect)) { $problems.Add("line $($f.Line): cart-device-cell-formula: $sheet!$($it[2].Value) holds a formula where the host writes values") }
        $writes.Add(@{ Key = $key; Sheet = $sheet; Rect = $rect; Line = $f.Line; Text = $it[2].Value; Kind = $kind; Value = $it[3] })
    }

    # -- one write per cell: single cells by key, ranges against everything --
    $singles = New-Object 'System.Collections.Generic.Dictionary[string,int]'
    $ranges = New-Object System.Collections.Generic.List[object]
    foreach ($w in $writes) {
        $r0 = $w.Rect
        if ($r0.T -eq $r0.B -and $r0.L -eq $r0.R) {
            $ck = $w.Key + '|' + $r0.T + '|' + $r0.L
            if ($singles.ContainsKey($ck)) { $problems.Add("line $($w.Line): cart-cell-written-twice: $($w.Sheet)!$($w.Text) is written at line $($singles[$ck]) and again here") }
            else { $singles[$ck] = $w.Line }
        } else { $ranges.Add($w) }
    }
    foreach ($a in $ranges) {
        foreach ($b in $writes) {
            if ([object]::ReferenceEquals($a, $b) -or $a.Key -ne $b.Key -or -not (Test-Overlap $a.Rect $b.Rect)) { continue }
            $isRange = -not ($b.Rect.T -eq $b.Rect.B -and $b.Rect.L -eq $b.Rect.R)
            if ($isRange -and $b.Line -lt $a.Line) { continue }   # a pair of ranges is named once, from the earlier
            $problems.Add("line $($b.Line): cart-cell-written-twice: $($b.Sheet)!$($b.Text) writes cells the range $($a.Sheet)!$($a.Text) at line $($a.Line) writes too")
        }
    }

    # -- the Screen inside its declared size when there is no Camera sheet --
    if ($width -gt 0 -and -not $sheetsNamed.ContainsKey('camera')) {
        foreach ($w in $writes) { if ($w.Key -eq 'screen' -and ($w.Rect.B -gt $height -or $w.Rect.R -gt $width)) { $problems.Add("line $($w.Line): cart-screen-outside: Screen!$($w.Text) is past the declared $width by $height, and no Camera sheet places a window") } }
    }

    # -- the Palette's sixteen rows, in plane mode --
    if ($mode -ceq 'plane') {
        $pal = @{}
        foreach ($w in $writes) {
            if ($w.Key -ne 'palette' -or $w.Kind -ne 'cell') { continue }
            for ($row = $w.Rect.T; $row -le $w.Rect.B; $row++) { for ($col = $w.Rect.L; $col -le $w.Rect.R; $col++) { $pal[[string]$row + '|' + $col] = $w.Value } }
        }
        for ($row = 1; $row -le 16; $row++) {
            $ix = $pal[[string]$row + '|1']; $colour = $pal[[string]$row + '|2']
            if ($null -eq $ix -or -not (Test-Kind $ix 'number') -or [double]$ix.Text -ne ($row - 1)) { $problems.Add("cart-palette-invalid: Palette!A$row holds $(Show-Datum $ix), and the index $($row - 1) belongs there (SPEC.md section 3.2)") }
            if ($null -eq $colour -or -not (Test-Kind $colour 'string') -or $colour.Value -cnotmatch '^#[0-9A-Fa-f]{6}$') { $problems.Add("cart-palette-invalid: Palette!B$row holds $(Show-Datum $colour), not a colour as #RRGGBB") }
        }
    }
    return @{ Problems = $problems; Rows = $forms.Count - 1; Cells = $cells; Formulas = $formulas }
}

# ---- every cartridge of a tree, against the baseline ----
function Test-Tree([string]$root) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    $dir = Join-Path $root 'cartridges'
    $files = @()
    if (Test-Path -LiteralPath $dir) { $files = @(Get-ChildItem -LiteralPath $dir -Recurse -Filter '*.vla' -File | Sort-Object FullName) }
    if ($files.Count -ne $expectedCartridges) { $problems.Add("found $($files.Count) cartridge(s) under cartridges/, and the baseline pins ${expectedCartridges}; a cartridge added, removed or renamed out of the glob moves the pin in this file") }
    foreach ($file in $files) {
        $rel = ($file.FullName.Substring($root.TrimEnd('\', '/').Length + 1)) -replace '\\', '/'
        $t = Test-Cartridge $file.FullName
        foreach ($p in $t.Problems) { $problems.Add("${rel}: $p") }
        $note = ("  {0}: {1} rows, {2:N0} cells written, {3:N0} of them formula cells" -f $rel, $t.Rows, $t.Cells, $t.Formulas)
        if (-not $rowFloors.ContainsKey($rel)) { $problems.Add("${rel}: not in the baseline; add its row floor to this file") }
        elseif ($t.Rows -lt $rowFloors[$rel]) { $problems.Add("${rel}: $($t.Rows) rows, below its floor of $($rowFloors[$rel])"); $note += ", BELOW THE FLOOR of $($rowFloors[$rel])" }
        elseif ($t.Rows -gt $rowFloors[$rel]) { $note += ", above the floor of $($rowFloors[$rel]) - raise it in this file" }
        else { $note += ', at its floor' }
        $lines.Add($note + $(if ($t.Problems.Count) { "  FAIL ($($t.Problems.Count))" } else { ', every rule of section 7 holds' }))
    }
    return @{ Problems = $problems; Lines = $lines }
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_cart_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        Copy-Item -LiteralPath (Join-Path $Root 'cartridges') -Destination (Join-Path $tmp 'cartridges') -Recurse
        $life = Join-Path $tmp 'cartridges/life/life.vla'
        $life0 = [System.IO.File]::ReadAllText($life)
        $lf0 = $life0 -replace "`r`n", "`n"
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $verdicts = New-Object System.Collections.Generic.List[string]
        $ok = $true
        $clean = Test-Tree $tmp
        if ($clean.Problems.Count -eq 0) { $verdicts.Add('the clean copy passes') } else { $ok = $false; $verdicts.Add("the clean copy fails: $($clean.Problems -join ' | ')") }
        $mutants = @(
            @{ Name = 'a directive dropped'; Anchor = '(rate 30)'; With = ''; Want = 'has no (rate ...) directive' },
            @{ Name = 'a rate of 121'; Anchor = '(rate 30)'; With = '(rate 121)'; Want = '(rate 121); a rate is' },
            @{ Name = 'a screen 321 wide'; Anchor = '(screen plane 320 200)'; With = '(screen plane 321 200)'; Want = 'the screen plane 321 by 200 is past the limit' },
            @{ Name = 'a cell written twice'; Append = '(cell "Palette" "C2" "twice")'; Want = 'cart-cell-written-twice: Palette!C2' },
            @{ Name = 'a cell outside the Screen'; Append = '(cell "Screen" "A201" 1)'; Want = 'cart-screen-outside: Screen!A201' },
            @{ Name = 'a Palette index out of order'; Anchor = '(cell "Palette" "A2" 1)'; With = '(cell "Palette" "A2" 2)'; Want = 'cart-palette-invalid: Palette!A2 holds 2' },
            @{ Name = 'a colour that is not #RRGGBB'; Anchor = '"#FFFFFF"'; With = '"white"'; Want = 'cart-palette-invalid: Palette!B2 holds "white"' },
            @{ Name = 'NOW() in the rule'; Anchor = 'Clock!$B$1=1'; With = 'NOW()>0'; Want = 'cart-formula-volatile' },
            @{ Name = 'a sheet named Board.last'; Append = '(cell "Board.last" "A1" 1)'; Want = 'cart-sheet-reserved: the sheet Board.last' },
            @{ Name = 'the header dropped'; Anchor = $header; With = '; no licence'; Want = 'the licence header is not the first line' },
            @{ Name = 'an unknown row kind'; Append = '(paint "Screen" "A1" 1)'; Want = 'grid-row-unknown: (paint ...)' },
            @{ Name = 'a formula into Input!B1'; Append = '(formula "Input" "B1" "=1")'; Want = 'cart-device-cell-formula: Input!B1' },
            @{ Name = 'the file renamed out of the glob'; Rename = 'life.txt'; Want = ("found {0} cartridge(s)" -f ($expectedCartridges - 1)) }
        )
        foreach ($mu in $mutants) {
            $applied = $false
            if ($mu.ContainsKey('Rename')) {
                Rename-Item -LiteralPath $life -NewName $mu.Rename
                $applied = (-not (Test-Path -LiteralPath $life)) -and (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $life) $mu.Rename))
            } else {
                if ($mu.ContainsKey('Anchor')) {
                    if (([regex]::Matches($lf0, [regex]::Escape($mu.Anchor))).Count -ne 1) { $ok = $false; $verdicts.Add("$($mu.Name): the anchor $($mu.Anchor) is not in life.vla exactly once"); continue }
                    $mut = $lf0.Replace($mu.Anchor, $mu.With)
                } else { $mut = $lf0 + $mu.Append + "`n" }
                [System.IO.File]::WriteAllText($life, ($mut -replace "`n", "`r`n"), $utf8)
                $back = [System.IO.File]::ReadAllText($life) -replace "`r`n", "`n"
                $applied = ($back -ne $lf0) -and ($back -ceq $mut)
            }
            if (-not $applied) { $ok = $false; $verdicts.Add("$($mu.Name): the mutation did not apply") }
            else {
                $r = Test-Tree $tmp
                $hit = @($r.Problems | Where-Object { $_.Contains($mu.Want) }).Count
                if ($hit -ge 1) { $verdicts.Add("$($mu.Name): fails, as it should") }
                elseif ($r.Problems.Count -gt 0) { $ok = $false; $verdicts.Add("$($mu.Name): fails, but without '$($mu.Want)': $($r.Problems -join ' | ')") }
                else { $ok = $false; $verdicts.Add("$($mu.Name): PASSED but should fail") }
            }
            # put the file back
            $other = Join-Path (Split-Path -Parent $life) 'life.txt'
            if (Test-Path -LiteralPath $other) { Remove-Item -LiteralPath $other -Force }
            [System.IO.File]::WriteAllText($life, $life0, $utf8)
        }
        foreach ($v in $verdicts) { Write-Output ('control: ' + $v) }
        if ($ok) { Write-Output 'OK: the check passes the clean copy and fails each of the thirteen mutants for its own reason, each proving it applied'; exit 0 }
        Write-Output 'FAIL: the control did not behave as the header says'
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

Write-Output '=== THE CARTRIDGES: EACH A CARTRIDGE AS SPEC.md SECTION 7 HAS IT, READ WITHOUT AN ENGINE (ENGINE.1) ==='
$tr = Test-Tree $Root
$tr.Lines | ForEach-Object { Write-Output $_ }
Write-Output ''
if ($tr.Problems.Count -eq 0) {
    Write-Output ("=== CHECK: clean - {0} cartridge(s), each holding to section 7, at or above its floor ===" -f $expectedCartridges)
    exit 0
}
Write-Output "=== CHECK: $($tr.Problems.Count) problem(s) ==="
$tr.Problems | ForEach-Object { Write-Output "  $_" }
exit 1
