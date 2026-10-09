<#
check_view_fixtures.ps1 - the viewport's fixtures are the records the door
printed, byte for byte: each pinned by a hash, never shorter, in oracle 11's
fixed order, and the 10,000-line record held to the rule that generated its
program.

WHY: KERNEL.5, laid here, draws from the view record (Frazaro's
conformance/README.md, oracle 11), and its fixtures under web/fixtures/ are
copies of Frazaro's six view goldens (scripts/view/, the commit named below)
and of the record the door printed for the benchmark's 10,000-line program
(tools/bench_view.ps1's generator). Frazaro is absent in CI and the .vla
attribute gives CRLF on checkout wherever the clone is made, so a copy is
pinned here by the SHA-256 of its bytes with line endings normalized to LF,
the bytes Frazaro's blob holds; a copy that drifts from the pin fails on
every push, and a regeneration in Frazaro is a copy here and a new pin, in
one reviewed commit. The record of the 10,000-line program is held by two
more witnesses: it is the generator's own output (six header rows, then for
each row a cell or a formula row and its sentence row; measured 2026-10-08,
an awk of the rule reproduces the door's text byte for byte), so this check
regenerates it from the rule and compares it whole, which costs nothing and
catches a copy that drifted from the program it claims; and -Door has a door
print it again when one is named.

ALSO HELD, read off each fixture itself: its line count as a floor that never
goes down, and oracle 11's fixed order (the sheet rows, one window, one
extent, one gridlines row, the column rows, the format rows with 0 first and
ascending, then the cells in row-major order with each cell's style and
sentence rows), the order check Frazaro's check_view_golden.ps1 reads off a
golden, copied arm for arm.

-Frazaro <tree> compares each copy to that tree's scripts/view/<name>.vla
(normalized), and -Door <frazaro.exe> with -Frazaro has the door print the
10,000-line record over the tree's corpus files and compares; both SKIPPED
when not named, since CI never has Frazaro.

-Control proves the check on a scratch folder holding copies of the seven:
the clean copy passes; a byte changed in one fixture fails its pin; a line
dropped from another fails its floor; a format row moved below a cell fails
the order; a line changed in the 10,000-line record fails the rule.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network;
exit 0 clean, exit 1 with every problem named.

Usage:  powershell -File tools\check_view_fixtures.ps1
        powershell -File tools\check_view_fixtures.ps1 -Frazaro ..\Frazaro
        powershell -File tools\check_view_fixtures.ps1 -Frazaro ..\Frazaro -Door ..\Frazaro\target\debug\frazaro.exe
        powershell -File tools\check_view_fixtures.ps1 -Control
