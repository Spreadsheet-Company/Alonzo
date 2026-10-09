<#
build_web.ps1 - the viewport's page: web/index.template.html, filled with the
viewport's source and the fixtures, is web/index.html.

WHAT IT DOES: reads web/index.template.html and fills its placeholders, each
exactly as many times as the template has a place for it: {{VIEWPORT_JS}}
with web/viewport.js, the viewport's source, inlined whole, once; and each
{{FIXTURE:name}} with web/fixtures/<name>.vla, a view record the door
printed (the six view goldens of Frazaro's scripts/view/ and the record of
the 10,000-line program), inlined as text with its line endings normalized
to LF, so that the page holds the bytes the fixture check pins. The two
sets, the template's places and the folder's files, must agree exactly both
ways. A text holding '</script' would end its block in the page and is
refused, as Frazaro's builder refuses a phrasebook. The page is written
UTF-8 without a byte-order mark to web/index.html, one file that runs from
disk and fetches nothing: a build artifact (.gitignore), as Frazaro's page
and its add-in are; the template, the script and the fixtures are the source.
No module yet: the engine's wasm joins the page at ENGINE.1, as Frazaro's
core joins its page, and the builder gains that placeholder then.

WHY A SCRIPT: the page is one file by doctrine, and a page assembled by hand
would drift from the script and the fixtures; this is the twin of Frazaro's
tools/build_web.ps1, run before a commit and by both CI jobs, which keep the
page as an artifact beside the wasm and run the render oracle over it
(tools/check_render_oracle.ps1).

House style (tools/*.ps1): PowerShell 5.1, host-free, no network; exit 0
with the output named, exit 1 with the reason. -Template, -ViewportJs,
-FixturesDir and -Out exist so that a check can build a page of its own
from mutated sources (the oracle's control), never for the real page.

Usage:  powershell -File tools\build_web.ps1
        powershell -File tools\build_web.ps1 -Out C:\somewhere\index.html
        powershell -File tools\build_web.ps1 -Template <file> -ViewportJs <file> -Out <file>
#>
param(
    [string]$Out = '',
    [string]$Template = '',
    [string]$ViewportJs = '',
    [string]$FixturesDir = ''
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
$FixturesDir = Resolve-Arg $FixturesDir 'web/fixtures'
$Out = Resolve-Arg $Out 'web/index.html'
foreach ($p in @($Template, $ViewportJs)) { if (-not (Test-Path -LiteralPath $p)) { Write-Output ("FAIL: no file at {0}" -f $p); exit 1 } }
if (-not (Test-Path -LiteralPath $FixturesDir)) { Write-Output ("FAIL: no fixtures folder at {0}" -f $FixturesDir); exit 1 }

$html = [System.IO.File]::ReadAllText($Template)

# The viewport's source: once.
$n = ([regex]::Matches($html, [regex]::Escape('{{VIEWPORT_JS}}'))).Count
if ($n -ne 1) { Write-Output ("FAIL: the template has {{{{VIEWPORT_JS}}}} {0} time(s), not once" -f $n); exit 1 }

# The fixtures: each {{FIXTURE:name}} once, each a file of the folder, and every file a place.
$places = @{}
foreach ($m in [regex]::Matches($html, '\{\{FIXTURE:([a-z0-9_]+)\}\}')) {
    $name = $m.Groups[1].Value
    if ($places.ContainsKey($name)) { Write-Output ("FAIL: the template has {0} more than once" -f $m.Value); exit 1 }
    $places[$name] = $true
}
$files = @(Get-ChildItem -LiteralPath $FixturesDir -Filter '*.vla' -File | Sort-Object Name)
$names = @{}
foreach ($f in $files) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $names[$name] = $f.FullName
    if (-not $places.ContainsKey($name)) { Write-Output ("FAIL: the fixture {0} has no {{{{FIXTURE:{1}}}}} place in the template" -f $f.Name, $name); exit 1 }
}
foreach ($name in $places.Keys) {
    if (-not $names.ContainsKey($name)) { Write-Output ("FAIL: the template has {{{{FIXTURE:{0}}}}}, and {1} holds no {0}.vla" -f $name, $FixturesDir); exit 1 }
}

$script = [System.IO.File]::ReadAllText($ViewportJs)
if ($script -match '(?i)</script') { Write-Output ("FAIL: {0} contains '</script', which would end its block in the page" -f $ViewportJs); exit 1 }
$texts = @{}
$fixtureBytes = 0
foreach ($name in @($names.Keys | Sort-Object)) {
    $t = [System.IO.File]::ReadAllText($names[$name])
    $t = $t -replace "`r`n", "`n"
    if ($t -match '(?i)</script') { Write-Output ("FAIL: the fixture {0} contains '</script', which would end its block in the page" -f $name); exit 1 }
    $texts[$name] = $t
    $fixtureBytes += [System.Text.Encoding]::UTF8.GetByteCount($t)
}

$page = $html.Replace('{{VIEWPORT_JS}}', $script)
foreach ($name in $texts.Keys) { $page = $page.Replace('{{FIXTURE:' + $name + '}}', $texts[$name]) }
foreach ($ph in @('{{VIEWPORT_JS}}', '{{FIXTURE:')) {
    if ($page.Contains($ph)) { Write-Output ("FAIL: {0} is left in the page" -f $ph); exit 1 }
}
$outDir = Split-Path -Parent $Out
if ($outDir -ne '' -and -not (Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
[System.IO.File]::WriteAllText($Out, $page, (New-Object System.Text.UTF8Encoding($false)))
Write-Output ("OK: wrote {0} ({1:N0} characters): the viewport {2:N0} characters, {3} fixture(s) holding {4:N0} bytes" -f $Out, $page.Length, $script.Length, $texts.Count, $fixtureBytes)
exit 0
