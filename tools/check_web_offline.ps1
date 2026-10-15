<#
check_web_offline.ps1 - the viewport's page loads nothing, links nowhere, and
is filled from the viewport's source and the fixtures through placeholders,
each in its place.

WHY: the twin of Frazaro's check of the same name (KERNEL.5, laid here;
docs/SPEC.md section 8.3: the shim draws the record through the viewport and
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
each; and since ENGINE.15 {{BLOCKS}} exactly once and no place naming a
file, {{KIND:name}}: the template names no game's file, and its builder
writes every text the page holds as a block at {{BLOCKS}}, so that any
game's builder fills the same template. When web/index.html exists beside
the template, its markup is held to the same list of tags (a record or a
cartridge cannot spell a tag), no placeholder is left in it, and its blocks
are the folders' files both ways: each cartridge
(cartridges/<name>/<name>.vla), its source, replay and golden beside it
(<name>.source.vla, <name>.replay.vla, <name>.golden.vla), each library
(cartridges/<name>.vla) and each record (web/fixtures/<name>.vla) a block of
its kind and name, and each such block a file, so a built page is whole and
the page and its sources cannot drift apart.

SINCE ENGINE.4 (2026-10-10; docs/REARVIEW.md, decision 11): docs/CHARTER.md section 8
builds no sound synthesizer beyond the Web Audio graph's own nodes, and the
Audio device is an oscillator and a gain a voice, scheduled from the cells.
So the host's source, web/host.js, names none of the Web Audio calls that
would make samples of the host's own or reach past those nodes:
createScriptProcessor, AudioWorklet (and audioWorklet), createBuffer (and so
createBufferSource), createPeriodicWave, createMediaElementSource,
createMediaStreamSource, getUserMedia and addModule. The list is held on the
shim alone: the page's oracle reads a render's samples to measure it.

