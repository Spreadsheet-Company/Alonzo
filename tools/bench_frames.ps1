<#
bench_frames.ps1 - the frame floors' instrument: Life's frames measured on
the owner's machine, natively and in the browser, and printed as one block
to paste into tools/check_frame_floors.ps1.

WHY: CART.1's scoping, decisions 4 and 5 (REARVIEW.md). The engine's first
number is cells evaluated a second (CHARTER.md section 7), on the benchmark
cartridge's two fixtures, Life's soup (cartridges/life/life.vla) and Gosper's
glider gun (cartridges/gun/gun.vla), and it is measured twice: by the native
runner, engine/examples/frames.rs, which a contributor runs; and by the
engine's module in the browser, the product, through the page's ?frames=1
mode. One build moved the two apart by a factor of 1.4 in the scoping, so
neither stands for the other. A step costs computation and no display, so
both halves run without a window: the page under a headless Chrome, at its
load and synchronously, since --dump-dom writes a page at its load.

THE TRAP THIS INSTRUMENT IS BUILT AROUND (measured 2026-10-09, the scoping):
on the owner's machine Windows throttles a process it deems in the background
(the power throttling it calls EcoQoS) about three seconds into a run, by
about 40%: Life's frames went from 266-291 ms to 351-512, and a headless
Chrome's the same way. So the runner's process is opted out of it as it
starts (SetProcessInformation, ProcessPowerThrottling, the execution-speed
bit cleared), and Chrome is started with its four flags against
backgrounding and every one of its processes opted out as it appears; the
scoping measured that only the two together hold Chrome's frames flat.
Both halves also watch the clock themselves, a fixed computation timed
beside every frame, and print no rows when it moved more than 10%.

