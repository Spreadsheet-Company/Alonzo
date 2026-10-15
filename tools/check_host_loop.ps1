<#
check_host_loop.ps1 - the host's loop does what docs/SPEC.md section 5 says, over
a fixed input log against the fake module: the page's loop oracle, run
under a headless browser at two pixel ratios, every case OK and its counts
at their floors.

WHY: ENGINE.1's oracle (docs/REARVIEW.md, the scoping's decision 12). The built
page, web/index.html, carries the host shim (web/host.js), the fake module
(web/fake.js) and the Life cartridge; opened with ?loop=1 it drives the host
tick by tick with synthetic timestamps and a frozen clock over a fixed log of
keys, pointer moves, wheel notches and edits, and holds it to expectations
it computes itself, never by asking the host: the accumulator's arithmetic
re-done over the timestamps (a stall of a second runs seven frames at 30
and no more), the Input rows from the key events, the derived writes from
the fake module's declared rule, issued before the inputs so that a
person's edit wins, and the end state from a second fake module the page
drives with no host between, compared by digest. Twelve cases: rate30 (the
Camera moved by an edit and the window following, a derived write refused
and printed, a refused edit, a Camera cell that is not a number, a save
edge, the stall), rate0 (four edits, four steps, the Input sheet never
written), yield (a budget of 1,000 over 64,000 cells, the progress a
sentence, an edit held until the frame is done), since CART.2's third slice
slice (the host's time slice, three quarters of the display's interval:
over the double in steps of 1,000 cells, a clock the case keeps moving 1 ms
at each step call and ticks 20 ms apart, every tick's calls fifteen, the
share the oracle's own constant), since CART.2's playtest pass pace (the
host's tick put on the grid of the frame's interval when within a quarter
millisecond of it: over the double, on ticks 16.7, 16.6 and 16.7 ms apart in
turn as Chrome's timestamps come, every tick at a rate of 60 presents one
frame and every second tick at 30), memory (every allocation
detaches the buffer and the host keeps no view), abi (a module at ABI 2 and
two without an export refused, and the engine's module built into the page
attached at ABI 1 with its version), the refusals by id, scale (the backing
store at a whole number of device pixels a cell, and pixels read back
through the palette, magenta past it), and since ENGINE.1's second slice
two over the engine's own module when the page holds one: engine (the same
host loads Life on the real module and steps it eleven frames, the plane at
frames 1 and 11 equal byte for byte to a reference Life the page computes,
generations 0 and 10, frame 2 again on a second host in budgets of 2,000
cells equal to the unchunked frame, the module's memory grown at the load)
and parity (eleven refusals issued to the fake module and the engine's,
each answered with the same status and id); and since ENGINE.2 plane (the
plane the host draws held to the record of the same window, byte for value,
by the page's own reading of docs/SPEC.md section 3.1, at frame 0 and after every
frame: the window to the Camera's, the bytes to the record, and the canvas's
pixels at a cell of each kind to the Palette's color or magenta; over the
double, its Camera moved by edits and a formula without a value written
outside its declared size; over the engine's module, when the page holds
one, the test card, cartridges/testcard/testcard.vla, twenty-four frames
under a Camera that pans a column a frame, with two edits seen in their
frame); and since SPEC.3's second slice pass (the pass in the page: over the
double, a build declined in words and marked as a refusal, the double
holding no pass; over the engine's module, when the page holds one, every
source the page holds expanded by the host's expand into its cartridge
byte for byte as the command line wrote it, CRLF, a source whose include is
not handed in refused at the include's line, the first load after the pass
handle 1, and a build between two frames leaving the loop running); and
since ENGINE.3's first slice input, over the engine's module when the page
holds one (the input card, cartridges/inputcard/inputcard.vla, loaded with
its seed named and driven by events dispatched to the canvas: keys held
across frames, player 2's press, a key no button binds, the pointer with a
click and a right click, three notches of the wheel that pan the Camera, an
edit of the Clock's frame refused, the Clock's rate written to 1 and back;
the window the host draws equal at every frame to the card computed by hand
from the log, the Tally's counts, the seed in the Clock and in the dice, the
ticks following the rate), with rate30 pinning the pointer written through
the double's Camera and parity holding fourteen refusals; and since ENGINE.3's
second slice replay (the host's SHA-256 held to FIPS 180-2's five vectors;
over the double, a live run of keys, the pointer, derived writes and a
person's edits of the State and Input sheets, copied and played on a fresh
host all at once and through the loop, each ending at the live run's frame
in its digest, the player's recording the replay it played, a person's edit
refused while it plays, the loop paused at its last frame and its stop said
once there (since 2026-10-10), and six replays refused in words with nothing
loaded; over the engine's module, when the page
holds one, the input card's committed replay, cartridges/inputcard/
inputcard.replay.vla, equal to the input case's live run as the host
recorded it, its header the card's digest and seed, each edit that landed
logged in its frame and the Input sheet logged whole after a person's edit
of it; played on a fresh host, every frame the live run's window and its end
the golden, inputcard.golden.vla, byte for byte); and since ENGINE.4's first
slice audio (a double of the Web Audio graph handed to the host as its audio
context, every node and call recorded with its time on a clock the oracle
drives, and held frame by frame to the page's own arithmetic of the scoping's
decisions 1 to 6: over the double, its Audio sheet written by a person's
edits, frames on time, a long task that moves the audio clock on, a stall's
burst, Pause and Run, the page hidden and shown, rate 0 and the unload, and a
wave and a volume that are no voice each said once; over the engine's module,
when the page holds one, the sound card, cartridges/soundcard/soundcard.vla,
240 frames, every frame's Audio sheet equal to the card computed by hand and
every call the arithmetic's, presses each a tick, a knob turned to a wave that
is no wave and back, the rate moved to 10 and back, the waterfall drawn by
hand, and the run as the host recorded it the card's committed replay); and
since ENGINE.4's second slice sound (the host's own voices over the double,
handed an OfflineAudioContext as their audio context, a sequence of voice
states written by edits rendered into samples and measured frame by frame
between the frame's own times, against the graph's own waves rendered beside
it: a settled frame's pitch within 0.1% of its note's and its rms within 4%
of the volume over four times its wave's own, a rest silent below 0.0001, a
frame where a gain or a wave moves stepping no more than 1.5 times its wave's
own; the four waves, notes from 36 to 96, rests, a voice sounding again on
the oscillator it kept and a wave changed twice while its voice sounds), with
replay playing the sound card's committed replay too, every frame of it the
card by hand and its end its golden, the Log's record; and since CART.2's
second slice Sand's, a person's painting session, every frame's Screen the
page's sand under the replay's brush and its end its golden, the Tally's
record; and since CART.4's second slice Kairos's, the owner's two games,
every frame's board the page's Kairos under the replay's buttons and its end
its golden, the Tally's record; and since ENGINE.8 grid (a grid cartridge's
Screen drawn by the host's own viewport, held at frame 0 and after every frame to the record of
the same window by the page's own reading of it: the window to the
Camera's, the viewport's top-left cell to the window's corner and the
person's scroll, every visible cell's text, fill, alignment and place both
ways, a pixel of a look's, a style's and a column's fill, the selection
kept, and the viewport emptied at the unload; over the double, a grid of 20
by 12 drawn through its looks, its Camera moved by edits, a formula written
outside its declared size drawn as its text, the pointer and a bound key
read back from the Input sheet, and an edit made while the loop is paused at
its rate said to wait for the frame Run brings, then written in it; over the
engine's module, when the page holds one, the grid card,
cartridges/gridcard/gridcard.vla, twenty-four frames under a Camera an edit
moves a column right at frames 10 and 20, two edits seen in their frame, and
a person's scroll kept through the Camera's move); and since ENGINE.14 tabs
(a tab with no record clicked as a person clicks it, its sheet shown and held
at the click and after every frame to the record of a window holding every
cell in view, a scroll with the loop paused viewing the new region at once,
the pointer and the wheel over another sheet the viewport's and a bound key
still the game's, the Screen's tab giving back the Camera's window an edit
moved meanwhile, and on the Screen the wheel counted over a cell of the
window and not over the column header, the tab strip or a scrollbar, nor the
pointer over the tab strip; over the double, State, a grid of 20 by 40 taller
than the stage's box; over the module, the grid card's Clock, the frame's
number drawn at every frame); and since ENGINE.15 empty (the page any game's:
the picker's entries the empty sheet the page opens on and then the page's
cartridge blocks in the builder's order, each by its manifest's title, each
library held at its block's path, and the empty sheet loaded as a grid of 80
by 50 at rate zero on the double and on the module, its Screen holding no
cell). It
prints one line a case into
<pre id="loop"> and a last line, 'loop ok cases=N', once the last case has
answered. This check runs the
page under a headless Chromium at a device scale factor of 1 and of 1.5,
reads that element off the dump, and holds every case to OK and its counts
to the floors below; the floors over the engine's module apply when the page
holds one, as abi's module count says, and a page built beside the engine's
artifact must hold that artifact, byte count for byte count, or it is stale.

THE BROWSER, as tools/check_render_oracle.ps1 finds and launches it:
-Browser, else $env:ALONZO_BROWSER, else Google Chrome, Microsoft Edge or
Chromium at their known paths on Windows and by name on the PATH elsewhere;
the KERNEL.3 recipe's flags; Start-Process with redirected output, since
Edge's launcher detaches from a shell pipe. The oracle awaits no animation
frame; its one wait is the sound case's render, which a chain of 0 ms tasks
paces under the virtual clock, about 1.6 s of it on the owner's machine
(measured) and more on a slower one, the clock running with the wall's while
the render runs. The virtual-time budget, 60 s since ENGINE.4's second slice
where it was 20, only bounds the run: a page with nothing left to do skips to
its end, and the case's own watchdog says a render that never lands at 45 s.
SKIPPED with exit 0
without a built page or without a browser: CI builds the page before the
runner and has the browser.

