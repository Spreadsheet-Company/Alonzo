<#
check_host_exports.ps1 - the engine exports exactly the eleven names SPEC.md
section 8.1 gives it, and nothing else: ten functions and the memory.

WHY (ENGINE.1's second slice, 2026-10-09): the host can reach into the
module only through what the module exports, so the export section is the
engine's whole surface to the page, as the import section is the page's
whole surface to the engine (tools/check_host_imports.ps1, the twin of this
file). An export added by accident is a second door into the grid. The one
this check was written against: the language crate's own C surface, vla_load,
vla_write, vla_step and vla_view with the memory pair, compiled into every
module built on vla-lang and exported only under its c-abi feature, because
a C export of a library crate is exported again by every module built on it
(measured in Frazaro on rustc 1.99, KERNEL.22). Nothing in this workspace
turns that feature on; if anything ever does, a module exports vla_load
beside alonzo_load, a door past the engine's device checks, and this check
fails by name. Frazaro's tools/check_wasm_exports.ps1 holds its two modules
the same way. SPEC.md section 13 named this check as a candidate item; it
rides under ENGINE.1, the list it holds being what that slice writes.

WHAT IT READS: the binary format's section table (magic "\0asm", version 1,
then sections of id byte, LEB128 size, payload). Section id 7 is the export
section: a LEB128 count, then each entry's name, a kind byte (0 a function,
1 a table, 2 a memory, 3 a global) and a LEB128 index. The names are held to
the list below exactly: every export listed, every listed name exported,
memory a memory and the rest functions, and the count pinned beside the
list, so that the list and the count are one fact raised in one commit.

WHERE THE ARTIFACT COMES FROM: target/wasm32-unknown-unknown/release/
alonzo.wasm, which `cargo build --release -p alonzo --target
wasm32-unknown-unknown` writes and CI builds on every push. A tree with no
Rust toolchain has no artifact; the check then says SKIPPED and exits 0, as
the import check does, because CI, which always has the artifact, is where
the pin bites. The 32-byte module of REPO.1, if one is still in a local
target/, exports its memory alone and fails until the engine is rebuilt.
-Path reads any module instead, and a -Path that names no file fails.

-Control proves the reader and the judgment on modules built in memory, each
a valid module (a type section, a function section, the memory and a global
where a case asks for them, the export section and the code section): the
eleven names pass; the ten functions without the memory fail; the eleven with
vla_load fail with the c-abi hint; the eleven less alonzo_step fail; a memory
exported under a function's name fails on its kind; a global __heap_base
beside the eleven fails; a list that disagrees with its count fails; an
export of an unknown kind fails; bytes that are not a module are refused.
Every mutant proves it applied: the reader must name the exports the module
was built with before the judgment is asked.

House style (tools/check_*.ps1): PowerShell 5.1 and pwsh alike, host-free, a
hardcoded and reviewable baseline. Exit 0 clean; exit 1 with every export
named and every problem listed.

Usage:  powershell -File tools\check_host_exports.ps1
        powershell -File tools\check_host_exports.ps1 -Path x.wasm
        powershell -File tools\check_host_exports.ps1 -Control
