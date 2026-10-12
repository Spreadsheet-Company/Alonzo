<#
bench_frames.ps1 - the frame floors' instrument: Life's frames and Sand's
measured on the owner's machine, natively and in the browser, and printed as
one block to paste into tools/check_frame_floors.ps1.

WHY: CART.1's scoping, decisions 4 and 5 (REARVIEW.md). The engine's first
number is cells evaluated a second (CHARTER.md section 7), on the benchmark
cartridge's two fixtures, Life's soup (cartridges/life/life.vla) and Gosper's
glider gun (cartridges/gun/gun.vla), and since CART.2 (decision 11) on Sand's
opening (cartridges/sand/sand.vla), the charter's test of a chain two hundred
rows deep. It is measured twice: by the native
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
before each fixture's frames and after them, and print no rows when it moved
more than 10%; never between two frames, where it slowed the frame after it
(CART.1's decision 5, reopened 2026-10-12: native Life's steady frames read
3.1 to 3.2 ms with it beside each and 2.7 to 2.9 without it, where its floor
wants 3.12).

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

THE THIRD TRAP (found 2026-10-10, when Frazaro's KERNEL.26 stepped the gun in
about 20 microseconds): the page's clock steps in tenths of a millisecond,
Chrome's performance.now() in a page that is not cross-origin isolated, so a
gun frame timed alone read 0 ms, its cells a second infinite, and this
script died making a floor of it ("Cannot convert value NaN to Int64"). So
the page reads its clock's step, times frames 2 to N alone as before, and,
when their median reads under twenty steps, times the steady frames again
past them in runs of consecutive steps, a run doubled from 2 until it reads
twenty, each run's last frame held to the page's Life and every frame held
on a second instance stepped untimed; its rows say Run, the frames a run, 1
where the frames are timed alone. (The gun's second frame over KERNEL.26
still read over 2 ms, a frame computed whole after the load, so frame 2
alone cannot decide.) And this script refuses a row whose rates are no
finite number above 0, in words, and prints no block.

THE FOURTH TRAP (found by the fourth baseline, 2026-10-11, and measured
2026-10-12, CART.2): the native runner reads nanoseconds, yet a frame of
microseconds timed alone was no measurement either. It came right after
the clock the runner then read beside every frame, and the gun's frames 2
to 31 read 17.6 to 26.9 microseconds in one evening's runs and 22 to 48 in
one sitting the next day, against 12.3 to 13.2 with the clock taken away,
where the floors' margin is 10%. So the native runner times a frame under
2 ms, the page's own line, in runs as the page does: the gun's runs read
42.4 to 44.5 microseconds a frame across launches and an added load, over
frames 158 to 3997, the page's frames. A row timed one way where the
check's baseline timed it the other measures other frames, so its floor is
re-based on this run (step 4); and so is a row whose fixture is not the
file the check's baseline measured (CART.2's decision 24), since cells a
second count the fixture's cells: Sand with water steps its opening in
slice 1's time over half again the cells.

