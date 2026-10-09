<#
check_web_offline.ps1 - the viewport's page loads nothing, links nowhere, and
is filled from the viewport's source and the fixtures through placeholders,
each in its place.

WHY: the twin of Frazaro's check of the same name (KERNEL.5, laid here;
SPEC.md section 8.3: the shim draws the record through the viewport and
never calls fetch). The page, web/index.template.html, is one HTML file that
runs from disk, and its whole promise is SD-13 in a browser: it reads nothing
from the network and writes nothing anywhere. The engine it will carry
cannot phone home, since its import section is held to an allowlist read
off the artifact (tools/check_host_imports.ps1); this check holds the page
around it to the same doctrine, on every push, so that a script tag, a
stylesheet, a font, an image, a link or a fetch cannot quietly make the page
need a network the day someone adds one for convenience. Unlike Frazaro's
page, this one has no link at all: there is no allowed anchor, and a bare
address fails as any other reaching out does.

WHAT IT HOLDS, on web/index.template.html (the source) and the three
scripts the builder inlines into the page, so that their text is the page's
code: web/viewport.js, web/fake.js and web/host.js (ENGINE.1): no external
reference of any kind - script, link, img, iframe, form, anchor, @import,
url(), http(s)://, fetch, XMLHttpRequest, WebSocket, EventSource,
sendBeacon, dynamic import, importScripts; a charset declaration;
{{VIEWPORT_JS}}, {{FAKE_JS}}, {{HOST_JS}} and {{ALONZO_WASM}} exactly once
each; each {{FIXTURE:name}} once, a file web/fixtures/<name>.vla, and each
{{CARTRIDGE:name}} once, a file cartridges/<name>/<name>.vla, with no file of
either folder left without its place, so a built page is whole and the page
and its sources cannot drift apart. When web/index.html exists beside the
template, its markup is held to the same list of tags (a record or a
cartridge cannot spell a tag) and no placeholder is left in it.

-Control proves the check on scratch copies of the template and the
scripts: the real set passes; a template with a script tag's src appended,
one with a fetch call, one with the viewport's placeholder removed, one with
an anchor appended, one with an image, one with a FIXTURE place for a file
the folder does not hold, one with a CARTRIDGE place for a cartridge the
folder does not hold, a viewport source with a fetch call appended and a
host source with a fetch call appended must each fail.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network;
exit 0 clean, exit 1 with every problem named.

Usage:  powershell -File tools\check_web_offline.ps1
        powershell -File tools\check_web_offline.ps1 -Control
