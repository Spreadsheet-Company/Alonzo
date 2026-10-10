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

THE SECOND TRAP (found by Frazaro's KERNEL.25 and measured here 2026-10-10,
CART.1's second slice): the owner's processor has two kinds of core, eight
performance cores and twelve efficiency cores, and Windows may run a process
on either. On an efficiency core a steady frame of the soup took 120 to 121.5
ms against 97 to 99 on a performance core, and the clock check passed those
runs, since the clock's first readings were taken on the same kind of core:
a floor could measure the scheduler. So both halves are started on the
performance cores, the logical processors of the highest efficiency class
the system reports (GetSystemCpuSetInformation): this script's own affinity
is set to them before each start and put back after, so that the runner and
Chrome inherit it from their creation, and Chrome's children from Chrome;
every process found later is held there too. A machine of one kind of core
is left unpinned, and the environment line says which it was.

WHAT IT DOES:
  1. builds what it measures, unless -NoBuild: the runner (cargo build
     --release --example frames), the engine's module (cargo build --release
     -p alonzo --target wasm32-unknown-unknown) and the page
     (tools/build_web.ps1);
  2. runs the runner over both fixtures and reads its two native rows;
  3. runs web/index.html?frames=1 and reads its two wasm rows, both halves
     on the performance cores and opted out of the throttling;
  4. prints the block: the date, the environment, the pin of vla-lang in
     Cargo.toml, each fixture's SHA-256 over LF bytes, the four rows, and the
     floor history as the check holds it with this run's entry added last,
     each row's cells a second less the check's margin of 10%, rounded down
     to three figures, to paste over the check's history whole (a lone entry
     to add by hand was pasted over the first at the second baseline,
     2026-10-10); and writes the same block to target/bench_frames.txt, to
     copy from, since a terminal that wraps a long line can drop a space from
     a copy (the first baseline's paste lost two, 2026-10-09).
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
public static class AlonzoCores {
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool GetSystemCpuSetInformation(IntPtr information, uint length, out uint returned, IntPtr process, uint flags);
    // Group 0's logical processors as pairs, its index then its efficiency
    // class, a higher class a faster core. Each SYSTEM_CPU_SET_INFORMATION is
    // Size, Type (0 for a CPU set), Id, Group (at 12), LogicalProcessorIndex
    // (14), CoreIndex, LastLevelCacheIndex, NumaNodeIndex, EfficiencyClass (18).
    public static int[] Classes() {
        uint length;
        GetSystemCpuSetInformation(IntPtr.Zero, 0, out length, IntPtr.Zero, 0);
        var pairs = new System.Collections.Generic.List<int>();
        if (length == 0) return pairs.ToArray();
        IntPtr buffer = Marshal.AllocHGlobal((int)length);
        try {
            if (!GetSystemCpuSetInformation(buffer, length, out length, IntPtr.Zero, 0)) return pairs.ToArray();
            int at = 0;
            while (at + 20 <= length) {
                int size = Marshal.ReadInt32(buffer, at);
                if (size <= 0) break;
                if (Marshal.ReadInt32(buffer, at + 4) == 0 && Marshal.ReadInt16(buffer, at + 12) == 0) {
                    pairs.Add(Marshal.ReadByte(buffer, at + 14));
                    pairs.Add(Marshal.ReadByte(buffer, at + 18));
                }
                at += size;
            }
        } finally { Marshal.FreeHGlobal(buffer); }
        return pairs.ToArray();
    }
}
"@
}
function Stop-Throttling($process) {
    if (-not $onWindows) { return $true }
    try { return [AlonzoPowerThrottling]::OptOut($process.Handle) } catch { return $false }
}