WHAT IT DOES:
  1. builds what it measures, unless -NoBuild: the runner (cargo build
     --release --example frames), the engine's module (cargo build --release
     -p alonzo --target wasm32-unknown-unknown) and the page
     (tools/build_web.ps1);
  2. runs the runner over the three fixtures and reads its three native rows;
  3. runs web/index.html?frames=1 and reads its three wasm rows, both halves
     on the performance cores and opted out of the throttling;
  4. prints the block: the date, the environment, the pin of vla-lang in
     Cargo.toml, each fixture's SHA-256 over LF bytes, the six rows, and the
     floor history as the check holds it with this run's entry added last,
     each row's cells a second less the check's margin of 10%, rounded down
     to three figures, or the latest entry's floor for the row where that is
     higher, since this instrument never lowers a floor (CART.2, 2026-10-11:
     a run slower on unchanged code lowered two floors, and the check refused
     the entry); a row measured under its latest floor is named, a finding
     and not a baseline. Two exceptions: a row this run timed in runs where
     the check's baseline timed it alone, or the other way about, measures
     other frames (2026-10-12, the fourth trap); and a row whose fixture is
     not the file the check's baseline measured, nor that file's rows
     rebuilt, measures another cartridge (CART.2's decision 24). Either row's
     floor is this run's less 10% whatever the latest, and where that is
     lower the entry's reason says why. The block is pasted over the check's history whole (a lone entry
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

# The frames a run of each row of the check's baseline, read as text as the
# history is: a row this run times another way measures other frames.
function Get-BaselineRuns([string]$path) {
    $runs = @{}
    if (-not (Test-Path -LiteralPath $path)) { return $runs }
    $inside = $false
    foreach ($line in [System.IO.File]::ReadAllLines($path)) {
        if (-not $inside) { if ($line -match '^\$baseline = @\(\s*$') { $inside = $true }; continue }
        if ($line -match '^\)\s*$') { break }
        $m = [regex]::Match($line, "Runner = '([a-z]+)'; Fixture = '([a-z]+)';.*\bRun = (\d+);")
        if ($m.Success) { $runs[$m.Groups[1].Value + ' ' + $m.Groups[2].Value] = [int]$m.Groups[3].Value }
    }
    return $runs
}

# The fixtures the check's baseline measured, by name, each its SHA-256 over
# LF bytes; and the check's rebuilt fixtures, a file's digest to the measured
# one whose rows it holds. Read as text, as the history is.
function Get-BaselineFixtures([string]$path) {
    $fixtures = @{}
    if (-not (Test-Path -LiteralPath $path)) { return $fixtures }
    foreach ($line in [System.IO.File]::ReadAllLines($path)) {
        if ($line -match '^\$baselineFixtures = @\{') {
            foreach ($m in [regex]::Matches($line, "'([a-z]+)' = '([0-9A-F]{64})'")) { $fixtures[$m.Groups[1].Value] = $m.Groups[2].Value }
            break
        }
    }
    return $fixtures
}
function Get-SameRows([string]$path) {
    $same = @{}
    if (-not (Test-Path -LiteralPath $path)) { return $same }
    $inside = $false
    foreach ($line in [System.IO.File]::ReadAllLines($path)) {
        if (-not $inside) { if ($line -match '^\$sameRows = @\{\s*$') { $inside = $true }; continue }
        if ($line -match '^\}\s*$') { break }
        $m = [regex]::Match($line, "'([0-9A-F]{64})' = '([0-9A-F]{64})'")
        if ($m.Success) { $same[$m.Groups[1].Value] = $m.Groups[2].Value }
    }
    return $same
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
$sand = Join-Path $repoRoot 'cartridges/sand/sand.vla'
$runnerExe = Join-Path $repoRoot ('target/release/examples/frames' + $(if ($onWindows) { '.exe' } else { '' }))
$wasm = Join-Path $repoRoot 'target/wasm32-unknown-unknown/release/alonzo.wasm'
$page = Join-Path $repoRoot 'web/index.html'

Write-Output '=== THE FRAME FLOORS: LIFE AND SAND MEASURED NATIVELY AND IN THE BROWSER (CART.1, CART.2) ==='
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
$psi.Arguments = ('--frames {0} "{1}" "{2}" "{3}"' -f $Frames, $life, $gun, $sand)
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
if ($nativeRows.Count -ne 3) {
    Write-Output $nativeText
    Write-Output ("FAIL: the runner printed {0} row(s), not 3 (exit {1}); its words are above" -f $nativeRows.Count, $proc.ExitCode)
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
if ($wasmRows.Count -ne 3) {
    Write-Output $wasmText
    Write-Output ("FAIL: the page printed {0} row(s), not 3; its words are above" -f $wasmRows.Count)
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
# Every row's two rates a finite number above 0, as a floor is: a gun frame quicker than the page's
# clock once read 0 ms timed alone, its rates infinite, and the floor's arithmetic made NaN of them
# (CART.1, 2026-10-10). A page this tree builds times such frames in runs.
$timeless = @()
foreach ($r in $rows) {
    foreach ($field in @('CellsPerSecond', 'FramesPerSecond')) {
        $text = Get-Field $r $field
        $value = 0.0
        $parsed = [double]::TryParse($text, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$value)
        if (-not $parsed -or [double]::IsNaN($value) -or [double]::IsInfinity($value) -or $value -le 0) { $timeless += ("the row {0} {1} says {2} = {3}" -f (Get-Field $r 'Runner'), (Get-Field $r 'Fixture'), $field, $text) }
    }
}
if ($timeless.Count -gt 0) {
    Write-Output $nativeText.TrimEnd()
    Write-Output $wasmText.TrimEnd()
    Write-Output ("FAIL: {0}: a rate that is no finite number above 0 is no floor, so no block is printed. A frame read as 0 ms timed alone; the page this tree builds times a frame quicker than its clock in runs, so build it again (run without -NoBuild)." -f ($timeless -join '; '))
    exit 1
}
# Each row's floor: this run's cells a second less the margin, rounded down to three figures, or the
# latest entry's floor for the row where that is higher, so that this instrument never lowers a floor
# (CART.2, 2026-10-11: the fourth baseline's paste lowered Life's two native floors, measured slower
# that night on unchanged code, and the check refused the entry, a floor going down only with its
# reason written). A row this run measured under its latest floor is named, a finding and not a
# baseline: run again, or lower that floor by hand with its reason in the entry. A row timed in runs
# where the check's baseline timed it alone, or the other way about, measures other frames (2026-10-12,
# the fourth trap), and a row whose fixture is not the file the check's baseline measured, nor its
# rows rebuilt, measures another cartridge (CART.2's decision 24): either row's floor is re-based on
# this run, the entry saying why where it goes down.
$checkFile = Join-Path $repoRoot 'tools/check_frame_floors.ps1'
$entries = @(Get-HistoryEntries $checkFile)
$was = Get-BaselineRuns $checkFile
$measured = Get-BaselineFixtures $checkFile
$rebuilt = Get-SameRows $checkFile
$digestNow = @{ 'life' = (Get-LfDigest $life); 'gun' = (Get-LfDigest $gun); 'sand' = (Get-LfDigest $sand) }
$latest = @{}
if ($entries.Count -gt 0) {
    foreach ($m in [regex]::Matches([string]$entries[$entries.Count - 1], "'([a-z]+ [a-z]+)' = (\d+)")) { $latest[$m.Groups[1].Value] = [double]$m.Groups[2].Value }
}
$floors = @()
$kept = @()
$under = @()
$rebased = @()
$reasons = @()
foreach ($r in $rows) {
    $fixture = Get-Field $r 'Fixture'
    $key = (Get-Field $r 'Runner') + ' ' + $fixture
    $cps = [double](Get-Field $r 'CellsPerSecond')
    $run = [int](Get-Field $r 'Run')
    $floor = Get-RoundedDown ($cps * (1 - $margin))
    $now = [string]$digestNow[$fixture]
    $changed = $measured.ContainsKey($fixture) -and $now -ne $measured[$fixture] -and -not ($rebuilt.ContainsKey($now) -and $rebuilt[$now] -eq $measured[$fixture])
    $retimed = $was.ContainsKey($key) -and (($was[$key] -gt 1) -ne ($run -gt 1))
    if ($changed -or $retimed) {
        $rebased += $key
        if ($latest.ContainsKey($key) -and $floor -lt $latest[$key]) {
            $whys = @()
            if ($changed) { $whys += ("its fixture is another file, {0}..., where the baseline before it measured {1}..., and cells a second count a fixture's cells (CART.2's decision 24)" -f $now.Substring(0, 8), ([string]$measured[$fixture]).Substring(0, 8)) }
            if ($retimed) { $whys += $(if ($run -gt 1) { "timed in runs of $run from this entry, where the baseline before it timed its frames alone, and a frame under 2 ms timed alone, right after the clock, varied between sessions past the margin (CART.1's frame timer)" } else { 'timed alone from this entry, its frames 2 ms or more, where the baseline before it timed them in runs (CART.1''s frame timer)' }) }
            $reasons += ("{0} re-based: {1}; its floor is this run's less 10%" -f $key, ($whys -join '; and '))
        }
    } elseif ($latest.ContainsKey($key) -and $latest[$key] -gt $floor) {
        $floor = [long]$latest[$key]
        if ($cps -lt $latest[$key]) { $under += $key } else { $kept += $key }
    }
    $floors += ("'{0}' = {1}" -f $key, $floor)
}

$block = New-Object System.Collections.Generic.List[string]
if ($under.Count -gt 0) { $block.Add(('# ---- NOT A BASELINE for {0}: measured under the latest floor, which the check refuses; run again, or lower that floor by hand with its reason in the entry ----' -f ($under -join ', '))) }
$block.Add('# ---- paste from here into tools/check_frame_floors.ps1, over the baseline ----')
$block.Add(("`$baselineDate = '{0}'" -f $date))
$block.Add(("`$baselineEnvironment = '{0}'" -f ($environment -replace "'", "''")))
$block.Add(("`$baselinePin = '{0}'" -f $pin))
$block.Add(("`$baselineFixtures = @{{ 'life' = '{0}'; 'gun' = '{1}'; 'sand' = '{2}' }}" -f (Get-LfDigest $life), (Get-LfDigest $gun), (Get-LfDigest $sand)))
$block.Add('$baseline = @(')
for ($i = 0; $i -lt $rows.Count; $i++) { $block.Add(('    ' + $rows[$i] + $(if ($i -lt $rows.Count - 1) { ',' } else { '' }))) }
$block.Add(')')
$entries += ("@{{ Date = '{0}'; Pin = '{1}'; Reason = '{2}'; Floors = @{{ {3} }} }}" -f $date, $pin, (($reasons -join '; ') -replace "'", "''"), ($floors -join '; '))
$block.Add(('# ---- and this over $floorHistory = @( ... ), whole: the check''s {0} entr{1} as they stand, then this run''s, each row''s cells a second less 10%, three figures, or its latest floor where that is higher, unless the row is timed another way than the baseline before or over another fixture ----' -f ($entries.Count - 1), $(if ($entries.Count -eq 2) { 'y' } else { 'ies' })))
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
if ($kept.Count -gt 0) { Write-Output ("Kept: {0}, measured slower than the run that set the latest floor and still above it, so the entry keeps that floor." -f ($kept -join ', ')) }
if ($rebased.Count -gt 0) { Write-Output ("Re-based: {0}, each timed another way than the check's baseline timed it, or over another fixture than it measured: its floor is this run's less 10%{1}." -f ($rebased -join ', '), $(if ($reasons.Count -gt 0) { ', and where that is lower than the latest, the entry says why' } else { '' })) }
if ($under.Count -gt 0) { Write-Output ("NOT A BASELINE for {0}: measured under the latest floor, so the check refuses this block. Run again at a quieter time; or, where the cause is known and accepted, lower that floor by hand with its reason written in the entry, and record the finding in REARVIEW.md." -f ($under -join ', ')) }
Write-Output ("The block above is also in {0}: copy it from there, since a terminal's line wrap can drop a space from a copy." -f $blockFile)
Write-Output 'In tools/check_frame_floors.ps1, its baseline lines go over the baseline lines, and its history over $floorHistory = @( ... ), whole.'
exit 0