WHAT IT DOES:
  1. builds what it measures, unless -NoBuild: the runner (cargo build
     --release --example frames), the engine's module (cargo build --release
     -p alonzo --target wasm32-unknown-unknown) and the page
     (tools/build_web.ps1);
  2. runs the runner over both fixtures and reads its two native rows;
  3. runs web/index.html?frames=1 and reads its two wasm rows;
  4. prints the block: the date, the environment, the pin of vla-lang in
     Cargo.toml, each fixture's SHA-256 over LF bytes, the four rows, and a
     floor line, each row's cells a second less the check's margin of 10%,
     rounded down to three figures, to add to the check's history; and
     writes the same block to target/bench_frames.txt, to copy from, since a
     terminal that wraps a long line can drop a space from a copy (the first
     baseline's paste lost two, 2026-10-09).
It is an instrument and not a check: it measures, the owner pastes, and the
check holds what was pasted. No job runs it; a shared runner's numbers are
not this machine's.

House style (tools/*.ps1): PowerShell 5.1 and pwsh alike; ASCII; no network
(cargo's own fetch of the pinned language aside, which is the build's).

Usage:  powershell -File tools\bench_frames.ps1
        powershell -File tools\bench_frames.ps1 -NoBuild -Frames 31
        powershell -File tools\bench_frames.ps1 -Browser "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
#>
param(
    [switch]$NoBuild,
    [string]$Browser = '',
    [int]$Frames = 31
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$onWindows = [System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT
$margin = 0.10

function Find-Cargo {
    $c = Get-Command cargo -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
    $home2 = if ($env:USERPROFILE) { $env:USERPROFILE } else { $env:HOME }
    foreach ($p in @((Join-Path $home2 '.cargo/bin/cargo.exe'), (Join-Path $home2 '.cargo/bin/cargo'))) { if (Test-Path -LiteralPath $p) { return $p } }
    return ''
}
function Find-Browser([string]$named) {
    if ($named -ne '') { if (Test-Path -LiteralPath $named) { return $named }; return '' }
    if ($env:ALONZO_BROWSER) { if (Test-Path -LiteralPath $env:ALONZO_BROWSER) { return $env:ALONZO_BROWSER }; return '' }
    if ($onWindows) {
        foreach ($c in @((Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'), (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'),
                         (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'), (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe'))) {
            if ($c -and (Test-Path -LiteralPath $c)) { return $c }
        }
        return ''
    }
    foreach ($name in @('google-chrome', 'google-chrome-stable', 'chromium-browser', 'chromium')) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    return ''
}

# Windows' power throttling, opted out for one process by its handle.
if ($onWindows) {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class AlonzoPowerThrottling {
    [StructLayout(LayoutKind.Sequential)]
    public struct State { public uint Version; public uint ControlMask; public uint StateMask; }
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool SetProcessInformation(IntPtr process, int infoClass, ref State info, uint size);
    // ProcessPowerThrottling is class 4; the execution-speed bit is 1; a state of 0 opts the process out.
    public static bool OptOut(IntPtr process) {
        var s = new State(); s.Version = 1; s.ControlMask = 1; s.StateMask = 0;
        return SetProcessInformation(process, 4, ref s, (uint)Marshal.SizeOf(typeof(State)));
    }
}
"@
}
function Stop-Throttling($process) {
    if (-not $onWindows) { return $true }
    try { return [AlonzoPowerThrottling]::OptOut($process.Handle) } catch { return $false }
}

# The SHA-256 of a text file over LF bytes, upper-case hex, as the check computes it.
function Get-LfDigest([string]$path) {
    $text = [System.IO.File]::ReadAllText($path) -replace "`r`n", "`n"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($text)) } finally { $sha.Dispose() }
    return (($hash | ForEach-Object { $_.ToString('X2') }) -join '')
}

# The pin of vla-lang as Cargo.toml writes it: a git rev, or a registry version.
function Get-Pin {
    $toml = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'Cargo.toml'))
    $m = [regex]::Match($toml, '(?m)^vla-lang\s*=\s*\{[^}\r\n]*rev\s*=\s*"([0-9a-f]+)"')
    if ($m.Success) { return $m.Groups[1].Value }
    $m = [regex]::Match($toml, '(?m)^vla-lang\s*=\s*"=?([0-9][0-9.]*)"')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}

# One build step, its output shown only when it fails.
function Invoke-Step([string]$what, [string]$exe, [string[]]$arguments) {
    Write-Output ("  building {0}..." -f $what)
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $out = & $exe @arguments 2>&1 | Out-String } finally { $ErrorActionPreference = $old }
    if ($LASTEXITCODE -ne 0) { Write-Output $out; throw ("building {0} failed" -f $what) }
}

$life = Join-Path $repoRoot 'cartridges/life/life.vla'
$gun = Join-Path $repoRoot 'cartridges/gun/gun.vla'
$runnerExe = Join-Path $repoRoot ('target/release/examples/frames' + $(if ($onWindows) { '.exe' } else { '' }))
$wasm = Join-Path $repoRoot 'target/wasm32-unknown-unknown/release/alonzo.wasm'
$page = Join-Path $repoRoot 'web/index.html'

Write-Output '=== THE FRAME FLOORS: LIFE MEASURED NATIVELY AND IN THE BROWSER (CART.1) ==='
if (-not $NoBuild) {
    $cargo = Find-Cargo
    if ($cargo -eq '') { Write-Output 'FAIL: no cargo on PATH or in ~/.cargo/bin; build the runner and the module, then run with -NoBuild'; exit 1 }
    Push-Location $repoRoot
    try {
        Invoke-Step 'the native runner' $cargo @('build', '--release', '--example', 'frames')
        Invoke-Step 'the engine''s module' $cargo @('build', '--release', '-p', 'alonzo', '--target', 'wasm32-unknown-unknown')
        $shell = if (Get-Command powershell -ErrorAction SilentlyContinue) { 'powershell' } else { 'pwsh' }
        Invoke-Step 'the page' $shell @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $repoRoot 'tools/build_web.ps1'))
    } catch {
        Write-Output ('FAIL: ' + $_.Exception.Message); exit 1
    } finally { Pop-Location }
}
foreach ($need in @($runnerExe, $wasm, $page)) {
    if (-not (Test-Path -LiteralPath $need)) { Write-Output "FAIL: $need is not built; run without -NoBuild"; exit 1 }
}

# --- the native half ---
Write-Output ("  the native runner, {0} frames a fixture, its process opted out of power throttling..." -f $Frames)
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $runnerExe
$psi.Arguments = ('--frames {0} "{1}" "{2}"' -f $Frames, $life, $gun)
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.WorkingDirectory = $repoRoot
$proc = [System.Diagnostics.Process]::Start($psi)
$nativeOptedOut = Stop-Throttling $proc
$nativeText = $proc.StandardOutput.ReadToEnd()
$proc.WaitForExit()
$nativeRows = @(($nativeText -split "`r?`n") | Where-Object { $_ -match "^\s+@\{ Runner = 'native'" } | ForEach-Object { $_.Trim() })
if ($nativeRows.Count -ne 2) {
    Write-Output $nativeText
    Write-Output ("FAIL: the runner printed {0} row(s), not 2 (exit {1}); its words are above" -f $nativeRows.Count, $proc.ExitCode)
    exit 1
}

# --- the browser half ---
$browser = Find-Browser $Browser
if ($browser -eq '') { Write-Output 'FAIL: no Chrome or Edge found; name one with -Browser'; exit 1 }
$browserVersion = ''
try { $browserVersion = (Get-Item -LiteralPath $browser).VersionInfo.ProductVersion } catch { $browserVersion = '' }
Write-Output ("  the page under headless {0} {1}, its processes opted out of power throttling..." -f [System.IO.Path]::GetFileNameWithoutExtension($browser), $browserVersion)
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_frames_' + [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $tmp | Out-Null
$wasmText = ''
$optedOut = 0
try {
    $dump = Join-Path $tmp 'dump.html'
    $slashed = [System.IO.Path]::GetFullPath($page) -replace '\\', '/'
    $url = $(if ($slashed.StartsWith('/')) { 'file://' } else { 'file:///' }) + $slashed + '?frames=1&n=' + $Frames
    $argList = @('--headless=new', '--disable-gpu', '--no-first-run', '--no-default-browser-check',
                 '--disable-renderer-backgrounding', '--disable-background-timer-throttling', '--disable-backgrounding-occluded-windows', '--disable-features=UseEcoQoSForBackgroundProcess',
                 ('--user-data-dir="' + (Join-Path $tmp 'profile') + '"'))
    if (-not $onWindows) { $argList += @('--no-sandbox', '--disable-dev-shm-usage') }
    $argList += @('--dump-dom', ('"' + $url + '"'))
    $procName = [System.IO.Path]::GetFileNameWithoutExtension($browser)
    $before = @(Get-Process -Name $procName -ErrorAction SilentlyContinue | ForEach-Object { $_.Id })
    $start = @{ FilePath = $browser; ArgumentList = $argList; RedirectStandardOutput = $dump; RedirectStandardError = (Join-Path $tmp 'err.txt'); PassThru = $true }
    if ($onWindows) { $start['NoNewWindow'] = $true }
    $chrome = Start-Process @start
    $seen = @{}
    while (-not $chrome.HasExited) {
        foreach ($c in @(Get-Process -Name $procName -ErrorAction SilentlyContinue)) {
            if ($before -notcontains $c.Id -and -not $seen.ContainsKey($c.Id)) {
                $seen[$c.Id] = $true
                if (Stop-Throttling $c) { $optedOut++ }
            }
        }
        Start-Sleep -Milliseconds 50
    }
    $html = ''
    for ($try = 0; $try -lt 100 -and $html -eq ''; $try++) {
        try { $html = [System.IO.File]::ReadAllText($dump) } catch { Start-Sleep -Milliseconds 100 }
    }
    $m = [regex]::Match($html, '(?s)<pre id="frames"[^>]*>(.*?)</pre>')
    if ($m.Success) { $wasmText = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value) }
} finally {
    Remove-Item -Recurse -Force -LiteralPath $tmp -ErrorAction SilentlyContinue
}
$wasmRows = @(($wasmText -split "`r?`n") | Where-Object { $_ -match "^\s+@\{ Runner = 'wasm'" } | ForEach-Object { $_.Trim() })
if ($wasmRows.Count -ne 2) {
    Write-Output $wasmText
    Write-Output ("FAIL: the page printed {0} row(s), not 2; its words are above" -f $wasmRows.Count)
    exit 1
}

# --- the block ---
$date = (Get-Date).ToString('yyyy-MM-dd')
$machine = ''
if ($onWindows) {
    try {
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $os = Get-CimInstance Win32_OperatingSystem
        $machine = ('{0}, {1} cores | {2} {3}' -f $cpu.Name.Trim(), $cpu.NumberOfCores, $os.Caption, $os.Version)
    } catch { $machine = 'Windows' }
} else {
    $machine = (& uname -srm) -join ' '
}
$rustc = ''
try { $rustc = ((& rustc --version) -join ' ').Trim() } catch { $rustc = '' }
if ($rustc -eq '') { $rc = Join-Path $(if ($env:USERPROFILE) { $env:USERPROFILE } else { $env:HOME }) '.cargo/bin/rustc.exe'; if (Test-Path -LiteralPath $rc) { $rustc = ((& $rc --version) -join ' ').Trim() } }
$pin = Get-Pin
$moduleBytes = (Get-Item -LiteralPath $wasm).Length
$environment = ('{0} | {1} | {2} {3} headless | the engine''s module {4:N0} bytes | vla-lang at {5} | power throttling opted out: the runner {6}, {7} browser process(es)' -f $machine, $rustc, [System.IO.Path]::GetFileNameWithoutExtension($browser), $browserVersion, $moduleBytes, $pin, $(if ($nativeOptedOut) { 'yes' } else { 'no' }), $optedOut)
$rows = @($nativeRows + $wasmRows)
function Get-Field([string]$row, [string]$name) { $m = [regex]::Match($row, "\b$name = '?([^;']+)'?"); if ($m.Success) { return $m.Groups[1].Value.Trim() }; return '' }
function Get-RoundedDown([double]$x) { if ($x -le 0) { return 0 }; $p = [math]::Pow(10, [math]::Floor([math]::Log10($x)) - 2); return [long]([math]::Floor($x / $p) * $p) }
$floors = @()
foreach ($r in $rows) {
    $key = (Get-Field $r 'Runner') + ' ' + (Get-Field $r 'Fixture')
    $floors += ("'{0}' = {1}" -f $key, (Get-RoundedDown ([double](Get-Field $r 'CellsPerSecond') * (1 - $margin))))
}

$block = New-Object System.Collections.Generic.List[string]
$block.Add('# ---- paste from here into tools/check_frame_floors.ps1, over the baseline ----')
$block.Add(("`$baselineDate = '{0}'" -f $date))
$block.Add(("`$baselineEnvironment = '{0}'" -f ($environment -replace "'", "''")))
$block.Add(("`$baselinePin = '{0}'" -f $pin))
$block.Add(("`$baselineFixtures = @{{ 'life' = '{0}'; 'gun' = '{1}' }}" -f (Get-LfDigest $life), (Get-LfDigest $gun)))
$block.Add('$baseline = @(')
for ($i = 0; $i -lt $rows.Count; $i++) { $block.Add(('    ' + $rows[$i] + $(if ($i -lt $rows.Count - 1) { ',' } else { '' }))) }
$block.Add(')')
$block.Add('# ---- and this entry as the last line inside $floorHistory = @( ... ), a comma after the entry before it: each row''s cells a second less 10%, three figures ----')
$block.Add(("    @{{ Date = '{0}'; Pin = '{1}'; Reason = ''; Floors = @{{ {2} }} }}" -f $date, $pin, ($floors -join '; ')))
# The block in a file as well: a terminal that wraps a long line can drop a
# space where it joins a copy (met at the first baseline, 2026-10-09).
$blockFile = Join-Path $repoRoot 'target/bench_frames.txt'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $blockFile) | Out-Null
[System.IO.File]::WriteAllText($blockFile, (($block -join "`r`n") + "`r`n"), (New-Object System.Text.UTF8Encoding($false)))

Write-Output ''
Write-Output $nativeText.TrimEnd()
Write-Output $wasmText.TrimEnd()
Write-Output ''
$block | ForEach-Object { Write-Output $_ }
Write-Output ''
Write-Output ("The block above is also in {0}: copy it from there, since a terminal's line wrap can drop a space from a copy." -f $blockFile)
exit 0
