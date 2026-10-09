<#
build_web.ps1 - the engine's page: web/index.template.html, filled with the
viewport's source, the host shim, the fake module, the cartridges, the
engine's wasm when one is built, and the fixtures, is web/index.html.

WHAT IT DOES: reads web/index.template.html and fills its placeholders, each
exactly as many times as the template has a place for it: {{VIEWPORT_JS}}
with web/viewport.js, {{FAKE_JS}} with web/fake.js and {{HOST_JS}} with
web/host.js, each inlined whole, once; each {{CARTRIDGE:name}} with
cartridges/<name>/<name>.vla and each {{FIXTURE:name}} with
web/fixtures/<name>.vla, inlined as text with line endings normalized to LF,
so that the page holds the bytes the checks pin; and {{ALONZO_WASM}} once,
with the engine's module as base64 when the artifact exists
(target/wasm32-unknown-unknown/release/alonzo.wasm, or -Wasm), and with
nothing when it does not, the page then saying no module was built in, so
that a machine with no Rust toolchain still builds the page (ENGINE.1). The
template's places and each folder's files must agree exactly, both ways. A
text holding '</script' would end its block in the page and is refused, as
Frazaro's builder refuses a phrasebook. The page is written UTF-8 without a
byte-order mark to web/index.html, one file that runs from disk and fetches
nothing: a build artifact (.gitignore), as Frazaro's page and its add-in
are; the template, the scripts, the cartridges and the fixtures are the
source.

WHY A SCRIPT: the page is one file by doctrine, and a page assembled by hand
would drift from its sources; this is the twin of Frazaro's
tools/build_web.ps1, run before a commit and by both CI jobs, which keep the
page as an artifact beside the wasm and run the render oracle and the host
loop's oracle over it (tools/check_render_oracle.ps1,
tools/check_host_loop.ps1).

House style (tools/*.ps1): PowerShell 5.1, host-free, no network; exit 0
with the output named, exit 1 with the reason. -Template, -ViewportJs,
-FakeJs, -HostJs, -FixturesDir, -CartridgesDir, -Wasm, -NoWasm and -Out
exist so that a check can build a page of its own from mutated sources (the
oracles' controls), never for the real page.

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

$html = [System.IO.File]::ReadAllText($Template)

# The scripts and the module: each placeholder once.
foreach ($ph in @('{{VIEWPORT_JS}}', '{{FAKE_JS}}', '{{HOST_JS}}', '{{ALONZO_WASM}}')) {
    $n = ([regex]::Matches($html, [regex]::Escape($ph))).Count
    if ($n -ne 1) { Write-Output ("FAIL: the template has {0} {1} time(s), not once" -f $ph, $n); exit 1 }
}

# A family of places, {{KIND:name}}, held to the files of a folder both ways: name to file.
function Get-Places([string]$kind) {
    $places = @{}
    foreach ($m in [regex]::Matches($html, '\{\{' + $kind + ':([a-z0-9_-]+)\}\}')) {
        $name = $m.Groups[1].Value
        if ($places.ContainsKey($name)) { throw ("the template has {0} more than once" -f $m.Value) }
        $places[$name] = $true
    }
    return $places
}
try { $fixturePlaces = Get-Places 'FIXTURE'; $cartridgePlaces = Get-Places 'CARTRIDGE' } catch { Write-Output ("FAIL: " + $_.Exception.Message); exit 1 }
$fixtureFiles = @{}
foreach ($f in @(Get-ChildItem -LiteralPath $FixturesDir -Filter '*.vla' -File | Sort-Object Name)) { $fixtureFiles[[System.IO.Path]::GetFileNameWithoutExtension($f.Name)] = $f.FullName }
# A cartridge is a folder holding its file of the same name: cartridges/life/life.vla.
$cartridgeFiles = @{}
foreach ($d in @(Get-ChildItem -LiteralPath $CartridgesDir -Directory | Sort-Object Name)) {
    $file = Join-Path $d.FullName ($d.Name + '.vla')
    if (-not (Test-Path -LiteralPath $file)) { Write-Output ("FAIL: the cartridge folder {0} holds no {1}.vla" -f $d.FullName, $d.Name); exit 1 }
    $cartridgeFiles[$d.Name] = $file
}
foreach ($pair in @(@('FIXTURE', $fixturePlaces, $fixtureFiles, $FixturesDir), @('CARTRIDGE', $cartridgePlaces, $cartridgeFiles, $CartridgesDir))) {
    $kind = $pair[0]; $places = $pair[1]; $files = $pair[2]; $dir = $pair[3]
    foreach ($name in $files.Keys) { if (-not $places.ContainsKey($name)) { Write-Output ("FAIL: {0} has {1} and the template has no {{{{{2}:{1}}}}} place for it" -f $dir, $name, $kind); exit 1 } }
    foreach ($name in $places.Keys) { if (-not $files.ContainsKey($name)) { Write-Output ("FAIL: the template has {{{{{0}:{1}}}}}, and {2} holds no {1}" -f $kind, $name, $dir); exit 1 } }
}

# The texts, '</script' refused in every one.
function Read-Inlined([string]$path, [bool]$normalize) {
    $t = [System.IO.File]::ReadAllText($path)
    if ($normalize) { $t = $t -replace "`r`n", "`n" }
    if ($t -match '(?i)</script') { throw ("{0} contains '</script', which would end its block in the page" -f $path) }
    return $t
}
try {
    $scripts = @{ '{{VIEWPORT_JS}}' = (Read-Inlined $ViewportJs $false); '{{FAKE_JS}}' = (Read-Inlined $FakeJs $false); '{{HOST_JS}}' = (Read-Inlined $HostJs $false) }
    $texts = @{}
    $fixtureBytes = 0
    foreach ($name in @($fixtureFiles.Keys | Sort-Object)) { $t = Read-Inlined $fixtureFiles[$name] $true; $texts['{{FIXTURE:' + $name + '}}'] = $t; $fixtureBytes += [System.Text.Encoding]::UTF8.GetByteCount($t) }
    foreach ($name in @($cartridgeFiles.Keys | Sort-Object)) { $texts['{{CARTRIDGE:' + $name + '}}'] = (Read-Inlined $cartridgeFiles[$name] $true) }
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
foreach ($ph in $texts.Keys) { $page = $page.Replace($ph, $texts[$ph]) }
foreach ($ph in @('{{VIEWPORT_JS}}', '{{FAKE_JS}}', '{{HOST_JS}}', '{{ALONZO_WASM}}', '{{FIXTURE:', '{{CARTRIDGE:')) {
    if ($page.Contains($ph)) { Write-Output ("FAIL: {0} is left in the page" -f $ph); exit 1 }
}
$outDir = Split-Path -Parent $Out
if ($outDir -ne '' -and -not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
[System.IO.File]::WriteAllText($Out, $page, (New-Object System.Text.UTF8Encoding($false)))
Write-Output ("OK: wrote {0} ({1:N0} characters): the viewport, the fake module and the host, {2} cartridge(s), {3}, {4} fixture(s) holding {5:N0} bytes" -f $Out, $page.Length, $cartridgeFiles.Count, $wasmNote, $fixtureFiles.Count, $fixtureBytes)
exit 0