-Control proves the check on scratch copies of the template and the
scripts: the real set passes; a template with a script tag's src appended,
one with a fetch call, one with the viewport's placeholder removed, one with
an anchor appended, one with an image, a viewport source with a fetch call
appended and a host source with a fetch call appended must each fail; since
ENGINE.4 a host source with each of the eight Web Audio names planted, one a
copy, each failing by its name; and since ENGINE.15 a template with a place
naming a file appended and one with the BLOCKS place removed, and, over a
page tools/build_web.ps1 builds in a scratch folder, which passes, that page
without Life's cartridge block, with a block for a library the folder does
not hold, without the input card's golden block, and the template itself
standing as a built page, its places left: twenty-one mutants.

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
# The Web Audio names the host's source never holds (ENGINE.4; docs/CHARTER.md section 8): a sample of its own
# (a script processor, a worklet, a buffer, a periodic wave) or a reach past the graph's nodes (a media
# element or stream, the microphone, a module fetched by address). Compared without case, as the code tokens are.
$shimAudioTokens = @('createScriptProcessor', 'AudioWorklet', 'createBuffer', 'createPeriodicWave', 'createMediaElementSource', 'createMediaStreamSource', 'getUserMedia', 'addModule')
# The placeholders the builder fills once each: the three scripts, the engine's module and the blocks (ENGINE.15).
$viewportPlaceholder = '{{VIEWPORT_JS}}'
$blocksPlaceholder = '{{BLOCKS}}'
$oncePlaceholders = @($viewportPlaceholder, '{{FAKE_JS}}', '{{HOST_JS}}', '{{ALONZO_WASM}}', $blocksPlaceholder)
# A place naming a file, which the template no longer has (ENGINE.15).
$namedPlace = '\{\{[A-Z]+:[^}]*\}\}'

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
# A cartridge's source, replay or golden stands beside it: cartridges/life/life.source.vla (SPEC.3),
# cartridges/inputcard/inputcard.replay.vla and inputcard.golden.vla (ENGINE.3's second slice).
function Get-BesideNames([string]$dir, [string]$suffix) {
    $names = @()
    if (Test-Path -LiteralPath $dir) {
        foreach ($d in (Get-ChildItem -LiteralPath $dir -Directory | Sort-Object Name)) { if (Test-Path -LiteralPath (Join-Path $d.FullName ($d.Name + $suffix))) { $names += $d.Name } }
    }
    return ,$names
}
# A library is a file of cartridges/ itself: cartridges/common.vla (SPEC.3).
function Get-LibraryNames([string]$dir) {
    $names = @()
    if (Test-Path -LiteralPath $dir) {
        foreach ($f in (Get-ChildItem -LiteralPath $dir -Filter '*.vla' -File | Sort-Object Name)) { $names += [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }
    }
    return ,$names
}
# The blocks a page's folders owe it, by kind and name: cartridge-life, source-life, library-common ...
function Get-OwedBlocks([string]$cartridges, [string]$fixtures) {
    $owed = @{}
    foreach ($n in (Get-CartridgeNames $cartridges)) { $owed['cartridge-' + $n] = $cartridges }
    foreach ($n in (Get-BesideNames $cartridges '.source.vla')) { $owed['source-' + $n] = $cartridges }
    foreach ($n in (Get-BesideNames $cartridges '.replay.vla')) { $owed['replay-' + $n] = $cartridges }
    foreach ($n in (Get-BesideNames $cartridges '.golden.vla')) { $owed['golden-' + $n] = $cartridges }
    foreach ($n in (Get-LibraryNames $cartridges)) { $owed['library-' + $n] = $cartridges }
    foreach ($n in (Get-FixtureNames $fixtures)) { $owed['fixture-' + $n] = $fixtures }
    return $owed
}

function Test-Template([string]$path, [string]$script, [string]$fake = $fakePath, [string]$hostjs = $hostPath) {
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
    # The template names no file (ENGINE.15): every text the page holds is a block the builder writes.
    foreach ($m in [regex]::Matches($text, $namedPlace)) { $problems += ("the template names a file at {0}; every text the page holds is a block its builder writes at {1}" -f $m.Value, $blocksPlaceholder) }
    # The scripts' sources: the code tokens, since each is the page's code once inlined.
    foreach ($pair in @(@("the viewport's source", $script), @("the fake module's source", $fake), @("the host's source", $hostjs))) {
        if (-not (Test-Path -LiteralPath $pair[1])) { $problems += ("no file for {0} at {1}" -f $pair[0], $pair[1]); continue }
        $js = [System.IO.File]::ReadAllText($pair[1]).ToLowerInvariant()
        foreach ($t in $codeTokens) {
            if ($js.Contains($t.ToLowerInvariant())) { $problems += ("{0} reaches out: '{1}'" -f $pair[0], $t) }
        }
        if ($pair[1] -ne $hostjs) { continue }
        foreach ($t in $shimAudioTokens) {
            if ($js.Contains($t.ToLowerInvariant())) { $problems += ("{0} names '{1}', a sound of the host's own or a reach past the Web Audio graph's oscillators and gains, which docs/CHARTER.md section 8 builds no part of (ENGINE.4)" -f $pair[0], $t) }
        }
    }
    # Returned without the comma, as Frazaro's twin returns it: the callers wrap the result in @().
    return $problems
}

# A built page: its markup, no placeholder left, and its blocks the folders' files both ways (ENGINE.15).
function Test-Built([string]$path, [string]$cartridges = $cartridgesDir, [string]$fixtures = $fixturesDir) {
    $problems = @()
    $text = [System.IO.File]::ReadAllText($path)
    $lower = $text.ToLowerInvariant()
    foreach ($t in $tagTokens) {
        if ($lower.Contains($t.ToLowerInvariant())) { $problems += ("the built page reaches out: '{0}'" -f $t) }
    }
    foreach ($ph in $oncePlaceholders) {
        if ($text.Contains($ph)) { $problems += ("the built page has {0} left in it" -f $ph) }
    }
    foreach ($m in [regex]::Matches($text, $namedPlace)) { $problems += ("the built page has {0} left in it" -f $m.Value) }
    $held = @{}
    foreach ($m in [regex]::Matches($text, '<script type="text/plain" id="((cartridge|source|replay|golden|library|fixture)-[a-z0-9_-]+)"')) {
        if ($held.ContainsKey($m.Groups[1].Value)) { $problems += ("the built page holds the block {0} twice" -f $m.Groups[1].Value) }
        $held[$m.Groups[1].Value] = $true
    }
    $owed = Get-OwedBlocks $cartridges $fixtures
    foreach ($id in @($owed.Keys | Sort-Object)) { if (-not $held.ContainsKey($id)) { $problems += ("{0} holds the file of the block {1}, and the built page holds no such block: build it again (tools/build_web.ps1)" -f $owed[$id], $id) } }
    foreach ($id in @($held.Keys | Sort-Object)) { if (-not $owed.ContainsKey($id)) { $problems += ("the built page holds the block {0}, and no file under {1} or {2} is it" -f $id, $cartridges, $fixtures) } }
    return $problems
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_weboff_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $text = [System.IO.File]::ReadAllText($templatePath)
        $js = [System.IO.File]::ReadAllText($scriptPath)
        $real = @(Test-Template $templatePath $scriptPath)
        $a = Join-Path $tmp 'a.html'; [System.IO.File]::WriteAllText($a, ($text + "`n<script src=""x.js""></script>`n"), $utf8)
        $b = Join-Path $tmp 'b.html'; [System.IO.File]::WriteAllText($b, ($text + "`n<script>fetch('x')</script>`n"), $utf8)
        $c = Join-Path $tmp 'c.html'; [System.IO.File]::WriteAllText($c, $text.Replace($viewportPlaceholder, ''), $utf8)
        $d = Join-Path $tmp 'd.html'; [System.IO.File]::WriteAllText($d, ($text + "`n<a href=""x.html"">x</a>`n"), $utf8)
        $e = Join-Path $tmp 'e.html'; [System.IO.File]::WriteAllText($e, ($text + "`n<img src=""data:image/png;base64,AAAA"">`n"), $utf8)
        $f = Join-Path $tmp 'f.html'; [System.IO.File]::WriteAllText($f, ($text + "`n{{CARTRIDGE:life}}`n"), $utf8)
        $gjs = Join-Path $tmp 'g.js'; [System.IO.File]::WriteAllText($gjs, ($js + "`nfetch('x');`n"), $utf8)
        if (([regex]::Matches($text, [regex]::Escape($blocksPlaceholder))).Count -ne 1) { Write-Output "FAIL: the place $blocksPlaceholder is not in the template exactly once"; exit 1 }
        $h = Join-Path $tmp 'h.html'; [System.IO.File]::WriteAllText($h, $text.Replace($blocksPlaceholder, ''), $utf8)
        $ijs = Join-Path $tmp 'i.js'; [System.IO.File]::WriteAllText($ijs, ([System.IO.File]::ReadAllText($hostPath) + "`nfetch('x');`n"), $utf8)
        $ra = @(Test-Template $a $scriptPath); $rb = @(Test-Template $b $scriptPath); $rc = @(Test-Template $c $scriptPath)
        $rd = @(Test-Template $d $scriptPath); $re = @(Test-Template $e $scriptPath)
        $rf = @(Test-Template $f $scriptPath); $rg = @(Test-Template $templatePath $gjs); $rh = @(Test-Template $h $scriptPath)
        $ri = @(Test-Template $templatePath $scriptPath $fakePath $ijs)
        $fHit = @($rf | Where-Object { $_ -like '*names a file at {{CARTRIDGE:life}}*' }).Count
        $hHit = @($rh | Where-Object { $_ -like '*{{BLOCKS}} appears 0 time(s)*' }).Count
        $iHit = @($ri | Where-Object { $_ -like "the host's source reaches out*" }).Count
        # ENGINE.15: a page built in the scratch folder, which passes, and four built pages that must not.
        $shell = if (Get-Command powershell.exe -ErrorAction SilentlyContinue) { 'powershell.exe' } else { 'pwsh' }
        $page = Join-Path $tmp 'page.html'
        $prev = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try { $null = & $shell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'build_web.ps1') -NoWasm -Out $page 2>&1; $code = $LASTEXITCODE } finally { $ErrorActionPreference = $prev }
        if ($code -ne 0 -or -not (Test-Path -LiteralPath $page)) { Write-Output 'FAIL: tools/build_web.ps1 could not build the control''s page'; exit 1 }
        $built = [System.IO.File]::ReadAllText($page)
        $realBuilt = @(Test-Built $page)
        function Remove-Block([string]$html, [string]$id) { return [regex]::Replace($html, '<script type="text/plain" id="' + [regex]::Escape($id) + '"[^>]*>[\s\S]*?</script>\n?', '') }
        $j = Join-Path $tmp 'j.html'; [System.IO.File]::WriteAllText($j, (Remove-Block $built 'cartridge-life'), $utf8)
        $k = Join-Path $tmp 'k.html'; [System.IO.File]::WriteAllText($k, $built.Replace('<script type="text/plain" id="alonzo-wasm">', '<script type="text/plain" id="library-nowhere" data-path="cartridges/nowhere.vla">x</script>' + "`n" + '<script type="text/plain" id="alonzo-wasm">'), $utf8)
        $l = Join-Path $tmp 'l.html'; [System.IO.File]::WriteAllText($l, $text, $utf8)
        $m = Join-Path $tmp 'm.html'; [System.IO.File]::WriteAllText($m, (Remove-Block $built 'golden-inputcard'), $utf8)
        $jApplied = ([System.IO.File]::ReadAllText($j)).Length -lt $built.Length
        $mApplied = ([System.IO.File]::ReadAllText($m)).Length -lt $built.Length
        $rj = @(Test-Built $j); $rk = @(Test-Built $k); $rl = @(Test-Built $l); $rm = @(Test-Built $m)
        $jHit = @($rj | Where-Object { $_ -like '*block cartridge-life, and the built page holds no such block*' }).Count
        $kHit = @($rk | Where-Object { $_ -like '*holds the block library-nowhere, and no file*' }).Count
        $lHit = @($rl | Where-Object { $_ -like '*has {{BLOCKS}} left in it*' }).Count
        $mHit = @($rm | Where-Object { $_ -like '*block golden-inputcard, and the built page holds no such block*' }).Count
        # ENGINE.4: each Web Audio name planted in a copy of the host's source, each failing by its own name
        $hostText = [System.IO.File]::ReadAllText($hostPath)
        $audioHits = New-Object System.Collections.Generic.List[string]
        $audioOk = $true
        for ($n = 0; $n -lt $shimAudioTokens.Count; $n++) {
            $tok = $shimAudioTokens[$n]
            $planted = $hostText + "`nvar planted = window.planted && window.planted." + $tok + ";`n"
            $pjs = Join-Path $tmp ('audio' + $n + '.js'); [System.IO.File]::WriteAllText($pjs, $planted, $utf8)
            $applied = ([System.IO.File]::ReadAllText($pjs)).Contains('.' + $tok + ';')
            $rp = @(Test-Template $templatePath $scriptPath $fakePath $pjs)
            $hit = @($rp | Where-Object { $_ -like ("the host's source names '" + $tok + "'*") }).Count
            $audioHits.Add(("{0} {1}" -f $tok, $(if ($applied -and $hit -ge 1) { 'failed' } else { 'NOT failed' })))
            if (-not ($applied -and $hit -ge 1)) { $audioOk = $false }
        }
        Write-Output ("control: the real set has {0} problem(s) and the page built from it {1}; the script src {2}, the fetch {3}, the missing placeholder {4}, the anchor {5}, the image {6}, the place naming a file {7}, the fetch in the viewport {8}, the blocks' place removed {9}, the fetch in the host {10}; built, Life's block cut ({11}) {12}, the stray library block {13}, the template as a page {14}, the golden's block cut ({15}) {16}; the Web Audio names planted in the host: {17}" -f $real.Count, $realBuilt.Count, $ra.Count, $rb.Count, $rc.Count, $rd.Count, $re.Count, $fHit, $rg.Count, $hHit, $iHit, $jApplied, $jHit, $kHit, $lHit, $mApplied, $mHit, ($audioHits -join ', '))
        if ($real.Count -eq 0 -and $realBuilt.Count -eq 0 -and $ra.Count -ge 1 -and $rb.Count -ge 1 -and $rc.Count -ge 1 -and $rd.Count -ge 1 -and $re.Count -ge 1 -and $fHit -ge 1 -and $rg.Count -ge 1 -and $hHit -ge 1 -and $iHit -ge 1 -and $jApplied -and $jHit -ge 1 -and $kHit -ge 1 -and $lHit -ge 1 -and $mApplied -and $mHit -ge 1 -and $audioOk) {
            Write-Output 'OK: the check passes the template, the three scripts and a page built from them, and fails each of the twenty-one mutants'
            exit 0
        }
        Write-Output 'FAIL: the control did not behave'
        foreach ($p in $real) { Write-Output ('  real: ' + $p) }
        foreach ($p in $realBuilt) { Write-Output ('  real page: ' + $p) }
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

if (-not (Test-Path -LiteralPath $templatePath)) { Write-Output ("FAIL: no template at {0}" -f $templatePath); exit 1 }
$problems = @(Test-Template $templatePath $scriptPath)
$builtNote = 'no built page beside it (tools/build_web.ps1 writes one)'
if (Test-Path -LiteralPath $builtPath) {
    $problems += @(Test-Built $builtPath)
    $owedCount = (Get-OwedBlocks $cartridgesDir $fixturesDir).Count
    $builtNote = ("the built page ({0:N0} characters) holds too, its {1} blocks the folders' files both ways" -f (Get-Item -LiteralPath $builtPath).Length, $owedCount)
}
if ($problems.Count -eq 0) {
    Write-Output ("OK: web/index.template.html, web/viewport.js, web/fake.js and web/host.js load nothing and link nowhere, the host names no Web Audio call past the graph's oscillators and gains, the scripts', the module's and the blocks' placeholders each in its one place, and no place naming a file; {0}" -f $builtNote)
    exit 0
}
Write-Output ("FAIL: the web page has {0} problem(s):" -f $problems.Count)
foreach ($p in $problems) { Write-Output ('  ' + $p) }
exit 1