#>
param(
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $repoRoot 'web/index.template.html'
$scriptPath = Join-Path $repoRoot 'web/viewport.js'
$fakePath = Join-Path $repoRoot 'web/fake.js'
$hostPath = Join-Path $repoRoot 'web/host.js'
$builtPath = Join-Path $repoRoot 'web/index.html'
$fixturesDir = Join-Path $repoRoot 'web/fixtures'
$cartridgesDir = Join-Path $repoRoot 'cartridges'

# Markup that reaches out: held on the template and on a built page alike.
# There is no allowed anchor on this page, so '<a href' is forbidden outright.
$tagTokens = @('<script src', '<script type="module" src', '<link ', '<img ', '<iframe', '<form', '<a href', '<video', '<audio', '<source', '<object', '<embed', '<meta http-equiv="refresh"')
# Code and style that reach out: held on the template and on the viewport's
# source, which the builder inlines into the page.
$codeTokens = @('fetch(', 'XMLHttpRequest', 'WebSocket', 'EventSource', 'sendBeacon', 'import(', 'importScripts', '@import', 'url(', 'http://', 'https://')
# The placeholders the builder fills once each: the three scripts and the engine's module.
$viewportPlaceholder = '{{VIEWPORT_JS}}'
$oncePlaceholders = @($viewportPlaceholder, '{{FAKE_JS}}', '{{HOST_JS}}', '{{ALONZO_WASM}}')

function Get-FixtureNames([string]$dir) {
    $names = @()
    if (Test-Path -LiteralPath $dir) {
        foreach ($f in (Get-ChildItem -LiteralPath $dir -Filter '*.vla' -File | Sort-Object Name)) { $names += [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }
    }
    return ,$names
}
# A cartridge is a folder holding its file of the same name: cartridges/life/life.vla.
function Get-CartridgeNames([string]$dir) {
    $names = @()
    if (Test-Path -LiteralPath $dir) {
        foreach ($d in (Get-ChildItem -LiteralPath $dir -Directory | Sort-Object Name)) { if (Test-Path -LiteralPath (Join-Path $d.FullName ($d.Name + '.vla'))) { $names += $d.Name } }
    }
    return ,$names
}
# A family of places, {{KIND:name}}, held to the names of a folder both ways.
function Test-Places([string]$text, [string]$kind, $names, [string]$dir) {
    $problems = @()
    if ($names.Count -eq 0) { $problems += ("no {0} read from {1}" -f $kind.ToLowerInvariant(), $dir) }
    $seen = @{}
    foreach ($m in [regex]::Matches($text, '\{\{' + $kind + ':([a-z0-9_-]+)\}\}')) {
        $name = $m.Groups[1].Value
        if ($seen.ContainsKey($name)) { $problems += ("placeholder repeated: {0}" -f $m.Value) }
        $seen[$name] = $true
        if ($names -notcontains $name) { $problems += ("{0} has no {1} under {2}" -f $m.Value, $name, $dir) }
    }
    foreach ($name in $names) {
        if (-not $seen.ContainsKey($name)) { $problems += ("{0} under {1} has no {{{{{2}:{0}}}}} place in the template" -f $name, $dir, $kind) }
    }
    return $problems
}

function Test-Template([string]$path, [string]$script, [string]$fixtures, [string]$fake = $fakePath, [string]$hostjs = $hostPath, [string]$cartridges = $cartridgesDir) {
    $problems = @()
    $text = [System.IO.File]::ReadAllText($path)
    $lower = $text.ToLowerInvariant()
    foreach ($t in ($tagTokens + $codeTokens)) {
        if ($lower.Contains($t.ToLowerInvariant())) { $problems += ("the template reaches out: '{0}'" -f $t) }
    }
    if (-not $lower.Contains('<meta charset="utf-8">')) { $problems += 'no <meta charset="utf-8">' }
    foreach ($ph in $oncePlaceholders) {
        $n = ([regex]::Matches($text, [regex]::Escape($ph))).Count
        if ($n -ne 1) { $problems += ("placeholder {0} appears {1} time(s), and the template has one place for it" -f $ph, $n) }
    }
    # The fixtures' and the cartridges' places: each once, each a file of its folder, and each file with its place.
    $problems += @(Test-Places $text 'FIXTURE' (Get-FixtureNames $fixtures) $fixtures)
    $problems += @(Test-Places $text 'CARTRIDGE' (Get-CartridgeNames $cartridges) $cartridges)
    # The scripts' sources: the code tokens, since each is the page's code once inlined.
    foreach ($pair in @(@("the viewport's source", $script), @("the fake module's source", $fake), @("the host's source", $hostjs))) {
        if (-not (Test-Path -LiteralPath $pair[1])) { $problems += ("no file for {0} at {1}" -f $pair[0], $pair[1]); continue }
        $js = [System.IO.File]::ReadAllText($pair[1]).ToLowerInvariant()
        foreach ($t in $codeTokens) {
            if ($js.Contains($t.ToLowerInvariant())) { $problems += ("{0} reaches out: '{1}'" -f $pair[0], $t) }
        }
    }
    # Returned without the comma, as Frazaro's twin returns it: the callers wrap the result in @().
    return $problems
}

function Test-Built([string]$path) {
    $problems = @()
    $lower = [System.IO.File]::ReadAllText($path).ToLowerInvariant()
    foreach ($t in $tagTokens) {
        if ($lower.Contains($t.ToLowerInvariant())) { $problems += ("the built page reaches out: '{0}'" -f $t) }
    }
    foreach ($ph in ($oncePlaceholders + @('{{FIXTURE:', '{{CARTRIDGE:'))) {
        if ($lower.Contains($ph.ToLowerInvariant())) { $problems += ("the built page has {0} left in it" -f $ph) }
    }
    return $problems
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_weboff_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $text = [System.IO.File]::ReadAllText($templatePath)
        $js = [System.IO.File]::ReadAllText($scriptPath)
        $real = @(Test-Template $templatePath $scriptPath $fixturesDir)
        $a = Join-Path $tmp 'a.html'; [System.IO.File]::WriteAllText($a, ($text + "`n<script src=""x.js""></script>`n"), $utf8)
        $b = Join-Path $tmp 'b.html'; [System.IO.File]::WriteAllText($b, ($text + "`n<script>fetch('x')</script>`n"), $utf8)
        $c = Join-Path $tmp 'c.html'; [System.IO.File]::WriteAllText($c, $text.Replace($viewportPlaceholder, ''), $utf8)
        $d = Join-Path $tmp 'd.html'; [System.IO.File]::WriteAllText($d, ($text + "`n<a href=""x.html"">x</a>`n"), $utf8)
        $e = Join-Path $tmp 'e.html'; [System.IO.File]::WriteAllText($e, ($text + "`n<img src=""data:image/png;base64,AAAA"">`n"), $utf8)
        $f = Join-Path $tmp 'f.html'; [System.IO.File]::WriteAllText($f, $text.Replace('{{FIXTURE:fixture_data}}', '{{FIXTURE:nowhere}}'), $utf8)
        $gjs = Join-Path $tmp 'g.js'; [System.IO.File]::WriteAllText($gjs, ($js + "`nfetch('x');`n"), $utf8)
        $anchorH = '{{CARTRIDGE:life}}'
        if (([regex]::Matches($text, [regex]::Escape($anchorH))).Count -ne 1) { Write-Output "FAIL: the anchor $anchorH is not in the template exactly once"; exit 1 }
        $h = Join-Path $tmp 'h.html'; [System.IO.File]::WriteAllText($h, $text.Replace($anchorH, '{{CARTRIDGE:nowhere}}'), $utf8)
        $ijs = Join-Path $tmp 'i.js'; [System.IO.File]::WriteAllText($ijs, ([System.IO.File]::ReadAllText($hostPath) + "`nfetch('x');`n"), $utf8)
        $ra = @(Test-Template $a $scriptPath $fixturesDir); $rb = @(Test-Template $b $scriptPath $fixturesDir); $rc = @(Test-Template $c $scriptPath $fixturesDir)
        $rd = @(Test-Template $d $scriptPath $fixturesDir); $re = @(Test-Template $e $scriptPath $fixturesDir); $rf = @(Test-Template $f $scriptPath $fixturesDir)
        $rg = @(Test-Template $templatePath $gjs $fixturesDir); $rh = @(Test-Template $h $scriptPath $fixturesDir)
        $ri = @(Test-Template $templatePath $scriptPath $fixturesDir $fakePath $ijs)
        $hHit = @($rh | Where-Object { $_ -like '*CARTRIDGE:nowhere*' }).Count
        $iHit = @($ri | Where-Object { $_ -like "the host's source reaches out*" }).Count
        Write-Output ("control: the real set has {0} problem(s); the script src {1}, the fetch {2}, the missing placeholder {3}, the anchor {4}, the image {5}, the stray fixture place {6}, the fetch in the viewport {7}, the stray cartridge place {8}, the fetch in the host {9}" -f $real.Count, $ra.Count, $rb.Count, $rc.Count, $rd.Count, $re.Count, $rf.Count, $rg.Count, $hHit, $iHit)
        if ($real.Count -eq 0 -and $ra.Count -ge 1 -and $rb.Count -ge 1 -and $rc.Count -ge 1 -and $rd.Count -ge 1 -and $re.Count -ge 1 -and $rf.Count -ge 1 -and $rg.Count -ge 1 -and $hHit -ge 1 -and $iHit -ge 1) {
            Write-Output 'OK: the check passes the template and the three scripts and fails each of the nine mutants'
            exit 0
        }
        Write-Output 'FAIL: the control did not behave'
        foreach ($p in $real) { Write-Output ('  real: ' + $p) }
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

if (-not (Test-Path -LiteralPath $templatePath)) { Write-Output ("FAIL: no template at {0}" -f $templatePath); exit 1 }
$problems = @(Test-Template $templatePath $scriptPath $fixturesDir)
$builtNote = 'no built page beside it (tools/build_web.ps1 writes one)'
if (Test-Path -LiteralPath $builtPath) {
    $problems += @(Test-Built $builtPath)
    $builtNote = ("the built page ({0:N0} characters) holds too" -f (Get-Item -LiteralPath $builtPath).Length)
}
if ($problems.Count -eq 0) {
    $names = Get-FixtureNames $fixturesDir
    $carts = Get-CartridgeNames $cartridgesDir
    Write-Output ("OK: web/index.template.html, web/viewport.js, web/fake.js and web/host.js load nothing and link nowhere, the scripts' and the module's placeholders each in its one place, the {0} fixture places the folder's files and the {1} cartridge places the cartridges'; {2}" -f $names.Count, $carts.Count, $builtNote)
    exit 0
}
Write-Output ("FAIL: the web page has {0} problem(s):" -f $problems.Count)
foreach ($p in $problems) { Write-Output ('  ' + $p) }
exit 1