#>
param(
    [string]$Path = '',
    [switch]$Control
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

# --- The list, SPEC.md section 4.6's table, and the count beside it. The
#     memory is a memory and every other name a function; the two statements
#     below are one fact and are raised in the same commit, with the page. ---
$list = @(
    'memory',
    'alonzo_abi_version', 'alonzo_version_text', 'alonzo_alloc', 'alonzo_free',
    'alonzo_load', 'alonzo_describe', 'alonzo_write', 'alonzo_step', 'alonzo_view', 'alonzo_unload'
)
$expectedExports = 11

function Read-Leb128([byte[]]$b, [ref]$i) {
    $result = 0; $shift = 0
    do {
        if ($i.Value -ge $b.Length) { throw 'truncated LEB128' }
        $byte = [int]$b[$i.Value]; $i.Value++
        $result = $result -bor (($byte -band 0x7F) -shl $shift)
        $shift += 7
    } while (($byte -band 0x80) -ne 0)
    return $result
}
function Read-Name([byte[]]$b, [ref]$i) {
    $len = Read-Leb128 $b $i
    if ($i.Value + $len -gt $b.Length) { throw 'truncated name' }
    $s = [System.Text.Encoding]::UTF8.GetString($b, $i.Value, $len)
    $i.Value += $len
    return $s
}

# Returns the exports of a module, one record each (Name, Kind), or throws if
# the bytes are not a module.
function Get-Exports([byte[]]$b) {
    if ($b.Length -lt 8) { throw 'not a wasm module: shorter than its header' }
    if (-not ($b[0] -eq 0 -and $b[1] -eq 0x61 -and $b[2] -eq 0x73 -and $b[3] -eq 0x6D)) { throw 'not a wasm module: bad magic' }
    $out = New-Object System.Collections.Generic.List[object]
    $i = 8
    while ($i -lt $b.Length) {
        $id = [int]$b[$i]; $i++
        $size = Read-Leb128 $b ([ref]$i)
        if ($id -eq 7) {
            $j = $i
            $count = Read-Leb128 $b ([ref]$j)
            for ($k = 0; $k -lt $count; $k++) {
                $name = Read-Name $b ([ref]$j)
                $kind = [int]$b[$j]; $j++
                [void](Read-Leb128 $b ([ref]$j))
                $what = switch ($kind) { 0 { 'func' } 1 { 'table' } 2 { 'memory' } 3 { 'global' } default { "kind $kind" } }
                $out.Add([pscustomobject]@{ Name = $name; Kind = $what })
            }
        }
        $i += $size
    }
    return ,$out
}

function Format-Export($e) { return "$($e.Name) ($($e.Kind))" }

# Judges a module's exports against the list. Returns the problems, one line
# each, none when the section equals the list.
function Get-Verdicts([object[]]$Exports, [string[]]$Names, [int]$Expected) {
    $out = New-Object System.Collections.Generic.List[string]
    if ($Names.Count -ne $Expected) {
        $out.Add("the list holds $($Names.Count) name(s) and `$expectedExports is $Expected; they are one fact, raised in the same commit")
    }
    $seen = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($e in $Exports) {
        [void]$seen.Add($e.Name)
        if ($Names -ccontains $e.Name) {
            $want = if ($e.Name -ceq 'memory') { 'memory' } else { 'func' }
            if ($e.Kind -ne $want) { $out.Add("kind: $($e.Name) is exported as a $($e.Kind), where the list has a $want") }
            continue
        }
        $hint = ''
        if ($e.Name -clike 'vla_*') { $hint = "; the language's C surface, exported only under vla-lang's c-abi feature, which nothing in this workspace turns on (engine/Cargo.toml)" }
        $out.Add("unknown: $(Format-Export $e) is not on the list$hint")
    }
    foreach ($n in $Names) {
        if (-not $seen.Contains($n)) { $out.Add("missing: $n is on the list and the module does not export it") }
    }
    if ($Exports.Count -ne $Expected) { $out.Add("count: the module exports $($Exports.Count) thing(s); pinned at $Expected") }
    return ,$out
}

if ($Control) {
    function Get-Leb128Bytes([int]$n) {
        $bytes = New-Object System.Collections.Generic.List[byte]
        do {
            $byte = $n -band 0x7F
            $n = $n -shr 7
            if ($n -ne 0) { $byte = $byte -bor 0x80 }
            $bytes.Add([byte]$byte)
        } while ($n -ne 0)
        return ,$bytes.ToArray()
    }
    function Add-Section($bytes, [int]$id, [byte[]]$payload) {
        $bytes.Add([byte]$id)
        $bytes.AddRange([byte[]](Get-Leb128Bytes $payload.Length))
        $bytes.AddRange($payload)
    }
    # A module built in memory: each entry 'name:kind', kind func, memory,
    # global or a number for a kind the format does not have. The functions
    # are () -> () with empty bodies, the memory has no pages and the global
    # is an i32 constant 0; a browser would instantiate it.
    function New-ControlModule([string[]]$Entries) {
        $funcs = @($Entries | Where-Object { $_.EndsWith(':func') }).Count
        $memory = @($Entries | Where-Object { $_.EndsWith(':memory') }).Count -gt 0
        $global = @($Entries | Where-Object { $_.EndsWith(':global') }).Count -gt 0
        $bytes = New-Object System.Collections.Generic.List[byte]
        $bytes.AddRange([byte[]](0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00))
        Add-Section $bytes 1 ([byte[]](0x01, 0x60, 0x00, 0x00))
        if ($funcs -gt 0) {
            $p = New-Object System.Collections.Generic.List[byte]
            $p.AddRange([byte[]](Get-Leb128Bytes $funcs))
            for ($f = 0; $f -lt $funcs; $f++) { $p.Add([byte]0x00) }
            Add-Section $bytes 3 $p.ToArray()
        }
        if ($memory) { Add-Section $bytes 5 ([byte[]](0x01, 0x00, 0x00)) }
        if ($global) { Add-Section $bytes 6 ([byte[]](0x01, 0x7F, 0x00, 0x41, 0x00, 0x0B)) }
        $p = New-Object System.Collections.Generic.List[byte]
        $p.AddRange([byte[]](Get-Leb128Bytes $Entries.Count))
        $fi = 0
        foreach ($e in $Entries) {
            $colon = $e.LastIndexOf(':')
            $name = [System.Text.Encoding]::UTF8.GetBytes($e.Substring(0, $colon))
            $kind = $e.Substring($colon + 1)
            $p.AddRange([byte[]](Get-Leb128Bytes $name.Length)); $p.AddRange($name)
            switch ($kind) {
                'func'   { $p.Add([byte]0x00); $p.AddRange([byte[]](Get-Leb128Bytes $fi)); $fi++ }
                'memory' { $p.Add([byte]0x02); $p.Add([byte]0x00) }
                'global' { $p.Add([byte]0x03); $p.Add([byte]0x00) }
                default  { $p.Add([byte][int]$kind); $p.Add([byte]0x00) }
            }
        }
        Add-Section $bytes 7 $p.ToArray()
        if ($funcs -gt 0) {
            $p = New-Object System.Collections.Generic.List[byte]
            $p.AddRange([byte[]](Get-Leb128Bytes $funcs))
            for ($f = 0; $f -lt $funcs; $f++) { $p.AddRange([byte[]](0x02, 0x00, 0x0B)) }
            Add-Section $bytes 10 $p.ToArray()
        }
        return ,$bytes.ToArray()
    }

    $functions = @($list | Where-Object { $_ -cne 'memory' } | ForEach-Object { "$($_):func" })
    $eleven = @('memory:memory') + $functions
    $lessStep = @($eleven | Where-Object { $_ -cne 'alonzo_step:func' })
    $asFunc = @('memory:func') + $functions
    $cases = @(
        @{ Name = 'the eleven names';                                Entries = $eleven;                          Names = $list;          Expected = 11; WantFail = $false; Want = @() },
        @{ Name = 'the ten functions without the memory';            Entries = $functions;                       Names = $list;          Expected = 11; WantFail = $true;  Want = @('missing: memory', 'count: the module exports 10') },
        @{ Name = 'the eleven and the language''s vla_load';         Entries = $eleven + @('vla_load:func');     Names = $list;          Expected = 11; WantFail = $true;  Want = @('unknown: vla_load (func)', "exported only under vla-lang's c-abi feature") },
        @{ Name = 'the eleven less alonzo_step';                     Entries = $lessStep;                        Names = $list;          Expected = 11; WantFail = $true;  Want = @('missing: alonzo_step') },
        @{ Name = 'a memory exported under a function''s name';      Entries = $asFunc;                          Names = $list;          Expected = 11; WantFail = $true;  Want = @('kind: memory is exported as a func, where the list has a memory') },
        @{ Name = 'the eleven and a global __heap_base';             Entries = $eleven + @('__heap_base:global'); Names = $list;         Expected = 11; WantFail = $true;  Want = @('unknown: __heap_base (global)', 'count: the module exports 12') },
        @{ Name = 'the list and its count disagree';                 Entries = $eleven;                          Names = $list;          Expected = 10; WantFail = $true;  Want = @('the list holds 11 name(s) and $expectedExports is 10') },
        @{ Name = 'an export of a kind the format does not have';    Entries = $eleven + @('odd:7');             Names = $list;          Expected = 11; WantFail = $true;  Want = @('unknown: odd (kind 7)') }
    )

    $verdicts = New-Object System.Collections.Generic.List[string]
    $ok = $true
    foreach ($c in $cases) {
        $bytes = New-ControlModule $c.Entries
        $exports = Get-Exports $bytes
        # The mutant proves it applied: the reader names exactly the exports the module was built with.
        $got = @($exports | ForEach-Object { $_.Name })
        $built = @($c.Entries | ForEach-Object { $_.Substring(0, $_.LastIndexOf(':')) })
        if (($got -join '|') -cne ($built -join '|')) {
            $ok = $false
            $verdicts.Add("$($c.Name): the reader read '$($got -join ', ')' from a module built with '$($built -join ', ')' - the mutant did not apply or the reader is wrong")
            continue
        }
        $problems = Get-Verdicts $exports $c.Names $c.Expected
        $failed = ($problems.Count -gt 0)
        $wantMissing = @()
        foreach ($w in $c.Want) {
            $hit = $false
            foreach ($p in $problems) { if ($p.Contains($w)) { $hit = $true } }
            if (-not $hit) { $wantMissing += $w }
        }
        if ($failed -eq $c.WantFail -and $wantMissing.Count -eq 0) {
            if ($failed) { $verdicts.Add("$($c.Name): fails, as it should ($($problems.Count): $($problems -join ' | '))") }
            else { $verdicts.Add("$($c.Name): passes, as it should ($($exports.Count) export(s) read)") }
        } else {
            $ok = $false
            if ($failed -ne $c.WantFail) {
                $verdicts.Add("$($c.Name): " + $(if ($failed) { "FAILED but should pass: $($problems -join ' | ')" } else { 'PASSED but should fail' }))
            } else {
                $verdicts.Add("$($c.Name): fails, but without the expected line(s) '$($wantMissing -join "', '")': $($problems -join ' | ')")
            }
        }
    }

    # Bytes that are not a module are refused, never read as no exports.
    $refused = $false
    try { [void](Get-Exports ([System.Text.Encoding]::ASCII.GetBytes('Hello, world'))) } catch { $refused = $true; $reason = $_.Exception.Message }
    if ($refused) { $verdicts.Add("bytes that are not a module: refused, as they should be ($reason)") }
    else { $ok = $false; $verdicts.Add('bytes that are not a module: READ as a module but should be refused') }

    foreach ($v in $verdicts) { Write-Host ('control: ' + $v) }
    if ($ok) {
        Write-Host "OK: control: the reader named every export it was given; $($cases.Count) cases judged as the header says, a non-module refused"
        exit 0
    }
    Write-Host 'FAIL: control: the reader or the judgment did not behave as the header says'
    exit 1
}

# Forward slashes: this runs under pwsh on the ubuntu job too, where '\' is a character in a name.
$wasm = if ($Path -ne '') { $Path } else { Join-Path $root 'target/wasm32-unknown-unknown/release/alonzo.wasm' }
if (-not (Test-Path $wasm)) {
    if ($Path -ne '') {
        # A path named by hand and not there is a mistake, never a tree without cargo.
        Write-Host "FAIL: no file at $wasm"
        exit 1
    }
    Write-Host "SKIPPED: no wasm artifact at $wasm (cargo build --release -p alonzo --target wasm32-unknown-unknown writes it; CI checks it on every push)"
    exit 0
}

$bytes = [System.IO.File]::ReadAllBytes($wasm)
try { $exports = Get-Exports $bytes } catch {
    Write-Host "FAIL: $wasm is $($_.Exception.Message)"
    exit 1
}
$problems = Get-Verdicts $exports $list $expectedExports
if ($problems.Count -gt 0) {
    Write-Host "FAIL: $wasm exports $($exports.Count) thing(s) and the list holds $($list.Count), pinned at $expectedExports; $($problems.Count) problem(s)"
    Write-Host '  the export section, every entry:'
    if ($exports.Count -eq 0) { Write-Host '  (none)' }
    foreach ($e in $exports) { Write-Host "  - $(Format-Export $e)" }
    Write-Host '  the problems:'
    foreach ($p in $problems) { Write-Host "  ! $p" }
    exit 1
}
Write-Host "OK: $wasm exports exactly the eleven names of SPEC.md section 8.1 ($($bytes.Length) bytes, $($exports.Count) exports, pinned at $expectedExports)"
exit 0
