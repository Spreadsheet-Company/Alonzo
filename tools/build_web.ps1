<#
build_web.ps1 - the engine's page: web/index.template.html, filled with the
viewport's source, the host shim, the fake module, the cartridges, the
engine's wasm when one is built, and the fixtures, is web/index.html.

WHAT IT DOES: reads web/index.template.html and fills its placeholders, each
once: {{VIEWPORT_JS}} with web/viewport.js, {{FAKE_JS}} with web/fake.js and
{{HOST_JS}} with web/host.js, each inlined whole; {{ALONZO_WASM}} with the
engine's module as base64 when the artifact exists
(target/wasm32-unknown-unknown/release/alonzo.wasm, or -Wasm), and with
nothing when it does not, the page then saying no module was built in, so
that a machine with no Rust toolchain still builds the page (ENGINE.1); and,
since ENGINE.15, {{BLOCKS}} with every text the page holds, each a block of
its own, <script type="text/plain" id="KIND-NAME" data-path="PATH">, the path
the file's from the repository's root. The blocks are written in this order:
the page's name (page-name, Alonzo); each cartridge in the page's order below,
cartridges/<name>/<name>.vla (cartridge-, with data-file, the name a load
passes on), its source beside it when it has one, <name>.source.vla (source-,
SPEC.3's second slice: the pass runs in the page over the texts the page
holds), and its replay and its golden when it has them, <name>.replay.vla and
<name>.golden.vla (replay- and golden-, ENGINE.3's second slice: the page
plays the replay and holds its end to the golden), and since ENGINE.16 its
hand when it has one, <name>.hand.js (hand-, the one block that is a script:
<script id="hand-NAME" data-path="PATH">, which the page runs where it stands
and which registers one constructor under its cartridge's name, the loop
oracle's replay case answering it each frame); each library the sources
include, cartridges/<name>.vla (library-); and each of the bench's records,
web/fixtures/<name>.vla (fixture-). Every text is inlined with its line
endings normalized to LF, so that the page holds the bytes the checks pin.
The template names no file, so that any game's builder fills it with blocks
of its own (web/README.md, "A game's page"), and a {{KIND:name}} place left
in it is refused. The page's order, $order below, and the cartridge folders
must agree exactly, both ways: it is the picker's order after the empty
sheet the page opens on. A text holding '</script' would end its block in
the page and is refused, as Frazaro's builder refuses a phrasebook. The page
is written UTF-8 without a byte-order mark to web/index.html, one file that
runs from disk and fetches nothing: a build artifact (.gitignore), as
Frazaro's page and its add-in are; the template, the scripts, the
cartridges and the fixtures are the source.

WHY A SCRIPT: the page is one file by doctrine, and a page assembled by hand
would drift from its sources; this is the twin of Frazaro's
tools/build_web.ps1, run before a commit and by CI, which keeps the page as
an artifact beside the wasm and runs the render oracle and the host loop's
oracle over it (tools/check_render_oracle.ps1, tools/check_host_loop.ps1).

House style (tools/*.ps1): PowerShell 5.1, host-free, no network; exit 0
with the output named, exit 1 with the reason. -Template, -ViewportJs,
-FakeJs, -HostJs, -FixturesDir, -CartridgesDir, -Wasm, -NoWasm and -Out
exist so that a check can build a page of its own from mutated sources (the
oracles' controls), never for the real page; and -PageOrder, the names of a
scratch folder's cartridges in its page's order, comma-separated, so that a
check builds a game's page from a folder of its own (ENGINE.16).

Usage:  powershell -File tools\build_web.ps1
        powershell -File tools\build_web.ps1 -Out C:\somewhere\index.html
        powershell -File tools\build_web.ps1 -Template <file> -ViewportJs <file> -HostJs <file> -Out <file>
        powershell -File tools\build_web.ps1 -NoWasm
#>
param(
    [string]$Out = '',
    [string]$Template = '',
    [string]$ViewportJs = '',
    [string]$FakeJs = '',
    [string]$HostJs = '',
    [string]$FixturesDir = '',
    [string]$CartridgesDir = '',
    [string]$Wasm = '',
    [string]$PageOrder = '',
    [switch]$NoWasm
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
function Resolve-Arg([string]$value, [string]$default) {
    if ($value -eq '') { return (Join-Path $root $default) }
    if ([System.IO.Path]::IsPathRooted($value)) { return $value }
    return (Join-Path $root $value)
}
$Template = Resolve-Arg $Template 'web/index.template.html'
$ViewportJs = Resolve-Arg $ViewportJs 'web/viewport.js'
$FakeJs = Resolve-Arg $FakeJs 'web/fake.js'
$HostJs = Resolve-Arg $HostJs 'web/host.js'
$FixturesDir = Resolve-Arg $FixturesDir 'web/fixtures'
$CartridgesDir = Resolve-Arg $CartridgesDir 'cartridges'
$Wasm = Resolve-Arg $Wasm 'target/wasm32-unknown-unknown/release/alonzo.wasm'
$Out = Resolve-Arg $Out 'web/index.html'
foreach ($p in @($Template, $ViewportJs, $FakeJs, $HostJs)) { if (-not (Test-Path -LiteralPath $p)) { Write-Output ("FAIL: no file at {0}" -f $p); exit 1 } }
foreach ($d in @($FixturesDir, $CartridgesDir)) { if (-not (Test-Path -LiteralPath $d)) { Write-Output ("FAIL: no folder at {0}" -f $d); exit 1 } }

# The page's order (ENGINE.15): its cartridges as the picker offers them after the empty sheet the page
# opens on, Life first, the benchmark, as the page has always offered them. Held to the cartridge folders
# both ways, so that a cartridge added without a place here, or a place without its folder, is refused.
$order = @('life', 'gun', 'testcard', 'inputcard', 'soundcard', 'sand', 'gridcard', 'kairos', 'superposition', 'seiyaku')
# A check's page of a scratch folder names its own (ENGINE.16); one string under -File, split here.
if ($PageOrder -ne '') { $order = @($PageOrder.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }) }

$html = [System.IO.File]::ReadAllText($Template)

# The places: the scripts, the module and the blocks, each once; and none naming a file.
foreach ($ph in @('{{VIEWPORT_JS}}', '{{FAKE_JS}}', '{{HOST_JS}}', '{{ALONZO_WASM}}', '{{BLOCKS}}')) {
    $n = ([regex]::Matches($html, [regex]::Escape($ph))).Count
    if ($n -ne 1) { Write-Output ("FAIL: the template has {0} {1} time(s), not once" -f $ph, $n); exit 1 }
}
$named = [regex]::Match($html, '\{\{[A-Z]+:[^}]*\}\}')
if ($named.Success) { Write-Output ("FAIL: the template names a file at {0}; every text the page holds is a block this builder writes at {{{{BLOCKS}}}} (ENGINE.15)" -f $named.Value); exit 1 }

$fixtureFiles = @{}
foreach ($f in @(Get-ChildItem -LiteralPath $FixturesDir -Filter '*.vla' -File | Sort-Object Name)) { $fixtureFiles[[System.IO.Path]::GetFileNameWithoutExtension($f.Name)] = $f.FullName }
# A cartridge is a folder holding its file of the same name, cartridges/life/life.vla, and its
# source beside it when it has one, life.source.vla, and its replay and golden when it has them,
# inputcard.replay.vla and inputcard.golden.vla; a library is a file of cartridges/ itself.
$cartridgeFiles = @{}
$sourceFiles = @{}
$replayFiles = @{}
$goldenFiles = @{}
$handFiles = @{}
foreach ($d in @(Get-ChildItem -LiteralPath $CartridgesDir -Directory | Sort-Object Name)) {
    $file = Join-Path $d.FullName ($d.Name + '.vla')
    # A folder holding no .vla at all is a design folder, a cartridge's notes ahead of its file
    # (CART.11): it is no cartridge and takes no place. A folder that holds another .vla without
    # its own is still refused, below.
    if (-not (Test-Path -LiteralPath $file) -and @(Get-ChildItem -LiteralPath $d.FullName -Filter '*.vla' -File).Count -eq 0) { continue }
    if (-not (Test-Path -LiteralPath $file)) { Write-Output ("FAIL: the cartridge folder {0} holds no {1}.vla" -f $d.FullName, $d.Name); exit 1 }
    $cartridgeFiles[$d.Name] = $file
    $source = Join-Path $d.FullName ($d.Name + '.source.vla')
    if (Test-Path -LiteralPath $source) { $sourceFiles[$d.Name] = $source }
    $replay = Join-Path $d.FullName ($d.Name + '.replay.vla')
    if (Test-Path -LiteralPath $replay) { $replayFiles[$d.Name] = $replay }
    $golden = Join-Path $d.FullName ($d.Name + '.golden.vla')
    if (Test-Path -LiteralPath $golden) { $goldenFiles[$d.Name] = $golden }
    $hand = Join-Path $d.FullName ($d.Name + '.hand.js')
    if (Test-Path -LiteralPath $hand) { $handFiles[$d.Name] = $hand }
}
$libraryFiles = @{}
foreach ($f in @(Get-ChildItem -LiteralPath $CartridgesDir -Filter '*.vla' -File | Sort-Object Name)) { $libraryFiles[[System.IO.Path]::GetFileNameWithoutExtension($f.Name)] = $f.FullName }
foreach ($name in $cartridgeFiles.Keys) { if ($order -notcontains $name) { Write-Output ("FAIL: {0} has the cartridge {1}, and the page's order in tools/build_web.ps1 does not name it" -f $CartridgesDir, $name); exit 1 } }
foreach ($name in $order) { if (-not $cartridgeFiles.ContainsKey($name)) { Write-Output ("FAIL: the page's order in tools/build_web.ps1 names {0}, and {1} holds no {0}" -f $name, $CartridgesDir); exit 1 } }
foreach ($name in $replayFiles.Keys) { if (-not $goldenFiles.ContainsKey($name)) { Write-Output ("FAIL: the cartridge {0} has a replay and no golden beside it" -f $name); exit 1 } }
foreach ($name in $goldenFiles.Keys) { if (-not $replayFiles.ContainsKey($name)) { Write-Output ("FAIL: the cartridge {0} has a golden and no replay beside it" -f $name); exit 1 } }

# The texts, '</script' refused in every one.
function Read-Inlined([string]$path, [bool]$normalize) {
    $t = [System.IO.File]::ReadAllText($path)
    if ($normalize) { $t = $t -replace "`r`n", "`n" }
    if ($t -match '(?i)</script') { throw ("{0} contains '</script', which would end its block in the page" -f $path) }
    return $t
}
# A block: one text, its id the kind and the name, its path the file's from the repository's root.
function New-Block([string]$id, [string]$path, [string]$text, [string]$file = '') {
    $attrs = ''
    if ($file -ne '') { $attrs += ' data-file="' + $file + '"' }
    if ($path -ne '') { $attrs += ' data-path="' + $path + '"' }
    return '<script type="text/plain" id="' + $id + '"' + $attrs + '>' + $text + '</script>'
}
# A hand (ENGINE.16): the one block that is a script, run where it stands, never through eval.
function New-HandBlock([string]$name, [string]$path, [string]$text) {
    return '<script id="hand-' + $name + '" data-path="' + $path + '">' + $text + '</script>'
}
try {
    $scripts = @{ '{{VIEWPORT_JS}}' = (Read-Inlined $ViewportJs $false); '{{FAKE_JS}}' = (Read-Inlined $FakeJs $false); '{{HOST_JS}}' = (Read-Inlined $HostJs $false) }
    $blocks = New-Object System.Collections.Generic.List[string]
    $blocks.Add((New-Block 'page-name' '' 'Alonzo'))
    foreach ($name in $order) {
        $dir = 'cartridges/' + $name + '/' + $name
        $blocks.Add((New-Block ('cartridge-' + $name) ($dir + '.vla') (Read-Inlined $cartridgeFiles[$name] $true) ($name + '.vla')))
        if ($sourceFiles.ContainsKey($name)) { $blocks.Add((New-Block ('source-' + $name) ($dir + '.source.vla') (Read-Inlined $sourceFiles[$name] $true))) }
        if ($replayFiles.ContainsKey($name)) {
            $blocks.Add((New-Block ('replay-' + $name) ($dir + '.replay.vla') (Read-Inlined $replayFiles[$name] $true)))
            $blocks.Add((New-Block ('golden-' + $name) ($dir + '.golden.vla') (Read-Inlined $goldenFiles[$name] $true)))
        }
        if ($handFiles.ContainsKey($name)) { $blocks.Add((New-HandBlock $name ($dir + '.hand.js') (Read-Inlined $handFiles[$name] $true))) }
    }
    foreach ($name in @($libraryFiles.Keys | Sort-Object)) { $blocks.Add((New-Block ('library-' + $name) ('cartridges/' + $name + '.vla') (Read-Inlined $libraryFiles[$name] $true))) }
    $fixtureBytes = 0
    foreach ($name in @($fixtureFiles.Keys | Sort-Object)) {
        $t = Read-Inlined $fixtureFiles[$name] $true
        $fixtureBytes += [System.Text.Encoding]::UTF8.GetByteCount($t)
        $blocks.Add((New-Block ('fixture-' + $name) ('web/fixtures/' + $name + '.vla') $t))
    }
} catch { Write-Output ("FAIL: " + $_.Exception.Message); exit 1 }

# The engine's module, base64, or nothing.
$wasmText = ''
$wasmNote = 'no engine module built in'
if (-not $NoWasm -and (Test-Path -LiteralPath $Wasm)) {
    $bytes = [System.IO.File]::ReadAllBytes($Wasm)
    $wasmText = [System.Convert]::ToBase64String($bytes)
    $wasmNote = ("the engine module, {0:N0} bytes" -f $bytes.Length)
}

$page = $html
foreach ($ph in $scripts.Keys) { $page = $page.Replace($ph, $scripts[$ph]) }
$page = $page.Replace('{{ALONZO_WASM}}', $wasmText)
$page = $page.Replace('{{BLOCKS}}', ($blocks -join "`n"))
foreach ($ph in @('{{VIEWPORT_JS}}', '{{FAKE_JS}}', '{{HOST_JS}}', '{{ALONZO_WASM}}', '{{BLOCKS}}')) {
    if ($page.Contains($ph)) { Write-Output ("FAIL: {0} is left in the page" -f $ph); exit 1 }
}
$outDir = Split-Path -Parent $Out
if ($outDir -ne '' -and -not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
[System.IO.File]::WriteAllText($Out, $page, (New-Object System.Text.UTF8Encoding($false)))
Write-Output ("OK: wrote {0} ({1:N0} characters): the viewport, the fake module and the host, {2} block(s): {3} cartridge(s) in the page's order, {4} source(s), {5} replay(s) with {6} golden(s), {7} hand(s) and {8} librar{9}, {10}, {11} fixture(s) holding {12:N0} bytes" -f $Out, $page.Length, $blocks.Count, $cartridgeFiles.Count, $sourceFiles.Count, $replayFiles.Count, $goldenFiles.Count, $handFiles.Count, $libraryFiles.Count, $(if ($libraryFiles.Count -eq 1) { 'y' } else { 'ies' }), $wasmNote, $fixtureFiles.Count, $fixtureBytes)
exit 0