-Control builds forty-two mutant pages through tools/build_web.ps1 and runs
each: a host whose accumulator cap is 2,500 ms and not 250, whose header
proves the mutant applied by printing cap=2500 and whose stall must fail;
a host that issues the derived writes after the inputs, whose edit of
State!B1 must lose to the derived write and fail by name; a template
whose loop element is cut, which this check must fail for want of the
block; when the real page holds the engine's module, a template whose
reference Life lets a cell survive on three neighbors alone, which the
engine case must fail by name at frame 11, proving the comparison bites
(not applicable to a page without a module); a host that draws no frame 0
at a load, whose scale case must fail after its reload; a host that
leaves the canvas as it was at an unload, whose scale case must fail after
its refused load; a host that says a refusal without marking it one,
whose rate30 case must fail by name, since the page paints every marked
refusal red; and since ENGINE.2 three more, each failing the plane case by
name: a host that reads the Camera after it draws the plane, whose plane is
a frame late; a host whose blit masks a byte to the palette, so a byte past
it draws as a color; and a double that reads a formula without a value as
255 again, which its own record says is 0; and since SPEC.3's second slice,
when the real page holds the engine's module, a page built from a scratch
copy of cartridges/ whose library writes the Palette's names to column D
and not C, so that the page's pass writes rows the command line did not,
which the pass case must fail by name (not applicable to a page without a
module); and since ENGINE.3's first slice three more: a host that writes
the pointer as the window's cell, without the Camera, which rate30 must
fail by name and, with the module, the input case at its window; and, when
the real page holds the module, a host that never reads the Clock's rate
after a step, whose ticks keep the manifest's rate where the input case
slowed it to 1, and a host that never writes its seed, whose Clock!B3 the
input case finds empty; and, found by the owner's hand test of ENGINE.3, a
host whose backlog is held to the quarter second whatever the rate, as it
was, so that at the teacher's rate of 1 no frame is ever owed, which the
input case must fail at the frame it never ran; and since ENGINE.3's second
slice three more, when the real page holds the module, each failing the
replay case by name: a recorder that drops a person's edits, a player that
skips the derived writes, and a recorder that keeps its record of the Input
sheet across a person's edit of it; and since ENGINE.4's first slice five
more, over the double and so with or without the module, each failing the
audio case by name: a host that sets a voice's gain at once, one that sounds
every frame a lookahead from the audio clock's now, the animation clock in the
rhythm, one whose voice's gain is its volume, one that leaves the voices
sounding at a stop, and one that changes a wave at once while the voice
sounds; and since ENGINE.4's second slice one more, over the double: a host
and a page whose time constant is written in milliseconds where the graph
takes seconds, both alike, so that the audio case passes it and the sound
case, whose render hears the voice that never arrives, must fail it by name;
and after ENGINE.4's close one more, over the double: a host that never says
a running loop stopped, so that the panel's live sheet would stay behind the
frame line at a stop, which the replay case must fail by name; and since
CART.2's third slice one more, over the double: a host whose slice is half
the display's interval again, whose header must say slice=0.5 and whose
ticks the slice case must fail by name, ten calls where it owes fifteen;
and since CART.2's playtest pass one more, over the double: a host whose
tick snaps to no grid, its tolerance 0, whose header must say snap=0 and
whose pace case must fail by name, its second tick at 60 presenting none;
and since CART.2's second slice one more, when the real page holds the
module: a template whose sand paints a brush without its rim, < where the
cartridge's Gate says <=, which the replay case must fail by name on Sand's
committed replay; and since ENGINE.8 six more, each failing the grid case
by name: a viewport that reads no value row, so a formula's text is drawn
where its value is due; one that matches no look, so a look's fill is
missing; a host that draws each frame without keeping the view, so the
selection and the Camera's scroll go back to A1; a host that draws the grid
before it reads the Camera, a frame late; a host that says nothing of an
edit made while the loop is paused at its rate; and, when the real page
holds the module, a viewport that lays every row at the default height, the
card's tall row and hidden row among them; and since CART.4's second slice
one more, when the real page holds the module: a template whose Kairos turns
a row a column early, at the board's sixth column where the cartridge turns
it at the seventh, which the replay case must fail by name on Kairos's
committed replay; and since ENGINE.14 five more, over the double, each
failing the tabs case by name: a host that answers no tab, so a clicked tab
shows nothing; one that views the sheet shown at the click alone, never at a
frame, so it is drawn stale; one whose Screen tab keeps the person's scroll,
so the Camera's window is not given back; one that takes the wheel over the
viewport's whole root, the tabs, headers and scrollbars, as ENGINE.8 built it;
and a viewport whose hit test counts the tab strip as cells, so the pointer
over it is written as a cell; and since ENGINE.15 two more, over the double,
each failing the empty case by name: a template whose empty sheet steps at
rate 30, and one whose picker offers the page's cartridges in reverse. The
real page must pass first.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network;
exit 0 clean, exit 1 with every problem named. A headless run's clock is
virtual, so nothing here is a timing.

Usage:  powershell -File tools\check_host_loop.ps1
        powershell -File tools\check_host_loop.ps1 -Browser "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        powershell -File tools\check_host_loop.ps1 -Page C:\somewhere\index.html
        powershell -File tools\check_host_loop.ps1 -Control