#>
param(
    [string]$Frazaro = '',
    [string]$Door = '',
    [string]$FixturesDir = '',
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if ($FixturesDir -eq '') { $FixturesDir = Join-Path $repoRoot 'web/fixtures' }
elseif (-not [System.IO.Path]::IsPathRooted($FixturesDir)) { $FixturesDir = Join-Path $repoRoot $FixturesDir }

# --- the fixtures and their pins: the SHA-256 over LF bytes, the line count as a floor ---
# 2026-10-08, KERNEL.5: the six view goldens as Frazaro's commit 0e5cbc6
# (KERNEL.4, 2026-10-07) holds them, and the 10,000-line program's record as
# the tree's debug door (frazaro 0.8.0) printed it the same day, 660,738
# bytes. Raise a floor when a regenerated copy is longer; lower it only with a
# regenerated copy that is shorter, and say why.
$frazaroCommit = '0e5cbc6'
$sparseLines = 10000
$fixtures = @(
    @{ Name = 'fixture_frazaro';      Floor = 66;    Sha256 = '1e084bbd00b459f8ea8b57b7cf1add2b58ec24fe98f96731efe3fbfea3789140'; Source = 'scripts/view/fixture_frazaro.vla' },
    @{ Name = 'fixture_output';       Floor = 21;    Sha256 = '31ce3956aa2e9b4f35b5f8cb0e7c3f43235dbc4679783264ee52b8fdb7d33301'; Source = 'scripts/view/fixture_output.vla' },
    @{ Name = 'fixture_output_b2_c3'; Floor = 15;    Sha256 = 'a50431c38ebc119802f58c0ec4bc469bf694b7abf55479b2761fad37d334bbc8'; Source = 'scripts/view/fixture_output_b2_c3.vla' },
    @{ Name = 'fixture_data';         Floor = 9;     Sha256 = '3b86d067a767feb5b45bf4657517471a8155940fc7cd74e6e1126e95d703010b'; Source = 'scripts/view/fixture_data.vla' },
    @{ Name = 'into_output';          Floor = 11;    Sha256 = '0fd381bd513f76b1373ca4a8613a8352193741e424ef120872994779b4ae3597'; Source = 'scripts/view/into_output.vla' },
    @{ Name = 'into_checks';          Floor = 9;     Sha256 = 'e6881c6bf063f5251cc94e92d4cb535531142d49cacc4df1e7d6fd81277fd363'; Source = 'scripts/view/into_checks.vla' },
    @{ Name = 'sparse_10000';         Floor = 20006; Sha256 = '8c9432bd8f57298c2c2db4a3dfa52068f061f51ef6e6f50a34e664bab49a17a7'; Source = ''; Rule = $true }
)
$expectedFixtures = 7

# The forms a view record holds, and the phase each belongs to in the fixed order.
$phases = @{ 'sheet' = 0; 'window' = 1; 'extent' = 2; 'gridlines' = 3; 'column' = 4; 'format' = 5; 'cell' = 6; 'formula' = 6; 'style' = 6; 'sentence' = 6 }

# A text with its line endings normalized to LF.
function Get-Normalized([string]$text) { return ($text -replace "`r`n", "`n") }
# The SHA-256 of a text's UTF-8 bytes, lower-case hex.
function Get-Sha256([string]$text) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        return (([System.BitConverter]::ToString($sha.ComputeHash($bytes))) -replace '-', '').ToLowerInvariant()
    } finally { $sha.Dispose() }
}
# A text as its lines: trailing blank lines dropped.
function Get-Lines([string]$normalized) {
    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($l in ($normalized -split "`n")) { $lines.Add($l) }
    while ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq '') { $lines.RemoveAt($lines.Count - 1) }
    return ,$lines
}
# The line ending a file uses: CRLF, LF, mixed, or none.
function Get-LineEnding([string]$text) {
    $crlf = ([regex]::Matches($text, "`r`n")).Count
    $lf = ([regex]::Matches($text, "`n")).Count - $crlf
    if ($crlf -gt 0 -and $lf -gt 0) { return 'mixed' }
    if ($crlf -gt 0) { return 'CRLF' }
    if ($lf -gt 0) { return 'LF' }
    return 'none'
}
function Get-Relation([string]$line) {
    $m = [regex]::Match($line, '^\(([a-z]+) ')
    if (-not $m.Success) { return '' }
    return $m.Groups[1].Value
}
function Get-Strings([string]$line) {
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($m in [regex]::Matches($line, '"((?:[^"\\]|\\.)*)"')) { $out.Add(($m.Groups[1].Value -replace '\\(.)', '$1')) }
    return ,$out
}
function Get-RowCol([string]$addr) {
    $m = [regex]::Match($addr, '^([A-Z]+)([0-9]+)$')
    if (-not $m.Success) { return $null }
    $col = 0
    foreach ($ch in $m.Groups[1].Value.ToCharArray()) { $col = $col * 26 + ([int][char]$ch - [int][char]'A' + 1) }
    return @([int]$m.Groups[2].Value, $col)
}
# The fixed order, read off a record's lines: a list of problems, empty when it holds.
function Test-Order($lines) {
    $problems = New-Object System.Collections.Generic.List[string]
    $phase = 0
    $windowSheet = $null
    $seen = @{ 'window' = 0; 'extent' = 0; 'gridlines' = 0 }
    $lastFormat = -1
    $lastCell = $null
    $open = ''
    $hadStyle = $false; $hadSentence = $false
    $n = 0
    foreach ($line in $lines) {
        $n++
        $rel = Get-Relation $line
        if ($rel -eq '' -or -not $phases.ContainsKey($rel)) { $problems.Add("line ${n}: not a row of the view record: $line"); continue }
        $p = $phases[$rel]
        if ($p -lt $phase) { $problems.Add("line ${n}: a $rel row after a later phase began: $line"); continue }
        $strings = Get-Strings $line
        switch ($rel) {
            'sheet' { }
            'window' { $seen['window']++; $windowSheet = $strings[0] }
            'extent' { $seen['extent']++; if ($strings[0] -ne $windowSheet) { $problems.Add("line ${n}: the extent names another sheet than the window: $line") } }
            'gridlines' { $seen['gridlines']++; if ($strings[0] -ne $windowSheet) { $problems.Add("line ${n}: the gridlines row names another sheet than the window: $line") } }
            'column' { if ($strings[0] -ne $windowSheet) { $problems.Add("line ${n}: a column of another sheet than the window: $line") } }
            'format' {
                $m = [regex]::Match($line, '^\(format ([0-9]+) ')
                $idx = if ($m.Success) { [int]$m.Groups[1].Value } else { -1 }
                if ($lastFormat -eq -1 -and $idx -ne 0) { $problems.Add("line ${n}: the first format row is not format 0: $line") }
                elseif ($idx -le $lastFormat) { $problems.Add("line ${n}: a format row out of ascending order: $line") }
                $lastFormat = $idx
            }
            { $_ -eq 'cell' -or $_ -eq 'formula' } {
                if ($lastFormat -eq -1) { $problems.Add("line ${n}: a cell before any format row: $line") }
                if ($strings[0] -ne $windowSheet) { $problems.Add("line ${n}: a cell of another sheet than the window: $line") }
                $rc = Get-RowCol $strings[1]
                if ($null -eq $rc) { $problems.Add("line ${n}: not an address: $line") }
                elseif ($null -ne $lastCell -and ($rc[0] -lt $lastCell[0] -or ($rc[0] -eq $lastCell[0] -and $rc[1] -le $lastCell[1]))) { $problems.Add("line ${n}: a cell out of row-major order: $line") }
                $lastCell = $rc; $open = $strings[1]; $hadStyle = $false; $hadSentence = $false
            }
            'style' {
                if ($strings[0] -ne $windowSheet -or $strings[1] -ne $open -or $hadStyle -or $hadSentence) { $problems.Add("line ${n}: a style row not right after its cell: $line") }
                $hadStyle = $true
            }
            'sentence' {
                if ($strings[0] -ne $windowSheet -or $strings[1] -ne $open -or $hadSentence) { $problems.Add("line ${n}: a sentence row not after its cell (and its style row): $line") }
                $hadSentence = $true
            }
        }
        $phase = $p
    }
    foreach ($k in @('window', 'extent', 'gridlines')) {
        if ($seen[$k] -ne 1) { $problems.Add("the record holds $($seen[$k]) $k row(s), not one") }
    }
    return ,$problems
}
# The 10,000-line program's record, regenerated from the rule: the six header
# rows, then for each row i an odd (cell) or even (formula) row and its sentence row.
function Get-RuleRecord([int]$n) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append("(sheet `"Frazaro`" visible)`n(sheet `"Output`" visible)`n(window `"Output`" `"A1:B$n`")`n(extent `"Output`" `"A1:B$n`")`n(gridlines `"Output`" on)`n(format 0 none general nowrap)`n")
    for ($i = 1; $i -le $n; $i++) {
        if (($i % 2) -eq 1) { [void]$sb.Append("(cell `"Output`" `"A$i`" $i)`n(sentence `"Output`" `"A$i`" $i)`n") }
        else { [void]$sb.Append("(formula `"Output`" `"B$i`" `"=A$($i - 1)*2`")`n(sentence `"Output`" `"B$i`" $i)`n") }
    }
    return $sb.ToString()
}
# The 10,000-line program itself, as tools/bench_view.ps1 writes it, LF.
function Get-RuleProgram([int]$n) {
    $sb = New-Object System.Text.StringBuilder
    for ($i = 1; $i -le $n; $i++) {
        if (($i % 2) -eq 1) { [void]$sb.Append("Put $i into cell A$i.`n") }
        else { [void]$sb.Append("Put formula `"=A$($i - 1)*2`" into cell B$i.`n") }
    }
    return $sb.ToString()
}
# The first differing line of two normalized texts, or 0 when they are the same.
function Get-FirstDifference([string]$a, [string]$b) {
    $la = Get-Lines $a; $lb = Get-Lines $b
    $n = [Math]::Min($la.Count, $lb.Count)
    for ($i = 0; $i -lt $n; $i++) { if ($la[$i] -ne $lb[$i]) { return ($i + 1) } }
    if ($la.Count -ne $lb.Count) { return ($n + 1) }
    return 0
}

# Every fixture of a folder against the table: problems, and lines to print.
function Test-Fixtures([string]$dir) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    if ($fixtures.Count -ne $expectedFixtures) { $problems.Add("the table holds $($fixtures.Count) fixture(s), not the $expectedFixtures pinned here") }
    $files = @()
    if (Test-Path -LiteralPath $dir) { $files = @(Get-ChildItem -LiteralPath $dir -Filter '*.vla' -File | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }) }
    $tableNames = @($fixtures | ForEach-Object { $_.Name })
    foreach ($f in $files) { if ($tableNames -notcontains $f) { $problems.Add("$f.vla is in $dir and not in the table") } }
    foreach ($g in $fixtures) {
        $path = Join-Path $dir ($g.Name + '.vla')
        if (-not (Test-Path -LiteralPath $path)) { $problems.Add("$($g.Name): no fixture at $path"); continue }
        $raw = [System.IO.File]::ReadAllText($path)
        $ending = Get-LineEnding $raw
        $norm = Get-Normalized $raw
        $hash = Get-Sha256 $norm
        $rows = Get-Lines $norm
        $note = "  $($g.Name): $ending on disk, $($rows.Count) lines"
        if ($hash -ne $g.Sha256) { $problems.Add("$($g.Name): the SHA-256 over LF bytes is $hash, the pin is $($g.Sha256)"); $note += ", HASH $($hash.Substring(0, 8)) IS NOT THE PIN $($g.Sha256.Substring(0, 8))  FAIL" }
        else { $note += ", the pin $($hash.Substring(0, 8)) holds" }
        if ($rows.Count -lt $g.Floor) { $problems.Add("$($g.Name): $($rows.Count) lines, below its floor of $($g.Floor)"); $note += ", BELOW THE FLOOR of $($g.Floor)  FAIL" }
        elseif ($rows.Count -gt $g.Floor) { $note += ", above the floor of $($g.Floor) - raise the floor in this file" }
        else { $note += ", at its floor" }
        $order = Test-Order $rows
        foreach ($p in $order) { $problems.Add("$($g.Name): $p") }
        if ($order.Count -gt 0) { $note += ", THE ORDER FAILS ($($order.Count) problem(s))" } else { $note += ", the fixed order holds" }
        if ($g.ContainsKey('Rule') -and $g.Rule) {
            $rule = Get-RuleRecord $sparseLines
            $d = Get-FirstDifference $norm $rule
            if ($d -ne 0) { $problems.Add("$($g.Name): differs from the rule's record at line $d") ; $note += ", NOT THE RULE'S RECORD (line $d)  FAIL" }
            else { $note += ", the rule's own record" }
        }
        $lines.Add($note)
    }
    return @{ Problems = $problems; Lines = $lines }
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_fixtures_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        function Copy-Scratch([string]$name) {
            $d = Join-Path $tmp $name
            New-Item -ItemType Directory -Path $d | Out-Null
            foreach ($g in $fixtures) { Copy-Item -LiteralPath (Join-Path $FixturesDir ($g.Name + '.vla')) -Destination (Join-Path $d ($g.Name + '.vla')) }
            return $d
        }
        $clean = Copy-Scratch 'clean'
        $r0 = Test-Fixtures $clean
        # a byte changed: the pin fails
        $m1 = Copy-Scratch 'byte'
        $p1 = Join-Path $m1 'fixture_data.vla'; $t1 = [System.IO.File]::ReadAllText($p1); [System.IO.File]::WriteAllText($p1, $t1.Replace('"west"', '"East"'), $utf8)
        if ($t1 -eq [System.IO.File]::ReadAllText($p1)) { Write-Output 'FAIL: the byte mutant did not apply'; exit 1 }
        $r1 = Test-Fixtures $m1
        # a line dropped: the floor fails
        $m2 = Copy-Scratch 'line'
        $p2 = Join-Path $m2 'fixture_output.vla'; $t2 = [System.IO.File]::ReadAllText($p2)
        $l2 = Get-Lines (Get-Normalized $t2); $l2.RemoveAt($l2.Count - 1); [System.IO.File]::WriteAllText($p2, (($l2 -join "`r`n") + "`r`n"), $utf8)
        $r2 = Test-Fixtures $m2
        # a format row moved below the first cell: the order fails
        $m3 = Copy-Scratch 'order'
        $p3 = Join-Path $m3 'fixture_frazaro.vla'; $l3 = Get-Lines (Get-Normalized ([System.IO.File]::ReadAllText($p3)))
        $formatRow = @($l3 | Where-Object { $_ -like '(format *' })[0]
        $moved = New-Object System.Collections.Generic.List[string]
        $placed = $false
        foreach ($l in $l3) { if ($l -eq $formatRow) { continue }; $moved.Add($l); if (-not $placed -and $l -like '(cell *') { $moved.Add($formatRow); $placed = $true } }
        [System.IO.File]::WriteAllText($p3, (($moved -join "`r`n") + "`r`n"), $utf8)
        $r3 = Test-Fixtures $m3
        # a line changed in the 10,000-line record: the rule fails
        $m4 = Copy-Scratch 'rule'
        $p4 = Join-Path $m4 'sparse_10000.vla'; $t4 = [System.IO.File]::ReadAllText($p4); [System.IO.File]::WriteAllText($p4, $t4.Replace('(cell "Output" "A9999" 9999)', '(cell "Output" "A9999" 9998)'), $utf8)
        if ($t4 -eq [System.IO.File]::ReadAllText($p4)) { Write-Output 'FAIL: the rule mutant did not apply'; exit 1 }
        $r4 = Test-Fixtures $m4
        $pinFailed = @($r1.Problems | Where-Object { $_ -like 'fixture_data: the SHA-256*' }).Count
        $floorFailed = @($r2.Problems | Where-Object { $_ -like 'fixture_output: *below its floor*' }).Count
        $orderFailed = @($r3.Problems | Where-Object { $_ -like 'fixture_frazaro: line *' }).Count
        $ruleFailed = @($r4.Problems | Where-Object { $_ -like 'sparse_10000: differs from the rule*' }).Count
        Write-Output ("control: the clean copy has {0} problem(s); the changed byte fails its pin ({1}), the dropped line its floor ({2}), the moved format row the order ({3}), the changed record the rule ({4})" -f $r0.Problems.Count, $pinFailed, $floorFailed, $orderFailed, $ruleFailed)
        if ($r0.Problems.Count -eq 0 -and $pinFailed -ge 1 -and $floorFailed -ge 1 -and $orderFailed -ge 1 -and $ruleFailed -ge 1) {
            Write-Output 'OK: the check passes the clean copy and fails each of the four mutants for its own reason'
            exit 0
        }
        Write-Output 'FAIL: the control did not behave as the header says'
        foreach ($p in $r0.Problems) { Write-Output ('  clean: ' + $p) }
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

Write-Output "=== THE VIEWPORT'S FIXTURES: THE DOOR'S RECORDS, PINNED, NEVER SHORTER, IN THE FIXED ORDER (KERNEL.5; oracle 11) ==="
$failed = New-Object System.Collections.Generic.List[string]
$tf = Test-Fixtures $FixturesDir
$tf.Lines | ForEach-Object { Write-Output $_ }
foreach ($p in $tf.Problems) { $failed.Add($p) }

# -Frazaro: each copy against the tree's golden.
if ($Frazaro -ne '') {
    if (-not [System.IO.Path]::IsPathRooted($Frazaro)) { $Frazaro = Join-Path $repoRoot $Frazaro }
    foreach ($g in $fixtures) {
        if ($g.Source -eq '') { continue }
        $theirs = Join-Path $Frazaro $g.Source
        if (-not (Test-Path -LiteralPath $theirs)) { $failed.Add("$($g.Name): no golden at $theirs"); Write-Output "  $($g.Name): no golden at $theirs  FAIL"; continue }
        $mine = Join-Path $FixturesDir ($g.Name + '.vla')
        if (-not (Test-Path -LiteralPath $mine)) { continue }
        $d = Get-FirstDifference (Get-Normalized ([System.IO.File]::ReadAllText($mine))) (Get-Normalized ([System.IO.File]::ReadAllText($theirs)))
        if ($d -ne 0) { $failed.Add("$($g.Name): differs from $theirs at line $d (copy it here and pin it anew)"); Write-Output "  $($g.Name): differs from the Frazaro tree's golden at line $d  FAIL" }
        else { Write-Output "  $($g.Name): the Frazaro tree's golden, whole" }
    }
} else {
    Write-Output "  SKIPPED the Frazaro tree (-Frazaro <tree> compares each copy to scripts/view/ there; the pins stand in for it here)"
}
# -Door: the 10,000-line record printed again.
if ($Door -ne '') {
    if ($Frazaro -eq '') { $failed.Add('-Door needs -Frazaro, for the corpus files the door reads'); Write-Output '  -Door needs -Frazaro  FAIL' }
    else {
        if (-not [System.IO.Path]::IsPathRooted($Door)) { $Door = Join-Path $repoRoot $Door }
        if (-not (Test-Path -LiteralPath $Door)) { $failed.Add("no door at $Door"); Write-Output "  no door at $Door  FAIL" }
        else {
            $tmpProgram = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_sparse_' + [System.IO.Path]::GetRandomFileName() + '.txt')
            [System.IO.File]::WriteAllText($tmpProgram, (Get-RuleProgram $sparseLines), (New-Object System.Text.UTF8Encoding($false)))
            try {
                $old = $ErrorActionPreference
                $ErrorActionPreference = 'Continue'
                try {
                    $global:LASTEXITCODE = 0
                    $printed = & $Door view $tmpProgram --sheet Output --prelude (Join-Path $Frazaro 'scripts/prelude.vla') --phrasebook (Join-Path $Frazaro 'scripts/polyglotta/english.vla') 2>$null
                    $code = $LASTEXITCODE
                } finally { $ErrorActionPreference = $old }
                if ($code -ne 0) { $failed.Add("the door exited $code printing the 10,000-line record"); Write-Output "  the door exited $code  FAIL" }
                else {
                    $text = ((@($printed) | ForEach-Object { [string]$_ }) -join "`n") + "`n"
                    $mine = Join-Path $FixturesDir 'sparse_10000.vla'
                    $d = Get-FirstDifference (Get-Normalized ([System.IO.File]::ReadAllText($mine))) $text
                    if ($d -ne 0) { $failed.Add("sparse_10000: differs from the door's record at line $d"); Write-Output "  sparse_10000: differs from the door's record at line $d  FAIL" }
                    else { Write-Output "  sparse_10000: the door's record, whole, printed again by $Door" }
                }
            } finally { Remove-Item -LiteralPath $tmpProgram -Force -ErrorAction SilentlyContinue }
        }
    }
} else {
    Write-Output "  SKIPPED the door (-Door <frazaro.exe> with -Frazaro prints the 10,000-line record again; the rule stands in for it here)"
}

Write-Output ''
if ($failed.Count -eq 0) {
    Write-Output "=== CHECK: clean - every fixture is the door's record under its pin, at or above its floor, in the fixed order; the sparse record is the rule's ==="
    exit 0
}
Write-Output "=== CHECK: $($failed.Count) problem(s) ==="
$failed | ForEach-Object { Write-Output "  $_" }
exit 1
