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

WHAT IT HOLDS, on web/index.template.html (the source) and web/viewport.js
(the viewport's source, inlined into the page at build, so its text is the
page's code): no external reference of any kind - script, link, img, iframe,
form, anchor, @import, url(), http(s)://, fetch, XMLHttpRequest, WebSocket,
EventSource, sendBeacon, dynamic import, importScripts; a charset
declaration; {{VIEWPORT_JS}} exactly once; each {{FIXTURE:name}} once, a
file web/fixtures/<name>.vla, with no file of that folder left without its
place, so a built page is whole and the page and the fixtures cannot drift
apart. When web/index.html exists beside the template, its markup is held to
the same list of tags (a record cannot spell a tag) and no placeholder is
left in it.

-Control proves the check on scratch copies of the template and the script:
the real pair passes; a template with a script tag's src appended, one with
a fetch call, one with the viewport's placeholder removed, one with an
anchor appended, one with an image, one with a FIXTURE place for a file the
folder does not hold, and a viewport source with a fetch call appended must
each fail.

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
$builtPath = Join-Path $repoRoot 'web/index.html'
$fixturesDir = Join-Path $repoRoot 'web/fixtures'

# Markup that reaches out: held on the template and on a built page alike.
# There is no allowed anchor on this page, so '<a href' is forbidden outright.
$tagTokens = @('<script src', '<script type="module" src', '<link ', '<img ', '<iframe', '<form', '<a href', '<video', '<audio', '<source', '<object', '<embed', '<meta http-equiv="refresh"')
# Code and style that reach out: held on the template and on the viewport's
# source, which the builder inlines into the page.
$codeTokens = @('fetch(', 'XMLHttpRequest', 'WebSocket', 'EventSource', 'sendBeacon', 'import(', 'importScripts', '@import', 'url(', 'http://', 'https://')
# The placeholder the builder fills once with the viewport's source.
$viewportPlaceholder = '{{VIEWPORT_JS}}'

function Get-FixtureNames([string]$dir) {
    $names = @()
    if (Test-Path -LiteralPath $dir) {
        foreach ($f in (Get-ChildItem -LiteralPath $dir -Filter '*.vla' -File | Sort-Object Name)) { $names += [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }
    }
    return ,$names
}

function Test-Template([string]$path, [string]$script, [string]$fixtures) {
    $problems = @()
    $text = [System.IO.File]::ReadAllText($path)
    $lower = $text.ToLowerInvariant()
    foreach ($t in ($tagTokens + $codeTokens)) {
        if ($lower.Contains($t.ToLowerInvariant())) { $problems += ("the template reaches out: '{0}'" -f $t) }
    }
    if (-not $lower.Contains('<meta charset="utf-8">')) { $problems += 'no <meta charset="utf-8">' }
    $n = ([regex]::Matches($text, [regex]::Escape($viewportPlaceholder))).Count
    if ($n -ne 1) { $problems += ("placeholder {0} appears {1} time(s), and the template has one place for it" -f $viewportPlaceholder, $n) }
    # The fixtures' places: each {{FIXTURE:name}} once, each a file of the folder, and each file with its place.
    $names = Get-FixtureNames $fixtures
    if ($names.Count -eq 0) { $problems += ("no fixtures read from {0}" -f $fixtures) }
    $seen = @{}
    foreach ($m in [regex]::Matches($text, '\{\{FIXTURE:([a-z0-9_]+)\}\}')) {
        $name = $m.Groups[1].Value
        if ($seen.ContainsKey($name)) { $problems += ("placeholder repeated: {0}" -f $m.Value) }
        $seen[$name] = $true
        if ($names -notcontains $name) { $problems += ("{0} has no file {1}.vla under {2}" -f $m.Value, $name, $fixtures) }
    }
    foreach ($name in $names) {
        if (-not $seen.ContainsKey($name)) { $problems += ("the fixture {0}.vla has no {{{{FIXTURE:{0}}}}} place in the template" -f $name) }
    }
    # The viewport's source: the code tokens, since it is the page's code once inlined.
    if (-not (Test-Path -LiteralPath $script)) { $problems += ("no viewport source at {0}" -f $script) }
    else {
        $js = [System.IO.File]::ReadAllText($script).ToLowerInvariant()
        foreach ($t in $codeTokens) {
            if ($js.Contains($t.ToLowerInvariant())) { $problems += ("the viewport's source reaches out: '{0}'" -f $t) }
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
    foreach ($ph in @($viewportPlaceholder, '{{FIXTURE:')) {
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
        $ra = @(Test-Template $a $scriptPath $fixturesDir); $rb = @(Test-Template $b $scriptPath $fixturesDir); $rc = @(Test-Template $c $scriptPath $fixturesDir)
        $rd = @(Test-Template $d $scriptPath $fixturesDir); $re = @(Test-Template $e $scriptPath $fixturesDir); $rf = @(Test-Template $f $scriptPath $fixturesDir)
        $rg = @(Test-Template $templatePath $gjs $fixturesDir)
        Write-Output ("control: the real pair has {0} problem(s); the script src {1}, the fetch {2}, the missing placeholder {3}, the anchor {4}, the image {5}, the stray fixture place {6}, the fetch in the viewport {7}" -f $real.Count, $ra.Count, $rb.Count, $rc.Count, $rd.Count, $re.Count, $rf.Count, $rg.Count)
        if ($real.Count -eq 0 -and $ra.Count -ge 1 -and $rb.Count -ge 1 -and $rc.Count -ge 1 -and $rd.Count -ge 1 -and $re.Count -ge 1 -and $rf.Count -ge 1 -and $rg.Count -ge 1) {
            Write-Output 'OK: the check passes the template and the viewport and fails each of the seven mutants'
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
    Write-Output ("OK: web/index.template.html and web/viewport.js load nothing and link nowhere, the viewport's placeholder in its one place and the {0} fixture places the folder's files; {1}" -f $names.Count, $builtNote)
    exit 0
}
Write-Output ("FAIL: the web page has {0} problem(s):" -f $problems.Count)
foreach ($p in $problems) { Write-Output ('  ' + $p) }
exit 1