#>
param(
    [string]$Page = '',
    [string]$Browser = '',
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if ($Page -eq '') { $Page = Join-Path $repoRoot 'web/index.html' }
elseif (-not [System.IO.Path]::IsPathRooted($Page)) { $Page = Join-Path $repoRoot $Page }
# Not $IsWindows: that name is a read-only automatic variable under PowerShell 7, and the crate job runs this under pwsh.
$onWindows = ($env:OS -eq 'Windows_NT')

# --- the floors: each case's counts, never lowered; the scales the oracle runs at ---
# 2026-10-08, ENGINE.1: seven cases, measured under headless Chrome 154 and
# Edge 154 at both ratios, the counts a function of the log and so the same
# on every machine: rate30 42 frames, 41 derived writes landed and 11 refused
# (frames divisible by 7, 11 and 13), 4 edits written and one refused, 3
# windows, 111 detachments; rate0 4 frames for 4 edits, 3 windows; yield 9
# frames in 608 step calls and 599 yields; memory 14 frames and 637
# detachments, one an allocation; abi 4 refusals with the module built in (3
# without one); refusals 5; scale 2 at a ratio of 1 and 3 at 1.5, 6 pixels
# read back. Live allocations and misfrees are held at exactly zero.
# 2026-10-09, ENGINE.1's second slice: nine cases, under headless Chrome 154
# at both ratios over the engine's module of about 456 KB, the first seven's
# counts unchanged and their digests the same; abi 3 refusals and the module
# attached; engine 11 frames, 2 planes equal to the reference Life (23,683 and
# 14,482 live cells at generations 0 and 10), frame 2 equal in 64 calls of
# 2,000 cells, the memory grown, 5 devices; parity 11 of 11; 5.5 s a run.
# WithModule floors hold only when the page holds the engine's module. The
# same day, from the owner's hand test (a reload at rate 0 left the last run's
# picture on the canvas): scale's 6 cells read opaque black after a reload,
# frame 0 drawn at the load, and transparent after a refused load, the canvas
# emptied at the unload; engine's reload holds frame 0's empty plane.
# 2026-10-09, ENGINE.2: ten cases, the first nine's counts and digests
# unchanged; plane over the double 12 frames, 13 of them equal to the record
# (frame 0 with them), 2 windows, 40 pixels read back; over the engine's
# module 24 frames, 25 equal, 21 windows, 96 pixels, 31 distinct bytes.
# 2026-10-10, SPEC.3's second slice: eleven cases, the first ten's counts
# unchanged; pass over the double 1 build declined, and over the engine's
# module of 514,688 bytes 3 sources, 3 the same as the command line's (251
# rows after their manifests), the include refused at its line, handle 1 at
# the first load after the pass, the loop run on through a build.
# 2026-10-10, ENGINE.3's first slice: twelve cases, the first eleven's counts
# unchanged but for three: rate30 pins the pointer written through the
# double's Camera (pointer 1); parity 14 refusals, the Clock's three added;
# pass 4 sources the same, the input card's among them. input over the
# engine's module of 516,175 bytes: 26 frames, each window equal to the card
# computed by hand from the log, the seed named, 4 presses (1 of player 2's),
# 2 clicks, 3 notches, 4 key frames and the last code, the dice, the click's
# frame 11 carried by a derived write, the pointer's last column 8 through the
# Camera, the cursor seen in 16 frames, a button held in 6, the rate followed
# 3 ways, cart-write-clock said once. The same day, from the owner's hand
# test (the rate of 1 froze the loop, its backlog held under the interval):
# the case writes the rate of 1, and paces its ticks by its own arithmetic of
# section 5 as corrected, three frames at a second owed only after their
# waiting ticks ran none, so the rate is followed 5 ways.
# 2026-10-10, ENGINE.3's second slice: thirteen cases, the first twelve's counts
# unchanged but for input, whose log gains a person's edit of the Input sheet,
# player 2's fifth button held for one frame by the edit: 5 presses, 2 of
# player 2's, a button held in 7 frames. replay over the double: the 5 vectors,
# a live run of 24 frames played to its digest all at once and through the
# loop, the recording its replay, an edit refused while it played, 6 replays
# refused; over the module of 516,175 bytes: the card's committed replay its
# digest's and seed's, equal to the input case's run as recorded, 3 edits
# logged in their frames, the Input sheet whole twice; and every committed
# replay played to its golden, 1 today, its 26 frames each equal to the live
# run's, and its recording itself.
# 2026-10-10, ENGINE.4's first slice: fourteen cases, the first thirteen's
# counts and digests unchanged but for pass, 5 sources the same, the sound
# card's among them (504 rows after their manifests). audio over the double:
# 43 frames, 41 sounded (the frames and three starts, less five skipped), 80
# calls on the double of the graph, 3 oscillators, 5 restarts (the start, the
# long task, the stall, the run after the pause, the page shown), 5 skipped
# (the stall's burst), 3 silences (the pause, the page hidden, the unload), 2
# notices, 3 frames at rate 0, and with the sound off the one notice that the
# voices would sound, nothing sounded; over the engine's module of 516,175 bytes, the
# sound card: 240 frames, each one's Audio sheet the card by hand and each
# one's calls the page's arithmetic, 241 sounded, 248 calls, 5 ticks, 1 frame
# silenced by a wave that is no wave and its one notice, 10 frames at the rate
# of 10, the waterfall drawn by hand 240 times.
# 2026-10-10, ENGINE.4's second slice: fifteen cases, the first twelve's counts
# and digests unchanged. sound over the double: 49 frames sounded and rendered,
# 19 settled frames each within 0.1% of its note's pitch and 4% of its rms (the
# worst 0.0052% and 0.06%, measured), 17 rests without a sample of 0.0001 (each
# 0 exactly), 8 frames where a gain or a wave moved, the worst step 1.00 times
# the wave's own, 2 of them a dip, 5 releases, 4 waves and 6 notes heard across
# a span of 60. replay over the module: 2 replays, each played to its golden and
# recording itself, the sound card's 240 frames each the card by hand; audio
# over the module: the card's run as recorded its committed replay.
# 2026-10-10, after ENGINE.4's close (ENGINE.1's panel, at the owner's word): the
# host says when a running loop stops, at its frame, so that the panel's live
# sheet is drawn at the frame its frame line says; replay holds the stop said
# once at the replay's last frame (stopped 1), the other counts unchanged.
# 2026-10-11, CART.2's first slice: fifteen cases, the counts and digests
# unchanged but for pass, 6 sources the same, Sand's among them.
# 2026-10-12, CART.2's third slice: sixteen cases, the fifteen's counts and
# digests unchanged, pass over Sand with water 6 sources the same (590 rows
# after their manifests). slice over the double: 39 ticks after the first, each
# 15 step calls (perTick, the oracle's own share of the 20 ms interval at
# 1 ms a call), 585 calls in all and 9 frames of 64 calls.
# 2026-10-12, CART.2's playtest pass: seventeen cases, the sixteen's counts
# unchanged. pace over the double: 60 ticks at each rate after its first, 60
# frames at a rate of 60 and 30 at the rate of 30, every tick as the grid owes it.
# 2026-10-12, CART.2's second slice: the seventeen cases' counts unchanged but
# for replay over the module, 3 replays each played to its golden and recording
# itself, Sand's the third, the owner's session on the finished toy: its 2,085
# frames each the page's sand under the replay's brush, 453 of them painted.
# 2026-10-12, ENGINE.8's first slice: eighteen cases, the seventeen's counts and
# digests unchanged but for pass, 7 sources the same, the grid card's among them
# (742 rows after their manifests). grid over the double, a grid of 20 by 12: 12
# frames, 13 equal to the record with frame 0, 2 windows, 2,336 texts, 1,913
# fills through a look, 244 formulas drawn as their text before a value, 12
# pixels read back, the selection kept 10 frames, the pointer and a bound key
# read back, the edits of frame 5 seen, the viewport emptied at the unload; over
# the engine's module of 682,679 bytes, the grid card: 24 frames, 25 equal, 3
# windows, 11,395 texts, 20 wrapped, 10,677 fills (10,311 through a look, 40 by a
# style, 326 by a column), 350 formulas drawn as their text at frame 0, 20 cells
# of a hidden row or column never drawn, 70 pixels read back, the selection kept
# 22 frames, the person's scroll kept through the Camera's move, the edits of
# frame 6 seen. A text left of the view reaches into it by its width in the
# browser's font, so the texts' floors hold a margin below the counts measured
# under Chrome 154 on Windows, where every other count is the record's and the
# layout's own.
# 2026-10-12, CART.4's first slice: the eighteen cases' counts and digests
# unchanged but for pass, 8 sources the same as the command line's (1,119 rows
# after their manifests), Kairos's among them, its library holding the five
# verbs the stacking game brought.
# 2026-10-12, CART.4's second slice: the eighteen cases' counts unchanged but
# for replay over the module, 4 replays each played to its golden and recording
# itself, Kairos's the fourth, the owner's two games: its 3,469 frames each
# the page's Kairos under the replay's buttons, 30 rows stopped.
# 2026-10-14, ENGINE.14: nineteen cases, the eighteen's counts and digests
# unchanged but for grid over the module, which now draws a number too wide
# for its column as #s: 168 cells over its 25 frames, the floor the card's
# three constants wider than any default column (B5, C5 and F5, B5 scrolled
# out at frame 20), 70. tabs over the double, a grid of 20 by 40: 14 frames,
# State's tab clicked and its sheet shown, held to the record of the region in
# view 8 times (at the click, 5 frames, the paused scroll and back), the
# Screen held 9 frames, the pointer, a bound key, the tab strip and 5 wheels
# routed (4 where a headless browser's scrollbars are overlays: noBar 1); over
# the engine's module of 749,162 bytes, the grid card: 12 frames, its Clock
# held 5 times and its frame's number drawn 4, the Screen 8, 5 wheels. The
# texts' floors hold a margin below Chrome 155's counts on Windows.
# 2026-10-14, ENGINE.15: twenty cases, the nineteen's counts unchanged. empty,
# the page any game's: the picker's entries the empty sheet and then the
# page's 8 cartridge blocks in the builder's order, all 8 titled from their
# manifests, the 1 library held at its block's path, and the empty sheet
# loaded as a grid of 80 by 50 at rate zero on the double and, over the
# module, its Screen holding no cell (filled, which must be 0).
$scales = @('1', '1.5')
$floors = @(
    @{ Case = 'rate30';   Min = @{ frames = 42; inputs = 42; applied = 41; refused = 11; edits = 4; windows = 3; detaches = 100; pointer = 1 } },
    @{ Case = 'rate0';    Min = @{ frames = 4; applied = 3; edits = 4; windows = 3 } },
    @{ Case = 'yield';    Min = @{ frames = 9; calls = 600; yields = 590; edits = 1 } },
    @{ Case = 'slice';    Min = @{ ticks = 39; perTick = 15; calls = 585; frames = 9 } },
    @{ Case = 'pace';     Min = @{ ticks = 120; rate60 = 60; rate30 = 30 } },
    @{ Case = 'memory';   Min = @{ frames = 14; edits = 1; detaches = 600 } },
    @{ Case = 'abi';      Min = @{ refused = 3 }; WithModule = @{ attached = 1 } },
    @{ Case = 'refusals'; Min = @{ refused = 5; marked = 5 } },
    @{ Case = 'scale';    Min = @{ scale = 2; probes = 6; reloaded = 6; cleared = 6 } },
    @{ Case = 'engine';   Min = @{}; WithModule = @{ frames = 11; equal = 2; live1 = 23683; live11 = 14482; chunked = 1; grown = 1; devices = 5; reloaded = 1 } },
    @{ Case = 'parity';   Min = @{}; WithModule = @{ same = 14 } },
    @{ Case = 'plane';    Min = @{ fakeFrames = 12; fakeEqual = 13; fakeWindows = 2; fakeProbes = 40 }; WithModule = @{ frames = 24; equal = 25; windows = 21; probes = 96; kinds = 31 } },
    @{ Case = 'pass';     Min = @{ declined = 1 }; WithModule = @{ sources = 8; same = 8; refused = 1; handle = 1; ranOn = 1 } },
    @{ Case = 'input';    Min = @{}; WithModule = @{ frames = 26; equal = 26; seed = 1; presses = 5; players = 2; clicks = 2; wheel = 3; typed = 4; code = 1; dice = 1; clicked = 11; pointer = 8; cursor = 16; held = 7; rate = 5; refused = 1 } },
    @{ Case = 'replay';   Min = @{ vectors = 5; liveFrames = 24; doubleSame = 1; doubleRound = 1; paced = 1; stopped = 1; waited = 1; refused = 6 }; WithModule = @{ digest = 1; seed = 1; recorded = 1; edits = 3; whole = 2; replays = 4; frames = 26; same = 26; golden = 4; round = 4; cardSame = 240; sandFrames = 2085; sandPainted = 453; kairosFrames = 3469; kairosStops = 30 } },
    @{ Case = 'audio';    Min = @{ frames = 43; sounded = 41; calls = 80; oscillators = 3; restarts = 5; skipped = 5; silences = 3; notices = 2; rate0 = 3; wanted = 1 }; WithModule = @{ cardFrames = 240; cardEqual = 240; cardSounded = 241; cardCalls = 248; ticks = 5; silenced = 1; cardNotices = 1; slow = 10; waterfall = 240; recorded = 1 } },
    @{ Case = 'sound';    Min = @{ frames = 49; settled = 19; rests = 17; steps = 8; dips = 2; releases = 5; waves = 4; notes = 6; span = 60 } },
    @{ Case = 'grid';     Min = @{ fakeFrames = 12; fakeEqual = 13; fakeWindows = 2; fakeTexts = 2300; fakeLooks = 1913; fakeUnvalued = 244; fakeProbes = 12; fakeKept = 10; fakeCleared = 1; pointer = 1; key = 1; edited = 1; waits = 1 };
                            WithModule = @{ frames = 24; equal = 25; windows = 3; texts = 11000; wraps = 20; fills = 10677; looks = 10311; styles = 40; columns = 326; unvalued = 350; hidden = 20; probes = 70; kept = 22; followed = 1; edits = 1; cleared = 1; hashes = 70 } },
    @{ Case = 'tabs';     Min = @{ fakeFrames = 14; fakeShown = 1; fakeHeld = 8; fakeScrolled = 1; fakeBack = 1; fakeScreen = 9; fakePointer = 1; fakeRouted = 1; fakeKey = 1; fakeStrip = 1; fakeWheel = 4; fakeTexts = 4600 };
                            WithModule = @{ frames = 12; shown = 1; held = 5; back = 1; screen = 8; pointer = 1; routed = 1; strip = 1; wheel = 4; clock = 4; texts = 3400 } },
    @{ Case = 'empty';    Min = @{ cartridges = 8; ordered = 8; titled = 8; libraries = 1; double = 1 }; WithModule = @{ engine = 1 } }
)
$zero = @('live', 'misfrees', 'filled')
$expectedCases = 20
# The engine's artifact: a page built beside it must hold it.
$artifact = Join-Path $repoRoot 'target/wasm32-unknown-unknown/release/alonzo.wasm'

function Find-Browser([string]$named) {
    if ($named -ne '') { if (Test-Path -LiteralPath $named) { return $named }; return '' }
    if ($env:ALONZO_BROWSER) { if (Test-Path -LiteralPath $env:ALONZO_BROWSER) { return $env:ALONZO_BROWSER }; return '' }
    if ($onWindows) {
        $candidates = @(
            (Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'),
            (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'),
            (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'),
            (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe'),
            (Join-Path $env:ProgramFiles 'Chromium\Application\chrome.exe')
        )
        foreach ($c in $candidates) { if ($c -and (Test-Path -LiteralPath $c)) { return $c } }
        return ''
    }
    foreach ($name in @('google-chrome', 'google-chrome-stable', 'chromium-browser', 'chromium', 'microsoft-edge', 'microsoft-edge-stable')) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    return ''
}
function Get-PageUrl([string]$path) {
    $slashed = [System.IO.Path]::GetFullPath($path) -replace '\\', '/'
    if ($slashed.StartsWith('/')) { return 'file://' + $slashed + '?loop=1' }
    return 'file:///' + $slashed + '?loop=1'
}
# One headless run: the loop element's text, or '' with the reason.
function Invoke-Loop([string]$browser, [string]$page, [string]$scale) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_loop_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $dump = Join-Path $tmp 'dump.html'
        $err = Join-Path $tmp 'err.txt'
        $argList = @('--headless=new', '--disable-gpu', '--run-all-compositor-stages-before-draw', '--disable-frame-rate-limit', '--disable-gpu-vsync',
                     '--virtual-time-budget=60000', ('--force-device-scale-factor=' + $scale), '--window-size=1600,1200', '--no-first-run', '--no-default-browser-check',
                     ('--user-data-dir="' + (Join-Path $tmp 'profile') + '"'))
        if (-not $onWindows) { $argList += @('--no-sandbox', '--disable-dev-shm-usage') }
        $argList += @('--dump-dom', ('"' + (Get-PageUrl $page) + '"'))
        $start = @{ FilePath = $browser; ArgumentList = $argList; RedirectStandardOutput = $dump; RedirectStandardError = $err; Wait = $true }
        if ($onWindows) { $start['NoNewWindow'] = $true }
        Start-Process @start
        if (-not (Test-Path -LiteralPath $dump)) { return @{ Text = ''; Reason = 'the browser wrote no dump' } }
        $html = [System.IO.File]::ReadAllText($dump)
        $m = [regex]::Match($html, '(?s)<pre id="loop"[^>]*>(.*?)</pre>')
        if (-not $m.Success) { return @{ Text = ''; Reason = ("no loop block in the dump ({0:N0} characters)" -f $html.Length) } }
        $text = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value).Trim()
        if ($text -eq '') { return @{ Text = ''; Reason = 'the loop block is empty' } }
        return @{ Text = $text; Reason = '' }
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}
# The judgment of one run's text at one scale: the problems, and the case lines to print.
function Test-Loop([string]$text, [string]$scale) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = @($text -split "`n" | ForEach-Object { $_.TrimEnd("`r") })
    $header = $lines[0]
    if ($header -notlike 'loop: host *') { $problems.Add("the first line is not the loop oracle's header: $header") }
    $dm = [regex]::Match($header, 'dpr=([0-9.]+)')
    if (-not $dm.Success -or $dm.Groups[1].Value -ne $scale) { $problems.Add("the page saw a ratio of '$($dm.Groups[1].Value)', the run asked for $scale") }
    $cases = @{}
    $caseLines = New-Object System.Collections.Generic.List[string]
    foreach ($l in $lines) {
        $m = [regex]::Match($l, '^case (\S+): ([^:]*): (OK|FAIL.*)$')
        if (-not $m.Success) { continue }
        $counts = @{}
        foreach ($pair in ($m.Groups[2].Value -split ',\s*')) { $kv = [regex]::Match($pair.Trim(), '^(\w+) (\S+)$'); if ($kv.Success) { $counts[$kv.Groups[1].Value] = $kv.Groups[2].Value } }
        $cases[$m.Groups[1].Value] = @{ Counts = $counts; Verdict = $m.Groups[3].Value }
        $caseLines.Add(("  {0}: {1}" -f $m.Groups[1].Value, ($l -replace '^case \S+: ', '')))
    }
    # The engine's module, as the abi case counts its bytes: 0 when the page holds none.
    $module = 0
    if ($cases.ContainsKey('abi') -and $cases['abi'].Counts.ContainsKey('module')) { $module = [double]$cases['abi'].Counts['module'] }
    if (Test-Path -LiteralPath $artifact) {
        $size = (Get-Item -LiteralPath $artifact).Length
        if ($module -ne $size) { $problems.Add("the page holds an engine module of $module bytes and $artifact is $size; a page built beside the artifact holds it, so rebuild the page (tools/build_web.ps1)") }
    }
    foreach ($f in $floors) {
        $c = $cases[$f.Case]
        if ($null -eq $c) { $problems.Add("the case $($f.Case) was not run"); continue }
        if ($c.Verdict -ne 'OK') { $problems.Add("the case $($f.Case) at a ratio of $scale`: $($c.Verdict)") }
        $mins = @{}
        foreach ($k in $f.Min.Keys) { $mins[$k] = $f.Min[$k] }
        if ($f.ContainsKey('WithModule') -and $module -gt 0) { foreach ($k in $f.WithModule.Keys) { $mins[$k] = $f.WithModule[$k] } }
        if ($f.ContainsKey('WithModule') -and $c.Counts.ContainsKey('module') -and [double]$c.Counts['module'] -ne $module) { $problems.Add("the case $($f.Case) ran over a module of $($c.Counts['module']) bytes and abi over $module") }
        foreach ($k in $mins.Keys) {
            if (-not $c.Counts.ContainsKey($k)) { $problems.Add("the case $($f.Case) printed no count of $k"); continue }
            if ([double]$c.Counts[$k] -lt $mins[$k]) { $problems.Add("the case $($f.Case) at a ratio of $scale counted $($c.Counts[$k]) $k, below its floor of $($mins[$k])") }
        }
        foreach ($k in $zero) { if ($c.Counts.ContainsKey($k) -and [double]$c.Counts[$k] -ne 0) { $problems.Add("the case $($f.Case) at a ratio of $scale counted $($c.Counts[$k]) $k, where it must count none") } }
    }
    $last = $lines[$lines.Count - 1]
    if ($last -notmatch '^loop ok cases=(\d+)') { $problems.Add("the last line is not 'loop ok': $last") }
    elseif ([int]$Matches[1] -ne $expectedCases) { $problems.Add("the oracle ran $($Matches[1]) case(s), not the $expectedCases pinned here") }
    return @{ Problems = $problems; Lines = $caseLines; Header = $header }
}

$browser = Find-Browser $Browser
if ($Control) {
    if (-not (Test-Path -LiteralPath $Page)) { Write-Output ("SKIPPED: no built page at {0}; the control builds nothing without the real page to start from (tools/build_web.ps1 writes it)" -f $Page); exit 0 }
    if ($browser -eq '') { Write-Output 'SKIPPED: no browser found for the control (set ALONZO_BROWSER, or -Browser)'; exit 0 }
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_loop_control_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $shell = if (Get-Command powershell.exe -ErrorAction SilentlyContinue) { 'powershell.exe' } else { 'pwsh' }
        $builder = Join-Path $PSScriptRoot 'build_web.ps1'
        $template = Join-Path $repoRoot 'web/index.template.html'
        $hostJs = Join-Path $repoRoot 'web/host.js'
        $js = [System.IO.File]::ReadAllText($hostJs)
        $tpl = [System.IO.File]::ReadAllText($template)
        $fakeJs = Join-Path $repoRoot 'web/fake.js'
        $fk = [System.IO.File]::ReadAllText($fakeJs)
        $viewportJs = Join-Path $repoRoot 'web/viewport.js'
        $vpText = [System.IO.File]::ReadAllText($viewportJs)
        function New-MutantPage([string]$name, [string]$tplPath, [string]$jsPath, [string]$fakePath = '', [string]$cartsPath = '', [string]$viewportPath = '') {
            $out = Join-Path $tmp ($name + '.html')
            if ($fakePath -eq '') { $fakePath = $fakeJs }
            if ($cartsPath -eq '') { $cartsPath = Join-Path $repoRoot 'cartridges' }
            if ($viewportPath -eq '') { $viewportPath = $viewportJs }
            $prev = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            try { $null = & $shell -NoProfile -ExecutionPolicy Bypass -File $builder -Template $tplPath -HostJs $jsPath -FakeJs $fakePath -CartridgesDir $cartsPath -ViewportJs $viewportPath -Out $out 2>&1; $code = $LASTEXITCODE } finally { $ErrorActionPreference = $prev }
            if ($code -ne 0 -or -not (Test-Path -LiteralPath $out)) { throw "the builder could not build the mutant page $name" }
            return $out
        }
        # the real page first
        $r0 = Invoke-Loop $browser $Page '1'
        $j0 = if ($r0.Text -ne '') { Test-Loop $r0.Text '1' } else { @{ Problems = @($r0.Reason) } }
        # mutant A: the accumulator's cap raised; the header must say so and the stall must fail
        $anchorA = 'var ACCUMULATOR_CAP_MS = 250;'
        if (([regex]::Matches($js, [regex]::Escape($anchorA))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorA' is not in web/host.js exactly once"; exit 1 }
        $jsA = Join-Path $tmp 'a.js'; [System.IO.File]::WriteAllText($jsA, $js.Replace($anchorA, 'var ACCUMULATOR_CAP_MS = 2500;'), $utf8)
        $rA = Invoke-Loop $browser (New-MutantPage 'a' $template $jsA) '1'
        $aApplied = ($rA.Text -ne '') -and ($rA.Text.Split("`n")[0] -like '*cap=2500*')
        $jA = if ($rA.Text -ne '') { Test-Loop $rA.Text '1' } else { @{ Problems = @($rA.Reason) } }
        $aStall = @($jA.Problems | Where-Object { $_ -like '*rate30*after tick 60 the host is at frame*' }).Count
        # mutant B: the derived writes issued after the inputs; the edit of State!B1 must lose and fail by name
        $anchorB = "    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs`n    this._issueInputs();    // step 3: the Input rows, then a person's edits, each its own write"
        $swapB = "    this._issueInputs();    // step 3: the Input rows, then a person's edits, each its own write`n    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs"
        if (([regex]::Matches($js, [regex]::Escape($anchorB))).Count -ne 1) { Write-Output "FAIL: the two lines of the frame's writes are not in web/host.js exactly once, in order"; exit 1 }
        $jsB = Join-Path $tmp 'b.js'; $mutB = $js.Replace($anchorB, $swapB); [System.IO.File]::WriteAllText($jsB, $mutB, $utf8)
        $bApplied = ([regex]::Matches($mutB, [regex]::Escape($swapB))).Count -eq 1
        $rB = Invoke-Loop $browser (New-MutantPage 'b' $template $jsB) '1'
        $jB = if ($rB.Text -ne '') { Test-Loop $rB.Text '1' } else { @{ Problems = @($rB.Reason) } }
        $bLost = @($jB.Problems | Where-Object { $_ -like '*must win over the derived write*' }).Count
        # mutant C: the loop element cut from the template
        $anchorC = '<pre id="loop" class="result">'
        if (([regex]::Matches($tpl, [regex]::Escape($anchorC))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorC' is not in the template exactly once"; exit 1 }
        $tplC = Join-Path $tmp 'c.template.html'; [System.IO.File]::WriteAllText($tplC, $tpl.Replace($anchorC, '<pre id="loop-cut" class="result">'), $utf8)
        $rC = Invoke-Loop $browser (New-MutantPage 'c' $tplC $hostJs) '1'
        $cNoBlock = ($rC.Text -eq '') -and ($rC.Reason -like 'no loop block*')
        # mutant D, when the real page holds the engine's module: the reference Life lets a cell
        # survive on three neighbors alone; the engine case must fail by name at frame 11
        $moduleReal = 0
        if ($r0.Text -ne '') { $am = [regex]::Match($r0.Text, 'case abi: [^\n]*module (\d+)'); if ($am.Success) { $moduleReal = [int]$am.Groups[1].Value } }
        $dApplied = $false; $dFailed = 0; $dNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorD = 'next[i] = (others === 3 || (me === 1 && others === 2)) ? 1 : 0;'
            if (([regex]::Matches($tpl, [regex]::Escape($anchorD))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorD' is not in the template exactly once"; exit 1 }
            $mutD = $tpl.Replace($anchorD, 'next[i] = (others === 3 || (me === 1 && others === 3)) ? 1 : 0;')
            $dApplied = $mutD -cne $tpl
            $tplD = Join-Path $tmp 'd.template.html'; [System.IO.File]::WriteAllText($tplD, $mutD, $utf8)
            $rD = Invoke-Loop $browser (New-MutantPage 'd' $tplD $hostJs) '1'
            $jD = if ($rD.Text -ne '') { Test-Loop $rD.Text '1' } else { @{ Problems = @($rD.Reason) } }
            $dFailed = @($jD.Problems | Where-Object { $_ -like '*case engine*frame 11 differs from the reference Life*' }).Count
            $dNote = "applied ($dApplied) and failed the engine case at frame 11 ($dFailed)"
        }
        $dOk = ($moduleReal -eq 0) -or ($dApplied -and $dFailed -ge 1)
        # mutant E: no frame 0 drawn at a load; the scale case's reload must fail by name
        $anchorE = "    if (c.mode === 'plane') this._drawPlane();   // frame 0, drawn at the load"
        if (([regex]::Matches($js, [regex]::Escape($anchorE))).Count -ne 1) { Write-Output "FAIL: the frame-0 draw is not in web/host.js exactly once"; exit 1 }
        $mutE = $js.Replace($anchorE, '    // the frame-0 draw cut by the control')
        $eApplied = $mutE -cne $js
        $jsE = Join-Path $tmp 'e.js'; [System.IO.File]::WriteAllText($jsE, $mutE, $utf8)
        $rE = Invoke-Loop $browser (New-MutantPage 'e' $template $jsE) '1'
        $jE = if ($rE.Text -ne '') { Test-Loop $rE.Text '1' } else { @{ Problems = @($rE.Reason) } }
        $eFailed = @($jE.Problems | Where-Object { $_ -like '*case scale*after the reload the cell*' }).Count
        # mutant F: the canvas left as it was at an unload; the scale case's refused load must fail by name
        $anchorF = '    this._clear();'
        if (([regex]::Matches($js, [regex]::Escape($anchorF))).Count -ne 1) { Write-Output "FAIL: the clear at an unload is not in web/host.js exactly once"; exit 1 }
        $mutF = $js.Replace($anchorF, '    // the clear cut by the control')
        $fApplied = $mutF -cne $js
        $jsF = Join-Path $tmp 'f.js'; [System.IO.File]::WriteAllText($jsF, $mutF, $utf8)
        $rF = Invoke-Loop $browser (New-MutantPage 'f' $template $jsF) '1'
        $jF = if ($rF.Text -ne '') { Test-Loop $rF.Text '1' } else { @{ Problems = @($rF.Reason) } }
        $fFailed = @($jF.Problems | Where-Object { $_ -like '*case scale*after a refused load the cell*' }).Count
        # mutant G: a refusal said without its mark; the rate30 case must fail, a refusal not marked as one
        $anchorG = "Host.prototype._refuse = function (text) { this._say(text, 'event', true); };"
        if (([regex]::Matches($js, [regex]::Escape($anchorG))).Count -ne 1) { Write-Output "FAIL: the refusal's mark is not in web/host.js exactly once"; exit 1 }
        $mutG = $js.Replace($anchorG, "Host.prototype._refuse = function (text) { this._say(text, 'event', false); };")
        $gApplied = $mutG -cne $js
        $jsG = Join-Path $tmp 'g.js'; [System.IO.File]::WriteAllText($jsG, $mutG, $utf8)
        $rG = Invoke-Loop $browser (New-MutantPage 'g' $template $jsG) '1'
        $jG = if ($rG.Text -ne '') { Test-Loop $rG.Text '1' } else { @{ Problems = @($rG.Reason) } }
        $gFailed = @($jG.Problems | Where-Object { $_ -like '*case rate30*a refusal is not marked as one*' }).Count
        # mutant H: the Camera read after the plane is drawn; the plane is a frame late and the plane case must fail by name
        $anchorH = "    if (d.camera) this._readCamera();`n    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();"
        $swapH = "    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();`n    if (d.camera) this._readCamera();"
        if (([regex]::Matches($js, [regex]::Escape($anchorH))).Count -ne 1) { Write-Output "FAIL: the three reads of a frame's effects are not in web/host.js exactly once, in order"; exit 1 }
        $mutH = $js.Replace($anchorH, $swapH)
        $hApplied = ([regex]::Matches($mutH, [regex]::Escape($swapH))).Count -eq 1
        $jsH = Join-Path $tmp 'h.js'; [System.IO.File]::WriteAllText($jsH, $mutH, $utf8)
        $rH = Invoke-Loop $browser (New-MutantPage 'h' $template $jsH) '1'
        $jH = if ($rH.Text -ne '') { Test-Loop $rH.Text '1' } else { @{ Problems = @($rH.Reason) } }
        $hFailed = @($jH.Problems | Where-Object { $_ -like "*case plane*in the host's plane and*by the record of*" }).Count
        # mutant I: the blit masks a byte to the palette; a byte past it draws as a color, and the plane case's pixels must fail
        $anchorI = '    for (var i = 0; i < n; i++) px[i] = pal[bytes[i]];'
        if (([regex]::Matches($js, [regex]::Escape($anchorI))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorI' is not in web/host.js exactly once"; exit 1 }
        $mutI = $js.Replace($anchorI, '    for (var i = 0; i < n; i++) px[i] = pal[bytes[i] & 15];')
        $iApplied = $mutI -cne $js
        $jsI = Join-Path $tmp 'i.js'; [System.IO.File]::WriteAllText($jsI, $mutI, $utf8)
        $rI = Invoke-Loop $browser (New-MutantPage 'i' $template $jsI) '1'
        $jI = if ($rI.Text -ne '') { Test-Loop $rI.Text '1' } else { @{ Problems = @($rI.Reason) } }
        $iFailed = @($jI.Problems | Where-Object { $_ -like '*case plane*reads*not 255,0,255*' }).Count
        # mutant J: the double reads a formula without a value as 255 again; the plane case must fail over the double
        $anchorJ = '    if (!e || e.v === undefined) return 0;   // nothing here, or a formula with no value'
        if (([regex]::Matches($fk, [regex]::Escape($anchorJ))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorJ' is not in web/fake.js exactly once"; exit 1 }
        $mutJ = $fk.Replace($anchorJ, '    if (!e) return 0;')
        $jApplied = $mutJ -cne $fk
        $fkJ = Join-Path $tmp 'j.fake.js'; [System.IO.File]::WriteAllText($fkJ, $mutJ, $utf8)
        $rJ = Invoke-Loop $browser (New-MutantPage 'j' $template $hostJs $fkJ) '1'
        $jJ = if ($rJ.Text -ne '') { Test-Loop $rJ.Text '1' } else { @{ Problems = @($rJ.Reason) } }
        $jFailed = @($jJ.Problems | Where-Object { $_ -like "*case plane*fake frame*holds 255 in the host's plane and 0 by the record*" }).Count
        # mutant K, when the real page holds the engine's module: a scratch copy of cartridges/ whose
        # library writes the Palette's names to column D; the page's pass writes rows the command line
        # did not, and the pass case must fail by name
        $kApplied = $false; $kFailed = 0; $kNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $cartsK = Join-Path $tmp 'cartridges_k'
            Copy-Item -Recurse -LiteralPath (Join-Path $repoRoot 'cartridges') -Destination $cartsK
            $libK = Join-Path $cartsK 'common.vla'
            $lib = [System.IO.File]::ReadAllText($libK)
            $anchorK = '(cell "Palette" (symbol "\"C" (+expand index 1))'
            if (([regex]::Matches($lib, [regex]::Escape($anchorK))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorK' is not in cartridges/common.vla exactly once"; exit 1 }
            $mutK = $lib.Replace($anchorK, '(cell "Palette" (symbol "\"D" (+expand index 1))')
            $kApplied = $mutK -cne $lib
            [System.IO.File]::WriteAllText($libK, $mutK, $utf8)
            $rK = Invoke-Loop $browser (New-MutantPage 'k' $template $hostJs '' $cartsK) '1'
            $jK = if ($rK.Text -ne '') { Test-Loop $rK.Text '1' } else { @{ Problems = @($rK.Reason) } }
            $kFailed = @($jK.Problems | Where-Object { $_ -like "*case pass*the page's pass differs from*the command line's*" }).Count
            $kNote = "applied ($kApplied) and failed the pass case ($kFailed)"
        }
        $kOk = ($moduleReal -eq 0) -or ($kApplied -and $kFailed -ge 1)
        # mutant L (ENGINE.3): the pointer written as the window's cell, without the Camera; rate30's
        # pin over the double must fail by name, and, with the module, the input card's cursor too
        $anchorL = "    out.push('(cell `"Input`" `"B11`" ' + (on ? cam.col + pt.col - 1 : 0) + ')', '(cell `"Input`" `"B12`" ' + (on ? cam.row + pt.row - 1 : 0) + ')');"
        if (([regex]::Matches($js, [regex]::Escape($anchorL))).Count -ne 1) { Write-Output "FAIL: the pointer's two rows are not in web/host.js exactly once"; exit 1 }
        $mutL = $js.Replace($anchorL, "    out.push('(cell `"Input`" `"B11`" ' + (on ? pt.col : 0) + ')', '(cell `"Input`" `"B12`" ' + (on ? pt.row : 0) + ')');")
        $lApplied = $mutL -cne $js
        $jsL = Join-Path $tmp 'l.js'; [System.IO.File]::WriteAllText($jsL, $mutL, $utf8)
        $rL = Invoke-Loop $browser (New-MutantPage 'l' $template $jsL) '1'
        $jL = if ($rL.Text -ne '') { Test-Loop $rL.Text '1' } else { @{ Problems = @($rL.Reason) } }
        $lFailed = @($jL.Problems | Where-Object { $_ -like '*case rate30*the pointer at the window*' }).Count
        $lInput = @($jL.Problems | Where-Object { $_ -like '*case input*in the card by hand*' }).Count
        $lOk = $lApplied -and $lFailed -ge 1 -and (($moduleReal -eq 0) -or $lInput -ge 1)
        # mutants M and N (ENGINE.3), when the real page holds the engine's module: the Clock's rate
        # never read after a step, so the ticks keep the manifest's rate, and the host's seed never
        # written; the input case must fail each by name
        $mApplied = $false; $mFailed = 0; $nApplied = $false; $nFailed = 0; $oApplied = $false; $oFailed = 0
        $mnNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorM = '    if (d.clock) this._readClock();'
            if (([regex]::Matches($js, [regex]::Escape($anchorM))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorM' is not in web/host.js exactly once"; exit 1 }
            $mutM = $js.Replace($anchorM, '    // the rate read cut by the control')
            $mApplied = $mutM -cne $js
            $jsM = Join-Path $tmp 'm.js'; [System.IO.File]::WriteAllText($jsM, $mutM, $utf8)
            $rM = Invoke-Loop $browser (New-MutantPage 'm' $template $jsM) '1'
            $jM = if ($rM.Text -ne '') { Test-Loop $rM.Text '1' } else { @{ Problems = @($rM.Reason) } }
            $mFailed = @($jM.Problems | Where-Object { $_ -like '*case input*before its interval was owed*' }).Count
            $anchorN = "    if (c.seed === 'host') this._seed();"
            if (([regex]::Matches($js, [regex]::Escape($anchorN))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorN' is not in web/host.js exactly once"; exit 1 }
            $mutN = $js.Replace($anchorN, '    // the seed cut by the control')
            $nApplied = $mutN -cne $js
            $jsN = Join-Path $tmp 'n.js'; [System.IO.File]::WriteAllText($jsN, $mutN, $utf8)
            $rN = Invoke-Loop $browser (New-MutantPage 'n' $template $jsN) '1'
            $jN = if ($rN.Text -ne '') { Test-Loop $rN.Text '1' } else { @{ Problems = @($rN.Reason) } }
            $nFailed = @($jN.Problems | Where-Object { $_ -like '*case input*Clock!B3 holds*' }).Count
            # mutant O (ENGINE.3's hand test): the backlog held to the quarter second whatever the rate,
            # as it was, which starved the teacher's rate of 1; the input case must fail at the frame it never ran
            $anchorO = '    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), Math.max(ACCUMULATOR_CAP_MS, 1000 / c.rate));'
            if (([regex]::Matches($js, [regex]::Escape($anchorO))).Count -ne 1) { Write-Output "FAIL: the accumulator's line is not in web/host.js exactly once"; exit 1 }
            $mutO = $js.Replace($anchorO, '    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), ACCUMULATOR_CAP_MS);')
            $oApplied = $mutO -cne $js
            $jsO = Join-Path $tmp 'o.js'; [System.IO.File]::WriteAllText($jsO, $mutO, $utf8)
            $rO = Invoke-Loop $browser (New-MutantPage 'o' $template $jsO) '1'
            $jO = if ($rO.Text -ne '') { Test-Loop $rO.Text '1' } else { @{ Problems = @($rO.Reason) } }
            $oFailed = @($jO.Problems | Where-Object { $_ -like '*case input*ticks of 250 ms at the Clock*rate of 1 the host is at frame 18, not 19*' }).Count
            $mnNote = "the rate read cut applied ($mApplied) and failed the input case ($mFailed); the seed cut applied ($nApplied) and failed it ($nFailed); the backlog held to the quarter second applied ($oApplied) and failed it ($oFailed)"
        }
        $mnOk = ($moduleReal -eq 0) -or ($mApplied -and $mFailed -ge 1 -and $nApplied -and $nFailed -ge 1 -and $oApplied -and $oFailed -ge 1)
        # mutants P, Q and R (ENGINE.3's second slice), when the real page holds the engine's module: a
        # recorder that drops a person's edits, a player that skips the derived writes, and a recorder
        # that keeps its record of the Input sheet across a person's edit of it; the replay case must
        # fail each by name
        $pApplied = $false; $pFailed = 0; $qApplied = $false; $qFailed = 0; $rApplied = $false; $rFailed = 0
        $pqrNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorP = "      this._recordEdit(row);   // the replay logs a person's edit that landed, in its frame (section 7.6)"
            if (([regex]::Matches($js, [regex]::Escape($anchorP))).Count -ne 1) { Write-Output "FAIL: the record of a person's edit is not in web/host.js exactly once"; exit 1 }
            $mutP = $js.Replace($anchorP, "      // the edit's record cut by the control")
            $pApplied = $mutP -cne $js
            $jsP = Join-Path $tmp 'p.js'; [System.IO.File]::WriteAllText($jsP, $mutP, $utf8)
            $rP = Invoke-Loop $browser (New-MutantPage 'p' $template $jsP) '1'
            $jP = if ($rP.Text -ne '') { Test-Loop $rP.Text '1' } else { @{ Problems = @($rP.Reason) } }
            $pFailed = @($jP.Problems | Where-Object { $_ -like '*case replay*does not log the edit*' }).Count
            $anchorQ = '    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs'
            if (([regex]::Matches($js, [regex]::Escape($anchorQ))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorQ' is not in web/host.js exactly once"; exit 1 }
            $mutQ = $js.Replace($anchorQ, '    if (!this.player) this._issueDerived();   // the derived writes cut from a replay by the control')
            $qApplied = $mutQ -cne $js
            $jsQ = Join-Path $tmp 'q.js'; [System.IO.File]::WriteAllText($jsQ, $mutQ, $utf8)
            $rQ = Invoke-Loop $browser (New-MutantPage 'q' $template $jsQ) '1'
            $jQ = if ($rQ.Text -ne '') { Test-Loop $rQ.Text '1' } else { @{ Problems = @($rQ.Reason) } }
            $qFailed = @($jQ.Problems | Where-Object { $_ -like '*case replay*that is not its golden*' }).Count
            $anchorR = "    if (String(str(f[1])).toLowerCase() === 'input') rec.input = null;   // the Input sheet unknown to the replay: its next rows are logged whole"
            if (([regex]::Matches($js, [regex]::Escape($anchorR))).Count -ne 1) { Write-Output "FAIL: the Input sheet's record made unknown is not in web/host.js exactly once"; exit 1 }
            $mutR = $js.Replace($anchorR, "    // the Input sheet's record kept across a person's edit of it, by the control")
            $rApplied = $mutR -cne $js
            $jsR = Join-Path $tmp 'r.js'; [System.IO.File]::WriteAllText($jsR, $mutR, $utf8)
            $rR = Invoke-Loop $browser (New-MutantPage 'r' $template $jsR) '1'
            $jR = if ($rR.Text -ne '') { Test-Loop $rR.Text '1' } else { @{ Problems = @($rR.Reason) } }
            $rFailed = @($jR.Problems | Where-Object { $_ -like "*case replay*after a person's edit of the Input sheet*" }).Count
            $pqrNote = "the edit's record cut applied ($pApplied) and failed the replay case ($pFailed); the derived writes cut from a replay applied ($qApplied) and failed it ($qFailed); the Input sheet's record kept applied ($rApplied) and failed it ($rFailed)"
        }
        $pqrOk = ($moduleReal -eq 0) -or ($pApplied -and $pFailed -ge 1 -and $qApplied -and $qFailed -ge 1 -and $rApplied -and $rFailed -ge 1)
        # mutants S, T, U, V and W (ENGINE.4), over the double and so with or without the engine's module: a
        # voice's gain set at once; every frame a lookahead from the audio clock's now, the animation clock in
        # the rhythm; a voice's gain its volume; no silence at a stop; a wave changed at once while the voice
        # sounds. The audio case must fail each by name, at the call its own reason makes the first to differ.
        $sndMutants = @(
            @{ L = 's'; Name = 'the gain set at once'; Anchor = "    v.gain.gain.setTargetAtTime(value, at, GAIN_TAU);   // the graph's own approach, never a sample of the host's (decision 3)"; With = '    v.gain.gain.setValueAtTime(value, at);'
               Want = 'case audio.*on the graph is "gain \d+ gain set [\d.]+ at [^"]+", and the page''s arithmetic says "gain \d+ gain target ' },
            @{ L = 't'; Name = 'every frame a lookahead from now'; Anchor = "      at = s.end;   // the end of the last frame's sound (decision 1)"; With = '      at = now + LOOKAHEAD;'
               Want = 'case audio.*on the graph is "(oscillator \d+ frequency set [\d.]+) at [^"]+", and the page''s arithmetic says "\1 at ' },
            @{ L = 'u'; Name = 'a voice''s gain its volume'; Anchor = "  var VOICE_SHARE = 0.25;            // a voice's gain is its volume times this, so four voices at full volume never clip"; With = '  var VOICE_SHARE = 1;'
               Want = 'case audio.*on the graph is "gain 2 gain target 0\.5 at [^"]+", and the page''s arithmetic says "gain 2 gain target 0\.125 at ' },
            @{ L = 'v'; Name = 'no silence at a stop'; Anchor = '    this._silence();   // the voices stop with the loop (ENGINE.4, decision 6)'; With = '    // the silence cut by the control'
               Want = 'case audio.*over the double, the pause: the host''s call \d+ on the graph is missing, and the page''s arithmetic says "gain \d+ gain cancel ' },
            @{ L = 'w'; Name = 'a wave changed at once'; Anchor = '      var sw = v.target > 0 ? at + DIP_TAUS * GAIN_TAU : at;   // through a dip while the voice sounds'; With = '      var sw = at;'
               Want = 'case audio.*on the graph is "oscillator \d+ stop [^"]+", and the page''s arithmetic says "gain \d+ gain target 0 at ' }
        )
        $sndNotes = New-Object System.Collections.Generic.List[string]
        $sndJudged = New-Object System.Collections.Generic.List[object]
        $sndOk = $true
        foreach ($mu in $sndMutants) {
            if (([regex]::Matches($js, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/host.js exactly once"; exit 1 }
            $mutS = $js.Replace($mu.Anchor, $mu.With)
            $sApplied = $mutS -cne $js
            $jsS = Join-Path $tmp ($mu.L + '.js'); [System.IO.File]::WriteAllText($jsS, $mutS, $utf8)
            $rS = Invoke-Loop $browser (New-MutantPage $mu.L $template $jsS) '1'
            # not $jS: names fold case here, and $jS would be $js, the host's text the next mutant reads
            $sJudge = if ($rS.Text -ne '') { Test-Loop $rS.Text '1' } else { @{ Problems = @($rS.Reason) } }
            $sFailed = @($sJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $sndJudged.Add(@{ Name = $mu.Name; Problems = @($sJudge.Problems) })
            $sndNotes.Add(("{0} applied ({1}) and failed the audio case ({2})" -f $mu.Name, $sApplied, $sFailed))
            if (-not ($sApplied -and $sFailed -ge 1)) { $sndOk = $false }
        }
        $sndNote = $sndNotes -join '; '
        # mutant X (ENGINE.4's second slice), over the double: the time constant written in milliseconds
        # where the graph takes seconds, in the host and in the page's own arithmetic alike. The audio case
        # agrees with the host and passes it; the sound case renders the voices and must fail it by name,
        # its first settled frame's rms the voice that never arrives.
        $anchorXh = '  var GAIN_TAU = 0.003;'
        $anchorXt = 'var SND_LOOKAHEAD = 0.05, SND_TAU = 0.003,'
        if (([regex]::Matches($js, [regex]::Escape($anchorXh))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorXh' is not in web/host.js exactly once"; exit 1 }
        if (([regex]::Matches($tpl, [regex]::Escape($anchorXt))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorXt' is not in web/index.template.html exactly once"; exit 1 }
        $mutXh = $js.Replace($anchorXh, '  var GAIN_TAU = 3;')
        $mutXt = $tpl.Replace($anchorXt, 'var SND_LOOKAHEAD = 0.05, SND_TAU = 3,')
        $xApplied = ($mutXh -cne $js) -and ($mutXt -cne $tpl)
        $jsX = Join-Path $tmp 'x.js'; [System.IO.File]::WriteAllText($jsX, $mutXh, $utf8)
        $tplX = Join-Path $tmp 'x.template.html'; [System.IO.File]::WriteAllText($tplX, $mutXt, $utf8)
        $rX = Invoke-Loop $browser (New-MutantPage 'x' $tplX $jsX) '1'
        $jX = if ($rX.Text -ne '') { Test-Loop $rX.Text '1' } else { @{ Problems = @($rX.Reason) } }
        $xFailed = @($jX.Problems | Where-Object { $_ -cmatch 'case sound.*the sound, frame \d+ \(voice \d, a \w+ at note \d+\): its rms [\d.]+, and the volume over four times the \w+''s own [\d.]+, [\d.]+% apart, over 4%' }).Count
        $xAudio = @($jX.Problems | Where-Object { $_ -like '*case audio*' }).Count
        $xNote = "the time constant in milliseconds, in the host and the page alike, applied ($xApplied), passed the audio case ($($xAudio -eq 0)) and failed the sound case ($xFailed)"
        $xOk = $xApplied -and $xFailed -ge 1 -and $xAudio -eq 0
        # mutant Y (2026-10-10, ENGINE.1's panel), over the double: a host that never says a running loop
        # stopped, so that a page cannot draw its sheet at the frame it stopped at; the replay case, whose
        # replay played through the loop must say its stop once at its last frame, must fail it by name.
        $anchorY = "    if (was) this._emit('stop', { frame: this.frame });"
        if (([regex]::Matches($js, [regex]::Escape($anchorY))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorY' is not in web/host.js exactly once"; exit 1 }
        $mutY = $js.Replace($anchorY, '    // the stop said to no one, by the control')
        $yApplied = $mutY -cne $js
        $jsY = Join-Path $tmp 'y.js'; [System.IO.File]::WriteAllText($jsY, $mutY, $utf8)
        $rY = Invoke-Loop $browser (New-MutantPage 'y' $template $jsY) '1'
        $jY = if ($rY.Text -ne '') { Test-Loop $rY.Text '1' } else { @{ Problems = @($rY.Reason) } }
        $yFailed = @($jY.Problems | Where-Object { $_ -cmatch 'case replay.*said the loop stopped 0 time\(s\), where it says so once, at its last frame' }).Count
        $yNote = "the stop said to no one applied ($yApplied) and failed the replay case ($yFailed)"
        $yOk = $yApplied -and $yFailed -ge 1
        # mutant Z (CART.2's third slice), over the double: the host's slice half the display's interval
        # again, as it was; its header must say slice=0.5, and the slice case must fail it by name, ten
        # calls a tick where the oracle's own share owes fifteen.
        $anchorZ = '  var SLICE_FRACTION = 0.75;'
        if (([regex]::Matches($js, [regex]::Escape($anchorZ))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorZ' is not in web/host.js exactly once"; exit 1 }
        $mutZ = $js.Replace($anchorZ, '  var SLICE_FRACTION = 0.5;')
        $jsZ = Join-Path $tmp 'z.js'; [System.IO.File]::WriteAllText($jsZ, $mutZ, $utf8)
        $rZ = Invoke-Loop $browser (New-MutantPage 'z' $template $jsZ) '1'
        $zApplied = ($mutZ -cne $js) -and ($rZ.Text -ne '') -and ($rZ.Text.Split("`n")[0] -like '*slice=0.5;*')
        $jZ = if ($rZ.Text -ne '') { Test-Loop $rZ.Text '1' } else { @{ Problems = @($rZ.Reason) } }
        $zFailed = @($jZ.Problems | Where-Object { $_ -cmatch 'case slice.*a tick spends 0\.75 of a display interval of 20 ms, 15 step calls of 1 ms, and tick 2 made 10' }).Count
        $zNote = "the slice at a half applied ($zApplied) and failed the slice case ($zFailed)"
        $zOk = $zApplied -and $zFailed -ge 1
        # mutant AA (CART.2's playtest pass), over the double: a host whose tick snaps to no grid, its
        # tolerance 0, as it was; its header must say snap=0, and the pace case must fail it by name, the
        # second tick at a rate of 60 presenting no frame where the grid owes one.
        $anchorAA = '  var SNAP_MS = 0.25;'
        if (([regex]::Matches($js, [regex]::Escape($anchorAA))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorAA' is not in web/host.js exactly once"; exit 1 }
        $mutAA = $js.Replace($anchorAA, '  var SNAP_MS = 0;')
        $jsAA = Join-Path $tmp 'aa.js'; [System.IO.File]::WriteAllText($jsAA, $mutAA, $utf8)
        $rAA = Invoke-Loop $browser (New-MutantPage 'aa' $template $jsAA) '1'
        $aaApplied = ($mutAA -cne $js) -and ($rAA.Text -ne '') -and ($rAA.Text.Split("`n")[0] -like '* snap=0 slice=*')
        $jAA = if ($rAA.Text -ne '') { Test-Loop $rAA.Text '1' } else { @{ Problems = @($rAA.Reason) } }
        $aaFailed = @($jAA.Problems | Where-Object { $_ -cmatch 'case pace.*at a rate of 60, on ticks 16\.6 or 16\.7 ms apart, a tick presents one frame, and tick 2 presented 0' }).Count
        $aaNote = "the tick on no grid applied ($aaApplied) and failed the pace case ($aaFailed)"
        $aaOk = $aaApplied -and $aaFailed -ge 1
        # mutant AB (CART.2's second slice), when the real page holds the engine's module: the page's sand
        # paints a brush without its rim, < where the cartridge's Gate says <=; Sand's committed replay
        # paints with the rim, and the replay case must fail it by name at the first frame the rim lands.
        $abApplied = $false; $abFailed = 0; $abNote = 'the brush without its rim: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorAB = '      return dr * dr + dc * dc <= brush.radius * brush.radius ? brush.material : -1;'
            if (([regex]::Matches($tpl, [regex]::Escape($anchorAB))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorAB' is not in the template exactly once"; exit 1 }
            $mutAB = $tpl.Replace($anchorAB, '      return dr * dr + dc * dc < brush.radius * brush.radius ? brush.material : -1;')
            $abApplied = $mutAB -cne $tpl
            $tplAB = Join-Path $tmp 'ab.template.html'; [System.IO.File]::WriteAllText($tplAB, $mutAB, $utf8)
            $rAB = Invoke-Loop $browser (New-MutantPage 'ab' $tplAB $hostJs) '1'
            $jAB = if ($rAB.Text -ne '') { Test-Loop $rAB.Text '1' } else { @{ Problems = @($rAB.Reason) } }
            $abFailed = @($jAB.Problems | Where-Object { $_ -like "*case replay*Sand's committed replay, played on a fresh host, is not the page's sand at frame*" }).Count
            $abNote = "the brush without its rim applied ($abApplied) and failed the replay case ($abFailed)"
        }
        $abOk = ($moduleReal -eq 0) -or ($abApplied -and $abFailed -ge 1)
        # mutant AI (CART.4's second slice), when the real page holds the engine's module: the page's Kairos
        # turns a row a column early, its right end at the board's sixth column where the cartridge turns it
        # at the seventh; Kairos's committed replay slides rows to both ends of the board, and the replay case
        # must fail it by name at the first frame a row reaches the seventh column.
        $aiApplied = $false; $aiFailed = 0; $aiNote = 'the turn a column early: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorAI = '    var turn = (this.direction === 1 && right >= KAIROS.columns) || (this.direction === -1 && this.left <= 1);'
            if (([regex]::Matches($tpl, [regex]::Escape($anchorAI))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorAI' is not in the template exactly once"; exit 1 }
            $mutAI = $tpl.Replace($anchorAI, '    var turn = (this.direction === 1 && right >= KAIROS.columns - 1) || (this.direction === -1 && this.left <= 1);')
            $aiApplied = $mutAI -cne $tpl
            $tplAI = Join-Path $tmp 'ai.template.html'; [System.IO.File]::WriteAllText($tplAI, $mutAI, $utf8)
            $rAI = Invoke-Loop $browser (New-MutantPage 'ai' $tplAI $hostJs) '1'
            $jAI = if ($rAI.Text -ne '') { Test-Loop $rAI.Text '1' } else { @{ Problems = @($rAI.Reason) } }
            $aiFailed = @($jAI.Problems | Where-Object { $_ -like "*case replay*Kairos's committed replay, played on a fresh host, is not the page's Kairos at frame*" }).Count
            $aiNote = "the turn a column early applied ($aiApplied) and failed the replay case ($aiFailed)"
        }
        $aiOk = ($moduleReal -eq 0) -or ($aiApplied -and $aiFailed -ge 1)
        # mutants AC, AD, AE, AF and AH (ENGINE.8), over the double and so with or without the engine's module,
        # and AG when the real page holds it: a viewport that reads no value row, one that matches no look, a host
        # that draws each frame without keeping the view, a host that draws the grid before it reads the Camera,
        # a host silent over an edit made while the loop is paused at its rate (the owner's hand test), and a
        # viewport that lays every row at the default height. The grid case must fail each by name.
        $gridMutants = @(
            @{ L = 'ac'; Name = 'the value row unread'; File = 'viewport'; Anchor = "      } else if (head === 'value') {"; With = "      } else if (head === 'value-unread') {"
               Want = 'case grid.*fake frame 1: \w+\d+ shows "=FAKE\.PLANE\(\)", and the record says "\d+"' },
            @{ L = 'ad'; Name = 'no look matched'; File = 'viewport'; Anchor = '    if (cell && cell.lookKey !== null && Object.prototype.hasOwnProperty.call(model.looks, cell.lookKey)) {'; With = '    if (false) {'
               Want = 'case grid.*fake frame 1: \w+\d+''s fill, #[0-9A-Fa-f]{6} by its look, is not drawn' },
            @{ L = 'ae'; Name = 'the view not kept'; File = 'host'; Anchor = '      vp.load(r.text, { keep: !atLoad });'; With = '      vp.load(r.text);'
               Want = 'case grid.*fake frame 3: (the viewport shows A1 at its top left, and the Camera at L1|the selection is A1, where the person selected C5)' },
            @{ L = 'af'; Name = 'the grid drawn before the Camera is read'; File = 'host'
               Anchor = "    if (d.camera) this._readCamera();`n    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();`n    if (this.cart.mode === 'grid') this._drawGrid(false);   // the record through the frame's own Camera (ENGINE.8)"
               With = "    if (this.cart.mode === 'grid') this._drawGrid(false);   // the record through the frame's own Camera (ENGINE.8)`n    if (d.camera) this._readCamera();`n    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();"
               Want = 'case grid.*fake frame 3: the viewport shows A1 at its top left, and the Camera at L1 puts L1 there' },
            @{ L = 'ag'; Name = 'every row at the default height'; File = 'viewport'; Module = $true; Anchor = '    if (model && model.rowSettings) {'; With = '    if (false) {'
               Want = 'case grid.*engine frame 0: (A9|B9|A10|B10|C10|A11|B11|A12|B12)\b' },
            @{ L = 'ah'; Name = 'a paused edit unsaid'; File = 'host'; Anchor = '    else if (this.cart.rate > 0 && !this.running) this._say('; With = '    else if (false) this._say('
               Want = 'case grid.*fake: the edit \(cell "Screen" "W7" 1\), made while the loop was paused at its rate, was not said to wait' }
        )
        $gridNotes = New-Object System.Collections.Generic.List[string]
        $gridJudged = New-Object System.Collections.Generic.List[object]
        $gridOk = $true
        foreach ($mu in $gridMutants) {
            if ($mu.Module -and $moduleReal -eq 0) { $gridNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            $orig = if ($mu.File -eq 'viewport') { $vpText } else { $js }
            if (([regex]::Matches($orig, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/$($mu.File).js exactly once"; exit 1 }
            $mutG2 = $orig.Replace($mu.Anchor, $mu.With)
            $g2Applied = $mutG2 -cne $orig
            $fileG2 = Join-Path $tmp ($mu.L + '.' + $mu.File + '.js'); [System.IO.File]::WriteAllText($fileG2, $mutG2, $utf8)
            $pageG2 = if ($mu.File -eq 'viewport') { New-MutantPage $mu.L $template $hostJs '' '' $fileG2 } else { New-MutantPage $mu.L $template $fileG2 }
            $rG2 = Invoke-Loop $browser $pageG2 '1'
            # not $jG2 alone: names fold case here, so every judgment of this loop keeps a name of its own
            $g2Judge = if ($rG2.Text -ne '') { Test-Loop $rG2.Text '1' } else { @{ Problems = @($rG2.Reason) } }
            $g2Failed = @($g2Judge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $gridJudged.Add(@{ Name = $mu.Name; Problems = @($g2Judge.Problems) })
            $gridNotes.Add(("{0} applied ({1}) and failed the grid case ({2})" -f $mu.Name, $g2Applied, $g2Failed))
            if (-not ($g2Applied -and $g2Failed -ge 1)) { $gridOk = $false }
        }
        $gridNote = $gridNotes -join '; '
        # mutants AJ, AK, AL, AM and AN (ENGINE.14), over the double and so with or without the engine's module: a
        # host that answers no tab; one that views the sheet shown at the click alone, never at a frame; one whose
        # Screen tab keeps the person's scroll, the Camera's window not given back; one that takes the wheel over
        # the viewport's whole root, as ENGINE.8 built it; and a viewport whose hit test counts the tab strip as
        # cells. The tabs case must fail each by name.
        $tabsMutants = @(
            @{ L = 'aj'; Name = 'no tab answered'; File = 'host'; Anchor = "    this.vp.on('sheet', function (e) { self.answer(self.vp, e); });"; With = '    // the tabs answered by no one, by the control'
               Want = 'case tabs.*fake frame 3: the tab State, clicked, did not show its sheet: the viewport shows Screen' },
            @{ L = 'ak'; Name = 'the sheet shown viewed at the click alone'; File = 'host'; Anchor = '    if (!atLoad && this.vp && !isScreen(this.vp.sheet())) { if (this.refreshSheet(this.vp)) this.c.draws++; return; }'; With = '    if (!atLoad && this.vp && !isScreen(this.vp.sheet())) return;'
               Want = 'case tabs.*fake frame \d+: B[12] shows "[^"]*", and the record says "[^"]*"' },
            @{ L = 'al'; Name = 'the window not given back'; File = 'host'; Anchor = '    this._quiet(function () { self._drawGrid(true); });'; With = '    this._quiet(function () { self._drawGrid(false); });'
               Want = 'case tabs.*fake frame 8: the Screen''s tab shows A1 at the viewport''s top left, and the Camera at E1 puts its corner there' },
            @{ L = 'am'; Name = 'the wheel taken everywhere'; File = 'host'
               Anchor = "    this._on(root, 'wheel', function (ev) { if (!playing() || !self._windowCellAt(ev)) return; self.wheel(ev.deltaY > 0 ? 1 : (ev.deltaY < 0 ? -1 : 0)); ev.preventDefault(); }, { passive: false, capture: true });"
               With = "    this._on(root, 'wheel', function (ev) { if (!playing()) return; self.wheel(ev.deltaY > 0 ? 1 : (ev.deltaY < 0 ? -1 : 0)); ev.preventDefault(); }, { passive: false, capture: true });"
               Want = 'case tabs.*fake frame 4: the wheel over a cell of State was taken by the game' },
            @{ L = 'an'; Name = 'the tab strip counted as cells'; File = 'viewport'; Anchor = '    if (!this._inside({ clientX: clientX, clientY: clientY })) return null;'; With = '    // the hit test unbounded, by the control'
               Want = 'case tabs.*fake frame 11: the pointer over the tab strip was written as column \d+ and row \d+, not 0' }
        )
        $tabsNotes = New-Object System.Collections.Generic.List[string]
        $tabsJudged = New-Object System.Collections.Generic.List[object]
        $tabsOk = $true
        foreach ($mu in $tabsMutants) {
            $orig = if ($mu.File -eq 'viewport') { $vpText } else { $js }
            if (([regex]::Matches($orig, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/$($mu.File).js exactly once"; exit 1 }
            $mutT = $orig.Replace($mu.Anchor, $mu.With)
            $tApplied = $mutT -cne $orig
            $fileT = Join-Path $tmp ($mu.L + '.' + $mu.File + '.js'); [System.IO.File]::WriteAllText($fileT, $mutT, $utf8)
            $pageT = if ($mu.File -eq 'viewport') { New-MutantPage $mu.L $template $hostJs '' '' $fileT } else { New-MutantPage $mu.L $template $fileT }
            $rT = Invoke-Loop $browser $pageT '1'
            $tJudge = if ($rT.Text -ne '') { Test-Loop $rT.Text '1' } else { @{ Problems = @($rT.Reason) } }
            $tFailed = @($tJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $tabsJudged.Add(@{ Name = $mu.Name; Problems = @($tJudge.Problems) })
            $tabsNotes.Add(("{0} applied ({1}) and failed the tabs case ({2})" -f $mu.Name, $tApplied, $tFailed))
            if (-not ($tApplied -and $tFailed -ge 1)) { $tabsOk = $false }
        }
        $tabsNote = $tabsNotes -join '; '
        # mutants AO and AP (ENGINE.15), over the double and so with or without the engine's module: a template
        # whose empty sheet steps at rate 30, and one whose picker offers the page's cartridges in reverse. The
        # empty case must fail each by name.
        $emptyMutants = @(
            @{ L = 'ao'; Name = 'the empty sheet at rate 30'; Anchor = '(title "An empty sheet")\n  (rate 0)'; With = '(title "An empty sheet")\n  (rate 30)'
               Want = 'case empty.*the empty sheet on the double steps at a rate of 30, where it waits at 0 for an edit' },
            @{ L = 'ap'; Name = 'the picker in reverse'; Anchor = '    for (var i = 0; i < ORDER.length; i++) out.push({ value: ORDER[i], label: CARTRIDGES[ORDER[i]].title });'
               With = '    for (var i = ORDER.length - 1; i >= 0; i--) out.push({ value: ORDER[i], label: CARTRIDGES[ORDER[i]].title });'
               Want = 'case empty.*the picker''s entry 2 is kairos, and the page''s cartridge block 1 is life' }
        )
        $emptyNotes = New-Object System.Collections.Generic.List[string]
        $emptyJudged = New-Object System.Collections.Generic.List[object]
        $emptyOk = $true
        foreach ($mu in $emptyMutants) {
            if (([regex]::Matches($tpl, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in the template exactly once"; exit 1 }
            $mutE2 = $tpl.Replace($mu.Anchor, $mu.With)
            $e2Applied = $mutE2 -cne $tpl
            $tplE2 = Join-Path $tmp ($mu.L + '.template.html'); [System.IO.File]::WriteAllText($tplE2, $mutE2, $utf8)
            $rE2 = Invoke-Loop $browser (New-MutantPage $mu.L $tplE2 $hostJs) '1'
            $e2Judge = if ($rE2.Text -ne '') { Test-Loop $rE2.Text '1' } else { @{ Problems = @($rE2.Reason) } }
            $e2Failed = @($e2Judge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $emptyJudged.Add(@{ Name = $mu.Name; Problems = @($e2Judge.Problems) })
            $emptyNotes.Add(("{0} applied ({1}) and failed the empty case ({2})" -f $mu.Name, $e2Applied, $e2Failed))
            if (-not ($e2Applied -and $e2Failed -ge 1)) { $emptyOk = $false }
        }
        $emptyNote = $emptyNotes -join '; '
        Write-Output ("control: the real page has {0} problem(s); the raised cap applied ({1}) and failed the stall ({2}); the swapped writes applied ({3}) and lost the edit ({4}); the cut element left no block ({5}); the survival rule changed: {6}; the frame-0 draw cut applied ({7}) and failed the reload ({8}); the clear cut applied ({9}) and failed the refused load ({10}); the refusal's mark cut applied ({11}) and failed rate30 ({12}); the Camera read late applied ({13}) and failed the plane ({14}); the masked blit applied ({15}) and failed the pixels ({16}); the double's old 255 applied ({17}) and failed the plane ({18}); the library changed: {19}; the pointer without the Camera applied ({20}) and failed rate30 ({21}) and the input case ({22}); {23}; {24}; {25}; {26}; {27}; {28}; {29}; {30}; {31}; {32}; {33}; {34}" -f @($j0.Problems).Count, $aApplied, $aStall, $bApplied, $bLost, $cNoBlock, $dNote, $eApplied, $eFailed, $fApplied, $fFailed, $gApplied, $gFailed, $hApplied, $hFailed, $iApplied, $iFailed, $jApplied, $jFailed, $kNote, $lApplied, $lFailed, $lInput, $mnNote, $pqrNote, $sndNote, $xNote, $yNote, $zNote, $aaNote, $abNote, $gridNote, $aiNote, $tabsNote, $emptyNote)
        if (@($j0.Problems).Count -eq 0 -and $aApplied -and $aStall -ge 1 -and $bApplied -and $bLost -ge 1 -and $cNoBlock -and $dOk -and $eApplied -and $eFailed -ge 1 -and $fApplied -and $fFailed -ge 1 -and $gApplied -and $gFailed -ge 1 -and $hApplied -and $hFailed -ge 1 -and $iApplied -and $iFailed -ge 1 -and $jApplied -and $jFailed -ge 1 -and $kOk -and $lOk -and $mnOk -and $pqrOk -and $sndOk -and $xOk -and $yOk -and $zOk -and $aaOk -and $abOk -and $gridOk -and $aiOk -and $tabsOk -and $emptyOk) {
            Write-Output ('OK: the check passes the real page and fails each of the ' + $(if ($moduleReal -gt 0) { 'forty-two' } else { 'thirty-one applicable' }) + ' mutants for its own reason, each proving it applied')
            exit 0
        }
        Write-Output 'FAIL: the control did not behave as the header says'
        foreach ($p in @($j0.Problems)) { Write-Output ('  real: ' + $p) }
        foreach ($p in @($jA.Problems) | Select-Object -First 3) { Write-Output ('  raised cap: ' + $p) }
        foreach ($p in @($jB.Problems) | Select-Object -First 3) { Write-Output ('  swapped writes: ' + $p) }
        Write-Output ('  cut element: ' + $rC.Reason)
        if ($moduleReal -gt 0) { foreach ($p in @($jD.Problems) | Select-Object -First 3) { Write-Output ('  survival rule: ' + $p) } }
        foreach ($p in @($jE.Problems) | Select-Object -First 3) { Write-Output ('  frame-0 draw cut: ' + $p) }
        foreach ($p in @($jF.Problems) | Select-Object -First 3) { Write-Output ('  clear cut: ' + $p) }
        foreach ($p in @($jG.Problems) | Select-Object -First 3) { Write-Output ('  mark cut: ' + $p) }
        foreach ($p in @($jH.Problems) | Select-Object -First 3) { Write-Output ('  Camera read late: ' + $p) }
        foreach ($p in @($jI.Problems) | Select-Object -First 3) { Write-Output ('  masked blit: ' + $p) }
        foreach ($p in @($jJ.Problems) | Select-Object -First 3) { Write-Output ('  double''s old 255: ' + $p) }
        if ($moduleReal -gt 0) { foreach ($p in @($jK.Problems) | Select-Object -First 3) { Write-Output ('  library changed: ' + $p) } }
        foreach ($p in @($jL.Problems) | Select-Object -First 3) { Write-Output ('  pointer without the Camera: ' + $p) }
        if ($moduleReal -gt 0) {
            foreach ($p in @($jM.Problems) | Select-Object -First 3) { Write-Output ('  rate read cut: ' + $p) }
            foreach ($p in @($jN.Problems) | Select-Object -First 3) { Write-Output ('  seed cut: ' + $p) }
            foreach ($p in @($jO.Problems) | Select-Object -First 3) { Write-Output ('  backlog at the quarter second: ' + $p) }
            foreach ($p in @($jP.Problems) | Select-Object -First 3) { Write-Output ('  edit''s record cut: ' + $p) }
            foreach ($p in @($jQ.Problems) | Select-Object -First 3) { Write-Output ('  derived writes cut from a replay: ' + $p) }
            foreach ($p in @($jR.Problems) | Select-Object -First 3) { Write-Output ('  Input sheet''s record kept: ' + $p) }
        }
        foreach ($sj in $sndJudged) { foreach ($p in @($sj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $sj.Name + ': ' + $p) } }
        foreach ($p in @($jX.Problems) | Select-Object -First 3) { Write-Output ('  the time constant in milliseconds: ' + $p) }
        foreach ($p in @($jY.Problems) | Select-Object -First 3) { Write-Output ('  the stop said to no one: ' + $p) }
        foreach ($p in @($jZ.Problems) | Select-Object -First 3) { Write-Output ('  the slice at a half: ' + $p) }
        foreach ($p in @($jAA.Problems) | Select-Object -First 3) { Write-Output ('  the tick on no grid: ' + $p) }
        if ($moduleReal -gt 0) { foreach ($p in @($jAB.Problems) | Select-Object -First 3) { Write-Output ('  the brush without its rim: ' + $p) } }
        foreach ($gj in $gridJudged) { foreach ($p in @($gj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $gj.Name + ': ' + $p) } }
        if ($moduleReal -gt 0) { foreach ($p in @($jAI.Problems) | Select-Object -First 3) { Write-Output ('  the turn a column early: ' + $p) } }
        foreach ($tj in $tabsJudged) { foreach ($p in @($tj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $tj.Name + ': ' + $p) } }
        foreach ($ej in $emptyJudged) { foreach ($p in @($ej.Problems) | Select-Object -First 3) { Write-Output ('  ' + $ej.Name + ': ' + $p) } }
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

Write-Output "=== THE HOST'S LOOP: SECTION 5 OVER A FIXED LOG AGAINST THE FAKE MODULE, AND OVER THE ENGINE'S MODULE WHEN THE PAGE HOLDS ONE, UNDER A HEADLESS BROWSER AT TWO RATIOS (ENGINE.1) ==="
if (-not (Test-Path -LiteralPath $Page)) { Write-Output ("  SKIPPED: no built page at {0} (tools/build_web.ps1 writes it; CI builds it before the runner)" -f $Page); exit 0 }
if ($browser -eq '') { Write-Output '  SKIPPED: no browser found (Google Chrome, Microsoft Edge or Chromium at their known paths or on the PATH; set ALONZO_BROWSER, or -Browser, to name one)'; exit 0 }
if ($floors.Count -ne $expectedCases) { Write-Output ("FAIL: the floors table holds {0} case(s), not the {1} pinned here" -f $floors.Count, $expectedCases); exit 1 }
Write-Output ("  the browser: {0}" -f $browser)
Write-Output ("  the page: {0}" -f $Page)
$failed = New-Object System.Collections.Generic.List[string]
foreach ($scale in $scales) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $r = Invoke-Loop $browser $Page $scale
    $sw.Stop()
    if ($r.Text -eq '') { $failed.Add("at a ratio of $scale`: $($r.Reason)"); Write-Output ("  ratio {0}: {1}  FAIL" -f $scale, $r.Reason); continue }
    $j = Test-Loop $r.Text $scale
    Write-Output ("  ratio {0} ({1:N1} s): {2}" -f $scale, $sw.Elapsed.TotalSeconds, $j.Header)
    foreach ($l in $j.Lines) { Write-Output ('  ' + $l) }
    foreach ($p in $j.Problems) { $failed.Add($p); Write-Output ("    {0}  FAIL" -f $p) }
}
Write-Output ''
if ($failed.Count -eq 0) {
    Write-Output "=== CHECK: clean - every case OK at both ratios, every count at or above its floor ==="
    exit 0
}
Write-Output "=== CHECK: $($failed.Count) problem(s) ==="
$failed | ForEach-Object { Write-Output "  $_" }
exit 1