# The performance cores: the logical processors of the highest efficiency
# class, as an affinity mask; a mask of 0 where the machine has one kind of
# core, or where none could be read, and then nothing is pinned.
function Get-PerformanceCores {
    $set = @{ Mask = [long]0; Fast = 0; All = 0; Class = 0 }
    if (-not $onWindows) { return $set }
    try { $pairs = @([AlonzoCores]::Classes()) } catch { return $set }
    if ($pairs.Count -lt 2) { return $set }
    $classes = @(for ($i = 1; $i -lt $pairs.Count; $i += 2) { $pairs[$i] })
    $set.All = $classes.Count
    $set.Class = ($classes | Measure-Object -Maximum).Maximum
    for ($i = 0; $i -lt $pairs.Count; $i += 2) {
        if ($pairs[$i + 1] -eq $set.Class -and $pairs[$i] -lt 64) { $set.Mask = $set.Mask -bor ([long]1 -shl $pairs[$i]); $set.Fast++ }
    }
    if ($set.Fast -eq $set.All) { $set.Mask = [long]0 }
    return $set
}
# Whether a process runs on the performance cores, put there when it does not.
function Set-PerformanceCores($process) {
    if ($cores.Mask -eq 0) { return $true }
    try {
        if ([long]$process.ProcessorAffinity -ne $cores.Mask) { $process.ProcessorAffinity = [IntPtr]$cores.Mask }
        return ([long]$process.ProcessorAffinity -eq $cores.Mask)
    } catch { return $false }
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

# The floor history's entries as tools/check_frame_floors.ps1 holds them, one
# a line, each trimmed of its comma: read, never run, as the check reads them.
function Get-HistoryEntries([string]$path) {
    $entries = New-Object System.Collections.Generic.List[string]
    if (-not (Test-Path -LiteralPath $path)) { return $entries.ToArray() }
    $inside = $false
    foreach ($line in [System.IO.File]::ReadAllLines($path)) {
        if (-not $inside) { if ($line -match '^\$floorHistory = @\(\s*$') { $inside = $true }; continue }
        if ($line -match '^\)\s*$') { break }
        $t = $line.Trim().TrimEnd(',').Trim()
        if ($t -ne '' -and -not $t.StartsWith('#')) { $entries.Add($t) }
    }
    return $entries.ToArray()
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

# The cores both halves run on, and this script's own affinity, put back after
# each start (a child inherits its parent's from its creation).
$cores = Get-PerformanceCores
$self = [System.Diagnostics.Process]::GetCurrentProcess()
$ownAffinity = $self.ProcessorAffinity
$coresWord = if ($cores.Mask -ne 0) { ', on the performance cores' } else { '' }

# --- the native half ---
Write-Output ("  the native runner, {0} frames a fixture, its process opted out of power throttling{1}..." -f $Frames, $coresWord)
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $runnerExe
$psi.Arguments = ('--frames {0} "{1}" "{2}"' -f $Frames, $life, $gun)
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.WorkingDirectory = $repoRoot
if ($cores.Mask -ne 0) { $self.ProcessorAffinity = [IntPtr]$cores.Mask }
try { $proc = [System.Diagnostics.Process]::Start($psi) } finally { $self.ProcessorAffinity = $ownAffinity }
$nativeOptedOut = Stop-Throttling $proc
$nativePinned = Set-PerformanceCores $proc
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
Write-Output ("  the page under headless {0} {1}, its processes opted out of power throttling{2}..." -f [System.IO.Path]::GetFileNameWithoutExtension($browser), $browserVersion, $coresWord)
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_frames_' + [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $tmp | Out-Null
$wasmText = ''
$optedOut = 0
$pinned = 0
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
    if ($cores.Mask -ne 0) { $self.ProcessorAffinity = [IntPtr]$cores.Mask }
    try { $chrome = Start-Process @start } finally { $self.ProcessorAffinity = $ownAffinity }
    $seen = @{}
    while (-not $chrome.HasExited) {
        foreach ($c in @(Get-Process -Name $procName -ErrorAction SilentlyContinue)) {
            if ($before -notcontains $c.Id -and -not $seen.ContainsKey($c.Id)) {
                $seen[$c.Id] = $true
                if (Stop-Throttling $c) { $optedOut++ }
                if (Set-PerformanceCores $c) { $pinned++ }
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
$coresText = if ($cores.Mask -ne 0) { ('on the performance cores, {0} of {1} logical processors (efficiency class {2}): the runner {3}, {4} browser process(es)' -f $cores.Fast, $cores.All, $cores.Class, $(if ($nativePinned) { 'yes' } else { 'no' }), $pinned) }
             elseif ($cores.All -gt 0) { ('one kind of core, {0} logical processors, unpinned' -f $cores.All) }
             else { 'the cores not read, unpinned' }
$environment = ('{0} | {1} | {2} {3} headless | the engine''s module {4:N0} bytes | vla-lang at {5} | power throttling opted out: the runner {6}, {7} browser process(es) | {8}' -f $machine, $rustc, [System.IO.Path]::GetFileNameWithoutExtension($browser), $browserVersion, $moduleBytes, $pin, $(if ($nativeOptedOut) { 'yes' } else { 'no' }), $optedOut, $coresText)
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
$entries = @(Get-HistoryEntries (Join-Path $repoRoot 'tools/check_frame_floors.ps1'))
$entries += ("@{{ Date = '{0}'; Pin = '{1}'; Reason = ''; Floors = @{{ {2} }} }}" -f $date, $pin, ($floors -join '; '))
$block.Add(('# ---- and this over $floorHistory = @( ... ), whole: the check''s {0} entr{1} as they stand, then this run''s, each row''s cells a second less 10%, three figures ----' -f ($entries.Count - 1), $(if ($entries.Count -eq 2) { 'y' } else { 'ies' })))
$block.Add('$floorHistory = @(')
for ($i = 0; $i -lt $entries.Count; $i++) { $block.Add(('    ' + $entries[$i] + $(if ($i -lt $entries.Count - 1) { ',' } else { '' }))) }
$block.Add(')')
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
Write-Output 'In tools/check_frame_floors.ps1, its baseline lines go over the baseline lines, and its history over $floorHistory = @( ... ), whole.'
exit 0
