<#
check_host_imports.ps1 - the engine imports the host's functions, named by hand
and held to a list, and nothing else. Pinned at 0 today.

WHY: a WebAssembly module can reach the outside world only through the
functions its host hands it, listed in the module's import section
(CHARTER.md section 2, the honest bottom). Frazaro's core takes that to its
limit and holds its section EMPTY (tools/check_core_imports.ps1, the twin of
this file). The engine cannot: a game must draw, sound and listen, and each
of those is the host's function. So the rule here is a list (AD-4: zero
there, an allowlist here), and the list is written by hand, one reviewed line
per import, never generated (AD-5). SD-13 crosses the road: no outbound call,
ever. This check reads the section off the artifact and holds it to the list,
which turns SECURITY.md's promise from a claim a reviewer takes on faith into
a fact verified on the file, on every push.

WHAT IT READS: the binary format's section table (magic "\0asm", version 1,
then sections of id byte, LEB128 size, payload). Section id 2 is the import
section; its payload begins with a LEB128 count of entries, and each entry
is a module name, a field name, a kind byte and that kind's description. An
unknown kind stops the walk and keeps the count, so an entry the reader
cannot parse is reported and can never pass. On the empty crate there is no
import section at all, and the count is zero by its absence.

THE TWO LISTS, in the order they are judged:
  1. FORBIDDEN, first. A name that fails even when someone lists it, so that
     no reviewed line can admit one: the network, fetch first, then
     XMLHttpRequest, WebSocket, EventSource, sendBeacon, WebTransport, WebRTC,
     and anything that opens a socket; any WASI module, since a WASI import
     means the module was built for a system interface and could reach the
     clock, the file system or a socket through it; and the names generated
     glue writes into the section (__wbindgen, the wbg module), AD-5's pin on
     the artifact. Matched as case-folded regular expressions over
     module.field, so prefetch and websocket fall with their roots.
  2. ALLOWED. One module name for every host function, alonzo, declared once
     as #[link(wasm_import_module = "alonzo")] on the engine's one extern "C"
     block, so an entry reads alonzo.<function> (the owner's decision,
     2026-10-08). The section must EQUAL the list: every import listed, every
     listed name imported, and the count pinned beside the list. Equality and
     not a subset, because the linker drops an import nothing calls, so a
     listed name the module does not import is a declaration the code no
     longer takes, a dormant line nobody reviews again. SPEC.1 owns the
     names; until it names the first, the list is empty and the count is 0.
     An import from module env, the catch-all of C glue and toolchains, is
     told in its own line that no hand-declared import lands there: on
     rustc 1.99 an extern block without #[link(wasm_import_module = ...)]
     does not link at all (measured 2026-10-08, rust-lld: undefined symbol),
     so the module name is always written in the engine's own source.

WHERE THE ARTIFACT COMES FROM: target/wasm32-unknown-unknown/release/
alonzo.wasm, which `cargo build --release -p alonzo --target
wasm32-unknown-unknown` writes and CI builds on every push. A tree with no
Rust toolchain has no artifact; the check then says SKIPPED and exits 0,
because a check that fails on every machine without cargo would be ignored on
all of them, and CI, which always has the artifact, is where the pin bites.
-Path reads any module instead, and a -Path that names no file fails.

-Control proves the reader and the judgment on modules built in memory, each
a valid module (a type section with one signature, then the import section):
the empty module passes against the empty list; a module importing
alonzo.blit fails against the empty list and passes once listed with the
count raised; two imports pass when both are listed and fail when one is;
alonzo.fetch fails as forbidden even when listed; a WASI socket call and two
spellings of generated glue fail as forbidden; alonzo.other against a list of
alonzo.blit fails twice, the unknown name and the missing one; env.blit fails
as unknown with the #[link] hint; a list that disagrees with its count fails;
an import of an unknown kind keeps the count and fails; bytes that are not a
module are refused rather than read as zero imports. Every mutant proves it
applied: the reader must name the imports the module was built with before
the judgment is asked. The reader must count every one right or it is not
trusted to count the real thing.

House style (tools/check_*.ps1): PowerShell 5.1 and pwsh alike, host-free, a
hardcoded and reviewable baseline. Exit 0 clean; exit 1 with every import
named and every problem listed.

Usage:  powershell -File tools\check_host_imports.ps1
        powershell -File tools\check_host_imports.ps1 -Path x.wasm
        powershell -File tools\check_host_imports.ps1 -Control
#>
param(
    [string]$Path = '',
    [switch]$Control
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

# --- 1. The forbidden names, first. Regular expressions, matched without case
#        against module.field; the first match names the reason. A name here
#        fails even when it is on the allowlist below. ---
$forbidden = @(
    @{ Pattern = 'fetch';             Why = 'the Fetch API, an outbound call (SD-13 across the road)' },
    @{ Pattern = 'xmlhttprequest';    Why = 'XMLHttpRequest, an outbound call (SD-13)' },
    @{ Pattern = 'websocket';         Why = 'WebSocket, a socket (SD-13)' },
    @{ Pattern = 'eventsource';       Why = 'EventSource, a connection held open (SD-13)' },
    @{ Pattern = 'sendbeacon';        Why = 'navigator.sendBeacon, an outbound call (SD-13)' },
    @{ Pattern = 'webtransport';      Why = 'WebTransport, a socket (SD-13)' },
    @{ Pattern = 'rtcpeerconnection'; Why = 'WebRTC, a peer connection (SD-13)' },
    @{ Pattern = 'rtcdatachannel';    Why = 'WebRTC, a data channel (SD-13)' },
    @{ Pattern = 'socket';            Why = 'anything that opens a socket (SD-13)' },
    @{ Pattern = 'sock_';             Why = 'a WASI socket call: sock_accept, sock_recv, sock_send, sock_shutdown (SD-13)' },
    @{ Pattern = 'connect';           Why = 'anything that opens a socket (SD-13)' },
    @{ Pattern = '^wasi';             Why = 'a WASI module; the engine is built for wasm32-unknown-unknown and takes no system interface' },
    @{ Pattern = '__wbindgen';        Why = 'generated glue; the imports are named by hand (AD-5)' },
    @{ Pattern = '^wbg\.';            Why = 'generated glue, the wbg module; the imports are named by hand (AD-5)' }
)

# --- 2. The allowlist, and the count beside it. One line per import, as
#        alonzo.<function>, each with the item that added it and the device
#        it serves; the two statements below are one fact and are raised in
#        the same commit. Empty until SPEC.1 names the host's functions. ---
$allowed = @(
    # 'alonzo.blit'    # ENGINE.2: the Screen sheet blitted whole (an example of the shape; SPEC.1 names the real ones)
)
$expectedImports = 0

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
function Skip-Limits([byte[]]$b, [ref]$i) {
    $flag = [int]$b[$i.Value]; $i.Value++
    [void](Read-Leb128 $b $i)
    if (($flag -band 1) -ne 0) { [void](Read-Leb128 $b $i) }
}

# Returns the imports of a module, one record each (Module, Field, Kind), or
# throws if the bytes are not a module. An unknown kind stops the walk of the
# entries and keeps the count; the entries not reached are '?.? (unparsed
# entry)', which no list can hold.
function Get-Imports([byte[]]$b) {
    if ($b.Length -lt 8) { throw 'not a wasm module: shorter than its header' }
    if (-not ($b[0] -eq 0 -and $b[1] -eq 0x61 -and $b[2] -eq 0x73 -and $b[3] -eq 0x6D)) { throw 'not a wasm module: bad magic' }
    $list = New-Object System.Collections.Generic.List[object]
    $i = 8
    while ($i -lt $b.Length) {
        $id = [int]$b[$i]; $i++
        $size = Read-Leb128 $b ([ref]$i)
        if ($id -eq 2) {
            $j = $i
            $count = Read-Leb128 $b ([ref]$j)
            for ($k = 0; $k -lt $count; $k++) {
                $mod = Read-Name $b ([ref]$j)
                $fld = Read-Name $b ([ref]$j)
                $kind = [int]$b[$j]; $j++
                switch ($kind) {
                    0 { [void](Read-Leb128 $b ([ref]$j)); $what = 'func' }
                    1 { $j++; Skip-Limits $b ([ref]$j); $what = 'table' }
                    2 { Skip-Limits $b ([ref]$j); $what = 'memory' }
                    3 { $j += 2; $what = 'global' }
                    default { $what = "kind $kind"; $k = $count }   # unknown kind: stop walking entries, keep the count
                }
                $list.Add([pscustomobject]@{ Module = $mod; Field = $fld; Kind = $what })
            }
            while ($list.Count -lt $count) { $list.Add([pscustomobject]@{ Module = '?'; Field = '?'; Kind = 'unparsed entry' }) }
        }
        $i += $size
    }
    return ,$list
}

function Format-Import($imp) { return "$($imp.Module).$($imp.Field) ($($imp.Kind))" }

function Get-ForbiddenReason([string]$Name) {
    foreach ($f in $forbidden) { if ($Name -match $f.Pattern) { return $f.Why } }
    return $null
}

# Judges a module's imports against the two lists. Returns the problems, one
# line each, none when the section equals the list.
function Get-Verdicts([object[]]$Imports, [string[]]$Allow, [int]$Expected) {
    $out = New-Object System.Collections.Generic.List[string]
    if ($Allow.Count -ne $Expected) {
        $out.Add("the allowlist holds $($Allow.Count) name(s) and `$expectedImports is $Expected; they are one fact, raised in the same commit")
    }
    $seen = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($imp in $Imports) {
        $name = "$($imp.Module).$($imp.Field)"
        [void]$seen.Add($name)
        $why = Get-ForbiddenReason $name
        if ($why) { $out.Add("forbidden: $(Format-Import $imp) - $why"); continue }
        if ($Allow -ccontains $name) { continue }
        $hint = ''
        if ($imp.Module -ceq 'env') { $hint = "; env is the catch-all module of C glue and toolchains, never a hand-declared import, which is #[link(wasm_import_module = ""alonzo"")]" }
        $out.Add("unknown: $(Format-Import $imp) is not on the allowlist$hint")
    }
    foreach ($a in $Allow) {
        if (-not $seen.Contains($a)) { $out.Add("missing: $a is on the allowlist and the module does not import it; an import nothing calls is dropped by the linker, so remove the line or call the function") }
    }
    if ($Imports.Count -ne $Expected) { $out.Add("count: the module imports $($Imports.Count) thing(s); pinned at $Expected") }
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
    # A module built in memory: the header, a type section with one signature
    # () -> (), and an import section naming each module.field as a function
    # of that type. A browser would instantiate it given the imports.
    function New-ControlModule([string[]]$Pairs) {
        $bytes = New-Object System.Collections.Generic.List[byte]
        $bytes.AddRange([byte[]](0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00))
        $bytes.AddRange([byte[]](0x01, 0x04, 0x01, 0x60, 0x00, 0x00))
        if ($Pairs.Count -gt 0) {
            $payload = New-Object System.Collections.Generic.List[byte]
            $payload.AddRange([byte[]](Get-Leb128Bytes $Pairs.Count))
            foreach ($p in $Pairs) {
                $dot = $p.IndexOf('.')
                $mod = [System.Text.Encoding]::UTF8.GetBytes($p.Substring(0, $dot))
                $fld = [System.Text.Encoding]::UTF8.GetBytes($p.Substring($dot + 1))
                $payload.AddRange([byte[]](Get-Leb128Bytes $mod.Length)); $payload.AddRange($mod)
                $payload.AddRange([byte[]](Get-Leb128Bytes $fld.Length)); $payload.AddRange($fld)
                $payload.Add([byte]0x00)   # kind: func
                $payload.Add([byte]0x00)   # type index 0
            }
            $bytes.Add([byte]0x02)
            $bytes.AddRange([byte[]](Get-Leb128Bytes $payload.Count))
            $bytes.AddRange($payload.ToArray())
        }
        return ,$bytes.ToArray()
    }

    $cases = @(
        @{ Name = 'the empty module against the empty list';          Pairs = @();                              Allow = @();                               Expected = 0; WantFail = $false; Want = @() },
        @{ Name = 'alonzo.blit against the empty list';               Pairs = @('alonzo.blit');                 Allow = @();                               Expected = 0; WantFail = $true;  Want = @('unknown: alonzo.blit (func)', 'count: the module imports 1') },
        @{ Name = 'alonzo.blit once listed, the count raised';        Pairs = @('alonzo.blit');                 Allow = @('alonzo.blit');                  Expected = 1; WantFail = $false; Want = @() },
        @{ Name = 'two imports, both listed';                         Pairs = @('alonzo.blit', 'alonzo.note');  Allow = @('alonzo.blit', 'alonzo.note');   Expected = 2; WantFail = $false; Want = @() },
        @{ Name = 'two imports, one listed';                          Pairs = @('alonzo.blit', 'alonzo.note');  Allow = @('alonzo.blit');                  Expected = 1; WantFail = $true;  Want = @('unknown: alonzo.note (func)', 'count: the module imports 2') },
        @{ Name = 'alonzo.fetch, forbidden even when listed';         Pairs = @('alonzo.fetch');                Allow = @('alonzo.fetch');                 Expected = 1; WantFail = $true;  Want = @('forbidden: alonzo.fetch (func) - the Fetch API') },
        @{ Name = 'a WASI socket call';                               Pairs = @('wasi_snapshot_preview1.sock_accept'); Allow = @();                        Expected = 0; WantFail = $true;  Want = @('forbidden: wasi_snapshot_preview1.sock_accept (func)') },
        @{ Name = 'generated glue, the __wbindgen spelling';          Pairs = @('__wbindgen_placeholder__.__wbindgen_throw'); Allow = @();                 Expected = 0; WantFail = $true;  Want = @('forbidden: __wbindgen_placeholder__.__wbindgen_throw (func) - generated glue') },
        @{ Name = 'generated glue, the wbg module';                   Pairs = @('wbg.__wbg_log_1d3ae0273cc9fc8f'); Allow = @();                            Expected = 0; WantFail = $true;  Want = @('forbidden: wbg.__wbg_log_1d3ae0273cc9fc8f (func) - generated glue, the wbg module') },
        @{ Name = 'alonzo.other against a list of alonzo.blit';       Pairs = @('alonzo.other');                Allow = @('alonzo.blit');                  Expected = 1; WantFail = $true;  Want = @('unknown: alonzo.other (func)', 'missing: alonzo.blit is on the allowlist') },
        @{ Name = 'env.blit, the catch-all module';                   Pairs = @('env.blit');                    Allow = @();                               Expected = 0; WantFail = $true;  Want = @('unknown: env.blit (func)', 'never a hand-declared import, which is #[link(wasm_import_module') },
        @{ Name = 'the list and its count disagree';                  Pairs = @();                              Allow = @('alonzo.blit');                  Expected = 0; WantFail = $true;  Want = @('the allowlist holds 1 name(s) and $expectedImports is 0', 'missing: alonzo.blit') }
    )

    $verdicts = New-Object System.Collections.Generic.List[string]
    $ok = $true
    foreach ($c in $cases) {
        $bytes = New-ControlModule $c.Pairs
        $imports = Get-Imports $bytes
        # The mutant proves it applied: the reader names exactly the imports the module was built with, each a func.
        $got = @($imports | ForEach-Object { "$($_.Module).$($_.Field)" })
        $kinds = @($imports | ForEach-Object { $_.Kind } | Where-Object { $_ -ne 'func' })
        if (($got -join '|') -ne ($c.Pairs -join '|') -or $kinds.Count -ne 0) {
            $ok = $false
            $verdicts.Add("$($c.Name): the reader read '$($got -join ', ')' from a module built with '$($c.Pairs -join ', ')' - the mutant did not apply or the reader is wrong")
            continue
        }
        $problems = Get-Verdicts $imports $c.Allow $c.Expected
        $failed = ($problems.Count -gt 0)
        $wantMissing = @()
        foreach ($w in $c.Want) {
            $hit = $false
            foreach ($p in $problems) { if ($p.Contains($w)) { $hit = $true } }
            if (-not $hit) { $wantMissing += $w }
        }
        if ($failed -eq $c.WantFail -and $wantMissing.Count -eq 0) {
            if ($failed) { $verdicts.Add("$($c.Name): fails, as it should ($($problems.Count): $($problems -join ' | '))") }
            else { $verdicts.Add("$($c.Name): passes, as it should ($($imports.Count) import(s) read)") }
        } else {
            $ok = $false
            if ($failed -ne $c.WantFail) {
                $verdicts.Add("$($c.Name): " + $(if ($failed) { "FAILED but should pass: $($problems -join ' | ')" } else { 'PASSED but should fail' }))
            } else {
                $verdicts.Add("$($c.Name): fails, but without the expected line(s) '$($wantMissing -join "', '")': $($problems -join ' | ')")
            }
        }
    }

    # An import of an unknown kind: the count is kept, the entries past it are
    # unparsed, and nothing passes. Count 2; a.b of kind 7, then c.d, never reached.
    $odd = [byte[]](0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00,
                    0x01, 0x04, 0x01, 0x60, 0x00, 0x00,
                    0x02, 0x0C, 0x02, 0x01, 0x61, 0x01, 0x62, 0x07, 0x01, 0x63, 0x01, 0x64, 0x00, 0x00)
    $imports = Get-Imports $odd
    $names = @($imports | ForEach-Object { Format-Import $_ })
    $problems = Get-Verdicts $imports @() 0
    if ($imports.Count -eq 2 -and $names[0] -eq 'a.b (kind 7)' -and $names[1] -eq '?.? (unparsed entry)' -and $problems.Count -eq 3) {
        $verdicts.Add("an import of an unknown kind: the count is kept (2), the entries read '$($names -join ', ')', and it fails, as it should ($($problems.Count))")
    } else {
        $ok = $false
        $verdicts.Add("an import of an unknown kind: read $($imports.Count) entries '$($names -join ', ')' with $($problems.Count) problem(s); wanted 2, 'a.b (kind 7)', '?.? (unparsed entry)', 3")
    }

    # Bytes that are not a module are refused, never read as zero imports.
    $refused = $false
    try { [void](Get-Imports ([System.Text.Encoding]::ASCII.GetBytes('Hello, world'))) } catch { $refused = $true; $reason = $_.Exception.Message }
    if ($refused) { $verdicts.Add("bytes that are not a module: refused, as they should be ($reason)") }
    else { $ok = $false; $verdicts.Add('bytes that are not a module: READ as a module but should be refused') }

    foreach ($v in $verdicts) { Write-Host ('control: ' + $v) }
    if ($ok) {
        Write-Host "OK: control: the reader named every import it was given; $($cases.Count) cases judged as the header says, an unknown kind kept and failed, a non-module refused"
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
try { $imports = Get-Imports $bytes } catch {
    Write-Host "FAIL: $wasm is $($_.Exception.Message)"
    exit 1
}
$problems = Get-Verdicts $imports $allowed $expectedImports
if ($problems.Count -gt 0) {
    Write-Host "FAIL: $wasm imports $($imports.Count) thing(s) and the allowlist holds $($allowed.Count), pinned at $expectedImports; $($problems.Count) problem(s)"
    Write-Host '  the import section, every entry:'
    if ($imports.Count -eq 0) { Write-Host '  (none)' }
    foreach ($imp in $imports) { Write-Host "  - $(Format-Import $imp)" }
    Write-Host '  the problems:'
    foreach ($p in $problems) { Write-Host "  ! $p" }
    exit 1
}
if ($allowed.Count -eq 0) {
    Write-Host "OK: $wasm imports nothing; the allowlist is empty until SPEC.1 names the host's functions ($($bytes.Length) bytes, 0 imports, pinned at 0)"
} else {
    Write-Host "OK: $wasm imports exactly the allowlist ($($bytes.Length) bytes, $($imports.Count) imports, pinned at $expectedImports)"
}
exit 0
