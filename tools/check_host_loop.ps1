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
a person's scroll kept through the Camera's move; since CART.12 its row 16,
numbers under codes of Excel's, each cell drawn as its text row says and
pinned by name at frames 1, 4 and 5, codes, the texts from text rows counted,
coded, and a value under a code read whole among the lone record's); and since ENGINE.14 tabs
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
cell); and since ENGINE.17 still (a frame whose Screen record is the one the
viewport last drew is neither read nor painted: over the engine's module,
when the page holds one, the still card, written in the page, whose Day
sheet alone reads the Clock and whose Screen's 401 formulas read only the
day, 30 frames long, frames 1 to 90, each frame's drawn window held to its
record as grid holds it, a still frame's kept draw list included, and each
frame's draw or still frame held to the oracle's own choice: the day's two
boundaries drawn, a person's selection and scroll kept by the viewport
through the still frames, an edit into the Screen drawn in its frame and
the same edit again still, the Camera's move drawn, a record a page loads
into the host's viewport drawn over at the next frame, and redraw() a draw;
then, at the owner's word, the card's Board, which reads only the day, shown
in the Screen's place by its tab and in a viewer of the page's own, each
refreshed at every frame and loaded exactly when its record changed, the
Day, whose phase moves every frame, loaded at every frame, and the Screen's
tab giving the window back); and since ENGINE.18 views (a grid cartridge's
views on its own sheets, version 4's: over the engine's module, the views
card, written in the page at (spec 4), its Screen listed first and hidden,
opened on its first visible sheet, the Desk, the hidden Screen viewed by
nothing until its Camera shows it; frames 1 to 90, every sheet shown drawn
from the values record and held cell for cell, Input!B19 the sheet shown at
every frame; a press over Desk!C5 written as the sheet's own cell and counted
once, a press over the column header, the tab strip and the Ledger's C5
counted nowhere; the person's tabs, the Camera's third row showing the Ledger
at frame 40 and the Screen at 70, the person's tab kept between its changes;
the run's replay, version 4's, played to every frame's Input rows; a Camera
whose value row opens the card on the Ledger; and the still card, version
3's, opened on its Screen, its pointer 0 over another sheet, its Input sheet
of eighteen rows and its replay version 3's); and since ENGINE.19 changes (a
frame read by its changes: the host's pure patch over records the page
writes and a viewport's model patched with it, cell for cell; the double's
answers held to the page's own diff of its values records; and over the
engine's module, when the page holds one, the changes card, written in the
page, 60 frames, each frame's choice of a whole view, a patch or a still
frame the oracle's own from its own changes, the record, the model and the
drawn window held, no values view on a patched frame and a device's grid
view only where its changes say whole, the device state a whole read's, the
Input rows written exactly those that changed, a viewer of the Day patched
at every frame and one of the Screen refreshed every third frame viewing
whole, and the run's replay played on a fresh host without a viewport; and
since ENGINE.20 every patched frame repainted by its cells and no other, the
host's viewport's canvas held at every frame pixel for pixel, and its draw
list op for op, to a twin's full paint of the record in the view's own
state, its selection and mark, its panes frozen from 25 to 35, and the window
scrolled out of view from 44 to 48, where each patch repaints nothing; the
crafted patches held the same way, and a patch of more than a quarter of the
cells in view painted whole); and since ENGINE.7 continue (edit and continue:
over the engine's module, the continue card, a source written in the page and
built by the page's pass, run 20 frames; a rebuilt source applied before
frame 11, in the place of one pressed before it, and a second before frame
16 while the loop is paused, said to wait for Run; every frame's number and
every cell held to its rule, the state the run made kept across both, a
person's edit and the Write sheet's counts among it; every frame's records
equal to a twin host's that writes the rows named by hand as a person's
edits; the frame after the first continue viewed whole and the next patched;
five rebuilt sources refused at the press in words, a sheet added, the rate
changed, a row removed, a column's width and a cell written twice, and one at
the write, a formula closing a cycle with a person's, nothing written; the
run's replay the twin's byte for byte and played on a third host to every
frame; a continue refused while a replay plays; and the host's comparison,
pure, held to the rows named by hand); and since ENGINE.23 palette (the
command palette: its registry of twenty-five commands, its keys as browsers
report them and its lines for a text, pure; the palette itself in a box of
the stage, opened by Ctrl+K, Cmd+K and Ctrl+Shift+`, a line run by Enter,
by ArrowDown and by a click, a row of VLA written, what was run brought back
by Ctrl+Up, Escape and its own key shutting it, the focus given back, a held
key's repeat ignored and every other key passed on; and Escape in full
screen, a hint and then a leave, over a clock of its own); and since ENGINE.23's
second slice keys (the keymap: the page's own read clean, eighteen crafted texts
refused whole by line and words, twenty-four keys held to the command each
presses in its place, a box's typing and editing keys its own and an input method's
composing Enter none, a person's own
command run step by step and listed in the palette with its keys, the keymap kept,
read again and forgotten through a double of the browser's storage, a later
page's line set aside, Record a key's spellings read back, and the list's words of a
key a browser or the system keeps and of a game's button a binding shadows; and since
ENGINE.24 a binding on a sheet held before one on none where its sheet shows and the
other's elsewhere, the last key a game reads seen in its formulas' references alone,
and the drawer's note of the game's own keys, player by player); and since ENGINE.25
commands (a cartridge's own commands, over a card of the page's own written to
version 5 and the engine's module: its Commands sheet listed, commands run one a
frame into Input!B20 and emptied after, two a frame apart and one at two frames
running, a command's key on the Desk counted once with its repeat and nothing with
Ctrl, a command that holds not on the Ledger refused and its key passed on, sixteen
waiting and a seventeenth refused, the rows the host cannot take said once, the run's
replay played on a fresh host to every frame, a command refused while a replay plays,
a step a command at rate 0, and the card kept at version 4; and since its second
slice a page half, pure and on every page, module or not: a game's command named
<cartridge>.<command>, its palette lines while it holds, the keymap reading it, a
binding of it pressed while it is live and its key passed on while not, a person's
command running it, and the list's and the drawer's words of its keys); and since
CART.12 settle (an act settled, version 6: over the double, whose grid never
settles, the load's, an edit's and a press's acts each taking its K settle steps
and ending unsettled, said, the Clock counting acts and a press over a cell an act,
its place written and its press released; over a card of the page's own written to
version 6 at rate 0 and the engine's module, when the page holds one: the load
settled on computed values, a press on E2 spilling to the row's ends a cell a frame,
the Clock standing and the press released before the first settle step, the same
press written again after the release, an edit made during a settle waiting for it
on a host of one step call a tick, the command spill run by its key on the viewport
at rate 0 and its command released, the run's replay written at the acts' frames
alone and played on a fresh host to every frame, the card under (settle 3) unsettled
and said, the directive refused at version 5 and at a rate, and a version 5 card's
command key taken at rate 0); and since ENGINE.26 widths (a column's width a person
drags, kept a sheet: over a card of the page's own written to version 4 at rate 0
and the engine's module, a Desk and a Ledger each with its own column D and a
visible Screen, every drag made as a person makes it on a divider in the header;
a press that moves nothing raising nothing; each drag's width its sheet's alone
and its event naming that sheet; every sheet drawn cell for cell at the widths
the oracle's own drags left on it and no other sheet's, at the frame an edit
steps, at a person's tabs and at a sheet shown as a Camera shows one; a drag
that brings columns into view at rate 0 viewed at once; the region of a sheet
not shown estimated at its own widths; the Screen's width kept when its tab
loads its record without keep; every width kept by the source applied; a drag
pressed on one sheet while another comes to show the first one's; and every
width forgotten at a Load). It
prints one line a case into
<pre id="loop"> and a last line, 'loop ok cases=N', once the last case has
answered. This check runs the
page under a headless Chromium at a device scale factor of 1 and of 1.5,
reads that element off the dump, and holds every case to OK and its counts
to the floors below; the floors over the engine's module apply when the page
holds one, as abi's module count says, and a page built beside the engine's
artifact must hold that artifact, byte count for byte count, or it is stale.

SINCE ENGINE.16, the bench over a game's own cartridges: replay holds Sand's
and Kairos's committed replays to their hands, each a block of the page's
(hand-sand, hand-kairos) registered by its cartridge's name and held to the
blocks (hands 2), Kairos's Tally held cell by cell at every frame beside its
board (kairosCells), and no replay held to its golden alone (alone, held at
zero), and since CART.12 Superposition's, its hand (hand-superposition, hands
3) answering every frame with the Tally's sum of each row of its lattice, a
frame with no row a settle step after the engine's release; and grid runs its game's half over every grid cartridge the page
holds, the grid card here, a short run with no edits (grids, gridFrames,
gridEqual, gridValues, gridTexts, gridCleared). On every run this check also
builds a game's page, from a scratch folder holding Kairos alone, its
cartridge, source, replay, golden and hand and the library its source
includes, and runs its loop at a ratio of 1: abi, pass, replay with the
hand, grid over an empty set, empty and, since ENGINE.17, ENGINE.18,
ENGINE.19, ENGINE.7, ENGINE.23, ENGINE.25, CART.12, ENGINE.26, SPEC.5, ENGINE.5, ENGINE.39 and CART.16, still, views,
changes, continue, palette, drawer, keys, commands, settle, widths, modes, save, keep, clipboard and file must be OK
at their own floors, each of Alonzo's fifteen other cases must say it is not on this page, and
the last line must count twenty cases.

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

-Control builds three hundred and fifteen mutant pages through tools/build_web.ps1 and runs
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
by name: a viewport that reads no value row, so a formula's value is not
drawn from the values record; one that matches no look, so a look's fill is
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
rate 30, and one whose picker offers the page's cartridges in reverse; and
since ENGINE.8's second slice three more, over the double, each failing the
grid case by name: a host that draws the grid record at every frame, where
the values record is due once a frame has computed values; one that draws
the values record at frame 0 too, where the grid record is due; and a
viewport that reads no style row for a cell no row wrote, a formula with no
value yet in a values record; and since ENGINE.16, AB and AI now mutate
scratch copies of the hands' own files, and four more mutate a game's page of
Kairos alone, which must pass first, each failing by name: its hand a frame
late, at frame 1; its hand's Tally counting a stack at the level above, at the
first stack's frame; its hand's block dropped, the replay then counted alone;
and a template whose bench refuses a game's page wholesale in the loop too,
as it did before; and since ENGINE.17 five more, when the real page holds
the module, each failing the still case by name: a host that skips whatever
the record, its text unread, at frame 1, the record's first change; one that
never skips, its still frames under their floor; a redraw() that skips; a
host that compares the text alone, never asking whether its viewport still
holds the model it made, which keeps the record a page loaded before frame
81; and one that never finds a sheet shown in the Screen's place still,
loading Board again at frame 5; and since ENGINE.18 nine more, when the real
page holds the module, each failing by name: a host that opens a version 4
cartridge on its Screen; one that opens on its first sheet, hidden or not;
one that draws a sheet shown from the grid record after frame 0; one whose
pointer is 0 off the Screen; one that writes no Input!B19; one that writes
the pointer over another sheet for a version 3 cartridge too; one that never
shows the sheet the Camera names; one that shows it at every frame, over the
person's tab; and one whose replay names the host's version for a version 3
cartridge, which the replay case must fail on the committed replays; and
since ENGINE.19 ten more, each failing the changes case by name, nine when
the real page holds the module: a host that patches whatever the since,
which the Screen's viewer refreshed every third frame finds; one that takes
a whole answer as still, which frame 50's formula finds; one that compares
no window, which the viewport's own patch refuses, so that the replay's host,
which has no viewport, finds it at the Camera's move; one that never
patches; one that patches the text and not the model; one that keeps a
device's cells when its changes name some; one that keeps the Input rows
after a person's edit of the Input sheet; one that writes the rows whole
whenever one changed; and one that never keeps them; and, with or without
the module, a patch that leaves an empty row's cell in place, which the
crafted patches find. ENGINE.19 moved two anchors of ENGINE.8's, the
viewport's reading of a row having moved into readRow: AC's and AS's lines
are anchored where readRow holds them. And since ENGINE.20 five viewports,
each failing the changes case by name, four when the real page holds the
module: a repaint without the span its text spills over, which K2 growing
at frame 2 finds in L2; one without the span of a neighbor's text that
spills into a named cell, which N6 filling at frame 2 finds in O6, L6's
spill left standing; and one that leaves out the selection, which frame 2
finds in M1, under it; and, with or without the module, a repaint with no
clip, which the first crafted patch finds in A1, the selection blended
twice, and a draw list that keeps the last full paint's ops, which the
first crafted patch finds too. And since ENGINE.7 ten hosts, when the real
page holds the module, each failing the continue case by name: one that
loads the rebuilt cartridge instead, the frame number begun again at 0; one
that writes every value row of it, the knob the person set begun again;
one that records none of the rows it writes, the run's replay not the
twin's; one that compares the next continue with the cartridge loaded, D1
written again at frame 16; one that writes each row on its own, the refused
write's constant landing at frame 18; one that loads no second handle, a
cell written twice answered ok; one that writes the rows at the press, the
frame's derived write landing after D1's; one that compares no manifest,
the rate changed answered ok; one that counts no removed row's cells,
Screen!A3 dropped answered ok; and one that compares no row a write cannot
take, a column's width answered ok. And since ENGINE.23 eight templates,
each failing the palette case by name: one that takes Ctrl+Shift+K, Edge's,
for the palette's key; one that takes Cmd+Shift+`, a Mac's; one whose Enter
runs the first line whatever is chosen; one that gives the focus nowhere
back; one that reads a row in ( alone; one whose first Escape in full screen
leaves; one that leaves the palette open after its line runs; and one whose
held key's repeat toggles it. And since its second slice ten more, each failing
the keys case by name: a refused keymap applied anyway; a box's typing keys taken by
a binding written for anywhere; a person's command run to its first step alone; a
keymap without the palette's key applied; AltGr's Ctrl with Alt and a letter bound;
the page's own keymap applied and the kept one never forgotten; a kept keymap naming
a later page's command refused whole; a box's editing keys taken; a key a window's
browser keeps said nothing of in the list; and a game's button said shadowed by a key
held with Ctrl. And since ENGINE.24 four more: a binding on a sheet held on every
sheet; a binding on no sheet pressed before one on the sheet shown; a key a game reads
as the last key said nothing of; and the drawer's note naming the input card's keys
whatever the cartridge binds. And since ENGINE.25 nine hosts, when the real page holds
the module, each failing by name: one that writes no Input!B20, the command never
reaching the game; one that keeps B20 past its frame; one that keeps one command
waiting, the first of two in a frame dropped; one that writes B20 for a version 4
cartridge too, whose Input rows the engine refuses; one that runs a command that holds
not; one that runs a command while a replay plays; one that takes a command's key with
Ctrl held; one whose command's key runs again at its repeat; and one that leaves B20
for the step after a command's at rate 0. And since its second slice five templates, with or
without the module, each failing the commands case's page half by name: one whose palette lists a
game's command that holds not; one whose keymap refuses a game's commands; one that presses a binding of
a game's command that holds not, its key never passed on; one whose list says nothing of a game's
command key a person's binding shadows; and one that ranks the page's own commands with a person's own and
the game's, the page's listed first in the palette and in the list. And since CART.12 three more, each
failing the grid case by name: a viewport that reads no text row, so that the lone record's D1 under the
code 0.00 draws 1.5 where its text row says 1.50; one that counts a code's format row malformed, which the
lone record's counts find; and, when the real page holds the module, a host whose record by cell takes no
text row as a cell's, so that it never lays the grid card's changes on its record, the patches under
their floor. And since version 6 eight hosts, each failing the settle case by name, five over the double:
one that never steps a settle, the load left at frame 1 settling; one whose act's place is 0, the press
over C3 written at 0 and 0; one whose press over a cell is no act; one that never steps the load's act,
the load left at frame 0; and one that says nothing when K stops a settle; and four when the real page
holds the module: an act made during a settle cutting into it, the edit landing before the spill's end;
the engine's release unmirrored, so that a second press on E2 writes no press; a command's key at rate 0
left to the viewport; and a press read after the viewport's own handler, whose focus scrolls the page
under the point, the settle card's box below the fold, so that the press on E2 misses its cell. And since CART.12's
fourth slice one more, when the real page holds the module, EG, a scratch copy of Superposition's hand that keeps the press
and the command at a settle step, where the engine releases them, so that it opens a box again at the box's settle, which
the replay case must fail by name; and since its hand tests five more, when the real page holds the module: EH, a
host that shows a sheet without reading its columns whole first, so that the large board's narrow columns past the
record's window are drawn empty; EI, a viewport whose resize raises no event, so that a box grown as full screen
grows it shows columns no record named; EJ, a viewport that bounds no sheet, so that the Field lays slack past its
extent; EK, one whose tab chosen leaves the keys where they were; each of which the grid case's game half must fail
by name over Superposition's Field, at its load or its moves; and EL, Superposition's hand without the box's rule,
which the replay case must fail by name at frame 33, where the owner's box on V21 opens. And since ENGINE.26 seven more,
when the real page holds the module, each a viewport the widths case must fail by name: EM, its widths one map for
every sheet again, a column's letters alone, which leaves the Desk's D on the Ledger at the first frame; EN, one whose
clear keeps the widths, so that a Load keeps them; EO, one that estimates a sheet's region at the sheet shown's widths;
EP, one whose drag raises no scroll, so that the columns a narrower column brings into view at rate 0 stay unviewed;
EQ, one whose drag sets the width of the sheet shown, not the one it was pressed on; ER, one that raises columnresize
at a press that moved nothing; and ES, one whose load without keep forgets its sheet's widths, so that the Screen's
tab drops the Screen's. And since CART.14 one more, when the real page holds the module: ET, Seiyaku's hand whose
candidates forget the box, so that a domain filled keeps a value its box holds, which the replay case must fail by
name at frame 12, where the owner's session first fills the domains; and since its hand test four more, when the
real page holds the module, each a viewport the grid case's game half must fail by name over Seiyaku's Board, shown
whole in a box grown to hold it: EU, one whose bound sheet stands on the background, white past its edge; EV, one
whose gridlines cross a bound sheet's canvas, its first column's line running on below its last row, over Naught's
Lesson since ENGINE.28's third slice turned the Board's gridlines off; EW, one whose
column headers' edge runs on past its last column; and EX, one whose row headers' edge runs on below its last row.
And since its hand test's fifth note one more, when the real page holds the module: EY, a host whose keypad's digits
run no command, so that the keypad's 7, Num Lock on, passes on where the commands case's card runs seven, the command
of the digit row's 7, which the commands case must fail by name at frame 38. And since CART.9 one more, when the real
page holds the module: EZ, naught's hand that reads aut as vel, the inclusive or for the exclusive, which the replay
case must fail by name at frame 743, where the stand-in's carry-in first meets a 1 at an AUT already holding one
(frame 35 until the third slice's hand test put the owner's session and the levels before the bench, and 731 until
its short slice lengthened the levels' stand-in).
And since its second slice three more, needing no module, each a template the palette case must fail by name: FA,
a cell's edit whose caret stands past the closing quote; FB, Enter writing a cell's edit and moving no selection;
and FC, the floating palette at the top over a cell in the top half of the rows in view, of the window since
CART.9's short slice.
And since its hand test five more: FD, FE and FF, the palette case's, Backspace's emptied cell forgotten, Delete's
row over the selection's first cell alone and the window's own blur shutting the palette; FG, the settle case's, a
press an act whatever the cartridge reads; and FH, when the real page holds the module, the replay case's, a replay
that never shows the sheet its person showed. And since SPEC.5 ten more, each failing the modes case by name: three
templates, needing no module, FI, a key on a read sheet opening a cell's edit, FJ, the last key read on every sheet
at a rate, a work sheet's too, and FK, the palette's place written beside the line it replaces, two lines the keymap
refuses; five hosts over the double, needing no module, FM, a work or a read sheet the game's where no game sheet is
named, FN, a read sheet written by hand, FO, a person's row into a read sheet written, FP, a sheet named by none the
game's where a game sheet is named, and FT, a game sheet's keys forgotten; and two hosts when the real page holds the
module, FR, a command's key run on every sheet at rate 0, so that M runs mark on the work sheet, and FS, every key the
game's at a rate, so that x on the work sheet is the frame's last key. And since its hand test two more templates,
needing no module: FU, Enter on a read-only sheet left to the viewport, which opens a refused edit, and FV, Tab left
to the browser, which walks the focus out of the grid. And since CART.9's third slice five more, when the real page
holds the module: FW, a host whose press is an act on every sheet, which the modes case must fail by name on Notes, a
work sheet, where a press is the viewport's selection alone; and FX, FY, FZ and GA, naught's hand, which the replay
case must fail by name at frames 34, 108, 792 and 15 (80 and 780 for FY and FZ until its short slice): a test that
runs on past a wrong input, the stars counted against the budget alone, the due under test read from the switches as
they stand, so that a switch written over is tested where it stands, and a click that toggles no switch. And its rider
one more, needing no module: GB, a host whose log counts a load's sentences in an earlier load's lines, so that its
status line skips them, which the settle case must fail by name. And its short slice five more: GV, needing no
module, a viewport whose cell's box forgets the scroll, which the palette case must fail by name at a cell scrolled
into view; and four when the real page
holds the module: GW, GX, GY and GZ, naught's hand, which the replay case must fail by name at frames 52, 30, 52 and
21: a value read as a gate, every level giving every gate, an output's error due, and a test's stars read from the
gates as they stand.
And ENGINE.28's first slice three more: GC, needing no module, a viewport that passes over a format row's groups,
which the grid case must fail by name at the double's row of 200, drawn right-aligned in the default ink where its
look says white, bold and centered; and GD and GE, when the real page holds the module, a look that replaces the
cell's own format whole and no row fitted to its tallest size, which the grid card's N17 and row 17 must fail by
their places. And its second slice two more: GF, needing no module, a shared edge's tie given to the left or upper
cell, which the grid case must fail by name at a tie, the double's thin boxes on the row of 200 or the grid card's
red edge against its blue one between L2 and M2; and GG, when the real page holds the module, a repaint whose band
is not grown over a fill's gridlines and an edge's reach, which the changes case's pixels must fail. And at its hand
test one more, GH, when the real page holds the module: a hidden neighbor's side taken, the edge resolved against the
next column or row and not the next shown, which the grid card must fail by name between R2 and T2, beside its
hidden column S, or I11 and I13, beside its hidden row 12, each drawn by the hidden cell's red side where the record
resolves it to the shown cell's blue one.
And REPO.11 one more, needing no module: HA, a prompt's blur that never shuts the palette, which the palette case must
fail by its second verdict's line, a blur while the window has the focus, as FF fails by its first's. The case dispatches
both blurs itself, since a headless page's window focus comes late now and then and a browser fires no blur without it.
And ENGINE.36 twelve, each failing the changes case by name, eight when the real page holds the module: a viewport whose
wrap takes no line feed, LF; one that drops a piece's indent, LG; one that keeps its trailing spaces, LH; one that draws a
carriage return, LI; a nowrap's line feed drawn, LJ; a nowrap's measure counting none, LK; the loop oracle's twin without
the rule, LP, and its compare holding a line feed against a line, LQ; and, needing no module, each by the crafted
patches: a record by cell that joins no line, LL; a patch that joins none, LM; a row reader that joins any line, LN; and a
model's lines left at one a row, LO.
And CART.9's fifth slice two, each Naught's hand's, failing the replay case at its frame when the real page holds the
module: an error's kind read as #VALUE! whatever the error, HZ, at frame 4804, where III's gate divides by zero; and the
words of the kind a place after its own, IA, at frame 52, where III's emptied cell makes its first #VALUE!.
And CART.14.1's second slice three, each Seiyaku's hand's, failing the replay case at its frame when the real page
holds the module: the candidates blind to the strikes, KS, at frame 63; a hidden single read from a row's places for
a column's, KT, at frame 21; and a filter that strikes the marks it hides, KU, at frame 36.
And ENGINE.37 six, each failing the changes case by name, five needing no module: a host whose cell rows take no lit
row, LR, and a viewport whose cell rows take none, LS, each by the crafted patch that lays one; a lit row left counted
when its cell is patched, LT, by the one that takes one off, the model not a load's; the double's answers blind to its
rule over A1, LV, by the oracle's own diff of its records; and a rule's fill never repainted, LW, by the crafted
patch's pixels; and, when the real page holds the module, the fold kept by its cell and not by its rules, LU, by the
changes card's row 4 drawn against the oracle's own reading.
And ENGINE.41 two, each failing the changes case by name and needing no module, one viewport's mutation proven by each of
its two holds: a clip whose restore keeps the font the painter noted, MM by the crafted patch of two cells of one bold
font apart in a row, C1's pixels not a full paint's, the second rectangle drawing it in the default; and MN by the full
paint of a frozen row over a total of that font, A1 drawn in the default where its op names bold.
And CART.3's second slice four, each failing the commands case by name over the module, version 7's: a key with modifiers
taken with Shift held too, MO; Cmd not taken for Ctrl, MP; a key with modifiers read below version 7, MQ; and a key with
Shift left to the bare key of its code, MR. The key language moved into the host with it, so CK and CL, the palette's,
mutate web/host.js, and DM's line is the bare key's own.
And ENGINE.40's second slice two, each failing the keep case by name over the module, a file's drafts not taken back as
typed: a raw string of one # whatever its text holds, MS, which the closer's own run of # in a box ends early; and a
draft read and dropped, MT.
And CART.3's third slice fourteen, each failing the drawer case by name and needing no module: the drawer measured by
its contents, its containment taken out, MU; a press on a command's button that takes the keys, MV; a section's
summary left to take them, MW; and the drawer's boxes, the page's own: a text laid in one block whatever its length, MX;
an empty line's <br> read as a line feed, MY; Enter left to the browser, MZ; a paste left to it, NA; a copy and a cut
left to it, NB; Ctrl+Z left to it, NC; a delete at a block's edge left to it, ND; a value's CRLF kept, NE; three
keystrokes three steps of the history, NF; the history kept across a value written, NG; and the page's own edits
untold, NH. And its last, (c), four, Brickwork's hand, each failing the replay case by name at the frame of the
owner's game where it first leaves the engine, over the module: a slide stopping a column short, at the first slide,
frame 409, NM; a cut taking a place in the deal, at the second cut, the Clipboard's brick swapped in, frame 5155, NN;
a lay's rest restarted by a turn, at a turn of a brick resting, frame 35015, NO; and the pace a power, at the second
course cleared, frame 2524, NP.
And ENGINE.39's first slice five, version 8's repeat, each failing the commands case by name, four over the module:
the Commands sheet's column E unread, every command once, NR; a repeat never taken, NS; a person's (repeat) and (once)
unread, the column's word taken over the binding's, NT, needing no module; a repeat judged by no time, one pressed
before its command's frame came to rest run, NU; and a repeat taken while a command waits, NV. Its first slice moved
DN's anchor to the line where a command's own key judges its repeat.
And ENGINE.39's second slice five, the grid's copy, cut and paste, each failing the clipboard case by name: a paste
as n acts, the page's copy of 10 cells stepping 10 frames, NW; a read-only sheet written, the Ledger's paste taken,
NX; a cut emptied at the cut, its cells gone before its paste, NY, each over the module; the game's chord taken by
the page, its Ctrl+C on the Screen pressed where it passes on, NZ; and the last CRLF dropped from Excel's text, OA,
each needing no module. And its third slice four, a formula's references moved, each failing the clipboard case by
name over the module: a formula pasted unmoved, the copy of L1:M2 at N50 reading A1, OB; a cut's formula moved, the
cut of L1:L2 at N60 reading C60, OC; a cut's paste untiled, the move over N60:N63 written once, OD, inverted at the
owner's word at its push, where it was a cut's paste tiled; and, at the owner's word at its hand test, a cut's text a
copy after its move, its paste again over P60:P63 moved, OE. And after its close one, needing no module: a cut's one
formula filling a range as one fill row, each cell's references moved from the first's, OF; and at the owner's pick at
its hand test two more, needing no module: whole copies alone, the 2 by 2 copy over C5:E7 at its corner, OG; and a
fill not cut at the selection's edge, L1:M2 over N50:P52 written past it, OH; and at its second, one more, needing no
module: a selection smaller in a row taking the block at its corner, the 2 by 1 copy over C5:E5 at C5:C6, OI.
And CART.16's second slice, the file case's, six. Over the module: a file saved under the cartridge's name and not
the name it was opened by, OJ; a person's save writing a cartridge still, where the cartridge reads a file, OK; the
cartridge's own save, File!B3's, writing the file, OL; and the open's check asked while the load's act settles
forgotten, never said, ON. Needing no module: the check blind to line ends, CR LF beside LF found one file, OM; and
a file's kind judged by its case, WALTER.PL no .pl file, OO.
CART.12 moved one anchor of ENGINE.25's,
the twentieth row's write at rate 0
now an else of version 6's act rows: DO's line is anchored where _issueAct holds it. The real page must
pass first.

Since 2026-10-15 each mutant page runs `abi`, which names the page's
module, and the cases its reason is judged by (?loop=1&cases=), never every
case: replay after input, whose live run it copies; the real page
and the game's page run every case. Every case run alone prints the counts
it prints among the rest (measured that day), and the control went from 12
minutes to 3.6 on the owner's machine.

Since REPO.8 (2026-10-24) the browsers run side by side, -Jobs at a time:
by default half the logical processors, a browser a 0.6 GB of the memory
free, and at most eight; -Jobs 1 runs them one at a time. A run ends at its
whole dump, its one </html> written and grown no more, and the browser is
ended then: on Windows a browser's shutdown beside another instance waited
on a system service's reply up to 120 s a time, its page long done. The
check runs the sound case first and alone at the first ratio, since it
renders in real time and a starved processor fails it; then side by side
the first ratio's input and replay cases, its other cases, the second
ratio's every case but the replay and sound cases, which draw nothing and
map no pointer, and the game's page. The control runs its own code twice: a
plan pass that builds every mutant page in the background, -Jobs at a time,
and notes every run, but each run of the sound case, which it makes at
once, every build ended and nothing beside it; a pool that makes the runs
side by side, the longest first; and a run pass that judges every mutant as
before, each run answered from the pool, a run the plan missed made in its
turn and counted on the control's pool line. The real page's module, which
decides the mutants that apply, is read at once by abi alone, and the real
page is judged by the check's own runs at the first ratio. A mutant judged
by a game's replay plays that game's alone
(?loop=1&cases=...&replays=<names>, replay:<names> in a mutant's cases): P,
R and Y none, Q and BK the input card's, each hand's mutant its own game's;
and a hand's mutant whose verdict names its frame plays it to that frame
and no further (&upto=<frame>, replay:<names>:<frame>): EL at 33, ET at 15,
EZ at 743 and Naught's FX to GZ each at its own, where the whole replay ran
on past a hand gone wrong, GX alone four minutes beside the pool.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network;
exit 0 clean, exit 1 with every problem named. A headless run's clock is
virtual, so nothing here is a timing.

Usage:  powershell -File tools\check_host_loop.ps1
        powershell -File tools\check_host_loop.ps1 -Browser "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        powershell -File tools\check_host_loop.ps1 -Page C:\somewhere\index.html
        powershell -File tools\check_host_loop.ps1 -Control
        powershell -File tools\check_host_loop.ps1 -Control -Jobs 1
#>
param(
    [string]$Page = '',
    [string]$Browser = '',
    [switch]$Control,
    # REPO.8: the browsers side by side, by default half the logical processors, a browser a 0.6 GB of the memory free, and
    # at most eight; 1 is one at a time
    [int]$Jobs = 0
)
$ErrorActionPreference = 'Stop'
# The memory free in GB, or $null where it cannot be read: a run of the replay case holds up to half a GB, and the owner's
# machine had 3 to 6 GB of its 32 free beside its other work (REPO.8).
function Get-FreeGB {
    try { if ($env:OS -eq 'Windows_NT') { return [double](Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB } } catch { }
    try { $m = [regex]::Match([System.IO.File]::ReadAllText('/proc/meminfo'), 'MemAvailable:\s+(\d+) kB'); if ($m.Success) { return [double]$m.Groups[1].Value / 1MB } } catch { }
    return $null
}
# A workflow's width, ALONZO_LOOP_JOBS: on GitHub's Windows runner light mutant pages run beside another browser wrote no
# dump in ten minutes, where the same pages end here and on Linux, and one at a time they did before the pool (REPO.8's
# addendum). So its two Windows steps set 1.
if ($Jobs -le 0 -and $env:ALONZO_LOOP_JOBS) { $Jobs = [int]$env:ALONZO_LOOP_JOBS }
if ($Jobs -le 0) {
    $Jobs = [Math]::Max(1, [Math]::Min(8, [int][Math]::Floor([Environment]::ProcessorCount / 2)))
    $freeGB = Get-FreeGB
    if ($null -ne $freeGB) { $Jobs = [Math]::Max(1, [Math]::Min($Jobs, [int][Math]::Floor($freeGB / 0.6))) }
}
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
# 2026-10-14, ENGINE.8's second slice: the twenty cases' counts unchanged but
# for grid, every frame after the first drawn from the values record and held
# byte for byte to the grid record less its formula rows (fakeValues 12,
# values 24). Over the double, U5, a formula with no value outside the declared
# size, is drawn empty from frame 5 where it was its text, so fakeUnvalued is
# frame 0's 240 where it was 244; over the module frame 0 is still the grid
# record, its 350 formulas as their texts. lone: a values record written in
# the oracle, read whole by a viewport of its own, 1.
# 2026-10-15, ENGINE.16: the twenty cases' counts unchanged, new counts beside
# them. replay: hands 2, the blocks hand-sand and hand-kairos registered and
# matched; alone 0; kairosCells 156,105, Kairos's Tally (B2:D16, 45 cells)
# held at each of its 3,469 frames. grid's game half over the grid card: 1
# grid, 12 frames, 13 equal with frame 0, 12 from the values record, 5,369
# texts under Chrome 155 on Windows (the floor a margin below, as texts'),
# the viewport cleared. The game's page, Kairos alone, at a ratio of 1: abi
# 3 refused and the module attached; pass 1 source the same (378 rows);
# replay 5 vectors, 1 hand, 1 replay to its golden and its recording, every
# one of its 3,469 frames and 156,105 cells held, 30 rows stopped; grid over
# no grid cartridge; empty 1 cartridge, 1 library, the double and the module.
# 2026-10-15, ENGINE.17: the twenty cases' counts unchanged, and a twenty-first,
# still, over the module on both pages, the counts a function of its plan: 90
# frames, 91 held to their records with frame 0, 6 drawn (frames 1, 31, 45, 61,
# 70 and 81) and 84 still, every one of the 90 the oracle's own choice; both
# boundaries, the edit, the unchanged edit, the Camera's move and the replaced
# model each pinned; the selection kept at 88 frames; the timing's two shapes;
# redraw() a draw; the viewport cleared. The drawn count has no floor, decided
# holding every frame's choice either way. Then the sheets, at the owner's word
# the same day: Board shown in the Screen's place from frame 5 to 40 and in a
# viewer of the page's own, each frame decided in both (40 and 40), Board kept
# at 35 frames in the host's viewport and 39 refreshes of the viewer, loaded in
# both at the day's boundary (2), the Day loaded at each of its 4 frames, and
# the frame after the Screen's tab still.
$stillFloors = @{ frames = 90; equal = 91; stills = 84; decided = 90; boundaries = 2; edited = 1; unchanged = 1; moved = 1; replaced = 1; kept = 88; timed = 2; redrawn = 1; cleared = 1;
                  sheets = 40; sheetStills = 35; viewer = 40; viewerStills = 39; turned = 2; daily = 4; back = 1 }
# 2026-10-15, ENGINE.18: the twenty-one cases' counts unchanged, and a twenty-second, views, over the module on
# both pages, the counts a function of its plan: 90 frames; frame 0 opened on the Desk, the first visible sheet;
# 80 frames of a sheet other than the Screen held to the record the host drew, every one the values record, and
# 10 of the Screen through the Camera's window; the hidden Screen unviewed at all 70 frames before the Camera
# shows it; Input!B19 the sheet shown at all 90; the press over Desk!C5 counted once, and the presses over the
# column header, the tab strip and the Ledger's C5 counted nowhere (3); the person's 4 tabs and the Camera's 2
# shows; the person's Desk kept at the 19 frames the Camera holds still; the replay, version 4's, played to all
# 90 frames; the value row's opening and its empty first value; and the still card kept at version 3.
$viewsFloors = @{ frames = 90; opened = 1; held = 80; values = 80; screen = 10; hidden = 70; inputs = 90; pressed = 1; unpressed = 3; tabs = 4; shows = 2; kept = 19;
                  replayed = 1; replayFrames = 90; replayInputs = 90; valueRow = 1; unmoved = 1; older = 1; texts = 5000 }
# 2026-10-15, ENGINE.19: the twenty-two cases' counts unchanged, new counts beside them: inputsKept in every case the
# loop's model runs (rate30 28, yield 9, memory 10), and the grid case's patches, the double's frames 2, 4, 6 to 8 and
# 10 to 12 (8) and the grid card's (20). A twenty-third, changes, on both pages, its counts a function of its plan: the
# crafted patches, 5 records and a whole answer refused (6); the double's answers held to the oracle's own diff, 30 at
# frames 0 to 9 and 2 between frames (32); and over the module the changes card, 60 frames, each decided as the oracle
# decides it, 3 whole (1, 40, 50) and 57 patched, every record, model, drawn window, device state and Input write held;
# the rows written two at 10, 11 and 12, all of them at 1 and 21, none at 48 frames; the Day's viewer patched at 58
# frames, the Screen's viewer whole at its 20 refreshes; 2 saves; the replay to all 60 frames.
# 2026-10-15, ENGINE.20: changes gains its repaint's holds, its counts a function of its plan. The crafted patches each
# held to a fresh viewport's full paint, and a patch of all 64 cells of a window of 8 by 8 painted whole (crafted 7).
# Over the module, the 57 patched frames repainted by their cells (repainted), and at all 60 frames the canvas pixel for
# pixel and the draw list op for op a twin's full paint (pixels, ops), the 11 frames of frozen panes among them (frozen),
# and the 5 frames of the window out of view repainting nothing (unseen). drawnHeld falls from 60 to 49 for a written
# reason, not silently: the oracle's own layout has no frozen panes, so the window is held to the record cell for cell
# at the 49 frames the panes are thawed, and the 11 frozen ones are held to the twin's full paint instead.
# 2026-10-30, ENGINE.36: the crafted patches take a row running over lines, five laid and two refused (crafted 14); the
# frames' counts stand, the card's line feeds patched and repainted among the 57, its wrapped lines held text by text.
# 2026-11-15, ENGINE.37: the crafted patches take a record holding a rule, a cell's lit row laid with its value and taken
# off with it, a lit row alone at a cell holding nothing and that cell emptied (crafted 18); the double's answers name its
# A1 where its rule's answer alone moved, held by the oracle's own diff, its counts standing; and the changes card's rules
# on row 4, lit by the Clock's frame with no value moving, patched and repainted among the 57, its frames' counts standing.
# 2026-11-15, ENGINE.37's second slice: strands, a font's lines held over the frames by the page's own table, a rule's
# underline and strike on and off over L6's spill, a double under K2 and an accounting underline under M1's number and its
# #s, 176; the frames' counts standing.
# 2026-11-17, ENGINE.41: every text a crafted patch repaints held to the font its op names, the canvas's font noted at
# each; and two more crafted holds (crafted 20): two cells of one bold font apart in a row, changed together, the second's
# rectangle painted after the first's clip restored the font, and a full paint's frozen row of that font over a sheet
# whose last text is of it too. The frames' counts standing.
$changesFloors = @{ crafted = 20; double = 32; frames = 60; decided = 60; drawn = 3; patched = 57; equal = 60; models = 60; drawnHeld = 49; calls = 60; devices = 60;
                    inputs = 60; kept = 48; two = 3; whole = 2; dayViewer = 60; dayPatched = 58; screenViewer = 20; patches = 57; inputsKept = 48; saves = 2; replayed = 1; replayFrames = 60;
                    repainted = 57; pixels = 60; ops = 60; frozen = 11; unseen = 5; strands = 176; saved = 2 }
# 2026-10-16, ENGINE.7: the twenty-three cases' counts unchanged, and a twenty-fourth, continue, over the module on both
# pages, its counts a function of its plan: its ten sources built by the page's pass; 20 frames, each cell held to its
# rule at all 20 and the five sheets' records to the twin's at 21 with frame 0; 2 continues applied, the first in the
# place of a press before it (replaced) and the second while paused (waited); 5 refused at the press and 1 at the
# write; the frame after the first viewed whole and the next patched; the replays equal, the run's played to all 20
# frames; a continue refused while a replay plays; and the host's three comparisons, pure.
$continueFloors = @{ built = 10; compared = 3; frames = 20; hand = 20; twin = 21; applied = 2; replaced = 1; waited = 1; refused = 5; writeRefused = 1; whole = 1; patched = 1;
                     replays = 1; played = 20; replaying = 1 }
# 2026-10-16, ENGINE.23: the twenty-four cases' counts unchanged, and a twenty-fifth, palette, on both pages and needing
# no module, its counts a function of its plan: the 25 commands of the registry; 11 key events held to opening it or not;
# 9 texts held to their first line and an empty text's list; the palette opened, a line run, the second line chosen, a
# row written and what was run brought back once each; shut 3 times, after a line, by Escape and by its own key; the
# focus given back, a repeat ignored, the box's keys passed on and a line clicked once each; and 5 Escapes in full screen.
# 2026-10-16, ENGINE.23's second slice: the palette's commands 30 with the keymap's five, and a twenty-sixth case, keys,
# on both pages and needing no module: the page's own keymap read clean; 18 crafted texts refused whole by line and
# words; 24 keys held to the command each presses in its place; a person's command run in its 3 checks; 3 of the
# palette's lines; the keymap kept, read again, forgotten, a later page's line set aside and a refusing store, 5;
# and 6 of Record a key's spellings, each read back.
# 2026-11-16, ENGINE.5's hand test: offered, a kept keymap gaining the page's keys for its commands new since, once, a key
# taken out staying out and a key held for another command never taken (5).
$keysFloors = @{ defaults = 1; refused = 18; places = 25; steps = 3; lines = 3; kept = 5; spelled = 6; said = 21; sheets = 14; last = 9; game = 5; offered = 5 }
# 2026-10-20, CART.9's second slice: the palette case's cell edits, needing no module: 12 rows a cell opens, typed or
# opened, each with its caret; 6 of where the palette opens, fixed or floating; 7 of a cell's edit in the palette, its
# prompt and caret, Enter, Tab, Shift+Enter and Shift+Tab each moving the selection once, a refused row, Escape and a
# command moving nothing, and a row typed in a palette opened by its key moving nothing; and 5 of the keymap's
# (palette ...) line, three read and two refused.
# 2026-10-20, CART.9's hand test of the second slice: 6 of Delete and Backspace, Backspace's emptied cell and Delete's row
# over five selections, two of them none; and 2 of the window's own blur, which keeps the palette and its text, where a
# click elsewhere shuts it.
# 2026-10-20, SPEC.5: the palette's commands 33, the three of its place, palette-floating, palette-top and palette-bottom.
# 2026-10-24, CART.9's short slice, the owner's word at its hand test: the floating palette's side by the cell's box in
# the window's halves, where it was the rows in view, 8 sides; and 3 of a cell's box, the hit test's inverse, its middle
# the cell in the frozen corner, unscrolled and scrolled.
# 2026-10-30, REPO.11: every count as it was, the kept's 2 now over two blurs the case dispatches itself, so that a page
# whose window's focus comes late, which counted 1 and failed here now and then, counts the same as any other.
# 2026-11-17 and 2026-11-18, CART.3's third slice: the thirty-third case, drawer, pure, over the page's own markup and
# a box of the stage: the drawer contained, its size and layout its own (contained 1); every button of the player a
# command's, a press on it leaving the keys where they were (buttons 22), so too each section's summary (summaries 4),
# and each box and list taking them (boxes 9); six presses heard over the stage's box (pressed 6); and the drawer's five
# boxes the page's own, editable plain text with a box's role (regions 5): a text of 1,201 lines in thirteen blocks
# (blocks 1); eight texts, and three blocks as a browser's edit leaves them, read back as written (read 11); the caret
# kept and drawn (caret 4); Enter, Shift+Enter and Enter over two blocks the page's (breaks 3); a delete at a block's
# start and at its end (merged 2); a paste of 1,200 lines (pasted 1); a copy and a cut (copied 2); the history's seven
# steps and a value written forgetting it (undone 8); and the page's own edits told (told 1).
$drawerFloors = @{ contained = 1; buttons = 22; summaries = 4; boxes = 9; pressed = 6; regions = 5; blocks = 1; read = 11; caret = 4; breaks = 3; merged = 2; pasted = 1; copied = 2; undone = 8; told = 1 }
$paletteFloors = @{ commands = 33; keyed = 11; lines = 10; opened = 1; ran = 1; chosen = 1; rows = 1; recalled = 1; closed = 3; restored = 1; held = 1; passed = 1; clicked = 1; escapes = 5; edits = 12; sides = 8; boxes = 3; cellEdits = 7; placed = 5; clears = 6; kept = 2 }
# 2026-10-20, SPEC.5: the twenty-nine cases' counts unchanged but the palette's commands, and a thirtieth, modes, on both
# pages, its counts a function of its plan. Its page half, pure: 34 keys of SPEC.5's table, each mode's sheet given a
# game's key, a character, Delete, Backspace and an arrow, and since the hand test Enter and Tab, each moving the
# selection where it opens no edit, Tab on every sheet whose keys are a person's; 10 of the modes' words, the
# palette's note and the drawer's;
# and 5 of the palette's place written into a keymap. Its double half: the three read from the describe and printed (2);
# 6 sheets' modes, a name compared without case among them; 5 rows, three refused into read sheets, one written into the
# work sheet, and the count and the frame; 2 refusals said by the sheet's name, a row's and a key's; 3 of a sheet named by
# none; a plane's read sheet; and the three refused below version 6 (3). Over the module: the engine's describe read and
# printed (2); the card opened on its Board; 5 sheets by their tabs, M taken as the game's on the two game sheets alone
# (pressed 2, passed 3); 3 rows written and 2 refused with their count; a key on the read sheet refused; the card at a
# rate, M and x on the work sheet and on a game sheet (2); 5 of the engine's refusals; and on Alonzo's page Naught's
# Lesson read and its Bench worked (2), which a game's page, holding no Naught, counts 0. Since ENGINE.42 the bar's rule
# has 8, a repeat or not, an act's answer or not and over a key's refusal or not; and over the module, on a game's page
# too, an act's answers said again: a source built again and an edit written again, each the bar's after a refusal, the
# bar held over the loop's own repeat, and the log's last line each answer's (2).
$modesPageFloors = @{ acts = 39; words = 10; places = 5; bar = 8; fakeRead = 2; fakeModes = 6; fakeEdits = 5; fakeSaid = 3; fakeUnnamed = 3; fakePlane = 1; fakeOlder = 3 }
$modesFloors = @{ described = 2; opened = 1; takes = 5; pressed = 2; passed = 3; written = 3; refusedRows = 3; presses = 5; keyRefused = 1; rate = 2; refusals = 5; naught = 2; kept = 1; answersBuilt = 1; answersEdited = 1; answersHeld = 1; answersLast = 2 }
$modesGameFloors = @{ described = 2; opened = 1; takes = 5; pressed = 2; passed = 3; written = 3; refusedRows = 3; presses = 5; keyRefused = 1; rate = 2; refusals = 5; kept = 1; answersBuilt = 1; answersEdited = 1; answersHeld = 1; answersLast = 2 }
# 2026-10-17, ENGINE.25: the twenty-six cases' counts unchanged, and a twenty-seventh, commands, over the module on both
# pages, its counts a function of its plan: the card opened on the Desk, its four commands listed at the load; 40 frames,
# 3 commands run alone, Input!B20 naming the command due at 23 frames and empty at 17; two commands a frame apart and one
# at two frames running; U and its repeat once, Ctrl+U nothing; on the Ledger count-up holding not and back on the Desk
# holding again (2), refused there and its key passed on, note noted at 16; note's words live; sixteen waiting, one a
# frame, and a seventeenth refused; the four rows the host cannot take said once each; the replay played to all 40
# frames; a command refused during a replay; rate 0's step, the empty twentieth row after it and its replay; and the
# card kept at version 4.
# 2026-10-19, CART.14's hand test, the fifth note: the card's eighth row, seven, its key the digit row's 7; the keypad's 7
# before frame 38, Num Lock on, taken and running seven, and before 39, Num Lock off, passing on (keypad 2); Input!B20
# naming the command due at 24 frames and empty at 16, the frame seven runs moved from the one to the other.
# 2026-11-17, CART.3's second slice, version 7: a command's key with modifiers, a card of its own at (spec 7), its keys
# listed as the keymap spells them and said in words (2), and twelve frames each as planned (12): U, Ctrl+U, Cmd+U and
# Shift+U each running its own; Ctrl+Shift+U, Ctrl+Cmd+U and Alt+U passed on; Ctrl+U and its repeat once and the frame
# after it empty; Ctrl+B running bee and holding no button, B holding it, and Shift+N running note (chords 14); and the
# card at (spec 6), its three keys with modifiers said once each and no keys, listed so, Ctrl+U passed on and Shift+U
# count-up's (chordsOlder 6).
$commandsFloors = @{ opened = 1; listed = 1; frames = 40; ran = 3; landed = 24; emptied = 16; apart = 1; twice = 1; repeats = 1; ctrl = 1; holdsNot = 2; refused = 1;
                     passed = 1; noted = 1; words = 1; waited = 16; dropped = 1; said = 4; replayed = 1; replayFrames = 40; replaySame = 40; during = 1; rate0 = 1;
                     rate0Empty = 1; rate0Replayed = 1; older = 1; keypad = 2; chords = 14; chordsOlder = 6; repeating = 23 }
# 2026-11-18, ENGINE.39's first slice: the repeats card at (spec 8), its counts a function of its plan: listed at the load
# and after the first frame, a formula of column E repeating not until its first value (2), E5's text said once (1), and
# at 30 frames a second thirteen frames as planned (13), U and its repeat each run, two repeats before one frame run once,
# a repeat pressed before its command's frame came to rest none, T's and X's repeats none, N's while its formula says so,
# and at the frame of the two repeats a page's own repeat fresh by its time while a game's waits (1); at rate 0 six acts
# (6), a repeat at once, a stale one none, T's none, and a repeat handed over after the key's release none (1)
# (repeating 23). Its page half, pure: eleven bindings' repeats held to the person's word, the column's and the page's list
# (11), the list's words of each (1), and three refusals (3) (repeatWords 15).
# 2026-11-19, ENGINE.39's second slice: the clipboard case, its counts a function of its plan. Its page half, pure: fifteen
# chords (chords 15); the keymap's seven places and keys, the list's words and the keymap kept before it offered the three
# (bindings 9; never "keys", a hashtable's own property here); Excel's text of three ranges (text 3), nine texts read back
# (fields 9), eighteen fields as typed (values 18), seven shapes (shapes 7), three rows' plans (rows 3) and six selections
# (cells 6). Over the module, the clipboard card: Work's copy and the Ledger's (copied 2); the page's copy and a formula into
# the Bench pasted (pasted 2), the third exact (exact 1); tiled, one cell filling a range and at the corner (tiled, fills
# and corner 1 each; never "filled", held at zero in every case); two texts typed (typed 2); two edges (edges 2); four refusals, the
# Ledger's paste and cut, the Bench's value and a paste while a replay plays (refused 4); thirteen pastes of one frame each
# (frames 13); the cut standing (cut 1), moved and pasted again (moved 2), and let go thrice (letGo 3); the replay played
# (replayed 1); a paste at 30 frames a second (rate 1); Brickwork's Wall and Pace (game 2), Alonzo's page alone; and the
# browser's clipboard's double, a copy written and a paste and a copy refused (api 3).
# 2026-11-19, ENGINE.39's third slice, a formula's references moved: its page half lays four plans of a paste's formulas
# (laid 4); over the module, Excel's three moves through the thirteenth export (mover 1), the card's fill and the formula
# reading it pasted moved and one formula filling a range (formulas 2), a reference moved off the sheet (offSheet 1), a
# cut's move keeping its references and pasted once (kept 1), and at the owner's word at its hand test the cut's text
# pasted again as it was cut, once and unmoved (again 1), five pastes more (frames 18), and on Alonzo's page alone a gate
# of Naught's copied along its room (gate 1).
# 2026-11-19, after ENGINE.39's close, a cut tiled again at the owner's word at its push: its page half a fifth plan, a
# cut's fills tiled, each tile as it was cut, and a sixth, a cut's one formula filling a range a row a cell (laid 6); the
# cut's move and its paste again each tiled, over N60:N63 and P60:P63, and a cut of N60 alone filling R60:S61, every cell
# as it was cut (kept 2, again 1), a paste more (frames 19).
# 2026-11-19, the owner's pick at the tiling's hand test, the selection filled exactly: a rows plan cut at its edge (rows
# 4) and a laid plan (laid 7); the shapes' 2 by 2 copy over C5:E7 now filling it (shapes 7 still); over the module the
# 2 by 2 copy over G10:I12 filled exactly (partial 1), the block at the corner of G14:J14 a row smaller (corner 1), the
# cut's paste again over P60:P64 five cells (again 1), a paste more (frames 20).
# 2026-11-19, the owner's second note at the tiling's hand test, each dimension its own: two shapes more, a 2 by 1 copy
# over a row and a 2 by 2 over a column (shapes 9); over the module the 2 by 2 copy over G14:J14 tiled across it, its
# rows kept (across 1, in the place of corner).
$clipboardPageFloors = @{ chords = 15; bindings = 9; text = 3; fields = 9; values = 18; shapes = 9; rows = 4; cells = 6; laid = 7 }
$clipboardFloors = @{ copied = 2; pasted = 2; exact = 1; tiled = 1; fills = 1; partial = 1; across = 1; typed = 2; edges = 2; refused = 4; frames = 20; cut = 1; moved = 2; letGo = 3; replayed = 1; rate = 1; game = 2; api = 3; mover = 1; formulas = 2; offSheet = 1; kept = 2; again = 1; gate = 1 }
$clipboardGameFloors = @{ copied = 2; pasted = 2; exact = 1; tiled = 1; fills = 1; partial = 1; across = 1; typed = 2; edges = 2; refused = 4; frames = 20; cut = 1; moved = 2; letGo = 3; replayed = 1; rate = 1; api = 3; mover = 1; formulas = 2; offSheet = 1; kept = 2; again = 1 }
# 2026-10-18, CART.12's viewport slice, a code's text drawn: the twenty-seven cases' counts unchanged but for grid over
# the module, the grid card's row 16 of codes added, its counts a function of the card: codes 3, the row pinned by name
# at frames 1, 4 and 5; coded 213, the texts drawn from text rows over the 25 frames, the row's eight constants at the
# 20 frames before the Camera's second move and seven after it, B16 out of view, and G16 at the 18 frames its value has
# no look (at frames 4 to 24 by fours its value, 1 to 6, is a look's, General); hashes 193, the 168 before and H16 at
# all 25 frames, its floor 95, the four constants wider than any default column, H16's 1,234,567.89 the fourth. texts,
# fills, looks, styles, unvalued and probes grew with the row, each above its floor as it stood.
# 2026-10-18, CART.12, version 6: the twenty-seven cases' counts unchanged, and a twenty-eighth, settle, on both pages, its
# counts a function of its plan. Over the double (Min): the load's, an edit's and a press's acts each nine frames under
# (settle 8), unsettled and said (3) and under (settle 2) three (1), the Clock the acts, the press's place and its release.
# Over the module: the load settled at frame 2; the press on E2 at frames 3 to 10, the Clock 2 throughout and the press 1
# then 0; the same press again at 11; the edit made at the press's act landing at 11, after the spill's end at 9; the
# command by KeyS at 14, released by 16, KeyX passed on; the replay's frames the acts' four and the last, played to all 16;
# (settle 3) unsettled at frame 6; the directive refused twice; and a version 5 card's N at rate 0.
$settleFloors = @{ loaded = 1; spilled = 1; clock = 1; released = 1; place = 1; pressed = 1; again = 1; waited = 1; key = 1; passed = 1; commandReleased = 1;
                   said = 2; replayed = 1; replayFrames = 16; replaySame = 16; rowless = 1; unsettled = 1; refused = 1; fiveKey = 1 }
# 2026-10-20, CART.9's hand test: unread, a press over a cell of a cartridge that reads no act's place or press is the
# viewport's selection and no act, and after a person's formula reading the press the next press is one.
$settleDoubleFloors = @{ fakeWords = 8; fakeLoad = 1; fakeActs = 1; fakePress = 1; fakeReleased = 1; fakeUnsettled = 4; fakeReloaded = 1; unread = 2 }
# 2026-10-18, CART.12's third slice, Superposition the ninth cartridge: pass's sources and same 9; empty's cartridges,
# ordered and titled 9; and grid's game half over two grid cartridges, the grid card's 12 frames and Superposition's load
# settled at frame 2 on the 512 by 512 lattice, its Field shown and drawn from the values record cell for cell (grids 2,
# gridFrames 14, gridEqual 14, gridValues 13, gridCleared 2); its lattice draws fills and no text in the region shown.
# Mutant AP's words moved with it: the picker in reverse now offers Superposition second, after the empty sheet.
# 2026-10-19, CART.12's second hand test: the grid case's game half moves Superposition's Field after its load as a
# person moves it, the box grown, a page right, the last column, the last row, home and the box back, each held as a
# frame's sheet is (gridMoves 6, gridValues 13 to 19); its bound, the Field its extent A1:SR512 and no more (gridBound
# 1); and its tabs, the Observer's clicked and the Field's back each giving the grid the keys (gridFocused 2), and a
# box being typed in keeping them (gridTyped 1).
# 2026-10-18, CART.12's fourth slice, Superposition's replay and its hand: replay's hands 3, the block hand-superposition
# registered and matched beside hand-sand and hand-kairos; replays, golden and round 5; and the stand-in session, 27 acts
# over 113 frames, every frame held to the hand's Tally, the sum of each of the lattice's 512 rows (superpositionFrames
# 113, superpositionCells 57,856), its counts the hand's own: 25 acts on the Field (the Observer's Space and the branch
# act on no site), 2 worlds, 85 settle steps, a frame with no row, and 243 sites out of superposition at its end.
# 2026-10-19, CART.12's hand test: the owner's session in place of the stand-in (decision 7), 18 acts over 118 frames in
# one world, every frame held to the hand's Tally (superpositionFrames 118, superpositionCells 60,416), its counts the
# hand's own: 18 acts on the Field, 1 world, 99 settle steps and 637 sites out of superposition at its end. The acts and
# the worlds fell with the session, the stand-in's 25 and 2 being what its own session held, no measure of the host.
# 2026-10-19, CART.14's first slice, Seiyaku the tenth cartridge: pass's sources and same 10; empty's cartridges, ordered
# and titled 10, and mutant AP's words moved, the picker in reverse offering Seiyaku second, after the empty sheet;
# grid's game half over three grid cartridges, Seiyaku's Board loaded, settled and moved as Superposition's Field is
# (grids 3, gridFrames 16, gridEqual 15, gridValues 26, gridCleared 3, gridMoves 12, gridBound 2, gridFocused 4, gridTyped
# 2). Its gridTexts read 5,680 to 5,715 over four runs: Seiyaku's seed is the host's, so each run deals an instance of
# the second grade, of 24 to 32 givens, each drawn seven times, the rest of the case 5,491 to 5,512; so its floor is
# 5,650, under the least any such instance draws. And the replay's hands 4, the block hand-seiyaku, its book read
# from the page's own block source-seiyaku; replays, golden and round 6; and the stand-in session, 64 acts over 191
# frames, every frame held to the hand's Board, its 81 variables' codes and marks (seiyakuFrames 191, seiyakuCells
# 15,471), its counts the hand's own: 64 acts begun, the load's among them, 2 instances, 127 settle steps, and an
# instance satisfied. Mutant ET takes the control from one hundred and forty-nine mutant pages to one hundred and fifty.
# 2026-10-19, CART.14's hand test: the owner's session in place of the stand-in, 35 acts over 104 frames, every frame
# held to the hand's Board (seiyakuFrames 104, seiyakuCells 8,424), its counts the hand's own: 35 acts begun, the
# load's among them, 2 instances and 69 settle steps. Its frames, cells, acts and settles fell with the session, the
# stand-in's being what its own session held, no measure of the host; and the instance satisfied has no floor now,
# the owner's session satisfying none, which the engine's scripted session holds natively. Mutant ET moved with it,
# from a violated given, which the session never makes, to the hand's candidates, which its domains read at frame 15.
# And the grid case's game half holds a bound sheet on its canvas: Seiyaku's Board shown whole in a box grown to
# hold its extent, A1:L9 since the keys stand beside it, five pixels past its edge read the headers' gray (gridCanvas
# 5; Superposition's Field, 512 by 512, too large a box to grow). Its gridTexts read 5,783 to 5,810 over two runs at
# both ratios, the Board's rows taller and its keys' seventeen texts beside it, so its floor stays 5,650.
# Mutants EU, EV, EW and EX take the control from one hundred and fifty mutant pages to one hundred and fifty-four,
# and EY, the keypad's (the commands case's note), to one hundred and fifty-five.
# 2026-11-15, CART.14.1's second slice, the ladder, and its hand test: the owner's session in place of CART.14's, the
# grade to 3, an instance, the domains filled, I lit and applied five times, M four times, I again, P to the fixed
# point, satisfied, U, a violation said, the grade to 4, an instance and P stopping short; 26 acts over 158 frames,
# every frame held to the hand's Board and its words under it, B11 (seiyakuFrames 158, seiyakuCells 12,956, 82 a
# frame), its counts the hand's own: 26 acts begun, 3 instances, 132 settle steps, and an instance satisfied, its
# floor back. Mutant ET moved with it, to frame 12, where its domains are filled. Mutants KS, KT and KU, the hand's
# candidates blind to the strikes, its hidden singles read from a row's places for a column's and a column's for a
# row's, and a filter that strikes the marks it hides, fail the replay case at frames 63, 21 and 36.
# They take the control to two hundred and thirty-nine, landed after CART.9's fifth slice's HZ and IA.
# 2026-11-15, ENGINE.37's LR to LW take it to two hundred and forty-five, five of them needing no module (121 applicable).
# 2026-11-15, ENGINE.37's second slice: LX takes it to two hundred and forty-six, over the module (121 applicable without).
# 2026-11-15, CART.14.1's third slice, the light: Seiyaku's Board holds each variable's own digit where a code stood, and
# six rules light it; the hand answers the rules each variable is lit by and the replay case holds them to the record's
# lit rows, every frame of the owner's session (seiyakuLit 3,442, the lit cells held). Mutants LY, LZ and MA, the hand's
# reasons never lit, a pointing's box no reason, and a single's value not shown at its place before it is applied, fail
# the replay case at frames 15, 62 and 15, and take the control to two hundred and forty-nine, over the module.
# 2026-11-16, ENGINE.5: MB and MC take it to two hundred and fifty-one, the save case's, over the module (121 without).
# 2026-11-16, ENGINE.5's hand test: MD, a kept keymap offered nothing, the keys case's, takes it to two hundred and
# fifty-two, needing no module (122 applicable without).
# 2026-11-17, CART.3's first slice, Brickwork the twelfth cartridge, its floors and AP's words found unmoved by ENGINE.41's
# run of this control and moved: pass's sources and same 12; empty's cartridges, ordered and titled 12, and mutant AP's
# words moved, the picker in reverse offering Brickwork second, after the empty sheet; grid's game half over five grid
# cartridges, the Wall at rate 60 ticked at its own rate (grids 5, gridFrames 30, gridEqual 29, gridValues 51,
# gridCleared 5, gridMoves 24, gridBound 4, gridCanvas 15, gridFocused 8, gridTyped 4). Its gridTexts, gridEdges and
# gridFonts stand, each above its floor at both ratios, 6,155 texts, 62,281 and 61,583 edges, 872 and 868 fonts, their
# room kept for another platform's metrics.
# 2026-11-17, ENGINE.41: MM and MN, one viewport's mutation by each of the changes case's two holds of the painter's font,
# take it to two hundred and sixty-two, needing no module (124 applicable without).
# 2026-11-17, CART.3's second slice: MO to MR, version 7's, the commands case's over the module, take it to two hundred
# and sixty-six (124 applicable without).
# 2026-11-17, ENGINE.40's second slice: MS and MT, a file's drafts, the keep case's over the module, take it to two
# hundred and sixty-eight (124 applicable without).
# 2026-11-17 and 2026-11-18, CART.3's third slice: MU to NH, the drawer case's, needing no module, take it to two hundred
# and eighty-two (138 applicable without).
# 2026-11-18, ENGINE.39's first slice: NR to NV, version 8's repeats, the commands case's, NT needing no module, take it
# to two hundred and ninety-six (140 applicable without).
# 2026-11-19, ENGINE.39's second slice: NW to OA, the clipboard case's, NZ and OA needing no module, take it to three
# hundred and one (142 applicable without).
# 2026-11-19, ENGINE.39's third slice: OB to OE, the clipboard case's, each over the module, take it to three hundred and
# five (142 applicable without).
# 2026-11-19, after ENGINE.39's close, a cut tiled again at the owner's word at its push: OD inverted, a cut's paste
# untiled; and OF, a cut's one formula filling a range as one fill row, needing no module, take it to three hundred and
# six (143 applicable without).
# 2026-11-19, the owner's pick at the tiling's hand test, the selection filled exactly: OG and OH, needing no module, take
# it to three hundred and eight (145 applicable without).
# 2026-11-19, the owner's second note at the tiling's hand test, each dimension its own: OG's anchor moved with the line,
# and OI, needing no module, take it to three hundred and nine (146 applicable without).
# 2026-11-21, CART.16's second slice: OJ to OO, the file case's, four over the module and OM and OO needing none, take it
# to three hundred and fifteen (148 applicable without).
# 2026-11-18, CART.3's third slice: MO to MR, version 7's: pass's sources and same 11; empty's cartridges,
# ordered and titled 11, and mutant AP's words moved, the picker in reverse offering Naught second, after the empty
# sheet; grid's game half over four grid cartridges, the Bench loaded at rate 0 and settled, two frames, and
# moved, shown whole in a box grown to hold its extent A1:BI17, A1:BI18 since its labels (grids 4, gridFrames 18, gridEqual 16, gridValues 33,
# gridCleared 4, gridMoves 18, gridBound 3, gridCanvas 10, gridFocused 6, gridTyped 3). Its gridTexts read 8,824 and 8,834 at the two ratios, of which the
# Bench draws 3,059 every run (a game's page of Naught alone), so its floor is 5,650 and those, 8,709. And the
# replay's hands 5, the block hand-naught, its writer held line for line to the page's own block source-naught at
# its making; replays, golden and round 7; and the stand-in session, 38 switches written an act each over 78
# frames, each act and its settle two, every frame held to the hand's 400 gates (naughtFrames 78, naughtCells
# 31,200), its counts the hand's own:
# 38 switches written and 208 gates lit at its end. Mutant EZ takes the control to one hundred and fifty-six.
# CART.9's second slice: mutants FA, FB and FC, the palette case's, take it to one hundred and fifty-nine. And Naught
# opens on its Lesson, a sheet of its own bound to its extent, where it opened on the Bench: the grid case's game half
# draws the Lesson's 112 texts where it drew the Bench's 3,059, its gridTexts 5,902 and 5,916 at the two ratios, so its
# floor falls with the cartridge, 5,650 and those, 5,762.
# CART.9's hand test of the second slice, 2026-10-20: mutants FD, FE and FF, the palette case's, FG, the settle case's, and
# FH, the replay case's over the module, take it to one hundred and sixty-four: Backspace's emptied cell, Delete's row
# over its range, the window's own blur, a press no act on a cartridge that reads no act's rows, and a replay showing
# the sheet its person showed (naughtShown, the Bench at the first switch's act).
# SPEC.5, 2026-10-20: mutants FI to FT, each the modes case's, three templates, five hosts over the double and two over
# the module, take it to one hundred and seventy-four; and its hand test's FU and FV, Enter and Tab, to one hundred and
# seventy-six.
# CART.9's third slice, 2026-10-20: the game's levels. The replay's stand-in plays the levels after the bench, 71 acts
# over 706 frames, every frame held to the hand's game besides its bench (naughtFrames 784, naughtCells 842,800: the
# bench's 400 gates and the game's 675 cells a frame), 49 rows a person wrote (naughtWritten) and seven levels passed
# at its end (naughtPassed), its person showing ten sheets (naughtShown 10). At its hand test, 2026-10-21, the owner's
# session is the replay's first 45 frames, I and II played, and the stand-in follows it: the levels III to IX, the
# bench's 38 switches and I's switch written over, 782 frames (naughtFrames 782, naughtCells 840,650), 48 rows a
# person wrote and eight levels passed at its end, II's pass the owner's (naughtPassed 8). The modes case presses C3 on each of its
# card's five sheets, an act on the two game sheets alone (presses 5, on both pages). Mutant FW, the modes case's, and
# FX, FY, FZ and GA, the replay case's, take it to one hundred and eighty-one. Its rider, 2026-10-21: the settle case's double
# loads its card again and holds the status line to the reload's own sentence, the log counting it in its line
# (fakeReloaded 1); mutant GB, the settle case's, takes it to one hundred and eighty-two, and ninety without the module.
# And at the owner's word after it the log a line a run, a timeline across loads: the reload's sentence a line of its own
# after the first load's, each counting 1 (fakeReloaded 1 still), and GB's anchor the line's key.
# CART.9's short slice, 2026-10-24: a level's room read by its formulas, the Gates sheet's texts and kinds held to the
# hand with the Lab's six columns more, 2,313 cells of the game a frame where it held 675. The owner's 45 frames play
# against the new cartridge, and the stand-in after them runs ten frames longer, VI at the textbook's three gates and
# VII's idle gates deleted and tested again: 794 frames (naughtFrames 794, naughtCells 2,154,122, the bench's 400 gates
# and the game's 2,313 cells a frame), 51 rows a person wrote (naughtWritten 51) and eight levels passed still. EZ, FY
# and FZ move to frames 743, 108 and 792; and GW, GX, GY and GZ, the replay case's, take it to one hundred and
# eighty-nine after ENGINE.28's first slice's three, ninety-one without the module still. At its hand test, the owner's
# word: the floating palette's side by the window's halves, FC anchored on the new rule; and GV, the palette case's,
# needing no module, a cell's box forgetting the scroll, to one hundred and ninety, and ninety-two without the module.
# ENGINE.28's second slice, 2026-10-25: GF, a shared edge's tie the left cell's, needing no module, and GG, a repaint's
# band not grown, to one hundred and ninety-two, and ninety-three without the module. 2026-10-29, at its hand test: GH,
# a hidden neighbor's side taken, needing the module, to one hundred and ninety-three, still ninety-three without it.
# CART.9's fourth slice, 2026-10-30: Naught's replay runs through fifteen levels, 4,803 frames (naughtFrames 4803), 149 rows
# a person wrote (naughtWritten 149) and fourteen levels passed at its end (naughtPassed 14). Its frames are held as the
# engine's tests hold them (decision 44): the Lab's state and clock and each level an act, a test, a clock or a person's row
# could move, the bench at a row into it and the Gates at a block a row changed, and every cell one frame in 64, so that
# naughtCells, 1,608,754, is under what 794 frames held whole. EZ and FZ move to frames 4752 and 4801, GZ to 2; and HE to HN, the
# replay case's, take it ten pages higher, to two hundred and seven, and ninety-seven without the module still. The hand test's
# decision 49, a key on a game sheet a person writes the game's, or =, or nothing: modes' acts 39, and HO to HS, the modes case's,
# needing no module; with CART.14.1's KV to KY, which the words had not taken, two hundred and sixteen, and one hundred and six
# without the module. Decision 50, such a key refused in the bar: modes' bar 4 and fakeSaid 3, and HT, HU and HV, the modes
# case's, needing no module, to two hundred and nineteen, and one hundred and nine without the module. Decision 51, a settled
# act's frames in words and a command's name in single quotes: settle's fakeWords 8 and said 2, and HW, HX and HY, the settle
# case's, needing no module, to two hundred and twenty-two, and one hundred and twelve without the module.
# CART.9's fifth slice, 2026-11-15: the replay's tail, III's room given a gate dividing by zero and the cell emptied, 4,807
# frames (naughtFrames 4807, naughtCells 1,615,368), 151 rows a person wrote (naughtWritten 151) and eighteen sheets shown
# (naughtShown 18); HZ and IA, the replay case's, needing the module, to two hundred and thirty-six with ENGINE.36's twelve,
# and one hundred and sixteen without the module still.
# CART.3's third slice (c), 2026-11-18: Brickwork's replay, the owner's one game to level 81, held to its hand, the block
# hand-brickwork (hands 6): every one of its 41,129 frames (brickworkFrames 41129), the State's cells and the Tally's at
# each and the whole at the 1,085 that move its wall, the first and every 64th among them (brickworkWholes 1085,
# brickworkCells 4,146,108), the joints its rules light (brickworkLit 120,412), and its ends, the hand's own counts: level
# 81, 376 bricks laid, one game and one top-out; eight replays, goldens and recordings (replays, golden and round 8).
# NM to NP, the replay case's, needing the module, Brickwork's hand, to two hundred and ninety, and one hundred and
# thirty-nine without the module still.
# REPO.11, 2026-10-30: HA, the palette case's, needing no module, a blur never shutting the palette, to one hundred and
# ninety-four, and ninety-four without the module.
# ENGINE.14's addendum, 2026-10-30: the empty case's opening 3, a body with no mode hidden, the plane's box opening hidden and
# the Screen with no color of its own, so that a page over the network paints neither the bench's heading nor a dark Screen
# before its grid. HB, HC and HD, the empty case's, needing no module, to one hundred and ninety-seven, and ninety-seven
# without the module.
# 2026-10-17, ENGINE.25's second slice: the case's page half, pure and so on every page, module or not, its counts a function of
# its plan: 6 names a page writes a game's command by, held to the cartridge and the command or to none; 4 of the palette's
# lines, the command that holds with its own key, found by a word after the dot, the one that holds not no line, and one
# with no key; the keymap naming a game's commands read typed and kept (2); 4 of its refusals; 8 keys held to the binding
# each presses, a game's command's while it is live and passing on while not; a person's command running a game's twice;
# 5 of the list's words beside a game's command key; and 5 of the drawer's notes.
$commandsPageFloors = @{ named = 6; lines = 4; read = 2; refusals = 4; found = 8; steps = 1; shadow = 5; note = 5; order = 5; repeatWords = 15 }
# 2026-10-19, ENGINE.26: the twenty-eight cases' counts unchanged, and a twenty-ninth, widths, over the module on both
# pages, its counts a function of its plan, the same at both ratios under headless Chrome 155 on Windows: the opening
# on the Desk; a press on a divider that moved nothing raising nothing; 4 drags, each its sheet's own and its event
# naming that sheet (the Desk's D, the Ledger's, the Screen's B, and one pressed on the Desk while the Ledger came to
# show); 13 sheets held cell for cell at the oracle's own widths; the frame an edit steps keeping the Desk's; the
# Ledger's tab and the Desk's each at its own D (2); the Ledger's narrowed D viewed at rate 0 at once; its region
# estimated at its own widths and shown from the Desk; the Screen's B kept by its tab; every width kept by the source
# applied; the drag pressed on the Desk; and every width forgotten at a Load. texts 7,859, 2,336 of them formulas at
# frame 0, and 98 #s of the Desk's narrow D, each floor a margin below, a wider font drawing more #s, never fewer.
$widthsFloors = @{ opened = 1; clicked = 1; dragged = 4; held = 13; kept = 1; own = 2; rest = 1; fresh = 1; screen = 1; applied = 1; pressedOn = 1; forgotten = 1;
                   values = 7; texts = 7500; unvalued = 2000; hashes = 90 }
$scales = @('1', '1.5')
# 2026-11-16, ENGINE.5: the thirty-first case, save, over the module: every committed replay the page holds played to its
# middle and on to the first frame at rest, the host's own save taken there (saves 7, 2,730 KB of them), opened plainly at
# the Clock's frame with every sheet the run's (opened 7) and on the seed it ran on (seeds 7), and played on by the rest of
# its replay on a third host frame for frame beside the run (resumed 7), every sheet's fills held at the load, the frame
# after, every 64th frame and the last (compared 93, over 5,315 frames); and a save asked inside an act's settle waiting
# for it and handed to the page at rest, the three cartridges that settle (waited 3). Since CART.3's third slice (c), eight,
# Brickwork's game of 41,129 frames among them: saves, opened, seeds and resumed 8, compared 416 over 25,880 frames.
$saveFloors = @{ saves = 8; opened = 8; seeds = 8; resumed = 8; compared = 416; frames = 25880; waited = 3 }
# 2026-11-16, ENGINE.38: the thirty-second case, keep, over the module and a double of the browser's store: every
# committed replay the page holds played frame by frame with a keyframe at the first rest past every 37 frames, the run's
# work written at every frame at rest, and the tab dropped at frame 1, every 64th frame at rest and the last, a fresh page
# over what the browser kept offered the run and restoring it to every sheet's fills (cartridges 7, frames 10,903,
# restores and held 113, keyframes 189, eight of them Sand's live run drawn with the pointer, session 8); a run no person
# acted in keeping nothing (watched 1); a save written dropping the record, an act after it keeping it again (saved 1);
# Discard (discarded 1); a run another tab holds neither offered nor restored (tabs 2); a record of a later format and of
# a later page refused by name and left (stale 2), and one whose keyframe is not its frames' (torn 1); a ninth run
# dropping the oldest, said (capped 1); and a refused store said once, the run as without one (refused 1). The
# browser's own store answers nothing under the check's virtual clock (measured; its round trip holds over CDP in real
# time, store 1), so the case says so in a note and the double is the check's. Since ENGINE.40's first slice, the drawer's
# typing: a source typed in a run with no act kept, offered with its words and put back by a restore (typed 1); a run's
# typing its own across a cartridge picked, the next run carrying the boxes the pick left alone (switched 1); and typing a
# save leaves unsaved keeping the record (typedSaved 1). Since its second slice a save carries the typing, so typedSaved
# holds a save leaving nothing typed unsaved and a keystroke while the picker stood open kept; and a file's drafts, each
# box written after a save's rows over a raw string and taken back as typed (draftsRound 1), the file without them loading
# the grid as the save alone does (draftsLoaded 1). Since CART.3's third slice (c), eight cartridges, Brickwork's game
# among them: frames 52,032, restores and held 757, keyframes 1,300.
$keepFloors = @{ cartridges = 8; frames = 52032; restores = 757; held = 757; keyframes = 1300; session = 8; watched = 1; saved = 1; discarded = 1; tabs = 2; stale = 2; torn = 1; capped = 1; refused = 1; typed = 1; switched = 1; typedSaved = 1; draftsRound = 1; draftsLoaded = 1 }
# 2026-11-21, CART.16's second slice: the thirty-fifth case, file, a file opened, edited and saved (docs/SPEC.md section
# 3.11). Pure, the host's and the page's: where two files part, line for line and line ends and all, ten pairs
# (changes 10) and the words of each difference, a long line cut (words 9); a file's kind by its name, compared without
# case and never a cartridge's, what Open's picker offers, and what the page's picker says of a file opened, the cartridge
# and the file it reads, Afterlife (walter.pl), the owner's word at the hand test (kinds 11); over the double, which holds neither call, each
# declined in words (double 1). Over the module, a card of one sheet and its Format sheet, a file of settings: its type
# and the name a file is written under, the cartridge's own before a file is opened and the file's after (named 2); a
# file read into the cartridge's text, nothing loaded and the grid that runs as it was (read 1); that cartridge loaded
# and the open's check said, the sheet's own formula beside the file's rows (opened 1), a file of CR LF coming back as it
# is (same 1) and one written loosely said by its first line (loose 1); an edit its line in the file a person's save
# hands the page (edited 1), under the file's name, said (saved 1); the cartridge's own save and a person's save of the
# cartridge each a cartridge still (cartridge 2); a line no template reads refused by its number, nothing loaded
# (refused 1); a row no line says refused by its cell, nothing handed over (unwritten 1); a card written to version 8
# saving a cartridge and reading no file (none 1); and, where the load's act still settles, the check and a save each
# waiting for the grid to rest (waited 2). On Alonzo's own page, Afterlife's reel: its tabs written as a .pl of 934 lines,
# opened under the cartridge and written back byte for byte (golden 1, lines 934). A game's page runs it too, over the
# card, without Afterlife's.
$filePageFloors = @{ changes = 10; words = 9; kinds = 11; double = 1 }
$fileGameFloors = @{ named = 2; read = 1; opened = 1; same = 1; loose = 1; edited = 1; saved = 1; cartridge = 2; refused = 1; unwritten = 1; none = 1; waited = 2 }
$fileFloors = $fileGameFloors.Clone(); $fileFloors['golden'] = 1; $fileFloors['lines'] = 934
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
    @{ Case = 'pass';     Min = @{ declined = 1 }; WithModule = @{ sources = 12; same = 12; refused = 1; handle = 1; ranOn = 1 } },
    @{ Case = 'input';    Min = @{}; WithModule = @{ frames = 26; equal = 26; seed = 1; presses = 5; players = 2; clicks = 2; wheel = 3; typed = 4; code = 1; dice = 1; clicked = 11; pointer = 8; cursor = 16; held = 7; rate = 5; refused = 1 } },
    @{ Case = 'replay';   Min = @{ vectors = 5; liveFrames = 24; doubleSame = 1; doubleRound = 1; paced = 1; stopped = 1; waited = 1; refused = 6; hands = 6 }; WithModule = @{ digest = 1; seed = 1; recorded = 1; edits = 3; whole = 2; replays = 8; frames = 26; same = 26; golden = 8; round = 8; cardSame = 240; sandFrames = 2085; sandPainted = 453; kairosFrames = 3469; kairosCells = 156105; kairosStops = 30; superpositionFrames = 118; superpositionCells = 60416; superpositionActs = 18; superpositionWorlds = 1; superpositionSettles = 99; superpositionOpened = 637; seiyakuFrames = 158; seiyakuCells = 12956; seiyakuActs = 26; seiyakuInstances = 3; seiyakuSettles = 132; seiyakuLit = 3442; seiyakuSatisfied = 1; naughtFrames = 4807; naughtCells = 1615368; naughtEdits = 38; naughtLit = 208; naughtWritten = 151; naughtPassed = 14; naughtShown = 18; brickworkFrames = 41129; brickworkCells = 4146108; brickworkLit = 120412; brickworkWholes = 1085; brickworkLevel = 81; brickworkLaid = 376; brickworkGames = 1; brickworkTopouts = 1 } },
    @{ Case = 'audio';    Min = @{ frames = 43; sounded = 41; calls = 80; oscillators = 3; restarts = 5; skipped = 5; silences = 3; notices = 2; rate0 = 3; wanted = 1 }; WithModule = @{ cardFrames = 240; cardEqual = 240; cardSounded = 241; cardCalls = 248; ticks = 5; silenced = 1; cardNotices = 1; slow = 10; waterfall = 240; recorded = 1 } },
    @{ Case = 'sound';    Min = @{ frames = 49; settled = 19; rests = 17; steps = 8; dips = 2; releases = 5; waves = 4; notes = 6; span = 60 } },
    # 2026-10-24, ENGINE.28's first slice: the grid card's rows 17 and 18 are a format's appearance and its stripe starts
    # at row 19, two rows of looked and filled cells fewer in view at every frame, so the module half's texts, fills,
    # looks, unvalued, hidden and gridTexts, and tabs' texts over the same card, are lowered to the run's counts less a
    # margin; fakeLooks rises by the double's seventeenth look, the row of 200 that moves a frame; fonts and fakeFonts
    # count the texts a format dresses, held in their font, color and place. gridTexts, Seiyaku's random instance among
    # its cartridges, read 5,326 to 5,351 over six runs; its floor 5,250 leaves room for the instance with fewest givens,
    # as CART.14's did. Mutants GC, GD and GE, the grid case's,
    # take the control three mutant pages higher, GC needing no module (one more applicable without it).
    # 2026-10-25, ENGINE.28's second slice: edges and fakeEdges count the edges drawn as the record's borders resolve and
    # place them, the double's thin boxes on the row of 200 (531 over its frames) and the grid card's P18 to W18 (505);
    # each floor 5% below; the probes rise by two edges' samples a frame and a fill's gridlines, their floors standing.
    # 2026-10-29, at its hand test: the card's edges moved to row 2, I2 to P2, off the narrow, hidden and styled columns,
    # with an edge beside the hidden column and one beside the hidden row, 433 over the frames, row 2 leaving the view
    # where the person's scroll moves it down; edges 410, 5% below.
    # 2026-10-29, ENGINE.28's third slice: gridEdges and gridFonts count the edges and the dressed texts the game half
    # holds, so that a comparison of none cannot pass: the card's 325 edges and 156 texts before the slice, Seiyaku's
    # Board none; after it 1,471 edges at every run and both ratios, the Board's 1,146, and 327 to 354 texts over eleven
    # runs, the Board's givens, bold, and K3's keys, centered, by the host's instance, 24 to 32 givens in its book.
    # gridEdges 1,450, gridFonts 250, each above the card's alone, the fonts' room for the instance with fewest givens.
    # After ENGINE.28's close, Superposition's sites edged by their looks: gridEdges 50,929 at ratio 1 and 50,141 at
    # 1.5, the Field's about 49,000 beside the card's and the Board's; its floor 48,000, under both.
    # 2026-11-15, ENGINE.37: fakeRule, the double's A1 held by name lit at frame 1 and unlit at 2 (2), and fakeRules its fills
    # by its rule at the frames A1 is in view and lit (3); cardRules, the grid card's rows 17 and 18 held by name at frames
    # 1, 2, 21 and 22 (4), and rules the card's fills by a rule over the frames, 84, its floor 5% below.
# 2026-11-15, ENGINE.37's second slice: gridStrands, a font's lines the game half holds, the grid card's row 17 alone, 78
# at both ratios: Q17 to W17's seven strands and X17's two on the frames its rule lights.
# 2026-11-18, ENGINE.43: gridUnbound, the views card's Ledger moved as a person moves it, an unbound sheet whose extent
# grows with each record, its six moves each held inside the record's window and its last column and row inside the
# scroller's client area, at both ratios, on Alonzo's page and a game's; every other count as it stood. A page with
# no module moves no sheet, so a game's page counts it with the module alone, as Alonzo's does: CI's ratchets job,
# whose page carries none, found the game's floor in Min at the push.
    @{ Case = 'grid';     Min = @{ fakeFrames = 12; fakeEqual = 13; fakeWindows = 2; fakeTexts = 2300; fakeLooks = 2080; fakeUnvalued = 240; fakeProbes = 12; fakeKept = 10; fakeCleared = 1; fakeValues = 12; pointer = 1; key = 1; edited = 1; waits = 1; lone = 1; fakePatches = 8; fakeFonts = 170; fakeEdges = 500; sheetViews = 9; fakeRule = 2; fakeRules = 3 };
                            WithModule = @{ frames = 24; equal = 25; windows = 3; texts = 10300; wraps = 40; fills = 9150; looks = 8650; styles = 80; columns = 326; unvalued = 288; hidden = 17; probes = 70; kept = 22; followed = 1; edits = 1; cleared = 1; hashes = 200; values = 24; patches = 20; codes = 3; coded = 213; fonts = 260; edges = 410; cardRules = 4; rules = 80;
                                            grids = 5; gridFrames = 30; gridEqual = 29; gridValues = 51; gridTexts = 5250; gridCleared = 5; gridMoves = 24; gridBound = 4; gridCanvas = 15; gridFocused = 8; gridTyped = 4; gridEdges = 48000; gridFonts = 250; gridStrands = 78; gridUnbound = 6 } },
    @{ Case = 'tabs';     Min = @{ fakeFrames = 14; fakeShown = 1; fakeHeld = 8; fakeScrolled = 1; fakeBack = 1; fakeScreen = 9; fakePointer = 1; fakeRouted = 1; fakeKey = 1; fakeStrip = 1; fakeWheel = 4; fakeTexts = 4600 };
                            WithModule = @{ frames = 12; shown = 1; held = 5; back = 1; screen = 8; pointer = 1; routed = 1; strip = 1; wheel = 4; clock = 4; texts = 3100 } },
    @{ Case = 'empty';    Min = @{ cartridges = 12; ordered = 12; titled = 12; libraries = 1; double = 1; opening = 3 }; WithModule = @{ engine = 1 } },
    @{ Case = 'still';    Min = @{}; WithModule = $stillFloors },
    @{ Case = 'views';    Min = @{}; WithModule = $viewsFloors },
    @{ Case = 'changes';  Min = @{ crafted = 20; double = 32 }; WithModule = $changesFloors },
    @{ Case = 'continue'; Min = @{}; WithModule = $continueFloors },
    @{ Case = 'palette';  Min = $paletteFloors },
    @{ Case = 'drawer';   Min = $drawerFloors },
    @{ Case = 'keys';     Min = $keysFloors },
    @{ Case = 'commands'; Min = $commandsPageFloors; WithModule = $commandsFloors },
    @{ Case = 'settle';   Min = $settleDoubleFloors; WithModule = $settleFloors },
    @{ Case = 'widths';   Min = @{}; WithModule = $widthsFloors },
    @{ Case = 'modes';    Min = $modesPageFloors; WithModule = $modesFloors },
    @{ Case = 'save';     Min = @{}; WithModule = $saveFloors },
    @{ Case = 'keep';     Min = @{}; WithModule = $keepFloors },
    @{ Case = 'clipboard'; Min = $clipboardPageFloors; WithModule = $clipboardFloors },
    @{ Case = 'file';     Min = $filePageFloors; WithModule = $fileFloors }
)
$zero = @('live', 'misfrees', 'filled', 'alone')
$expectedCases = 35
# ENGINE.16: a game's page, built on every run from a scratch folder holding Kairos alone, its cartridge, source,
# replay, golden and hand and the library its source includes. Its loop runs the twenty cases that need nothing
# of Alonzo's own files, over its own blocks, still since ENGINE.17, views since ENGINE.18, changes since
# ENGINE.19, continue since ENGINE.7, palette and keys since ENGINE.23, commands since ENGINE.25, settle since CART.12,
# widths since ENGINE.26, modes since SPEC.5, save since ENGINE.5, keep since ENGINE.38, drawer since CART.3's
# third slice, clipboard since ENGINE.39's second, Brickwork's Ctrl+X its one part left to Alonzo's own page, and file
# since CART.16's second, Afterlife's reel its one part left to Alonzo's own page, among them, and each of the fifteen
# others says it is not on the page.
$gameFloors = @(
    @{ Case = 'abi';    Min = @{ refused = 3 }; WithModule = @{ attached = 1 } },
    @{ Case = 'pass';   Min = @{}; WithModule = @{ sources = 1; same = 1 } },
    @{ Case = 'replay'; Min = @{ vectors = 5; hands = 1 }; WithModule = @{ replays = 1; golden = 1; round = 1; kairosFrames = 3469; kairosCells = 156105; kairosStops = 30 } },
    @{ Case = 'grid';   Min = @{ grids = 0 }; WithModule = @{ gridUnbound = 6 } },
    @{ Case = 'empty';  Min = @{ cartridges = 1; ordered = 1; titled = 1; libraries = 1; double = 1; opening = 3 }; WithModule = @{ engine = 1 } },
    @{ Case = 'still';  Min = @{}; WithModule = $stillFloors },
    @{ Case = 'views';  Min = @{}; WithModule = $viewsFloors },
    @{ Case = 'changes'; Min = @{ crafted = 20; double = 32 }; WithModule = $changesFloors },
    @{ Case = 'continue'; Min = @{}; WithModule = $continueFloors },
    @{ Case = 'palette'; Min = $paletteFloors },
    @{ Case = 'drawer'; Min = $drawerFloors },
    @{ Case = 'keys'; Min = $keysFloors },
    @{ Case = 'commands'; Min = $commandsPageFloors; WithModule = $commandsFloors },
    @{ Case = 'settle'; Min = $settleDoubleFloors; WithModule = $settleFloors },
    @{ Case = 'widths'; Min = @{}; WithModule = $widthsFloors },
    @{ Case = 'modes'; Min = $modesPageFloors; WithModule = $modesGameFloors },
    @{ Case = 'save'; Min = @{}; WithModule = @{ saves = 1; opened = 1; seeds = 1; resumed = 1 } },
    @{ Case = 'keep'; Min = @{}; WithModule = @{ cartridges = 1; restores = 1; held = 1; watched = 1; saved = 1; discarded = 1; tabs = 2; stale = 2; torn = 1; capped = 1; refused = 1; typed = 1; switched = 1; typedSaved = 1; draftsRound = 1; draftsLoaded = 1 } },
    @{ Case = 'clipboard'; Min = $clipboardPageFloors; WithModule = $clipboardGameFloors },
    @{ Case = 'file'; Min = $filePageFloors; WithModule = $fileGameFloors }
)
$gameAbsent = @('rate30', 'rate0', 'yield', 'slice', 'pace', 'memory', 'refusals', 'scale', 'engine', 'parity', 'plane', 'input', 'audio', 'sound', 'tabs')
$gameCases = 20
$gameFiles = @('kairos/kairos.vla', 'kairos/kairos.source.vla', 'kairos/kairos.replay.vla', 'kairos/kairos.golden.vla', 'kairos/kairos.hand.js', 'common.vla')
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
function Get-PageUrl([string]$path, [string]$cases = '') {
    $slashed = [System.IO.Path]::GetFullPath($path) -replace '\\', '/'
    # a replay case's filter (REPO.8): replay:sand plays sand's committed replay alone, replay: none of them, and
    # replay:naught:34 naught's to its frame 34 and no further
    $names = New-Object System.Collections.Generic.List[string]
    $replays = $null
    $upto = $null
    foreach ($c in @($cases -split ',' | Where-Object { $_ -ne '' })) {
        if ($c -notlike 'replay:*') { $names.Add($c); continue }
        $names.Add('replay')
        $parts = $c.Substring(7) -split ':'
        $replays = $parts[0]
        if ($parts.Count -gt 1) { $upto = $parts[1] }
    }
    $query = '?loop=1' + $(if ($names.Count) { '&cases=' + ($names -join ',') } else { '' }) + $(if ($null -ne $replays) { '&replays=' + $replays } else { '' }) + $(if ($null -ne $upto) { '&upto=' + $upto } else { '' })
    if ($slashed.StartsWith('/')) { return 'file://' + $slashed + $query }
    return 'file:///' + $slashed + $query
}
# The cases a run's list names, each filter left out: abi,input,replay:sand names abi, input and replay.
function Get-CaseNames([string]$cases) { return @($cases -split ',' | Where-Object { $_ -ne '' } | ForEach-Object { ($_ -split ':')[0] }) }
# A run's folder removed, its browser's children given a moment to let go of it.
function Remove-LoopTemp([string]$dir) {
    for ($i = 0; $i -lt 100 -and (Test-Path -LiteralPath $dir); $i++) {
        Remove-Item -Recurse -Force $dir -ErrorAction SilentlyContinue
        if (Test-Path -LiteralPath $dir) { Start-Sleep -Milliseconds 50 }
    }
}
# A run's limit (0.3.0's first CI, 2026-10-30): a browser that never writes its whole dump and never exits would hold the
# check for as long as it was let, and one held controls.yml's Windows job to GitHub's six hours, which left no log, where
# this machine's same run ends in two minutes. So a run past ten minutes, several times the longest met on the slowest
# runner, is ended and said by its page and its cases, and a third such stops the check, so that its names reach the log
# before a step's limit does. A machine asleep past it reads the same, and a run again answers it.
$script:LoopRunLimit = 600
$script:LoopRunsOver = New-Object System.Collections.Generic.List[string]
# One headless run started (REPO.8): the browser over the page with its cases, its DOM dumped into a folder of its own,
# its profile there too, so that runs side by side share nothing. $cases, a comma-separated list, runs those cases alone
# (a mutant page's, 2026-10-15); empty runs every case.
function Start-LoopRun([string]$browser, [string]$page, [string]$scale, [string]$cases = '') {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_loop_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    $dump = Join-Path $tmp 'dump.html'
    $err = Join-Path $tmp 'err.txt'
    $argList = @('--headless=new', '--disable-gpu', '--run-all-compositor-stages-before-draw', '--disable-frame-rate-limit', '--disable-gpu-vsync',
                 '--virtual-time-budget=60000', ('--force-device-scale-factor=' + $scale), '--window-size=1600,1200', '--no-first-run', '--no-default-browser-check',
                 ('--user-data-dir="' + (Join-Path $tmp 'profile') + '"'))
    if (-not $onWindows) { $argList += @('--no-sandbox', '--disable-dev-shm-usage') }
    $argList += @('--dump-dom', ('"' + (Get-PageUrl $page $cases) + '"'))
    $start = @{ FilePath = $browser; ArgumentList = $argList; RedirectStandardOutput = $dump; RedirectStandardError = $err; PassThru = $true }
    if ($onWindows) { $start['NoNewWindow'] = $true }
    $watch = [System.Diagnostics.Stopwatch]::StartNew()
    $proc = Start-Process @start
    return @{ Proc = $proc; Tmp = $tmp; Dump = $dump; Watch = $watch; Size = -1; Seconds = $null; Over = $false; Page = $page; Cases = $cases; Err = $err }
}
# A run ended (REPO.8): its browser exited, or its dump whole, ending in </html> and grown no more since the last look, the
# browser ended then. A browser writes the whole dump and then shuts down, and beside another instance its shutdown on
# Windows waited on a system service's reply, up to 120 s a time, its page long done: four of Naught's replays side by
# side took 145 to 270 s each, and ended at their dumps 26. The dump's one </html> is its last.
function Test-LoopRunDone($run) {
    if ($null -ne $run.Seconds) { return $true }
    if (-not $run.Proc.HasExited -and $run.Watch.Elapsed.TotalSeconds -ge $script:LoopRunLimit) {
        $run.Over = $true
        try { $run.Proc.Kill() } catch {}
    }
    elseif (-not $run.Proc.HasExited) {
        if (-not (Test-Path -LiteralPath $run.Dump)) { return $false }
        $fs = $null
        try {
            $fs = New-Object System.IO.FileStream($run.Dump, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
            $n = $fs.Length
            if ($n -lt 16 -or $n -ne $run.Size) { $run.Size = $n; return $false }
            $k = [int][Math]::Min(64, $n)
            $buf = New-Object byte[] $k
            $null = $fs.Seek($n - $k, [System.IO.SeekOrigin]::Begin)
            $null = $fs.Read($buf, 0, $k)
            if ([System.Text.Encoding]::UTF8.GetString($buf).TrimEnd() -notlike '*</html>') { return $false }
        } catch { return $false } finally { if ($fs) { $fs.Dispose() } }
        try { $run.Proc.Kill() } catch {}
    }
    $run.Seconds = $run.Watch.Elapsed.TotalSeconds
    $null = $run.Proc.WaitForExit(60000)
    return $true
}
# A started run's answer: the loop element's text, or '' with the reason, and its seconds. Its browser's children may
# hold the dump a moment longer, so it is read beside them. -Defer leaves the folder for the caller to sweep once every
# run has ended.
function Complete-LoopRun($run, [switch]$Defer) {
    while (-not (Test-LoopRunDone $run)) { Start-Sleep -Milliseconds 50 }
    $seconds = $run.Seconds
    try {
        if ($run.Over) {
            $wrote = $(if (Test-Path -LiteralPath $run.Dump) { (Get-Item -LiteralPath $run.Dump).Length } else { 0 })
            $said = ''
            try { $said = ((Get-Content -LiteralPath $run.Err -Tail 3 -ErrorAction Stop) -join ' | ') } catch { }
            if ($said.Length -gt 400) { $said = $said.Substring($said.Length - 400) }
            $over = "the browser over {0} with the cases '{1}' had not ended after {2:N0} s, {3:N0} bytes of its dump written, its stderr '{4}': ended by the run's limit" -f (Split-Path -Leaf $run.Page), $run.Cases, $seconds, $wrote, $said
            $script:LoopRunsOver.Add($over)
            if ($script:LoopRunsOver.Count -ge 3) { throw ("three runs ended by the run's limit, so the check stops here: " + ($script:LoopRunsOver -join '; ')) }
            return @{ Text = ''; Reason = $over; Seconds = $seconds }
        }
        if (-not (Test-Path -LiteralPath $run.Dump)) { return @{ Text = ''; Reason = 'the browser wrote no dump'; Seconds = $seconds } }
        $fs = New-Object System.IO.FileStream($run.Dump, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
        try { $html = (New-Object System.IO.StreamReader($fs, (New-Object System.Text.UTF8Encoding($false)))).ReadToEnd() } finally { $fs.Dispose() }
        $m = [regex]::Match($html, '(?s)<pre id="loop"[^>]*>(.*?)</pre>')
        if (-not $m.Success) { return @{ Text = ''; Reason = ("no loop block in the dump ({0:N0} characters)" -f $html.Length); Seconds = $seconds } }
        $text = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value).Trim()
        if ($text -eq '') { return @{ Text = ''; Reason = 'the loop block is empty'; Seconds = $seconds } }
        return @{ Text = $text; Reason = ''; Seconds = $seconds }
    } finally {
        if (-not $Defer) { Remove-LoopTemp $run.Tmp }
    }
}
# One headless run, started and answered.
function Invoke-Loop([string]$browser, [string]$page, [string]$scale, [string]$cases = '') {
    return Complete-LoopRun (Start-LoopRun $browser $page $scale $cases)
}
# Runs side by side (REPO.8): each run of $plan, @{ Key; Page; Scale; Cases }, in its order, started while fewer than $jobs
# run, each answered into $results by its key as its browser exits, their folders swept once every run has ended. $plan
# is typed an array: in Windows PowerShell 5.1, @($v) over a generic list held by a variable fails to compile ("Argument
# types do not match").
function Invoke-LoopPool([object[]]$plan, [int]$jobs, $results) {
    $queue = New-Object System.Collections.Generic.Queue[object]
    foreach ($p in @($plan)) { $queue.Enqueue($p) }
    $running = New-Object System.Collections.Generic.List[object]
    $folders = New-Object System.Collections.Generic.List[string]
    try {
        while ($queue.Count -gt 0 -or $running.Count -gt 0) {
            while ($running.Count -lt $jobs -and $queue.Count -gt 0) {
                $p = $queue.Dequeue()
                $running.Add(@{ Plan = $p; Run = (Start-LoopRun $script:browser $p.Page $p.Scale $p.Cases) })
            }
            Start-Sleep -Milliseconds 25
            for ($i = $running.Count - 1; $i -ge 0; $i--) {
                $e = $running[$i]
                if (-not (Test-LoopRunDone $e.Run)) { continue }
                $results[$e.Plan.Key] = Complete-LoopRun $e.Run -Defer
                $folders.Add($e.Run.Tmp)
                $running.RemoveAt($i)
            }
        }
    } finally {
        foreach ($e in $running) { try { $e.Run.Proc.Kill() } catch {} }
    }
    foreach ($d in $folders) { Remove-LoopTemp $d }
}
# REPO.8's plan, the control's: $script:LoopMode is '' (each page built and run in its turn), 'plan' (each page's build
# started in the background, at most -Jobs at a time, and each run noted) or 'run' (each run answered from the pool).
$script:LoopMode = ''
$script:Planned = New-Object System.Collections.Generic.List[object]
$script:PlannedKeys = @{}
$script:Answers = @{}
$script:Builds = New-Object System.Collections.Generic.List[object]
$script:BuiltPages = @{}
$script:Misses = 0
$script:AloneRuns = 0
$script:AloneSeconds = 0.0
$builderShell = if (Get-Command powershell.exe -ErrorAction SilentlyContinue) { 'powershell.exe' } else { 'pwsh' }
# A page built by tools/build_web.ps1 with $builderArgs: at once in its turn; in the plan pass started in the
# background, at most -Jobs builds at a time, each page built once; in the run pass already built.
function Invoke-PageBuild([string]$name, [string[]]$builderArgs, [string]$out, [string]$failure) {
    if ($script:LoopMode -eq 'run' -and $script:BuiltPages.ContainsKey($out)) { return }
    if ($script:LoopMode -eq 'plan') {
        if ($script:BuiltPages.ContainsKey($out)) { throw "the page $name is built twice in the plan, so that one page would answer for two mutants" }
        while (@($script:Builds | Where-Object { -not $_.Proc.HasExited }).Count -ge $Jobs) { Start-Sleep -Milliseconds 10 }
        $quoted = @($builderArgs | ForEach-Object { if ($_ -match '[\s"]') { '"' + $_ + '"' } else { $_ } })
        $start = @{ FilePath = $builderShell; ArgumentList = $quoted; PassThru = $true; RedirectStandardOutput = ($out + '.out.txt'); RedirectStandardError = ($out + '.err.txt') }
        if ($onWindows) { $start['NoNewWindow'] = $true }
        $proc = Start-Process @start
        if ($onWindows) { $null = $proc.Handle }   # held, so that Windows PowerShell reads its exit code after it exits
        $script:Builds.Add(@{ Proc = $proc; Out = $out; Failure = $failure })
        $script:BuiltPages[$out] = $true
        return
    }
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { $null = & $builderShell @builderArgs 2>&1; $code = $LASTEXITCODE } finally { $ErrorActionPreference = $prev }
    if ($code -ne 0 -or -not (Test-Path -LiteralPath $out)) { throw $failure }
    $script:BuiltPages[$out] = $true
}
# Every build the plan started, ended with its page written, or the first that failed named as it would have been.
function Wait-PageBuilds {
    foreach ($b in $script:Builds) {
        $b.Proc.WaitForExit()
        if ($b.Proc.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $b.Out)) { throw $b.Failure }
    }
}
# A run's place in the pool: the replay case's longest games first, Naught's or every game's, then its others, then the
# grid's, then by the number of cases it runs, so that the pool's last runs are its shortest.
function Get-RunWeight([string]$cases) {
    $names = @(Get-CaseNames $cases)
    $filter = @($cases -split ',' | Where-Object { $_ -like 'replay:*' })
    $base = 0
    if ($names.Count -eq 0 -or $names.Count -ge 10) { $base = 100 }
    elseif ($names -contains 'replay') {
        $cut = $(if ($filter.Count) { [regex]::Match($filter[0], ':(\d+)$') } else { $null })
        $long = $filter.Count -eq 0 -or ($filter[0] -like '*naught*' -and -not ($cut.Success -and [int]$cut.Groups[1].Value -lt 200))
        $base = $(if ($long) { 100 } else { 10 })
    }
    elseif ($names -contains 'grid') { $base = 4 }
    return $base + $names.Count
}
# One run of the control's: at once in its turn, or with -Now in the plan pass; noted in the plan pass, its answer a
# stand-in, since the plan pass judges nothing; answered from the pool in the run pass, or made then and counted as a
# run the plan missed.
function Invoke-Planned([string]$page, [string]$scale, [string]$cases, [switch]$Now) {
    $key = $page + '|' + $scale + '|' + $cases
    if ($script:LoopMode -eq 'plan' -and -not $Now -and @(Get-CaseNames $cases) -contains 'sound') {
        # the sound case renders in real time and a starved processor fails it: made now, every build the plan started
        # ended first and none started meanwhile, where after the pool the machine was still busy with its aftermath
        Wait-PageBuilds
        if (-not $script:Answers.ContainsKey($key)) {
            $w = [System.Diagnostics.Stopwatch]::StartNew()
            $script:Answers[$key] = Invoke-Loop $browser $page $scale $cases
            $script:AloneRuns++
            $script:AloneSeconds += $w.Elapsed.TotalSeconds
        }
        return $script:Answers[$key]
    }
    if ($script:LoopMode -eq 'plan' -and -not $Now) {
        if (-not $script:PlannedKeys.ContainsKey($key)) {
            $script:PlannedKeys[$key] = $true
            $script:Planned.Add(@{ Key = $key; Page = $page; Scale = $scale; Cases = $cases; Alone = (@(Get-CaseNames $cases) -contains 'sound'); Weight = (Get-RunWeight $cases); Order = $script:Planned.Count })
        }
        return @{ Text = ''; Reason = 'planned and not yet run' }
    }
    if ($script:LoopMode -eq '') { return Invoke-Loop $browser $page $scale $cases }
    if (-not $script:Answers.ContainsKey($key)) {
        if ($script:LoopMode -eq 'run') { $script:Misses++ }
        $script:Answers[$key] = Invoke-Loop $browser $page $scale $cases
    }
    return $script:Answers[$key]
}
# A game's page (ENGINE.16) in $dir: a scratch folder holding Kairos alone, its cartridge, source, replay, golden
# and hand and the library its source includes, built by tools/build_web.ps1 with no fixtures and Kairos its one
# name. -Hand replaces the hand's text (a mutant's), -NoHand leaves the hand out, -Template names a mutant template.
function New-GamePage([string]$dir, [string]$name, [string]$Hand = '', [switch]$NoHand, [string]$Template = '') {
    $out = Join-Path $dir ($name + '.html')
    if ($script:LoopMode -eq 'run' -and $script:BuiltPages.ContainsKey($out)) { return $out }   # the plan pass built it (REPO.8)
    $carts = Join-Path $dir ($name + '_cartridges')
    $fix = Join-Path $dir ($name + '_fixtures')
    New-Item -ItemType Directory -Path (Join-Path $carts 'kairos') -Force | Out-Null
    New-Item -ItemType Directory -Path $fix -Force | Out-Null
    foreach ($f in $gameFiles) {
        $to = Join-Path $carts $f
        if ($f -like '*.hand.js') {
            if ($NoHand) { continue }
            if ($Hand -ne '') { [System.IO.File]::WriteAllText($to, $Hand, (New-Object System.Text.UTF8Encoding($false))); continue }
        }
        Copy-Item -LiteralPath (Join-Path $repoRoot ('cartridges/' + $f)) -Destination $to
    }
    $builderArgs = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', (Join-Path $PSScriptRoot 'build_web.ps1'), '-CartridgesDir', $carts, '-FixturesDir', $fix, '-PageOrder', 'kairos', '-Out', $out)
    if ($Template -ne '') { $builderArgs += @('-Template', $Template) }
    Invoke-PageBuild $name $builderArgs $out "the builder could not build the game's page $name"
    return $out
}
# The judgment of one run's text at one scale: the problems, and the case lines to print. A game's page
# (ENGINE.16) is judged by its own floors, its own count of cases, and the cases each must say are not on it. $only,
# a run of some cases alone (a mutant page's, 2026-10-15), judges those cases' floors and counts them alone, and the
# header must name them.
function Test-Loop([string]$text, [string]$scale, [object[]]$table = $floors, [int]$want = $expectedCases, [string[]]$absent = @(), [string[]]$only = @()) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = @($text -split "`n" | ForEach-Object { $_.TrimEnd("`r") })
    $header = $lines[0]
    if ($header -notlike 'loop: host *') { $problems.Add("the first line is not the loop oracle's header: $header") }
    if ($only.Count -gt 0) {
        $table = @($table | Where-Object { $only -contains $_.Case })
        $want = $table.Count
        if ($header -notlike ('*; asked=' + ($only -join ',') + ';*')) { $problems.Add("the page's header names no cases asked as " + ($only -join ',') + ": $header") }
    }
    $dm = [regex]::Match($header, 'dpr=([0-9.]+)')
    if (-not $dm.Success -or $dm.Groups[1].Value -ne $scale) { $problems.Add("the page saw a ratio of '$($dm.Groups[1].Value)', the run asked for $scale") }
    $cases = @{}
    $caseLines = New-Object System.Collections.Generic.List[string]
    $notHere = @{}
    foreach ($l in $lines) {
        $nh = [regex]::Match($l, '^case (\S+): not on this page')
        if ($nh.Success) { $notHere[$nh.Groups[1].Value] = $true; continue }
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
    foreach ($name in $absent) {
        if (-not $notHere.ContainsKey($name)) { $problems.Add("the case $name, Alonzo's own, did not say it is not on this page") }
        if ($cases.ContainsKey($name)) { $problems.Add("the case $name, Alonzo's own, ran on a game's page") }
    }
    foreach ($name in @($notHere.Keys | Sort-Object)) { if ($absent -notcontains $name) { $problems.Add("the case $name said it is not on this page, where it runs") } }
    foreach ($f in $table) {
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
    elseif ([int]$Matches[1] -ne $want) { $problems.Add("the oracle ran $($Matches[1]) case(s), not the $want pinned here") }
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
        # A run's limit proved: a page that never yields, so that its browser never dumps, ended by it and said by name.
        $hung = Join-Path $tmp 'hung.html'
        [System.IO.File]::WriteAllText($hung, '<!doctype html><script>for (;;) {}</script>', $utf8)
        $limit = $script:LoopRunLimit
        $script:LoopRunLimit = 5
        $rH = Invoke-Loop $browser $hung '1' 'never'
        $script:LoopRunLimit = $limit
        $script:LoopRunsOver.Clear()
        if ($rH.Text -ne '' -or $rH.Reason -notlike "*hung.html*'never'*ended by the run's limit" -or $rH.Seconds -gt 60) { Write-Output ("FAIL: a page that never yields was not ended by the run's limit: {0}" -f $rH.Reason); exit 1 }
        Write-Output ("control: a page that never yields, ended by the run's limit in {0:N1} s" -f $rH.Seconds)
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
            $builderArgs = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $builder, '-Template', $tplPath, '-HostJs', $jsPath, '-FakeJs', $fakePath, '-CartridgesDir', $cartsPath, '-ViewportJs', $viewportPath, '-Out', $out)
            Invoke-PageBuild $name $builderArgs $out "the builder could not build the mutant page $name"
            return $out
        }
        # A mutant page runs abi, which names the page's module, and the cases its reason is judged by, not every
        # case (2026-10-15, fix 5 of the controls' time); a replay case's filter, replay:<names>, plays those games'
        # committed replays alone (REPO.8). The real page and the game's page run every case.
        function Get-MutantCases([string]$cases) { return 'abi' + $(if ($cases -ne '') { ',' + $cases } else { '' }) }
        function Invoke-Mutant([string]$page, [string]$cases) { return Invoke-Planned $page '1' (Get-MutantCases $cases) }
        function Test-Mutant($run, [string]$cases, [object[]]$table = $floors) {
            if ($run.Text -eq '') { return @{ Problems = @($run.Reason) } }
            return Test-Loop $run.Text '1' $table $expectedCases @() @(Get-CaseNames (Get-MutantCases $cases))
        }
        # The pool's line, after the plan and its runs (REPO.8).
        function Get-PoolNote {
            $s = $script:PoolStats
            return ("pool: {0} pages built in the background, at most {1} at a time, and {5} run(s) of the sound case alone, in {2:N1} s ({6:N1} s of the runs alone); {3} runs side by side, the longest first, in {4:N1} s, the longest {8:N1} s ({9}); {7} run(s) the plan missed" -f $s.Builds, $Jobs, $s.BuildSeconds, $s.Pooled, $s.PoolSeconds, $s.Alone, $s.AloneSeconds, $script:Misses, $s.Longest, $s.LongestName)
        }
        $realNames = @($floors | ForEach-Object { $_.Case })
        $realParts = @(, @('abi', 'sound')) + @(, @('abi', 'input', 'replay')) + @(, @('abi', 'save')) + @(, @('abi', 'keep')) + @(, @($realNames | Where-Object { @('input', 'replay', 'sound', 'save', 'keep') -notcontains $_ }))
        # The control's code, run twice since REPO.8, a plan pass and a run pass, as its end says.
        $controlBody = {
        # the real page first: its module, which decides the mutants that apply, read at once by abi alone; then, as the
        # check runs them, the sound case alone, the input and replay cases, and every other case (REPO.8)
        $r0m = Invoke-Planned $Page '1' 'abi' -Now
        $j0 = @{ Problems = New-Object System.Collections.Generic.List[string] }
        foreach ($part in $realParts) {
            $run = Invoke-Planned $Page '1' ($part -join ',')
            if ($run.Text -eq '') { $j0.Problems.Add($run.Reason); continue }
            foreach ($p in @((Test-Loop $run.Text '1' $floors $expectedCases @() $part).Problems)) { $j0.Problems.Add($p) }
        }
        # mutant A: the accumulator's cap raised; the header must say so and the stall must fail
        $anchorA = 'var ACCUMULATOR_CAP_MS = 250;'
        if (([regex]::Matches($js, [regex]::Escape($anchorA))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorA' is not in web/host.js exactly once"; exit 1 }
        $jsA = Join-Path $tmp 'a.js'; [System.IO.File]::WriteAllText($jsA, $js.Replace($anchorA, 'var ACCUMULATOR_CAP_MS = 2500;'), $utf8)
        $rA = Invoke-Mutant (New-MutantPage 'a' $template $jsA) 'rate30'
        $aApplied = ($rA.Text -ne '') -and ($rA.Text.Split("`n")[0] -like '*cap=2500*')
        $jA = Test-Mutant $rA 'rate30'
        $aStall = @($jA.Problems | Where-Object { $_ -like '*rate30*after tick 60 the host is at frame*' }).Count
        # mutant B: the derived writes issued after the inputs; the edit of State!B1 must lose and fail by name
        $anchorB = "    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs`n    this._issueInputs();    // step 3: the Input rows, then a person's edits, each its own write"
        $swapB = "    this._issueInputs();    // step 3: the Input rows, then a person's edits, each its own write`n    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs"
        if (([regex]::Matches($js, [regex]::Escape($anchorB))).Count -ne 1) { Write-Output "FAIL: the two lines of the frame's writes are not in web/host.js exactly once, in order"; exit 1 }
        $jsB = Join-Path $tmp 'b.js'; $mutB = $js.Replace($anchorB, $swapB); [System.IO.File]::WriteAllText($jsB, $mutB, $utf8)
        $bApplied = ([regex]::Matches($mutB, [regex]::Escape($swapB))).Count -eq 1
        $rB = Invoke-Mutant (New-MutantPage 'b' $template $jsB) 'rate30'
        $jB = Test-Mutant $rB 'rate30'
        $bLost = @($jB.Problems | Where-Object { $_ -like '*must win over the derived write*' }).Count
        # mutant C: the loop element cut from the template
        $anchorC = '<pre id="loop" class="result">'
        if (([regex]::Matches($tpl, [regex]::Escape($anchorC))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorC' is not in the template exactly once"; exit 1 }
        $tplC = Join-Path $tmp 'c.template.html'; [System.IO.File]::WriteAllText($tplC, $tpl.Replace($anchorC, '<pre id="loop-cut" class="result">'), $utf8)
        $rC = Invoke-Mutant (New-MutantPage 'c' $tplC $hostJs) ''
        $cNoBlock = ($rC.Text -eq '') -and ($rC.Reason -like 'no loop block*')
        # mutant D, when the real page holds the engine's module: the reference Life lets a cell
        # survive on three neighbors alone; the engine case must fail by name at frame 11
        $moduleReal = 0
        if ($r0m.Text -ne '') { $am = [regex]::Match($r0m.Text, 'case abi: [^\n]*module (\d+)'); if ($am.Success) { $moduleReal = [int]$am.Groups[1].Value } }
        $dApplied = $false; $dFailed = 0; $dNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorD = 'next[i] = (others === 3 || (me === 1 && others === 2)) ? 1 : 0;'
            if (([regex]::Matches($tpl, [regex]::Escape($anchorD))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorD' is not in the template exactly once"; exit 1 }
            $mutD = $tpl.Replace($anchorD, 'next[i] = (others === 3 || (me === 1 && others === 3)) ? 1 : 0;')
            $dApplied = $mutD -cne $tpl
            $tplD = Join-Path $tmp 'd.template.html'; [System.IO.File]::WriteAllText($tplD, $mutD, $utf8)
            $rD = Invoke-Mutant (New-MutantPage 'd' $tplD $hostJs) 'engine'
            $jD = Test-Mutant $rD 'engine'
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
        $rE = Invoke-Mutant (New-MutantPage 'e' $template $jsE) 'scale'
        $jE = Test-Mutant $rE 'scale'
        $eFailed = @($jE.Problems | Where-Object { $_ -like '*case scale*after the reload the cell*' }).Count
        # mutant F: the canvas left as it was at an unload; the scale case's refused load must fail by name
        $anchorF = '    this._clear();'
        if (([regex]::Matches($js, [regex]::Escape($anchorF))).Count -ne 1) { Write-Output "FAIL: the clear at an unload is not in web/host.js exactly once"; exit 1 }
        $mutF = $js.Replace($anchorF, '    // the clear cut by the control')
        $fApplied = $mutF -cne $js
        $jsF = Join-Path $tmp 'f.js'; [System.IO.File]::WriteAllText($jsF, $mutF, $utf8)
        $rF = Invoke-Mutant (New-MutantPage 'f' $template $jsF) 'scale'
        $jF = Test-Mutant $rF 'scale'
        $fFailed = @($jF.Problems | Where-Object { $_ -like '*case scale*after a refused load the cell*' }).Count
        # mutant G: a refusal said without its mark; the rate30 case must fail, a refusal not marked as one
        $anchorG = "Host.prototype._refuse = function (text) { this._say(text, 'event', true); };"
        if (([regex]::Matches($js, [regex]::Escape($anchorG))).Count -ne 1) { Write-Output "FAIL: the refusal's mark is not in web/host.js exactly once"; exit 1 }
        $mutG = $js.Replace($anchorG, "Host.prototype._refuse = function (text) { this._say(text, 'event', false); };")
        $gApplied = $mutG -cne $js
        $jsG = Join-Path $tmp 'g.js'; [System.IO.File]::WriteAllText($jsG, $mutG, $utf8)
        $rG = Invoke-Mutant (New-MutantPage 'g' $template $jsG) 'rate30'
        $jG = Test-Mutant $rG 'rate30'
        $gFailed = @($jG.Problems | Where-Object { $_ -like '*case rate30*a refusal is not marked as one*' }).Count
        # mutant H: the Camera read after the plane is drawn; the plane is a frame late and the plane case must fail by name
        $anchorH = "    if (d.camera) this._readCamera();`n    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();"
        $swapH = "    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();`n    if (d.camera) this._readCamera();"
        if (([regex]::Matches($js, [regex]::Escape($anchorH))).Count -ne 1) { Write-Output "FAIL: the three reads of a frame's effects are not in web/host.js exactly once, in order"; exit 1 }
        $mutH = $js.Replace($anchorH, $swapH)
        $hApplied = ([regex]::Matches($mutH, [regex]::Escape($swapH))).Count -eq 1
        $jsH = Join-Path $tmp 'h.js'; [System.IO.File]::WriteAllText($jsH, $mutH, $utf8)
        $rH = Invoke-Mutant (New-MutantPage 'h' $template $jsH) 'plane'
        $jH = Test-Mutant $rH 'plane'
        $hFailed = @($jH.Problems | Where-Object { $_ -like "*case plane*in the host's plane and*by the record of*" }).Count
        # mutant I: the blit masks a byte to the palette; a byte past it draws as a color, and the plane case's pixels must fail
        $anchorI = '    for (var i = 0; i < n; i++) px[i] = pal[bytes[i]];'
        if (([regex]::Matches($js, [regex]::Escape($anchorI))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorI' is not in web/host.js exactly once"; exit 1 }
        $mutI = $js.Replace($anchorI, '    for (var i = 0; i < n; i++) px[i] = pal[bytes[i] & 15];')
        $iApplied = $mutI -cne $js
        $jsI = Join-Path $tmp 'i.js'; [System.IO.File]::WriteAllText($jsI, $mutI, $utf8)
        $rI = Invoke-Mutant (New-MutantPage 'i' $template $jsI) 'plane'
        $jI = Test-Mutant $rI 'plane'
        $iFailed = @($jI.Problems | Where-Object { $_ -like '*case plane*reads*not 255,0,255*' }).Count
        # mutant J: the double reads a formula without a value as 255 again; the plane case must fail over the double
        $anchorJ = '    if (!e || e.v === undefined) return 0;   // nothing here, or a formula with no value'
        if (([regex]::Matches($fk, [regex]::Escape($anchorJ))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorJ' is not in web/fake.js exactly once"; exit 1 }
        $mutJ = $fk.Replace($anchorJ, '    if (!e) return 0;')
        $jApplied = $mutJ -cne $fk
        $fkJ = Join-Path $tmp 'j.fake.js'; [System.IO.File]::WriteAllText($fkJ, $mutJ, $utf8)
        $rJ = Invoke-Mutant (New-MutantPage 'j' $template $hostJs $fkJ) 'plane'
        $jJ = Test-Mutant $rJ 'plane'
        $jFailed = @($jJ.Problems | Where-Object { $_ -like "*case plane*fake frame*holds 255 in the host's plane and 0 by the record*" }).Count
        # mutant K, when the real page holds the engine's module: a scratch copy of cartridges/ whose
        # library writes the Palette's names to column D; the page's pass writes rows the command line
        # did not, and the pass case must fail by name. Anchored since CART.9's short slice on the row as
        # KIT.5 spells it, by address-expand, where it stood on the symbol spelling KIT.5 replaced
        $kApplied = $false; $kFailed = 0; $kNote = 'not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $cartsK = Join-Path $tmp 'cartridges_k'
            $libK = Join-Path $cartsK 'common.vla'
            $lib = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/common.vla'))
            $anchorK = '(cell "Palette" (address-expand (+expand index 1) 3)'
            if (([regex]::Matches($lib, [regex]::Escape($anchorK))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorK' is not in cartridges/common.vla exactly once"; exit 1 }
            $mutK = $lib.Replace($anchorK, '(cell "Palette" (address-expand (+expand index 1) 4)')
            $kApplied = $mutK -cne $lib
            if (-not (Test-Path -LiteralPath $cartsK)) {   # the plan pass's copy serves the run pass (REPO.8)
                Copy-Item -Recurse -LiteralPath (Join-Path $repoRoot 'cartridges') -Destination $cartsK
                [System.IO.File]::WriteAllText($libK, $mutK, $utf8)
            }
            $rK = Invoke-Mutant (New-MutantPage 'k' $template $hostJs '' $cartsK) 'pass'
            $jK = Test-Mutant $rK 'pass'
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
        $rL = Invoke-Mutant (New-MutantPage 'l' $template $jsL) 'rate30,input'
        $jL = Test-Mutant $rL 'rate30,input'
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
            $rM = Invoke-Mutant (New-MutantPage 'm' $template $jsM) 'input'
            $jM = Test-Mutant $rM 'input'
            $mFailed = @($jM.Problems | Where-Object { $_ -like '*case input*before its interval was owed*' }).Count
            $anchorN = "    else if (c.seed === 'host') this._seed();"
            if (([regex]::Matches($js, [regex]::Escape($anchorN))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorN' is not in web/host.js exactly once"; exit 1 }
            $mutN = $js.Replace($anchorN, '    // the seed cut by the control')
            $nApplied = $mutN -cne $js
            $jsN = Join-Path $tmp 'n.js'; [System.IO.File]::WriteAllText($jsN, $mutN, $utf8)
            $rN = Invoke-Mutant (New-MutantPage 'n' $template $jsN) 'input'
            $jN = Test-Mutant $rN 'input'
            $nFailed = @($jN.Problems | Where-Object { $_ -like '*case input*Clock!B3 holds*' }).Count
            # mutant O (ENGINE.3's hand test): the backlog held to the quarter second whatever the rate,
            # as it was, which starved the teacher's rate of 1; the input case must fail at the frame it never ran
            $anchorO = '    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), Math.max(ACCUMULATOR_CAP_MS, 1000 / c.rate));'
            if (([regex]::Matches($js, [regex]::Escape($anchorO))).Count -ne 1) { Write-Output "FAIL: the accumulator's line is not in web/host.js exactly once"; exit 1 }
            $mutO = $js.Replace($anchorO, '    this.acc = Math.min(this.acc + Math.min(dt, ACCUMULATOR_CAP_MS), ACCUMULATOR_CAP_MS);')
            $oApplied = $mutO -cne $js
            $jsO = Join-Path $tmp 'o.js'; [System.IO.File]::WriteAllText($jsO, $mutO, $utf8)
            $rO = Invoke-Mutant (New-MutantPage 'o' $template $jsO) 'input'
            $jO = Test-Mutant $rO 'input'
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
            $rP = Invoke-Mutant (New-MutantPage 'p' $template $jsP) 'input,replay:'
            $jP = Test-Mutant $rP 'input,replay:'
            $pFailed = @($jP.Problems | Where-Object { $_ -like '*case replay*does not log the edit*' }).Count
            $anchorQ = '    this._issueDerived();   // section 5, step 2: the derived writes, before the inputs'
            if (([regex]::Matches($js, [regex]::Escape($anchorQ))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorQ' is not in web/host.js exactly once"; exit 1 }
            $mutQ = $js.Replace($anchorQ, '    if (!this.player) this._issueDerived();   // the derived writes cut from a replay by the control')
            $qApplied = $mutQ -cne $js
            $jsQ = Join-Path $tmp 'q.js'; [System.IO.File]::WriteAllText($jsQ, $mutQ, $utf8)
            $rQ = Invoke-Mutant (New-MutantPage 'q' $template $jsQ) 'input,replay:inputcard'
            $jQ = Test-Mutant $rQ 'input,replay:inputcard'
            $qFailed = @($jQ.Problems | Where-Object { $_ -like '*case replay*that is not its golden*' }).Count
            $anchorR = "    if (String(str(f[1])).toLowerCase() === 'input') rec.input = null;   // the Input sheet unknown to the replay: its next rows are logged whole"
            if (([regex]::Matches($js, [regex]::Escape($anchorR))).Count -ne 1) { Write-Output "FAIL: the Input sheet's record made unknown is not in web/host.js exactly once"; exit 1 }
            $mutR = $js.Replace($anchorR, "    // the Input sheet's record kept across a person's edit of it, by the control")
            $rApplied = $mutR -cne $js
            $jsR = Join-Path $tmp 'r.js'; [System.IO.File]::WriteAllText($jsR, $mutR, $utf8)
            $rR = Invoke-Mutant (New-MutantPage 'r' $template $jsR) 'input,replay:'
            $jR = Test-Mutant $rR 'input,replay:'
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
            $rS = Invoke-Mutant (New-MutantPage $mu.L $template $jsS) 'audio'
            # not $jS: names fold case here, and $jS would be $js, the host's text the next mutant reads
            $sJudge = Test-Mutant $rS 'audio'
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
        $rX = Invoke-Mutant (New-MutantPage 'x' $tplX $jsX) 'audio,sound'
        $jX = Test-Mutant $rX 'audio,sound'
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
        $rY = Invoke-Mutant (New-MutantPage 'y' $template $jsY) 'input,replay:'
        $jY = Test-Mutant $rY 'input,replay:'
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
        $rZ = Invoke-Mutant (New-MutantPage 'z' $template $jsZ) 'slice'
        $zApplied = ($mutZ -cne $js) -and ($rZ.Text -ne '') -and ($rZ.Text.Split("`n")[0] -like '*slice=0.5;*')
        $jZ = Test-Mutant $rZ 'slice'
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
        $rAA = Invoke-Mutant (New-MutantPage 'aa' $template $jsAA) 'pace'
        $aaApplied = ($mutAA -cne $js) -and ($rAA.Text -ne '') -and ($rAA.Text.Split("`n")[0] -like '* snap=0 slice=*')
        $jAA = Test-Mutant $rAA 'pace'
        $aaFailed = @($jAA.Problems | Where-Object { $_ -cmatch 'case pace.*at a rate of 60, on ticks 16\.6 or 16\.7 ms apart, a tick presents one frame, and tick 2 presented 0' }).Count
        $aaNote = "the tick on no grid applied ($aaApplied) and failed the pace case ($aaFailed)"
        $aaOk = $aaApplied -and $aaFailed -ge 1
        # The two hands' files (ENGINE.16, before it the template's): a scratch copy of cartridges/ with one hand
        # mutated, and the real page built from it.
        $sandHandText = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/sand/sand.hand.js'))
        $kairosHandText = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/kairos/kairos.hand.js'))
        function New-HandCopy([string]$name, [string]$file, [string]$text) {
            $carts = Join-Path $tmp ('cartridges_' + $name)
            if (Test-Path -LiteralPath $carts) { return $carts }   # the plan pass's copy (REPO.8)
            Copy-Item -Recurse -LiteralPath (Join-Path $repoRoot 'cartridges') -Destination $carts
            [System.IO.File]::WriteAllText((Join-Path $carts $file), $text, $utf8)
            return $carts
        }
        # mutant AB (CART.2's second slice), when the real page holds the engine's module: Sand's hand paints a
        # brush without its rim, < where the cartridge's Gate says <=; Sand's committed replay paints with the rim,
        # and the replay case must fail it by name at the first frame the rim lands.
        $abApplied = $false; $abFailed = 0; $abNote = 'the brush without its rim: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorAB = '      return dr * dr + dc * dc <= brush.radius * brush.radius ? brush.material : -1;'
            if (([regex]::Matches($sandHandText, [regex]::Escape($anchorAB))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorAB' is not in cartridges/sand/sand.hand.js exactly once"; exit 1 }
            $mutAB = $sandHandText.Replace($anchorAB, '      return dr * dr + dc * dc < brush.radius * brush.radius ? brush.material : -1;')
            $abApplied = $mutAB -cne $sandHandText
            $rAB = Invoke-Mutant (New-MutantPage 'ab' $template $hostJs '' (New-HandCopy 'ab' 'sand/sand.hand.js' $mutAB)) 'input,replay:sand'
            $jAB = Test-Mutant $rAB 'input,replay:sand'
            $abFailed = @($jAB.Problems | Where-Object { $_ -like "*case replay*sand's committed replay, played on a fresh host, is not its hand's at frame*" }).Count
            $abNote = "the brush without its rim applied ($abApplied) and failed the replay case ($abFailed)"
        }
        $abOk = ($moduleReal -eq 0) -or ($abApplied -and $abFailed -ge 1)
        # mutant AI (CART.4's second slice), when the real page holds the engine's module: Kairos's hand turns a
        # row a column early, its right end at the board's sixth column where the cartridge turns it at the
        # seventh; Kairos's committed replay slides rows to both ends of the board, and the replay case must fail
        # it by name at the first frame a row reaches the seventh column.
        $aiApplied = $false; $aiFailed = 0; $aiNote = 'the turn a column early: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorAI = '    var turn = (this.direction === 1 && right >= KAIROS.columns) || (this.direction === -1 && this.left <= 1);'
            if (([regex]::Matches($kairosHandText, [regex]::Escape($anchorAI))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorAI' is not in cartridges/kairos/kairos.hand.js exactly once"; exit 1 }
            $mutAI = $kairosHandText.Replace($anchorAI, '    var turn = (this.direction === 1 && right >= KAIROS.columns - 1) || (this.direction === -1 && this.left <= 1);')
            $aiApplied = $mutAI -cne $kairosHandText
            $rAI = Invoke-Mutant (New-MutantPage 'ai' $template $hostJs '' (New-HandCopy 'ai' 'kairos/kairos.hand.js' $mutAI)) 'input,replay:kairos'
            $jAI = Test-Mutant $rAI 'input,replay:kairos'
            $aiFailed = @($jAI.Problems | Where-Object { $_ -like "*case replay*kairos's committed replay, played on a fresh host, is not its hand's at frame*" }).Count
            $aiNote = "the turn a column early applied ($aiApplied) and failed the replay case ($aiFailed)"
        }
        $aiOk = ($moduleReal -eq 0) -or ($aiApplied -and $aiFailed -ge 1)
        # mutant EG (CART.12's fourth slice), when the real page holds the engine's module: Superposition's hand keeps the
        # press and the command at a settle step, where the engine releases them before the first; the committed replay,
        # the owner's session since CART.12's hand test, seals a box on V21 by the command box at frame 15, so the hand
        # opens it again at its settle's first step, frame 16, and the replay case must fail it by name at that frame.
        $egApplied = $false; $egFailed = 0; $egNote = 'the release kept from the hand: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $superHandText = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/superposition/superposition.hand.js'))
            $anchorEG = "    if (!rows.length) { input.B13 = { num: 0 }; input.B14 = { num: 0 }; input.B15 = { num: 0 }; input.B20 = ''; this.settles++; }"
            if (([regex]::Matches($superHandText, [regex]::Escape($anchorEG))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorEG' is not in cartridges/superposition/superposition.hand.js exactly once"; exit 1 }
            $mutEG = $superHandText.Replace($anchorEG, '    if (!rows.length) { this.settles++; }')
            $egApplied = $mutEG -cne $superHandText
            $rEG = Invoke-Mutant (New-MutantPage 'eg' $template $hostJs '' (New-HandCopy 'eg' 'superposition/superposition.hand.js' $mutEG)) 'input,replay:superposition'
            $jEG = Test-Mutant $rEG 'input,replay:superposition'
            $egFailed = @($jEG.Problems | Where-Object { $_ -like "*case replay*superposition's committed replay, played on a fresh host, is not its hand's at frame*" }).Count
            $egNote = "the release kept from the hand applied ($egApplied) and failed the replay case ($egFailed)"
        }
        $egOk = ($moduleReal -eq 0) -or ($egApplied -and $egFailed -ge 1)
        # mutants AC, AD, AE, AF and AH (ENGINE.8), over the double and so with or without the engine's module,
        # and AG when the real page holds it: a viewport that reads no value row, one that matches no look, a host
        # that draws each frame without keeping the view, a host that draws the grid before it reads the Camera,
        # a host silent over an edit made while the loop is paused at its rate (the owner's hand test), and a
        # viewport that lays every row at the default height. And AQ, AR and AS (ENGINE.8's second slice), over the
        # double: a host that draws the grid record at every frame, one that draws the values record at frame 0 too,
        # and a viewport that reads no style row for a cell no row wrote. And DU, DV and DW (CART.12, a code's text
        # drawn): a viewport that reads no text row, one that counts a code's format row malformed, and a host whose
        # record by cell takes no text row as a cell's, so that it never lays a window's changes on the grid card's
        # record. The grid case must fail each by name.
        $gridMutants = @(
            @{ L = 'ac'; Name = 'the value row unread'; File = 'viewport'; Anchor = "    } else if (head === 'value') {"; With = "    } else if (head === 'value-unread') {"
               Want = 'case grid.*fake frame 1: \w+\d+ \("\d+"\) is not drawn' },
            @{ L = 'ad'; Name = 'no look matched'; File = 'viewport'; Anchor = '    if (cell && cell.lookKey !== null && Object.prototype.hasOwnProperty.call(model.looks, cell.lookKey)) {'; With = '    if (false) {'
               # ENGINE.28: with no look matched the double's row of 200 loses its look's centering as well as its fill, and the
               # compare names a cell's place before it reaches the fills, so either line is the mutant's
               Want = 'case grid.*fake frame 1: (\w+\d+''s fill, #[0-9A-Fa-f]{6} by its look, is not drawn|\w+\d+ is drawn at \d+,\d+, and the record places it at \d+,\d+)' },
            @{ L = 'ae'; Name = 'the view not kept'; File = 'host'; Anchor = '      vp.load(r.text, { keep: !atLoad });'; With = '      vp.load(r.text);'
               Want = 'case grid.*fake frame 3: (the viewport shows A1 at its top left, and the Camera at L1|the selection is A1, where the person selected C5)' },
            @{ L = 'af'; Name = 'the grid drawn before the Camera is read'; File = 'host'
               Anchor = "    if (d.camera) this._readCamera();`n    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();`n    if (this.cart.mode === 'grid') this._drawGrid(false, true);   // the record through the frame's own Camera (ENGINE.8), a still one not drawn again (ENGINE.17)"
               With = "    if (this.cart.mode === 'grid') this._drawGrid(false, true);   // the record through the frame's own Camera (ENGINE.8), a still one not drawn again (ENGINE.17)`n    if (d.camera) this._readCamera();`n    if (d.palette) this._readPalette();`n    if (this.cart.mode === 'plane') this._drawPlane();"
               Want = 'case grid.*fake frame 3: the viewport shows A1 at its top left, and the Camera at L1 puts L1 there' },
            @{ L = 'ag'; Name = 'every row at the default height'; File = 'viewport'; Module = $true; Anchor = '    if (model && model.rowSettings) {'; With = '    if (false) {'
               Want = 'case grid.*engine frame 0: (A9|B9|A10|B10|C10|A11|B11|A12|B12)\b' },
            @{ L = 'ah'; Name = 'a paused edit unsaid'; File = 'host'; Anchor = '    else if (this.cart.rate > 0 && !this.running) this._answer('; With = '    else if (false) this._answer('
               Want = 'case grid.*fake: the edit \(cell "Screen" "W7" 1\), made while the loop was paused at its rate, was not said to wait' },
            @{ L = 'aq'; Name = 'the grid record at every frame'; File = 'host'; Anchor = "    var t0 = this.now(), projection = this.frame > 0 ? 'values' : 'grid';"; With = "    var t0 = this.now(), projection = 'grid';"
               Want = 'case grid.*fake frame 1: the host drew the grid record of [A-Z]+\d+:[A-Z]+\d+, where the values record is due' },
            @{ L = 'ar'; Name = 'the values record at frame 0'; File = 'host'; Anchor = "    var t0 = this.now(), projection = this.frame > 0 ? 'values' : 'grid';"; With = "    var t0 = this.now(), projection = 'values';"
               Want = 'case grid.*fake frame 0: the host drew the values record of [A-Z]+\d+:[A-Z]+\d+, where the grid record is due' },
            @{ L = 'as'; Name = 'the lone style row unread'; File = 'viewport'; Anchor = '      if (a && !e && n !== null) e = formulaCell(m, a, reach);'; With = '      // the lone style row unread, by the control'
               Want = 'case grid.*values read whole: C1''s fill, #00AA00 by its style, is not drawn' },
            @{ L = 'du'; Name = 'the text row unread'; File = 'viewport'; Anchor = "    } else if (head === 'text') {"; With = "    } else if (head === 'text-unread') {"
               Want = 'case grid.*values read whole: D1 shows "1\.5", and the record says "1\.50"' },
            @{ L = 'dv'; Name = 'a code''s format malformed'; File = 'viewport'; Anchor = "(num !== 'general' && num !== 'text' && code === null)"; With = "(num !== 'general' && num !== 'text')"
               Want = 'case grid.*values read whole: the viewport answers D1 as .*"malformed":1.*, where it draws 1\.50 for the value 1\.5 from one text row, every row known' },
            @{ L = 'dw'; Name = 'a text row no cell''s'; File = 'host'; Module = $true; Anchor = '  var CELL_LINE = /^\((?:cell|value|text|style|sentence|formula|lit|empty) "(?:[^"\\]|\\.)*" "([A-Z]+)([0-9]+)"/;'
               With = '  var CELL_LINE = /^\((?:cell|value|style|sentence|formula|lit|empty) "(?:[^"\\]|\\.)*" "([A-Z]+)([0-9]+)"/;'
               Want = 'the case grid at a ratio of 1 counted \d+ patches, below its floor of 20' }
        )
        $gridNotes = New-Object System.Collections.Generic.List[string]
        $gridJudged = New-Object System.Collections.Generic.List[object]
        $gridOk = $true
        # And EI, EJ and EK (CART.12's second hand test, 2026-10-19), over the engine's module, Superposition's Field moved
        # as a person moves it: a viewport whose resize raises no event, so that the host never views the region a box
        # grown shows; one that bounds no sheet, so that the Field lays slack past its extent; and one whose tab chosen
        # leaves the keys where they were, so that the arrows move nothing on the sheet shown.
        $gridMutants += @(
            @{ L = 'ei'; Name = 'a resize unsaid'; File = 'viewport'; Module = $true; Anchor = "    this._onResize = function () { self._resize(); self._draw(); self._emit('scroll', self._scrollPayload()); };"; With = '    this._onResize = function () { self._resize(); self._draw(); };'
               Want = 'case grid.*superposition frame 0, Field, the box grown: the viewport shows Field![A-Z]+\d+:[A-Z]+\d+, past the record''s window' },
            @{ L = 'ej'; Name = 'the bound ignored'; File = 'viewport'; Module = $true; Anchor = '    var extent = env.bound ? ((model && model.extent) || (layout && layout.extent) || null) : null;'; With = '    var extent = null;'
               Want = 'case grid.*superposition frame 0, Field: the bound sheet Field lays \d+ columns and \d+ rows, where its extent A1:SR512 is 512 and 512' },
            @{ L = 'ek'; Name = 'a tab chosen leaving the keys'; File = 'viewport'; Module = $true; Anchor = "    else this._emit('sheet', { name: name, loaded: false, state: sh ? sh.state : 'visible' });`n    this._focusGrid();"; With = "    else this._emit('sheet', { name: name, loaded: false, state: sh ? sh.state : 'visible' });"
               Want = 'case grid.*superposition frame 0: the tab \w+ clicked showed \w+ and left the keys with ' }
        )
        # And EU, EV, EW and EX (CART.14's hand test, 2026-10-19), over the engine's module, Seiyaku's Board shown whole in a
        # box grown to hold it: a viewport whose bound sheet stands on the background, white past its edge; one whose
        # gridlines cross a bound sheet's canvas, failed over Naught's Lesson since ENGINE.28's third slice, Seiyaku's Board
        # drawing no gridlines; one whose column headers' edge runs on past its last column; and one whose
        # row headers' edge runs on below its last row.
        $gridMutants += @(
            @{ L = 'eu'; Name = 'the canvas the background'; File = 'viewport'; Module = $true; Anchor = '    ctx.fillStyle = g.bounded ? this.colors.header : this.colors.background;'; With = '    ctx.fillStyle = this.colors.background;'
               Want = 'case grid.*seiyaku frame 0, Board: the pixel past its last column, in its first row, at \d+,\d+, reads 255,255,255, where a bound sheet stands on the canvas' },
            @{ L = 'ev'; Name = 'the gridlines across the canvas'; File = 'viewport'; Module = $true; Anchor = '        if (g.bounded) { top = Math.max(top, cellsY); bottom = Math.min(bottom, cellsB); left = Math.max(left, cellsX); right = Math.min(right, cellsR); }'; With = '        // the lines across the quadrant, by the control'
               Want = 'case grid.*naught frame 0, Lesson: the pixel below its last row, where its first column''s line would run on, at \d+,\d+, reads 217,217,210, where a bound sheet stands on the canvas' },
            @{ L = 'ew'; Name = 'the column headers'' edge run on'; File = 'viewport'; Module = $true; Anchor = '        if (g.bounded) end = Math.min(end, ox + g.colX[cEnd + 1] - scroll);'; With = '        // the column headers'' edge across the band, by the control'
               Want = 'case grid.*seiyaku frame 0, Board: the pixel past its last column, where the column headers'' edge would run on, at \d+,\d+, reads 217,217,210, where a bound sheet stands on the canvas' },
            @{ L = 'ex'; Name = 'the row headers'' edge run on'; File = 'viewport'; Module = $true; Anchor = '        if (g.bounded) end = Math.min(end, oy + g.rowTop(rEnd + 1) - scroll);'; With = '        // the row headers'' edge down the band, by the control'
               Want = 'case grid.*seiyaku frame 0, Board: the pixel below its last row, where the row headers'' edge would run on, at \d+,\d+, reads 217,217,210, where a bound sheet stands on the canvas' }
        )
        # ENGINE.28 (2026-10-24): a viewport that passes over a format row's groups, as it did until this item, which
        # the grid case must fail over the double at the row of 200, drawn right-aligned in the default ink where its
        # look says white, bold and centered; one whose look replaces the cell's own format whole, which the grid card's
        # N17, centered by its own format under the look of 77, must fail by its place; and one that fits no row of no
        # height to its tallest own size, which the card's row 17, fitted to its 22-point cell, must fail by every cell's
        # place.
        $gridMutants += @(
            @{ L = 'gc'; Name = 'the groups passed over'; File = 'viewport'; Anchor = '        if (!readGroups(f, fmt, 5)) { m.counts.malformed++; return; }'; With = '        // the groups passed over, by the control'
               Want = 'case grid.*fake frame 1: \w+\d+ is drawn (at \d+,\d+, and the record places it at \d+,\d+|in the font 13px [^,]+, and the record says bold)' },
            @{ L = 'gd'; Name = 'the look whole'; File = 'viewport'; Module = $true; Anchor = '        if (!model.styled && !model.bordered && !model.partial) return lf;'; With = '        if (true) return lf;   // the look whole, by the control'
               Want = 'case grid.*engine frame \d+: N17 is drawn at \d+,\d+, and the record places it at \d+,\d+' },
            @{ L = 'ge'; Name = 'no row fitted'; File = 'viewport'; Module = $true; Anchor = '        if (px > DEFAULT_ROW_PX && (fits[e.row] === undefined || px > fits[e.row])) fits[e.row] = px;'; With = '        // no row fitted, by the control'
               Want = 'case grid.*engine frame \d+: [A-O]17 is drawn at \d+,\d+, and the record places it at \d+,\d+' },
            @{ L = 'gf'; Name = 'a tie the left cell''s'; File = 'viewport'; Anchor = '      if (lb && (!la || lb.rank >= la.rank)) return { line: bb.line, color: bb.color || EDGE_INK, def: lb, near: false };'
               With = '      if (lb && (!la || lb.rank > la.rank)) return { line: bb.line, color: bb.color || EDGE_INK, def: lb, near: false };   // a tie the left cell''s, by the control'
               Want = 'case grid.*the edge between \w+\d+ and \w+\d+ is drawn thin #[0-9A-Fa-f]{6} by \w+\d+''s (right|bottom), and the record resolves it to thin #[0-9A-Fa-f]{6} by \w+\d+''s (left|top)' },
            @{ L = 'gh'; Name = 'a hidden neighbor''s side taken'; File = 'viewport'; Module = $true; Anchor = '  function shownAfter(size, i, last) { var k = i + 1; while (k <= last && size(k) === 0) k++; return k; }'
               With = '  function shownAfter(size, i, last) { return i + 1; }   // a hidden neighbor''s side taken, by the control'
               Want = 'case grid.*the edge between (R2 and T2|I11 and I13) is drawn thin #[0-9A-Fa-f]{6} by (S2''s left|I12''s top), and the record resolves it to thin #[0-9A-Fa-f]{6} by (T2''s left|I13''s top)' }
        )
        # CART.14.1's hand test: a sheet keeps its selection and its scroll across a tab, until a clear
        $gridMutants += @(
            @{ L = 'kv'; Name = 'a sheet''s selection forgotten'; File = 'viewport'; Anchor = '    if (kept) this.state.selection = kept.selection;'; With = '    // a sheet''s selection forgotten, by the control'
               Want = 'case grid.*grid, a sheet''s view: back on A, the selection reads A1, where C3 is due' },
            @{ L = 'kw'; Name = 'a sheet''s scroll forgotten'; File = 'viewport'; Anchor = '    if (kept && (kept.top || kept.left)) {'; With = '    if (false) {'
               Want = 'case grid.*grid, a sheet''s view: back on A, the scroll reads 1,1, where \d+,\d+ is due' },
            @{ L = 'kx'; Name = 'a clear keeping the sheets'' views'; File = 'viewport'; Anchor = '    this.views = {}; this._resetView();'; With = '    this._resetView();'
               Want = 'case grid.*grid, a sheet''s view: after a clear, the selection on B reads D4, where A1 is due' }
        )
        foreach ($mu in $gridMutants) {
            if ($mu.Module -and $moduleReal -eq 0) { $gridNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            $orig = if ($mu.File -eq 'viewport') { $vpText } else { $js }
            if (([regex]::Matches($orig, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/$($mu.File).js exactly once"; exit 1 }
            $mutG2 = $orig.Replace($mu.Anchor, $mu.With)
            $g2Applied = $mutG2 -cne $orig
            $fileG2 = Join-Path $tmp ($mu.L + '.' + $mu.File + '.js'); [System.IO.File]::WriteAllText($fileG2, $mutG2, $utf8)
            $pageG2 = if ($mu.File -eq 'viewport') { New-MutantPage $mu.L $template $hostJs '' '' $fileG2 } else { New-MutantPage $mu.L $template $fileG2 }
            $rG2 = Invoke-Mutant $pageG2 'grid'
            # not $jG2 alone: names fold case here, so every judgment of this loop keeps a name of its own
            $g2Judge = Test-Mutant $rG2 'grid'
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
            @{ L = 'ak'; Name = 'the sheet shown viewed at the click alone'; File = 'host'; Anchor = '    if (!atLoad && this.vp && !isScreen(this.vp.sheet())) { if (this.refreshSheet(this.vp, false, frame)) this.c.draws++; return; }'; With = '    if (!atLoad && this.vp && !isScreen(this.vp.sheet())) return;'
               Want = 'case tabs.*fake frame \d+: B[12] shows "[^"]*", and the record says "[^"]*"' },
            @{ L = 'al'; Name = 'the window not given back'; File = 'host'; Anchor = '    this._quiet(function () { self._drawGrid(true); });'; With = '    this._quiet(function () { self._drawGrid(false); });'
               Want = 'case tabs.*fake frame 8: the Screen''s tab shows \w+ at the viewport''s top left, and the Camera at E1 puts its corner there' },
            @{ L = 'ky'; Name = 'the Screen''s selection not kept'; File = 'host'; Anchor = '    if (kept !== null && this.vp.selection().text !== kept) this.vp.select(kept);'; With = '    // the Screen''s selection not kept, by the control'
               Want = 'case tabs.*fake frame 8: the Screen''s tab puts the selection at A1, where the person left it on C5' },
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
            $rT = Invoke-Mutant $pageT 'tabs'
            $tJudge = Test-Mutant $rT 'tabs'
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
               Want = 'case empty.*the picker''s entry 2 is brickwork, and the page''s cartridge block 1 is life' },
            # HB, HC and HD (ENGINE.14's addendum): the bench's heading painted before the script chooses the player, and the
            # dark Screen before the grid, each by the one rule or attribute that holds it back
            @{ L = 'hb'; Name = 'a body with no mode shown'; Anchor = '  body:not([class]) { visibility: hidden; }'; With = '  /* no rule */'
               Want = 'case empty.*a body with no mode is visible' },
            @{ L = 'hc'; Name = 'the plane''s box opening shown'; Anchor = '<div id="plane-box" class="plane-box" hidden>'; With = '<div id="plane-box" class="plane-box">'
               Want = 'case empty.*the plane''s box opens shown' },
            @{ L = 'hd'; Name = 'the Screen on its own dark color'; Anchor = '  .player-screen { flex: 1 1 auto; min-width: 0; position: relative; }'; With = '  .player-screen { flex: 1 1 auto; min-width: 0; position: relative; background: #1d1d1b; }'
               Want = 'case empty.*the Screen opens on its own color' }
        )
        $emptyNotes = New-Object System.Collections.Generic.List[string]
        $emptyJudged = New-Object System.Collections.Generic.List[object]
        $emptyOk = $true
        foreach ($mu in $emptyMutants) {
            if (([regex]::Matches($tpl, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in the template exactly once"; exit 1 }
            $mutE2 = $tpl.Replace($mu.Anchor, $mu.With)
            $e2Applied = $mutE2 -cne $tpl
            $tplE2 = Join-Path $tmp ($mu.L + '.template.html'); [System.IO.File]::WriteAllText($tplE2, $mutE2, $utf8)
            $rE2 = Invoke-Mutant (New-MutantPage $mu.L $tplE2 $hostJs) 'empty'
            $e2Judge = Test-Mutant $rE2 'empty'
            $e2Failed = @($e2Judge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $emptyJudged.Add(@{ Name = $mu.Name; Problems = @($e2Judge.Problems) })
            $emptyNotes.Add(("{0} applied ({1}) and failed the empty case ({2})" -f $mu.Name, $e2Applied, $e2Failed))
            if (-not ($e2Applied -and $e2Failed -ge 1)) { $emptyOk = $false }
        }
        $emptyNote = $emptyNotes -join '; '
        # mutants AX, AY, AZ, BA and BB (ENGINE.17), when the real page holds the engine's module, the still card
        # being the module's: a host that skips whatever the record, its text unread, which fails at frame 1, the
        # record's first change; one that never skips, whose still frames sit under their floor; a redraw() that
        # skips; a host that compares the text alone, never asking whether its viewport still holds the model it
        # made, which keeps the record a page loaded before frame 81; and one that never finds a sheet shown in the
        # Screen's place still, loading Board again at frame 5. The still case must fail each by name.
        $stillAnchor = '    return l.text === text && vp.model() === l.model;'
        $stillMutants = @(
            @{ L = 'ax'; Name = 'the record unread'; Anchor = $stillAnchor; With = '    return vp.model() === l.model;'
               Want = 'case still.*still frame 1: the host drew the unknown record of A1:CB50, where the values record is due' },
            @{ L = 'ay'; Name = 'never still'; Anchor = $stillAnchor; With = '    return false;'
               Want = 'the case still at a ratio of 1 counted 0 stills, below its floor of 84' },
            @{ L = 'az'; Name = 'a redraw that skips'; Anchor = "    if (this.cart.mode === 'grid') this._drawGrid(false, false); else this._drawPlane();   // never still (ENGINE.17)"
               With = "    if (this.cart.mode === 'grid') this._drawGrid(false, true); else this._drawPlane();"
               Want = 'case still.*still: redraw\(\) over the unchanged frame 90 counted 0 draw\(s\) and 1 still frame\(s\), where it always draws' },
            @{ L = 'ba'; Name = 'the model unasked'; Anchor = $stillAnchor; With = '    return l.text === text;'
               Want = 'case still.*still frame 81: [A-Z]+\d+ \("\d+"\) is not drawn' },
            @{ L = 'bb'; Name = 'a sheet never still'; Anchor = '    if (still && this._still(vp, t)) { if (vp === this.vp) this.c.stills++; return false; }   // a still sheet (ENGINE.17)'
               With = '    // a sheet never still, by the control'
               Want = "case still.*still sheets frame 5: Board's record is the frame before's, and the host loaded it" }
        )
        $stillNotes = New-Object System.Collections.Generic.List[string]
        $stillJudged = New-Object System.Collections.Generic.List[object]
        $stillOk = $true
        foreach ($mu in $stillMutants) {
            if ($moduleReal -eq 0) { $stillNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            if (([regex]::Matches($js, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/host.js exactly once"; exit 1 }
            $mutS2 = $js.Replace($mu.Anchor, $mu.With)
            $s2Applied = $mutS2 -cne $js
            $fileS2 = Join-Path $tmp ($mu.L + '.host.js'); [System.IO.File]::WriteAllText($fileS2, $mutS2, $utf8)
            $rS2 = Invoke-Mutant (New-MutantPage $mu.L $template $fileS2) 'still'
            $s2Judge = Test-Mutant $rS2 'still'
            $s2Failed = @($s2Judge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $stillJudged.Add(@{ Name = $mu.Name; Problems = @($s2Judge.Problems) })
            $stillNotes.Add(("{0} applied ({1}) and failed the still case ({2})" -f $mu.Name, $s2Applied, $s2Failed))
            if (-not ($s2Applied -and $s2Failed -ge 1)) { $stillOk = $false }
        }
        $stillNote = $stillNotes -join '; '
        # mutants BC to BK (ENGINE.18), when the real page holds the engine's module, the views card being the
        # module's: a host that opens a version 4 cartridge on its Screen; one that opens on its first sheet, hidden
        # or not; one that draws a sheet shown from the grid record after frame 0; one whose pointer is 0 off the
        # Screen; one that writes no Input!B19; one that writes the pointer over another sheet for a version 3
        # cartridge too; one that never shows the sheet the Camera names; one that shows it at every frame, over the
        # person's tab; and one whose replay names the host's version for a version 3 cartridge. Each must fail by
        # name, the last the replay case on the committed replays.
        $pointerAnchor = '    if (!this._four()) return null;'
        $viewsMutants = @(
            @{ L = 'bc'; Name = 'opened on the Screen'; Anchor = '    if (!this._four()) { this._drawGrid(true); return; }'; With = '    if (true) { this._drawGrid(true); return; }'
               Want = 'case views.*views frame 0: the host opened on Screen, where the card opens on its first visible sheet' },
            @{ L = 'bd'; Name = 'the first sheet, hidden or not'; Anchor = "    for (var i = 0; name === null && i < list.length; i++) if (list[i].state === 'visible') name = list[i].name;"
               With = '    for (var i = 0; name === null && i < list.length; i++) name = list[i].name;'
               Want = 'case views.*views frame 0: the host opened on Screen, where the card opens on its first visible sheet' },
            @{ L = 'be'; Name = 'a sheet drawn from the grid record'; Anchor = "    var r = this.m.texts('alonzo_view', [this.handle], [this.frame > 0 ? 'values' : 'grid', sheet, win || '']);"
               With = "    var r = this.m.texts('alonzo_view', [this.handle], ['grid', sheet, win || '']);"
               Want = 'case views.*views frame 1: the host drew the grid record of Desk!' },
            @{ L = 'bf'; Name = 'the pointer 0 off the Screen'; Anchor = $pointerAnchor; With = '    return null;'
               Want = 'case views.*views frame 10: the press over Desk!C5 was written as column 0' },
            @{ L = 'bg'; Name = 'the sheet shown unnamed'; Anchor = "    if (this._four()) out.push('(cell `"Input`" `"B19`" ' + quote(this.cart.mode === 'grid' ? this._shown() : 'Screen') + ')');"
               With = '    // the sheet shown unnamed, by the control'
               Want = 'case views.*views frame 1: Input!B19 holds "", where the sheet shown before the frame is Desk' },
            @{ L = 'bh'; Name = 'the version unasked'; Anchor = $pointerAnchor; With = '    // the version unasked, by the control'
               Want = 'case views.*views, version 3 frame 1: the press over Board!B2 was written as column 2' },
            @{ L = 'bi'; Name = 'the Camera''s sheet never shown'; Anchor = '    if (name !== null) this.showWanted = name;'; With = '    // the Camera''s sheet unshown, by the control'
               Want = 'case views.*views frame 40: the viewport shows Desk, where the Camera shows Ledger' },
            @{ L = 'bj'; Name = 'the Camera''s sheet at every frame'; Anchor = "    if (stage === 'load' || key === was) return;"; With = "    if (stage === 'load' || key === '') return;"
               Want = 'case views.*views frame 41: the host counted 1 show\(s\) of the Camera''s sheet, where its third row holds still' },
            @{ L = 'bk'; Name = 'the replay at the host''s version'; Cases = 'input,replay:inputcard'; Anchor = '    var spec = Math.max(3, Math.min(this.cart.spec || 3, SPEC));'; With = '    var spec = SPEC;'
               Want = 'case replay.*the player''s own recording of \w+\.vla''s committed replay is not the replay it played' }
        )
        $viewsNotes = New-Object System.Collections.Generic.List[string]
        $viewsJudged = New-Object System.Collections.Generic.List[object]
        $viewsOk = $true
        foreach ($mu in $viewsMutants) {
            if ($moduleReal -eq 0) { $viewsNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            if (([regex]::Matches($js, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/host.js exactly once"; exit 1 }
            $mutV = $js.Replace($mu.Anchor, $mu.With)
            $vApplied = $mutV -cne $js
            $fileV = Join-Path $tmp ($mu.L + '.host.js'); [System.IO.File]::WriteAllText($fileV, $mutV, $utf8)
            $vCases = if ($mu.ContainsKey('Cases')) { $mu.Cases } else { 'views' }
            $rV = Invoke-Mutant (New-MutantPage $mu.L $template $fileV) $vCases
            $vJudge = Test-Mutant $rV $vCases
            $vFailed = @($vJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $viewsJudged.Add(@{ Name = $mu.Name; Problems = @($vJudge.Problems) })
            $viewsNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $vApplied, $vFailed))
            if (-not ($vApplied -and $vFailed -ge 1)) { $viewsOk = $false }
        }
        $viewsNote = $viewsNotes -join '; '
        # mutants BL to BU (ENGINE.19), the changes card being the module's but for BU: a host that patches whatever the
        # since, which the Screen's viewer refreshed every third frame finds; one that takes a whole answer as still,
        # which frame 50's formula finds; one that compares no window, which the viewport's own patch refuses, so that it
        # fails where no viewport stands, the replay's host at the Camera's move; one that never patches; one that patches
        # the text and not the model; one that keeps a device's cells when its changes name some; one that keeps the
        # Input rows after a person's edit of the Input sheet, the edit standing a frame too long; one that writes the
        # rows whole whenever one changed; one that never keeps them; and, with or without the module, one whose patch
        # leaves an empty row's cell in place, which the crafted patches find. Each must fail the changes case by name.
        # And BV to BZ (ENGINE.20), viewports: a repaint without the span its text spills over, L2 left at frame 2; one
        # without a neighbor's text spilling into a named cell, O6 left; one that leaves out the selection, M1 under it
        # (since ENGINE.28's second slice L1 or M1, the card bordered and the band grown two pixels left over L1's pixels
        # under the selection's border; since ENGINE.36 said by the first crafted patch, A1 under the selection there, the
        # crafted patches' own sentences filling its report before frame 2's);
        # and, with or without the module, one with no clip, the crafted selection blended twice in A1, and a draw list
        # that keeps the last full paint's ops, which the first crafted patch finds.
        $changesMutants = @(
            @{ L = 'bl'; Name = 'a patch whatever the since'; Module = $true; Anchor = "    if (ch.since !== held.frame) return 'whole';"; With = '    // the since unasked, by the control'
               Want = 'case changes.*changes frame \d+: the viewer of the Screen, refreshed every third frame, was patched' },
            @{ L = 'bm'; Name = 'a whole answer taken as still'; Module = $true; Anchor = "    if (!ch || ch.whole) return 'whole';"; With = "    if (!ch) return 'whole';`n    if (ch.whole) return 'still';"
               Want = 'case changes.*changes frame 50: the host counted 0 draw\(s\), 0 patch\(es\) and 1 still frame\(s\), where the window''s changes make the frame a whole view' },
            @{ L = 'bn'; Name = 'no window compared'; Module = $true; Anchor = "    if (ch.sheet !== held.sheet || ch.range !== held.range) return 'whole';"; With = '    // the window uncompared, by the control'
               Want = 'case changes.*changes: the replay played on a fresh host is not the live run at frame 40: its Screen record' },
            @{ L = 'bo'; Name = 'never a patch'; Module = $true; Anchor = "    return ch.n === 0 ? 'still' : 'patch';"; With = "    return ch.n === 0 ? 'still' : 'whole';"
               Want = 'case changes.*changes frame 2: the host counted 1 draw\(s\), 0 patch\(es\) and 0 still frame\(s\), where the window''s changes make the frame a patch' },
            @{ L = 'bp'; Name = 'the text patched and not the model'; Module = $true; Anchor = '    if (text === null || (vp && !vp.patch(r.text))) { l.text = null; l.rec = null; return null; }'; With = '    if (text === null) { l.text = null; l.rec = null; return null; }'
               Want = 'case changes.*changes frame 2: the viewport''s model is not the one a load of the record makes' },
            @{ L = 'bq'; Name = 'a device''s named cells kept'; Module = $true; Anchor = "      if (how === 'patch' && patchCells(d.cells, ch.rows)) { d.frame = ch.at; return { cells: d.cells, text: null, changed: true }; }"
               With = "      if (how === 'patch') { d.frame = ch.at; return { cells: d.cells, text: null, changed: false }; }"
               Want = 'case changes.*changes frame \d+: the host keeps \w+''s cells as' },
            @{ L = 'br'; Name = 'the rows kept across an edit of the Input sheet'; Module = $true; Anchor = "      if (editsInput(row)) this.inputsLast = null;   // the Input sheet a person wrote: the next frame's rows written whole (ENGINE.19)"
               With = '      // the rows last written kept across a person''s edit of the Input sheet, by the control'
               Want = 'case changes.*changes frame 21: the host wrote 0 Input row\(s\), \[\], where the rows that differ from the last written are 48' },
            @{ L = 'bs'; Name = 'the rows whole when one changed'; Module = $true; Anchor = "        var r = this._write(changed.join('\n'));"; With = '        var r = this._write(rows);'
               Want = 'case changes.*changes frame 10: the host wrote 48 Input row\(s\), .*, where the rows that differ from the last written are 2' },
            @{ L = 'bt'; Name = 'the rows never kept'; Module = $true; Anchor = '      for (var i = 0; i < lines.length; i++) if (!last || last[i] !== lines[i]) changed.push(lines[i]);'; With = '      for (var i = 0; i < lines.length; i++) changed.push(lines[i]);'
               Want = 'case changes.*changes frame 2: the host wrote 48 Input row\(s\), .*, where the rows that differ from the last written are 0' },
            @{ L = 'bu'; Name = 'an empty row''s cell left in place'; Module = $false; Anchor = '        if (had) { rec.pieces.delete(c.k); rec.keys.splice(keyAt(rec.keys, c.k), 1); }'; With = '        // the empty cell left in place, by the control'
               Want = 'case changes.*crafted, an empty row: the host''s patch gives' },
            @{ L = 'bv'; Name = 'a repaint without the spill''s widening'; Module = $true; File = 'viewport'; Anchor = '    if (own) xs.push(own.x, own.x + own.w);'; With = '    // the spill unwidened, by the control'
               Want = 'case changes.*changes frame 2: the canvas is not a full paint''s of the record in the view''s state: \d+ pixel\(s\), the first at \d+,\d+ in L2' },
            @{ L = 'bw'; Name = 'a repaint without the left neighbor''s widening'; Module = $true; File = 'viewport'; Anchor = '      if (left && left.x + left.w > x + g.colX[c]) xs.push(left.x, left.x + left.w);'; With = '      // the left neighbor''s spill unwidened, by the control'
               Want = 'case changes.*changes frame \d+: the canvas is not a full paint''s of the record in the view''s state: \d+ pixel\(s\), the first at \d+,\d+ in O6' },   # frame 3 since ENGINE.37's second slice: L6 lit by its rule at frame 2 repaints its own spill
            @{ L = 'bx'; Name = 'a repaint with no clip'; Module = $false; File = 'viewport'; Anchor = '    p.clipped(rect, function () {'; With = '    (function (fn) { fn(); })(function () {'
               Want = 'case changes.*crafted, an empty row: the canvas is not a full paint''s of the record after the patch: \d+ pixel\(s\), the first at \d+,\d+ in A1' },
            @{ L = 'by'; Name = 'a repaint without the selection'; Module = $true; File = 'viewport'; Anchor = '      self._paintRanges(p, model, g, clip, r1, r2, c1, c2, sx, sy, name);'; With = '      if (!part) self._paintRanges(p, model, g, clip, r1, r2, c1, c2, sx, sy, name);'
               Want = 'case changes.*crafted, a new cell: the canvas is not a full paint''s of the record after the patch: \d+ pixel\(s\), the first at \d+,\d+ in A1' },
            @{ L = 'bz'; Name = 'a draw list that keeps the old ops'; Module = $false; File = 'viewport'; Anchor = '    if (!this.over) return this.ops.slice();'; With = '    if (true) return this.ops.slice();'
               Want = 'case changes.*crafted, an empty row: the draw list is not a full paint''s of the record after the patch' },
            @{ L = 'gg'; Name = 'a repaint''s band not grown'; Module = $true; File = 'viewport'; Anchor = '    var up = model.bordered ? 2 : (model.filled ? 1 : 0), down = model.bordered ? 1 : 0;'; With = '    var up = 0, down = 0;   // the band not grown, by the control'
               Want = 'case changes.*the canvas is not a full paint''s of the record in the view''s state' },
            # LF to LQ (ENGINE.36): the card's line feeds through each path a text takes; LL to LO the crafted patches', with
            # or without the module, and LP and LQ the oracle's own twin, which the template holds
            @{ L = 'lf'; Name = 'a wrap that takes no line feed'; Module = $true; File = 'viewport'; Anchor = "    if (shown.indexOf('\n') < 0) { wrapPiece(ctx, shown, width, lines, ''); return lines; }"; With = "    if (true) { wrapPiece(ctx, shown, width, lines, ''); return lines; }"
               Want = 'case changes.*changes frame \d+: the wrapped K7 breaks into 1 line\(s\), and the record into [23]' },
            @{ L = 'lg'; Name = 'a piece''s indent dropped'; Module = $true; File = 'viewport'; Anchor = "    words[0] = lead + words[0];"; With = ""
               Want = 'case changes.*changes frame \d+: the wrapped N7 draws its lines' },
            @{ L = 'lh'; Name = 'a piece''s trailing spaces kept'; Module = $true; File = 'viewport'; Anchor = "      var piece = pieces[p].replace(/ +`$/, ''), lead = /^ */.exec(piece)[0];"; With = "      var piece = pieces[p], lead = /^ */.exec(piece)[0];"
               Want = 'case changes.*changes frame \d+: the wrapped N7 draws its lines' },
            @{ L = 'li'; Name = 'a carriage return drawn'; Module = $true; File = 'viewport'; Anchor = "    var shown = text.indexOf('\r') < 0 ? text : text.replace(/\r/g, ''), lines = [];"; With = "    var shown = text, lines = [];"
               Want = 'case changes.*changes frame \d+: the wrapped M7 shows' },
            @{ L = 'lj'; Name = 'a nowrap''s line feed drawn'; Module = $true; File = 'viewport'; Anchor = "      shown = shown.replace(/[\r\n]/g, '');"; With = ""
               Want = 'case changes.*changes frame \d+: K3 shows' },
            @{ L = 'lk'; Name = 'a nowrap''s measure counting no line feed'; Module = $true; File = 'viewport'; Anchor = "      feedW = feedsIn(shown) * ctx.measureText('0').width;"; With = "      feedW = 0;"
               Want = 'case changes.*changes frame \d+: S3 is drawn at \d+,\d+, and the record places it at' },
            @{ L = 'll'; Name = 'a record by cell that joins no line'; Anchor = "        pieces.set(last, pieces.get(last) + lines[i] + '\n');"; With = "        return null;"
               Want = 'case changes.*crafted, a cell beside a row over lines: the host''s patch gives null' },
            @{ L = 'lm'; Name = 'a patch that joins no line'; Anchor = "        groups[groups.length - 1].text += lines[i] + '\n';"; With = "        return null;"
               Want = 'case changes.*crafted, a row over lines: the host''s patch gives null' },
            @{ L = 'ln'; Name = 'a row reader that joins any line'; Anchor = "  function stringOpen(row) {"; With = "  function stringOpen(row) { return true;"
               Want = 'case changes.*crafted: the host laid an answer''s line no string runs on to on a record' },
            @{ L = 'lo'; Name = 'a model''s lines at one a row'; File = 'viewport'; Anchor = "m.lines -= n + feedsOf(e);"; With = "m.lines -= n;"
               Want = 'case changes.*crafted, a row over lines replaced: the viewport''s patched model is not the one a load of the record after it makes: lines' },
            @{ L = 'lp'; Name = 'the oracle''s twin without the rule'; Module = $true; File = 'template'; Anchor = "    var shown = text.replace(/\r/g, ''), pieces = shown.split('\n'), out = [], many = pieces.length > 1;"; With = "    var shown = text, pieces = [shown], out = [], many = false;"
               Want = 'case changes.*changes frame \d+: the wrapped K7 breaks into [23] line\(s\), and the record into 1' },
            @{ L = 'lq'; Name = 'the oracle''s compare holding a line feed'; Module = $true; File = 'template'; Anchor = "wx.text.replace(/[ \r\n]/g, '')) say("; With = "wx.text.replace(/ /g, '')) say("
               Want = 'case changes.*changes frame \d+: the wrapped K7 shows' },
            # LR to LW (ENGINE.37): a lit row on the change path, each by name, five needing no module and failing by the
            # crafted patches or the double's answers, LU by the changes card over the module
            @{ L = 'lr'; Name = 'a host whose cell rows take no lit row'; Anchor = "  var CELL_LINE = /^\((?:cell|value|text|style|sentence|formula|lit|empty) "; With = "  var CELL_LINE = /^\((?:cell|value|text|style|sentence|formula|empty) "
               Want = 'case changes.*crafted, a lit row laid: the host''s patch gives null' },
            @{ L = 'ls'; Name = 'a viewport whose cell rows take no lit row'; File = 'viewport'; Anchor = "  var CELL_ROWS = { cell: 1, formula: 2, value: 4, style: 8, sentence: 16, text: 32, lit: 64 };"; With = "  var CELL_ROWS = { cell: 1, formula: 2, value: 4, style: 8, sentence: 16, text: 32 };"
               Want = 'case changes.*crafted, a lit row laid: the viewport refused the patch' },
            @{ L = 'lt'; Name = 'a lit row left counted'; File = 'viewport'; Anchor = "      m.counts[COUNTED[head]]--;"; With = "      if (head !== 'lit') m.counts[COUNTED[head]]--;"
               Want = 'case changes.*crafted, a lit row taken off: the viewport''s patched model is not the one a load of the record after it makes: counts' },
            @{ L = 'lu'; Name = 'the fold kept by its cell and not its rules'; Module = $true; File = 'viewport'; Anchor = "+ '|' + cell.lit.join(','), d = model.drawn.get(key);"; With = "+ '|', d = model.drawn.get(key);"
               Want = 'case changes.*changes frame \d+: (a fill is drawn at [OPQRS]4|[OPQRS]4)' },
            @{ L = 'lv'; Name = 'the double''s answers blind to its rule'; File = 'fake'; Anchor = "        var la = litOf(c, sk, addr, ea, c.twins.clock), lb = litOf(c, sk, addr, eb, c.prevTwins.clock);"; With = "        var la = '', lb = '';"
               Want = 'case changes.*the double, frame \d+, Screen: the answer names' },
            @{ L = 'lw'; Name = 'a rule''s fill never repainted'; File = 'viewport'; Anchor = "            if (fmt.fill) p.fillRect(ox + g.colX[c] - sx - 1, y - 1, w + 1, rh + 1, fmt.fill, { op: 'fill', row: r, col: c, quadrant: name });"
               With = "            if (fmt.fill && !(part && cell && cell.lit)) p.fillRect(ox + g.colX[c] - sx - 1, y - 1, w + 1, rh + 1, fmt.fill, { op: 'fill', row: r, col: c, quadrant: name });"
               Want = 'case changes.*crafted, a lit row laid: the canvas is not a full paint''s of the record after the patch' },
            # MB and MC (ENGINE.5), the save case's over the module, each by name: a save taken inside an act's settle, and
            # a save that keeps the twins
            @{ L = 'mb'; Name = 'a save inside a settle'; Module = $true; Case = 'save'; Anchor = '    if (this.inFrame || this.settling) return { ok: false, wait: true };'; With = '    if (this.inFrame) return { ok: false, wait: true };'
               Want = 'case save.*a save asked inside an act''s settle at frame \d+ was taken at once' },
            @{ L = 'mc'; Name = 'a save with its twins'; Module = $true; Case = 'save'; Anchor = '      if (/\.last$/.test(s) && named[s.slice(0, -5)]) continue;   // a twin, filled at the load with its sheet''s values'; With = '      // the twins kept, by the control'
               Want = 'case save.*the save at frame \d+ (did not load|opens at frame|played on is not the run)' },
            # MD (ENGINE.5's hand test), the keys case's, the page's: a kept keymap offered nothing of the commands new since
            @{ L = 'md'; Name = 'a kept keymap offered nothing'; File = 'template'; Case = 'keys'; Anchor = '      if (known && known.indexOf(b.command) >= 0) return;'; With = '      return;'
               Want = 'case keys.*a keymap kept before Save and Open is offered \[\]' },
            # ME to MI (ENGINE.38), the keep case's over the module, each by name: the frames kept numbered by the host's
            # frame and not from the keyframe's, which a settling cartridge's restore past a keyframe fails; a run's first
            # frame, its Input logged whole, taken for a person's act; a restore over a run another tab holds; a keyframe
            # not held to its frames; and a save written that leaves the run's record standing
            @{ L = 'me'; Name = 'frames kept by the host''s number'; Module = $true; Case = 'keep'; Anchor = '    var k = this.keep, f = n - k.off;'; With = '    var k = this.keep, f = n;'
               Want = 'case keep.*: frame \d+: (the work restored is not the run there|the offer was not restored)' },
            @{ L = 'mf'; Name = 'a run''s first frame an act'; Module = $true; Case = 'keep'; Anchor = '        if (was && !KEPT_NOT_ACTS[m[1]]) this._acted();   // a key, a press, the wheel or a command: a person''s act'; With = '        if (!KEPT_NOT_ACTS[m[1]]) this._acted();'
               Want = 'case keep.*watched: a run no person acted in kept 1 record' },
            @{ L = 'mg'; Name = 'a restore over another tab''s run'; File = 'template'; Module = $true; Case = 'keep'; Anchor = '      if (!release) { self._say(''The unsaved work on '' + workOn(w) + '' is open in another tab of this page'; With = '      if (false) { self._say(''The unsaved work on '' + workOn(w) + '' is open in another tab of this page'
               Want = 'case keep.*tabs: a run another tab holds was restored' },
            @{ L = 'mh'; Name = 'a keyframe not held to its frames'; File = 'template'; Module = $true; Case = 'keep'; Anchor = "        var torn = !k ? 'its keyframe is missing from this browser\'s store' : (k.kf !== w.kf ?"; With = "        var torn = !k ? 'its keyframe is missing from this browser\'s store' : (false ?"
               Want = 'case keep.*torn: restored, dropped, or refused otherwise' },
            @{ L = 'mi'; Name = 'a save written leaving the record'; Module = $true; Case = 'keep'; Anchor = '    if (k.acts === s.acts) k.acted = false;'; With = '    // the act kept, by the control'
               Want = 'case keep.*saved: kept true, dropped at the save false' },
            # MJ to ML (ENGINE.40's first slice), the drawer's typing: a restore that puts no box back, a cartridge picked
            # that leaves the boxes it replaced typed, and typing that keeps no run with no act
            @{ L = 'mj'; Name = 'a restore putting no box back'; File = 'template'; Module = $true; Case = 'keep'; Anchor = '          if (self.o.restored) self.o.restored(now ? now.keyframe : k.text, w, texts);'; With = '          if (self.o.restored) self.o.restored(now ? now.keyframe : k.text, w, {});'
               Want = 'case keep.*typed: a source typed in a run with no act was not kept, offered and put back as typed' },
            @{ L = 'mk'; Name = 'boxes replaced left typed'; File = 'template'; Module = $true; Case = 'keep'; Anchor = '    for (var i = 0; i < names.length; i++) delete this.typed[names[i]];'; With = '    // the boxes kept typed, by the control'
               Want = 'case keep.*switched: the run.s typing was not its own across a cartridge picked' },
            @{ L = 'ml'; Name = 'typing keeping no run'; File = 'template'; Module = $true; Case = 'keep'; Anchor = '    if (!w.acted && !names.length) {'; With = '    if (!w.acted) {'
               Want = 'case keep.*typed: a source typed in a run with no act was not kept' },
            # MS and MT (ENGINE.40's second slice), a file's drafts: a raw string of one # whatever its text holds, and a
            # draft read and dropped
            @{ L = 'ms'; Name = 'a raw string of one #'; File = 'template'; Module = $true; Case = 'keep'; Anchor = "    while (text.indexOf('`"' + new Array(n + 1).join('#')) >= 0) n++;"; With = '    // one #, by the control'
               Want = 'case keep.*drafts: a file.s boxes were not taken back as typed' },
            @{ L = 'mt'; Name = 'a draft read and dropped'; File = 'template'; Module = $true; Case = 'keep'; Anchor = '        drafts[d.key] = d.path === undefined ? { text: d.text } : { text: d.text, path: d.path };'; With = '        // the draft read and dropped, by the control'
               Want = 'case keep.*drafts: a file.s boxes were not taken back as typed' },
            # LX (ENGINE.37's second slice): a repaint that lays a cell's texts again in the draw list and drops its lines,
            # which the changes card's frames fail by name over the module, a strand of K2, L6 or M1 not drawn
            @{ L = 'lx'; Name = 'a repaint that drops a text''s lines'; Module = $true; File = 'viewport'; Anchor = "      else if (op.op === 'text' || op.op === 'decoration') { if (!drawn.has(key)) drawn.set(key, []); drawn.get(key).push(op); }"; With = "      else if (op.op === 'text') { if (!drawn.has(key)) drawn.set(key, []); drawn.get(key).push(op); }"
               Want = 'case changes.*changes frame \d+: the strand [KLM]\d+''s .* is not drawn' },
            # MM and MN (ENGINE.41), one viewport's mutation proven by each of its two holds, needing no module: a clip whose
            # restore keeps the font the painter noted, the crafted pair's second cell drawn in the default, its pixels not a
            # full paint's; and the frozen row's first text drawn in the default, its font not its op's
            @{ L = 'mm'; Name = 'a clip that keeps the painter''s font, by the repaint'; Module = $false; File = 'viewport'; Anchor = '    try { fn(); } finally { ctx.restore(); this.font = null; }'; With = '    try { fn(); } finally { ctx.restore(); }'
               Want = 'case changes.*crafted, two cells of one font repainted in turn: the canvas is not a full paint''s of the record after the patch: \d+ pixel\(s\), the first at \d+,\d+ in C1' },
            @{ L = 'mn'; Name = 'a clip that keeps the painter''s font, by the full paint'; Module = $false; File = 'viewport'; Anchor = '    try { fn(); } finally { ctx.restore(); this.font = null; }'; With = '    try { fn(); } finally { ctx.restore(); }'
               Want = 'case changes.*crafted, a frozen row over a total of its font: a text not drawn in its own font: A1 \(item\) drawn in' },
            # MU to NH (CART.3's third slice), the drawer case's, each by name and needing no module: the drawer measured by
            # its contents; a press on a command's button that takes the keys; a section's summary left to take them; and the
            # drawer's boxes, the page's own: a text in one block; an empty line's <br> read as a line feed; Enter, a paste, a
            # copy, Ctrl+Z and a delete at a block's edge left to the browser; a value's CRLF kept; keystrokes steps apart; the
            # history kept across a value written; and the page's own edits untold
            @{ L = 'mu'; Name = 'the drawer measured by its contents'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = 'color: #4b4b47; contain: size layout; }'; With = 'color: #4b4b47; }'
               Want = 'case drawer.*drawer: the drawer.s contain is "none"' },
            @{ L = 'mv'; Name = 'a press that takes the keys'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = 'if (ev.button === 0 && keepsTheKeys(ev.target)) ev.preventDefault();'; With = 'if (ev.button === 0 && keepsTheKeys(ev.target)) return;'
               Want = 'case drawer.*drawer: a press on a command.s button took the keys' },
            @{ L = 'mw'; Name = 'a summary that takes the keys'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '!!el.closest(''button[data-command], summary'')'; With = '!!el.closest(''button[data-command]'')'
               Want = 'case drawer.*drawer: a press on the summary .* takes the keys' },
            @{ L = 'mx'; Name = 'a text in one block'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '  var BOX_BLOCK_LINES = 100, BOX_UNDOS = 500, BOX_COALESCE_MS = 1500;'; With = '  var BOX_BLOCK_LINES = 1e9, BOX_UNDOS = 500, BOX_COALESCE_MS = 1500;'
               Want = 'case drawer.*drawer: a text of 1,201 lines lies in 1 blocks' },
            @{ L = 'my'; Name = 'an empty line''s br read as a line feed'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '(n.nextSibling && text && text.charCodeAt(text.length - 1) !== 10 ? ''\n'' : '''')'; With = '''\n'''
               Want = 'case drawer.*drawer: a block of "a\\n.{1,4}br.{1,4}" reads as "a\\n\\n"' },
            @{ L = 'mz'; Name = 'Enter left to the browser'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = 'if (t === ''insertParagraph'' || t === ''insertLineBreak'' || across ||'; With = 'if (across ||'
               Want = 'case drawer.*drawer: Enter in the hundred and first line leaves' },
            @{ L = 'na'; Name = 'a paste left to the browser'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '    if (!ev.clipboardData) return;'; With = '    return;'
               Want = 'case drawer.*drawer: a paste of 1,200 lines leaves 2 characters' },
            @{ L = 'nb'; Name = 'a copy and a cut left to the browser'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '    if (s === e || !ev.clipboardData) return;'; With = '    return;'
               Want = 'case drawer.*drawer: a copy across three blocks gave ""' },
            @{ L = 'nc'; Name = 'Ctrl+Z left to the browser'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '    if (k === ''z'' && !ev.shiftKey) { ev.preventDefault(); this.undo(); }'; With = '    if (false) { ev.preventDefault(); this.undo(); }'
               Want = 'case drawer.*drawer: Ctrl\+z in the box was left to the browser' },
            @{ L = 'nd'; Name = 'a delete at a block''s edge left to the browser'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '    var across = this.locate(span[0])[0] !== this.locate(span[1])[0];'; With = '    var across = false;'
               Want = 'case drawer.*drawer: Backspace at the second block.s start leaves' },
            @{ L = 'ne'; Name = 'a value''s CRLF kept'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '    var text = String(v === undefined || v === null ? '''' : v).replace(/\r\n?/g, ''\n'');'; With = '    var text = String(v === undefined || v === null ? '''' : v);'
               Want = 'case drawer.*drawer: the text "a\\r\\nb\\rc" \(6 characters\) reads back as "a\\r\\nb\\rc" \(6\)' },
            @{ L = 'nf'; Name = 'three keystrokes three steps'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '      if (kind === ''insertText'' && !removed && !last.removed && at === last.at + last.inserted.length) { last.inserted += inserted; last.after = after; last.when = now; return; }'; With = '      // typed steps kept apart, by the control'
               Want = 'case drawer.*drawer: at the history.s step 3 the box holds "abcxy"' },
            @{ L = 'ng'; Name = 'the history kept across a value written'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '    this.undos = []; this.redos = []; this.native = -1; this.texts = [];'; With = '    this.native = -1; this.texts = [];'
               Want = 'case drawer.*drawer: at the history.s step 4 the box holds' },
            @{ L = 'nh'; Name = 'the page''s own edits untold'; Module = $false; File = 'template'; Case = 'drawer'; Anchor = '    try { this.el.dispatchEvent(new InputEvent(''input'', { bubbles: true, inputType: kind })); } finally { this.own = false; }'; With = '    this.own = false;'
               Want = 'case drawer.*drawer: the page.s own edits told 0 input events' },
            # NI to NK (ENGINE.42), an act's answer said again, each failing the modes case's answers over the module: an
            # edit's answer unmarked where it lands, the bar passing over it; every sentence an act's, the loop's own repeat
            # taking the bar; and an act's repeat left in place in the log, its last line a refusal over a success
            @{ L = 'ni'; Name = 'an edit''s answer unmarked where it lands'; File = 'host'; Module = $true; Case = 'modes'; Anchor = "      if (!atRateZero) this._answer('frame ' + (this.frame + 1) + ': the edit ' + row + ' was written.');"; With = "      if (!atRateZero) this._say('frame ' + (this.frame + 1) + ': the edit ' + row + ' was written.');"
               Want = 'case modes.*answers: after an edit written, refused and written again, the bar says' },
            @{ L = 'nj'; Name = 'every sentence an act''s answer'; File = 'host'; Module = $true; Case = 'modes'; Anchor = '    kind = kind || ''event''; refusal = !!refusal; act = !!act;'; With = '    kind = kind || ''event''; refusal = !!refusal; act = true;'
               Want = 'case modes.*answers: a frame more, the loop.s own repeat' },
            @{ L = 'nk'; Name = 'an act''s repeat left in place in the log'; File = 'host'; Module = $true; Case = 'modes'; Anchor = '      if (act) { this.order.splice(this.order.indexOf(e), 1); this.order.push(e); this.status = text; }'; With = '      if (act) { this.status = text; }'
               Want = 'case modes.*answers: the log.s last line after the third build' },
            # NQ (ENGINE.43), the region measured over the canvas again, its last column one wholly under the scrollbar,
            # which the grid case's unbound sheet, the views card's Ledger, fails by name at its last column
            @{ L = 'nq'; Name = 'the region measured over the canvas'; File = 'viewport'; Module = $true; Case = 'grid'; Anchor = '    var seenW = Math.min(g.canvasW, Math.round(this.scroller.clientWidth * g.dpr)), seenH = Math.min(g.canvasH, Math.round(this.scroller.clientHeight * g.dpr));'; With = '    var seenW = g.canvasW, seenH = g.canvasH;'
               Want = 'case grid.*begins past the scroller.s client area, wholly under its scrollbar' },
            # NR to NV (ENGINE.39's first slice), the commands case's repeats card at version 8 and its keymap half, each by
            # name: column E unread, every command once; a repeat never taken; a person's (repeat) and (once) unread; a
            # repeat judged by no time, the stale one at frame 5 run; and a repeat taken while a command waits, a game's
            # repeat fresh at frame 4
            @{ L = 'nr'; Name = 'the repeats column unread'; File = 'host'; Module = $true; Case = 'commands'; Anchor = '      var repeats = this._eight() ? repeatsOf(cells[''E'' + r]) : false;'; With = '      var repeats = false;   // column E unread, by the control'
               Want = 'case commands.*commands, version 8: at the load the host lists count-up once' },
            @{ L = 'ns'; Name = 'a repeat never taken'; File = 'host'; Module = $true; Case = 'commands'; Anchor = '    if (ev && ev.repeat && !(cmd.repeats && this.freshRepeat(ev))) return;'; With = '    if (ev && ev.repeat) return;'
               Want = 'case commands.*commands, version 8, frame 3: Input!B20 holds "", where the command count-up runs' },
            @{ L = 'nt'; Name = 'a person''s repeat unread'; File = 'template'; Case = 'commands'; Anchor = '    if (b.repeat !== undefined) return b.repeat;'; With = '    // the person''s word unread, by the control'
               Want = 'case commands.*commands: U, .once. over the column.s repeat repeats true, where false is due' },
            @{ L = 'nu'; Name = 'a repeat judged by no time'; File = 'host'; Module = $true; Case = 'commands'; Anchor = '    return t === null || t === undefined || this.restAt === null || t >= this.restAt;'; With = '    return true;   // every repeat fresh by its time, by the control'
               Want = 'case commands.*commands, version 8, frame 5: Input!B20 holds "count-up", where no command runs and it is empty' },
            @{ L = 'nv'; Name = 'a repeat taken while a command waits'; File = 'host'; Module = $true; Case = 'commands'; Anchor = '      if (waits) return false;'; With = '      // a command waiting unasked, by the control'
               Want = 'case commands.*commands, version 8, frame 4: while count-up waits a page.s own repeat is fresh and a game.s fresh' },
            # NW to OA (ENGINE.39's second slice), the clipboard case's, each by name: a paste as n acts, the page's copy of 10
            # cells stepping 10 frames; a read-only sheet written, the Ledger's paste taken; a cut emptied at the cut, its cells
            # gone before its paste; the game's chord taken by the page, its Ctrl+C pressed where it passes on; and the last
            # CRLF dropped from Excel's text
            @{ L = 'nw'; Name = 'a paste as n acts'; File = 'host'; Module = $true; Case = 'clipboard'; Anchor = '    this.edits.push(act);   // one act, all or none (decision 10)'; With = '    for (var na = 0; na < act.rows.length; na++) this.edits.push({ paste: true, what: act.what, done: act.done, move: act.move, place: act.place, rows: [act.rows[na]] });   // n acts, by the control'
               Want = 'case clipboard.*clipboard: the paste of the page.s copy into Work!A10 stepped 10 frames, where one is due' },
            @{ L = 'nx'; Name = 'a read sheet written'; File = 'host'; Module = $true; Case = 'clipboard'; Anchor = '      if (m.read) { this.c.editsRead++;'; With = '      if (false) { this.c.editsRead++;'
               Want = 'case clipboard.*clipboard: a paste into the read-only Ledger stepped 1 frame' },
            @{ L = 'ny'; Name = 'a cut emptied at the cut'; File = 'template'; Module = $true; Case = 'clipboard'; Anchor = '    this.kept = { text: text, sheet: sheet, range: range, cells: c.rows, fills: c.fills || [], cut: !!cut, asCut: !!cut };'; With = '    this.kept = { text: text, sheet: sheet, range: range, cells: c.rows, fills: c.fills || [], cut: !!cut, asCut: !!cut }; if (cut) host.edit(''(cell '' + vlaString(sheet) + '' '' + vlaString(VP.rangeText(range)) + '' "")'');   // emptied at the cut, by the control'
               Want = 'case clipboard.*clipboard: the cut of Work!A30:B30 left Work!A30 holding ""' },
            @{ L = 'nz'; Name = 'the game''s chord taken by the page'; File = 'template'; Case = 'clipboard'; Anchor = '  function clipKeyAct(b, ev) { return b && !b.custom && !b.game && CLIP_ACTS[b.command] && clipboardChord(ev) === b.command ? ''pass'' : ''press''; }'; With = '  function clipKeyAct(b, ev) { return ''press''; }   // every binding pressed, by the control'
               Want = 'case clipboard.*clipboard: the page.s Ctrl\+C on the Screen is copy, pressed, where copy, passed on is due' },
            @{ L = 'oa'; Name = 'the last CRLF dropped'; File = 'template'; Case = 'clipboard'; Anchor = '    return rows.map(function (r) { return r.map(clipField).join(''\t'') + ''\r\n''; }).join('''');'; With = '    return rows.map(function (r) { return r.map(clipField).join(''\t''); }).join(''\r\n'');   // the last CRLF dropped, by the control'
               Want = 'case clipboard.*clipboard: Excel.s text of the measured range is' },
            # OB to OE (ENGINE.39's third slice), the clipboard case's, each by name over the module: a formula pasted unmoved, the
            # copy of L1:M2 at N50 reading A1; a cut's formula moved, the cut of L1:L2 at N60 reading C60; a cut's paste untiled,
            # the move over N60:N63 written once (inverted at the owner's word at its push); and a cut's text a copy after its
            # move (the owner's word at its hand test), its paste again over P60:P63 moved; and OF, after its close, a cut's one
            # formula filling a range as one fill row, each cell's references moved from the first's, needing no module
            @{ L = 'ob'; Name = 'a formula pasted unmoved'; File = 'template'; Module = $true; Case = 'clipboard'; Anchor = '    if (fills) rows = rows.concat(pasteFills(sheet, range, h, w, kept.range, fills, asCut ? null : function (t, dr, dc) { return host.moved(t, dr, dc); }));'; With = '    if (fills) rows = rows.concat(pasteFills(sheet, range, h, w, kept.range, fills, null));   // every formula unmoved, by the control'
               Want = 'case clipboard.*clipboard: the page.s copy of Work!L1:M2 pasted at Work!N50 holds Work!N50 "=A1\*10"' },
            @{ L = 'oc'; Name = 'a cut''s formula moved'; File = 'template'; Module = $true; Case = 'clipboard'; Anchor = '    if (fills) rows = rows.concat(pasteFills(sheet, range, h, w, kept.range, fills, asCut ? null : function (t, dr, dc) { return host.moved(t, dr, dc); }));'; With = '    if (fills) rows = rows.concat(pasteFills(sheet, range, h, w, kept.range, fills, function (t, dr, dc) { return host.moved(t, dr, dc); }));   // a cut''s formulas moved too, by the control'
               Want = 'case clipboard.*clipboard: the cut of Work!L1:L2 moved to Work!N60 holds Work!N60 "=C60\*10"' },
            @{ L = 'od'; Name = 'a cut''s paste untiled'; File = 'template'; Module = $true; Case = 'clipboard'; Anchor = '    var h = block.length, w = maxWidth(block), range = pasteRange(area, h, w, own), rows = pasteRows(sheet, range, block), n = 0;'; With = '    var h = block.length, w = maxWidth(block), range = pasteRange(area, h, w, own && !asCut), rows = pasteRows(sheet, range, block), n = 0;   // a cut never tiled, by the control'
               Want = 'case clipboard.*clipboard: after the cut.s paste of Work!L1:L2 into Work!N60:N63 the host said ".*to Work!N60:N61\.' },
            @{ L = 'oe'; Name = 'a cut''s text a copy after its move'; File = 'template'; Module = $true; Case = 'clipboard'; Anchor = '    if (took && p.move) kept.cut = false;   // the cut spent, its texts kept: the clipboard''s text pastes its cells again as they were cut'; With = '    if (took && p.move) { kept.cut = false; kept.asCut = false; }   // the cut''s text a copy after its move, by the control'
               Want = 'case clipboard.*clipboard: after the cut.s text pasted again over Work!P60:P64 the host said ".*the paste of five cells into Work!P60:P64\.' },
            @{ L = 'of'; Name = 'a cut''s one formula a fill row'; File = 'template'; Case = 'clipboard'; Anchor = '    if (move && h === 1 && w === 1 && fills.length === 1) { fill(range, fills[0].text, range.top - from.top, range.left - from.left); return out; }'; With = '    if (h === 1 && w === 1 && fills.length === 1) { fill(range, fills[0].text, range.top - from.top, range.left - from.left); return out; }   // a cut''s one formula a fill row too, by the control'
               Want = 'case clipboard.*clipboard: a cut of L1 filling N64:O65 lays .*N64:O65' },
            # OG and OH (the owner's pick at the tiling's hand test, the selection filled exactly), each needing no module: whole
            # copies alone, the 2 by 2 copy over C5:E7 at its corner; and a fill not cut at the selection's edge
            @{ L = 'og'; Name = 'whole copies alone'; File = 'template'; Case = 'clipboard'; Anchor = '    if (own) return { top: sel.top, left: sel.left, bottom: sel.top + Math.max(sh, h) - 1, right: sel.left + Math.max(sw, w) - 1 };'; With = '    if (own && sh % h === 0 && sw % w === 0) return { top: sel.top, left: sel.left, bottom: sel.bottom, right: sel.right };   // whole copies alone, by the control'
               Want = 'case clipboard.*clipboard: a 2 by 2 copy of the page.s into C5:E7 writes C5:D6, where C5:E7 is due' },
            @{ L = 'oh'; Name = 'a fill not cut at the edge'; File = 'template'; Case = 'clipboard'; Anchor = '          fill({ top: top, left: left, bottom: Math.min(f.bottom + dr, range.bottom), right: Math.min(f.right + dc, range.right) }, f.text, dr, dc);'; With = '          fill({ top: top, left: left, bottom: f.bottom + dr, right: f.right + dc }, f.text, dr, dc);   // every fill whole past the edge, by the control'
               Want = 'case clipboard.*clipboard: L1:M2 filling N50:P52, cut at its edge lays' },
            # OI (the owner's second note at the tiling's hand test, each dimension its own), needing no module: a selection
            # smaller in a row taking the block at its corner, the 2 by 1 copy over C5:E5 at C5:C6
            @{ L = 'oi'; Name = 'a smaller selection the block at its corner'; File = 'template'; Case = 'clipboard'; Anchor = '    if (own) return { top: sel.top, left: sel.left, bottom: sel.top + Math.max(sh, h) - 1, right: sel.left + Math.max(sw, w) - 1 };'; With = '    if (own && sh >= h && sw >= w) return { top: sel.top, left: sel.left, bottom: sel.bottom, right: sel.right };   // a smaller selection the block at its corner, by the control'
               Want = 'case clipboard.*clipboard: a 2 by 1 copy of the page.s into C5:E5 writes C5:C6, where C5:E6 is due' },
            # CART.16's second slice, the file case's. OJ, over the module: the name a file was opened by forgotten, its
            # save under the cartridge's own name.
            @{ L = 'oj'; Name = 'a file saved under the cartridge''s name'; File = 'host'; Module = $true; Case = 'file'; Anchor = '    return given.length > type.length && given.toLowerCase().slice(-type.length) === type.toLowerCase() ? given : (this._cartName() || ''file'') + type;'; With = '    return (this._cartName() || ''file'') + type;   // the name it was opened by forgotten, by the control'
               Want = 'case file.*after settings.env is opened its file is saved under "pairs.env"' },
            # OK, over the module: a person's save of a cartridge that reads a file a cartridge still.
            @{ L = 'ok'; Name = 'a person''s save a cartridge still'; File = 'host'; Module = $true; Case = 'file'; Anchor = '    var file = what === ''file'' || (what !== ''cartridge'' && by === ''person'' && !!this.fileType());'; With = '    var file = what === ''file'';   // a person''s save the cartridge, by the control'
               Want = 'case file.*after an edit a person.s save wrote a cartridge' },
            # OL, over the module: the cartridge's own save, File!B3's, writing the file.
            @{ L = 'ol'; Name = 'the cartridge''s own save the file'; File = 'host'; Module = $true; Case = 'file'; Anchor = '    var file = what === ''file'' || (what !== ''cartridge'' && by === ''person'' && !!this.fileType());'; With = '    var file = what === ''file'' || (what !== ''cartridge'' && !!this.fileType());   // the cartridge''s own save the file, by the control'
               Want = 'case file.*the cartridge.s own save handed the page a file' },
            # OM, needing no module: the check blind to line ends, a file of CR LF found the file written LF.
            @{ L = 'om'; Name = 'the check blind to line ends'; File = 'host'; Case = 'file'; Anchor = '    var a = fileLines(opened), b = fileLines(written), n = Math.max(a.lines.length, b.lines.length);'; With = '    var a = fileLines(String(opened).replace(/\r/g, '''')), b = fileLines(String(written).replace(/\r/g, '''')), n = Math.max(a.lines.length, b.lines.length);'
               Want = 'case file.*part at null, where .* is due: files are held to each other line for line, line ends and all' },
            # ON, over the module: the open's check asked while the load's act settles forgotten, never said.
            @{ L = 'on'; Name = 'a check asked in a settle never said'; File = 'host'; Module = $true; Case = 'file'; Anchor = '    if (w.wait) { this.checkWaiting = { opened: String(opened), name: name }; return { ok: true, waiting: true }; }'; With = '    if (w.wait) return { ok: true, waiting: true };   // the check forgotten, by the control'
               Want = 'case file.*the check was never said' },
            # OO, needing no module: a file's kind judged by its case, WALTER.PL no file of a cartridge that reads .pl.
            @{ L = 'oo'; Name = 'a file''s kind by its case'; File = 'template'; Case = 'file'; Anchor = '  function opensAsLines(name, kind) { return ofKind(name, kind) && !ofKind(name, ''.vla''); }'; With = '  function opensAsLines(name, kind) { return ofKind(name, kind) && name.slice(-kind.length) === kind; }   // by its case, by the control'
               Want = 'case file.*WALTER.PL under a cartridge that reads .pl opens as lines: false' }
        )
        $changesNotes = New-Object System.Collections.Generic.List[string]
        $changesJudged = New-Object System.Collections.Generic.List[object]
        $changesOk = $true
        foreach ($mu in $changesMutants) {
            if ($mu.Module -and $moduleReal -eq 0) { $changesNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            # a viewport's mutant (ENGINE.20), the template's (ENGINE.36) or the host's
            $c2File = if ($mu.ContainsKey('File')) { $mu.File } else { 'host' }
            $c2Orig = if ($c2File -eq 'viewport') { $vpText } elseif ($c2File -eq 'template') { $tpl } elseif ($c2File -eq 'fake') { $fk } else { $js }
            if (([regex]::Matches($c2Orig, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/$c2File.js exactly once"; exit 1 }
            $mutC2 = $c2Orig.Replace($mu.Anchor, $mu.With)
            $c2Applied = $mutC2 -cne $c2Orig
            $fileC2 = Join-Path $tmp ($mu.L + '.' + $c2File + '.js'); [System.IO.File]::WriteAllText($fileC2, $mutC2, $utf8)
            $pageC2 = if ($c2File -eq 'viewport') { New-MutantPage $mu.L $template $hostJs '' '' $fileC2 } elseif ($c2File -eq 'template') { New-MutantPage $mu.L $fileC2 $hostJs } elseif ($c2File -eq 'fake') { New-MutantPage $mu.L $template $hostJs $fileC2 } else { New-MutantPage $mu.L $template $fileC2 }
            $c2Case = if ($mu.ContainsKey('Case')) { $mu.Case } else { 'changes' }   # the save case's (ENGINE.5)
            $rC2 = Invoke-Mutant $pageC2 $c2Case
            $c2Judge = Test-Mutant $rC2 $c2Case
            $c2Failed = @($c2Judge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $changesJudged.Add(@{ Name = $mu.Name; Problems = @($c2Judge.Problems) })
            $changesNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $c2Applied, $c2Failed))
            if (-not ($c2Applied -and $c2Failed -ge 1)) { $changesOk = $false }
        }
        $changesNote = $changesNotes -join '; '
        # CA to CJ (ENGINE.7), hosts, when the real page holds the module, each failing the continue case by name: the
        # rebuilt cartridge loaded instead, the frame begun again at 0; every value row of it written, the person's knob
        # begun again; its rows unrecorded, the replay not the twin's; the next continue compared with the cartridge
        # loaded, D1 written again at frame 16; each row its own write, the refused write's constant landing at 18; no
        # second load, a cell written twice answered ok; the rows written at the press, the frame's derived write
        # landing after D1's at 11; and the manifest, a removed row's cells and the rows no write takes each uncompared,
        # their rebuilt sources answered ok.
        $continueMutants = @(
            @{ L = 'ca'; Name = 'the rebuilt cartridge loaded instead'; Anchor = '    if (!this.m) return this._answerFailed(''There is no engine module to apply a cartridge to.'');'
               With = '    if (this.m) return this.loadBytes(enc.encode(String(text || '''')), this.cartFile);'
               Want = 'case continue.*continue frame 11: after its tick the host is at frame 0 and its twin at 11, where a continue keeps the frame number' },
            @{ L = 'cb'; Name = 'every value row written'; Anchor = '    B.carried.forEach(function (v, key) { var o = A.carried.get(key); if (!o || o.text !== v.text) write.push(v); });'
               With = '    B.carried.forEach(function (v, key) { var o = A.carried.get(key); if (!o || o.text !== v.text || v.head === ''cell'') write.push(v); });'
               Want = 'case continue.*continue frame 11: Knob!B1 is 1, where the person''s edit at frame 3 gives 5' },
            @{ L = 'cc'; Name = 'the rows unrecorded'; Anchor = '        this._recordEdit(b.rows[i]);'; With = '        // the continue''s row unrecorded, by the control'
               Want = 'case continue.*continue: the run''s replay is not the twin''s: ' },
            @{ L = 'cd'; Name = 'the cartridge applied forgotten'; Anchor = '      this.given = b.text;'; With = '      // the cartridge applied forgotten, by the control'
               Want = 'case continue.*continue frame 16: State!D1 is 100, where ' },
            @{ L = 'ce'; Name = 'each row its own write'; Anchor = '    var r = this._write(b.rows.join(''\n''));'
               With = '    var r = { status: 0 }; for (var w = 0; w < b.rows.length && r.status === 0; w++) r = this._write(b.rows[w]);'
               Want = 'case continue.*continue frame 18: Params!B1 is 5, where ' },
            @{ L = 'cf'; Name = 'no second load'; Anchor = '    var r = this._checkLoad(next, file);'; With = '    var r = false;'
               Want = 'case continue.*continue: the rebuilt source with a cell written twice was answered ok, where a load refuses it' },
            @{ L = 'cg'; Name = 'the rows written at the press'; Anchor = '    this.edits.push(b);'; With = '    this._issueApplied(b, false);'
               Want = 'case continue.*continue frame 11: State!D1 is 10, where ' },
            @{ L = 'ch'; Name = 'the manifest uncompared'; Anchor = '    if (m) why.push(m);'; With = '    // the manifest uncompared, by the control'
               Want = 'case continue.*continue: the rebuilt source with \(rate 60\) was answered ok' },
            @{ L = 'ci'; Name = 'a removed row''s cells uncounted'; Anchor = '      if (left !== 0) why.push('; With = '      if (left !== left) why.push('
               Want = 'case continue.*continue: the rebuilt source without Screen!A3 was answered ok' },
            @{ L = 'cj'; Name = 'the rows no write takes uncompared'; Anchor = '    [[B.other, A.other, ''it writes ''], [A.other, B.other, ''it no longer writes '']].forEach('; With = '    [].forEach('
               Want = 'case continue.*continue: the rebuilt source with column A 14 wide was answered ok' }
        )
        $continueNotes = New-Object System.Collections.Generic.List[string]
        $continueJudged = New-Object System.Collections.Generic.List[object]
        $continueOk = $true
        foreach ($mu in $continueMutants) {
            if ($moduleReal -eq 0) { $continueNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            if (([regex]::Matches($js, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/host.js exactly once"; exit 1 }
            $mutC7 = $js.Replace($mu.Anchor, $mu.With)
            $c7Applied = $mutC7 -cne $js
            $fileC7 = Join-Path $tmp ($mu.L + '.host.js'); [System.IO.File]::WriteAllText($fileC7, $mutC7, $utf8)
            $rC7 = Invoke-Mutant (New-MutantPage $mu.L $template $fileC7) 'continue'
            $c7Judge = Test-Mutant $rC7 'continue'
            $c7Failed = @($c7Judge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $continueJudged.Add(@{ Name = $mu.Name; Problems = @($c7Judge.Problems) })
            $continueNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $c7Applied, $c7Failed))
            if (-not ($c7Applied -and $c7Failed -ge 1)) { $continueOk = $false }
        }
        $continueNote = $continueNotes -join '; '
        # CK to CR (ENGINE.23), templates, each failing the palette case by name, with or without the module: Ctrl+Shift+K,
        # Edge's, taken for the palette's key; Cmd+Shift+`, a Mac's, taken; Enter running the first line whatever is
        # chosen; the focus given nowhere back; a row read in ( alone; the first Escape in full screen leaving; the palette
        # left open after its line runs; and a held key's repeat toggling it.
        $paletteMutants = @(
            @{ L = 'ck'; Name = 'Shift ignored, Ctrl+Shift+K taken'; File = 'host'; Anchor = '    if (!!ev.shiftKey !== k.shift || !!ev.altKey !== k.alt) return false;'
               With = '    if (!!ev.altKey !== k.alt) return false;'
               Want = 'case palette.*palette: Ctrl\+Shift\+K, which Edge keeps, opens the palette' },
            @{ L = 'cl'; Name = 'Control taken for Cmd, Cmd+Shift+` taken'; File = 'host'; Anchor = "    else if (k.mod === 'control') { if (!ctrl || meta) return false; }"
               With = "    else if (k.mod === 'control') { if (!ctrl && !meta) return false; }"
               Want = 'case palette.*palette: Cmd\+Shift\+`, a Mac''s, opens the palette' },
            @{ L = 'cm'; Name = 'Enter running the first line'; Anchor = "    if (this.runLine(this.sel) && after && line && line.kind === 'row') after(direction);"
               With = "    if (this.runLine(0) && after && line && line.kind === 'row') after(direction);"
               Want = 'case palette.*palette: the line chosen by ArrowDown after "sheet d" ran "sheet Day"' },
            @{ L = 'cn'; Name = 'the focus given nowhere back'; Anchor = '    if (restore !== false && b && b.focus && b !== this.input) { try { b.focus(); } catch (e) { /* an element gone */ } }'
               With = '    // the focus given nowhere back, by the control'
               Want = 'case palette.*palette: after a line ran the focus is on' },
            @{ L = 'co'; Name = 'a row read in ( alone'; Anchor = '    var isRow = /^\s*[(;]/.test(t);'; With = '    var isRow = /^\s*\(/.test(t);'
               Want = 'case palette.*palette: the text "  ; a comment" gives' },
            @{ L = 'cp'; Name = 'the first Escape leaving full screen'; Anchor = "    if (now - this.at <= this.windowMs) { this.at = -Infinity; return 'leave'; }"
               With = "    if (true) { this.at = -Infinity; return 'leave'; }"
               Want = 'case palette.*palette: an Escape in full screen at 0 ms answered leave, where hint is due' },
            @{ L = 'cq'; Name = 'the palette left open after its line'; Anchor = '    this.close(true);   // the palette shut before its line runs, the focus given back first'
               With = '    // the palette left open, by the control'
               Want = 'case palette.*palette: the palette is open after the line pause ran' },
            @{ L = 'cr'; Name = 'a repeat toggling the palette'; Anchor = '      if (!ev.repeat) self.toggle();'; With = '      self.toggle();'
               Want = 'case palette.*palette: a held Ctrl\+K''s repeat was taken and the palette opened' },
            # FA, FB and FC (CART.9's second slice): a cell's edit whose caret stands past the closing quote; Enter writing a
            # cell's edit and leaving the selection where it was; and the floating palette at the top over a cell in the top
            # half of the rows in view, the window's since its short slice, over the very cell being edited.
            @{ L = 'fa'; Name = 'the caret past the closing quote'; Anchor = "    function row(head, value, quoted) { var t = '(' + head + ' ' + at + value + ')'; return { text: t, caret: t.length - (quoted ? 2 : 1) }; }"
               With = "    function row(head, value, quoted) { var t = '(' + head + ' ' + at + value + ')'; return { text: t, caret: t.length - 1 }; }"
               Want = 'case palette.*palette: the edit of "x" typed is .* and places the caret at 22, where' },
            @{ L = 'fb'; Name = 'a cell''s edit moving nothing'; Anchor = "    if (this.runLine(this.sel) && after && line && line.kind === 'row') after(direction);"
               With = '    this.runLine(this.sel);'
               Want = 'case palette.*palette: a cell''s edit written by Enter wrote .* and moved the selection \[\]' },
            @{ L = 'fc'; Name = 'the floating palette over its cell'; Anchor = "    return (box.top + box.bottom) / 2 <= height / 2 ? 'bottom' : 'top';"
               With = "    return 'top';"
               Want = 'case palette.*palette: the palette floating over the cell .* opens at top, where bottom is due' },
            # GV (CART.9's short slice, the hand test's note): a viewport whose cell's box forgets the scroll, so that the
            # middle of a cell scrolled into view is another cell's or none
            @{ L = 'gv'; Name = 'a cell''s box forgetting the scroll'; File = 'viewport'
               Anchor = '    var x = g.ox + g.colX[col] - (col > g.fc ? this.scroll.x : 0), y = g.oy + g.rowTop(row) - (row > g.fr ? this.scroll.y : 0);'
               With = '    var x = g.ox + g.colX[col], y = g.oy + g.rowTop(row);'
               Want = 'case palette.*palette: the box of B31 scrolled is' },
            # FD, FE and FF (CART.9's hand test of the second slice): Backspace opening what the cell holds and not the cell
            # emptied; Delete's row over the selection's first cell alone; and the window's own blur shutting the palette.
            @{ L = 'fd'; Name = 'Backspace''s emptied cell forgotten'; Anchor = '    if (typed === '''') return row(''cell'', ''""'', true);'
               With = '    // Backspace''s emptied cell forgotten, by the control'
               Want = 'case palette.*palette: Backspace on the gate C2 opens' },
            @{ L = 'fe'; Name = 'Delete over the first cell alone'; Anchor = '    return ''(cell '' + vlaString(sheet) + '' '' + vlaString(sel.text) + '' "")'';'
               With = '    return ''(cell '' + vlaString(sheet) + '' '' + vlaString(sel.text.split('':'')[0]) + '' "")'';'
               Want = 'case palette.*palette: Delete over the selection \{"kind":"cells","text":"A2:B3"' },
            @{ L = 'ff'; Name = 'the window''s blur shutting the palette'; Anchor = "    input.addEventListener('blur', function () { if (self._pageFocused()) self.close(false); });"
               With = "    input.addEventListener('blur', function () { self.close(false); });"
               Want = 'case palette.*palette: a blur while the window had not the focus left the palette shut' },
            @{ L = 'ha'; Name = 'a blur never shutting the palette'; Anchor = "    input.addEventListener('blur', function () { if (self._pageFocused()) self.close(false); });"
               With = "    input.addEventListener('blur', function () { });   // a blur never shutting the palette, by the control"
               Want = 'case palette.*palette: a blur while the window had the focus, a click elsewhere, left the palette open' }
        )
        $paletteNotes = New-Object System.Collections.Generic.List[string]
        $paletteJudged = New-Object System.Collections.Generic.List[object]
        $paletteOk = $true
        foreach ($mu in $paletteMutants) {
            # since CART.3's second slice the key language is the host's, so CK and CL mutate web/host.js
            $origP = if ($mu.File -eq 'viewport') { $vpText } elseif ($mu.File -eq 'host') { $js } else { $tpl }
            if (([regex]::Matches($origP, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in $(if ($mu.File -eq 'viewport') { 'web/viewport.js' } elseif ($mu.File -eq 'host') { 'web/host.js' } else { 'the template' }) exactly once"; exit 1 }
            $mutP = $origP.Replace($mu.Anchor, $mu.With)
            $pApplied = $mutP -cne $origP
            if ($mu.File -eq 'viewport') {
                $vpP = Join-Path $tmp ($mu.L + '.viewport.js'); [System.IO.File]::WriteAllText($vpP, $mutP, $utf8)
                $pageP = New-MutantPage $mu.L $template $hostJs '' '' $vpP
            } elseif ($mu.File -eq 'host') {
                $hostP = Join-Path $tmp ($mu.L + '.host.js'); [System.IO.File]::WriteAllText($hostP, $mutP, $utf8)
                $pageP = New-MutantPage $mu.L $template $hostP
            } else {
                $tplP = Join-Path $tmp ($mu.L + '.template.html'); [System.IO.File]::WriteAllText($tplP, $mutP, $utf8)
                $pageP = New-MutantPage $mu.L $tplP $hostJs
            }
            $rP = Invoke-Mutant $pageP 'palette'
            $pJudge = Test-Mutant $rP 'palette'
            $pFailed = @($pJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $paletteJudged.Add(@{ Name = $mu.Name; Problems = @($pJudge.Problems) })
            $paletteNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $pApplied, $pFailed))
            if (-not ($pApplied -and $pFailed -ge 1)) { $paletteOk = $false }
        }
        $paletteNote = $paletteNotes -join '; '
        # CS to DF (ENGINE.23's second slice and ENGINE.24), templates, each failing the keys case by name, with or without the module: a
        # refused keymap applied anyway; a box's typing keys taken by a binding written for anywhere; a person's command
        # running its first step alone; a keymap without the palette's key applied; AltGr's Ctrl with Alt and a letter
        # bound; the page's own keymap applied and the one kept never forgotten; a kept keymap naming a later page's
        # command refused whole; a box's editing keys taken; DA and DB, the list's words: a key a window's browser keeps
        # said nothing of; and a game's button said shadowed by a key held with Ctrl. DC to DF (ENGINE.24): a binding on a
        # sheet holding on every sheet; a binding on no sheet pressed before one on the sheet shown; a key a game reads as
        # the last key said nothing of; and the drawer's note naming the input card's keys whatever the cartridge binds.
        $keysMutants = @(
            @{ L = 'cs'; Name = 'a refused keymap applied'; Anchor = '    if (problems.length) return { ok: false, problems: problems, notes: notes };'; With = '    // the refusals ignored, by the control'
               Want = 'case keys.*keys: the text ending .* was applied, where it is refused whole' },
            @{ L = 'ct'; Name = 'a box''s typing keys taken'; Anchor = "    if (!k.mod && !(k.kind === 'named' && /^F\d+$/.test(k.value))) return false;"; With = '    // a box''s typing keys open to every binding, by the control'
               Want = 'case keys.*in the place source presses run, where nothing is due' },
            @{ L = 'cu'; Name = 'a person''s command at its first step alone'; Anchor = '    for (var i = 0; i < c.steps.length; i++) {'; With = '    for (var i = 0; i < Math.min(1, c.steps.length); i++) {'
               Want = 'case keys.*keys: the command pr ran' },
            @{ L = 'cv'; Name = 'no key kept for the palette'; Anchor = "    if (!bindings.some(function (b) { return b.command === 'palette'; })) problems.push('the palette keeps a key: no line binds palette, the way to every command');"
               With = '    // the palette''s key unrequired, by the control'
               Want = 'case keys.*saying "the palette keeps a key"' },
            @{ L = 'cw'; Name = 'AltGr bound'; Anchor = "      if (k.alt && k.mod && k.mod !== 'meta' && (k.kind === 'letter' || k.kind === 'digit' || k.kind === 'char')) { problems.push(at + k.text + ' is AltGr on Windows, Ctrl with Alt, which types a character there'); return; }"
               With = '      // AltGr unrefused, by the control'
               Want = 'case keys.*saying "line \d+: Ctrl\+Alt\+K is AltGr on Windows"' },
            @{ L = 'cx'; Name = 'the kept keymap never forgotten'; Anchor = '      if (text === defaults) { this.s.removeItem(this.key); this.s.removeItem(this.key + ''-commands''); } else this.s.setItem(this.key, text);'; With = '      this.s.setItem(this.key, text);'
               Want = 'case keys.*keys: the page''s own keymap applied left a keymap kept' },
            @{ L = 'cy'; Name = 'a later page''s line refused whole'; Anchor = '      if (!known(cmd)) { if (lenient) notes.push('; With = '      if (!known(cmd)) { if (false) notes.push('
               Want = 'case keys.*keys: a kept keymap naming a later page''s command was refused' },
            @{ L = 'cz'; Name = 'a box''s editing keys taken'; Anchor = '    if (k.mod && !k.alt && /^(a|c|v|x|y|z|arrowleft|arrowright|arrowup|arrowdown|home|end|backspace|delete)$/.test(k.value.toLowerCase())) return false;'
               With = '    // a box''s editing keys open to every binding, by the control'
               Want = 'case keys.*in the place source presses pause, where nothing is due' },
            @{ L = 'da'; Name = 'a window''s browser''s keys unsaid'; Anchor = "    if (!k.alt && ((ctrl && /^(t|n|w|tab)$/.test(v)) || (k.mod === 'meta' && /^(t|n|w)$/.test(v)) || (ctrl && !k.shift && /^(f4|pagedown|pageup)$/.test(v)))) out.push('the browser\'s in a window, the page\'s in full screen');"
               With = '    // a window''s browser''s keys unsaid, by the control'
               Want = 'case keys.*keys: the list says of Ctrl\+W "", where it names' },
            @{ L = 'db'; Name = 'a shadow said of a key held with Ctrl'; Anchor = 'screen = !b.keys.mod && place'; With = 'screen = place'
               Want = 'case keys.*keys: the list says of \(bind "Ctrl\+Z" run\) beside a game''s Z.*where no shadow is due' },
            @{ L = 'dc'; Name = 'a binding on a sheet held on every sheet'; Anchor = '      return shown !== null && shown !== undefined && !!b.sheets[String(shown).toLowerCase()];'; With = '      return true;'
               Want = 'case keys.*keys: P in the place screen showing Day presses pause, where run is due' },
            @{ L = 'dd'; Name = 'a binding on no sheet pressed first'; Anchor = '    for (i = 0; i < map.bindings.length; i++) { b = map.bindings[i]; if (b.sheets && holdsIn(b, place, shown) && keyMatches(b.keys, ev)) return b; }'
               With = '    for (i = 0; i < map.bindings.length; i++) { b = map.bindings[i]; if (holdsIn(b, place, shown) && keyMatches(b.keys, ev)) return b; }'
               Want = 'case keys.*keys: P in the place screen showing Gigs presses run, where pause is due' },
            @{ L = 'de'; Name = 'the last key unsaid'; Anchor = "    else if (screen && readsKey) out.push('shadows a key the game reads on the Screen');"; With = '    // the last key unsaid, by the control'
               Want = 'case keys.*keys: beside a game that reads the last key, the list says of 3 ""' },
            @{ L = 'df'; Name = 'the input card''s keys said of every game'; Anchor = "    var said = players.length ? players.join('; ') : hasKeys ? 'the game binds no key now' : readsKey ? '' : 'this cartridge binds no key';"
               With = "    var said = 'the arrows, Z, X, A, S, Enter and Space are player 1\'s';"
               Want = 'case keys.*keys: the drawer''s note says the game''s keys' }
        )
        $keysNotes = New-Object System.Collections.Generic.List[string]
        $keysJudged = New-Object System.Collections.Generic.List[object]
        $keysOk = $true
        foreach ($mu in $keysMutants) {
            if (([regex]::Matches($tpl, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in the template exactly once"; exit 1 }
            $mutK = $tpl.Replace($mu.Anchor, $mu.With)
            $kApplied = $mutK -cne $tpl
            $tplK = Join-Path $tmp ($mu.L + '.template.html'); [System.IO.File]::WriteAllText($tplK, $mutK, $utf8)
            $rK = Invoke-Mutant (New-MutantPage $mu.L $tplK $hostJs) 'keys'
            $kJudge = Test-Mutant $rK 'keys'
            $kFailed = @($kJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $keysJudged.Add(@{ Name = $mu.Name; Problems = @($kJudge.Problems) })
            $keysNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $kApplied, $kFailed))
            if (-not ($kApplied -and $kFailed -ge 1)) { $keysOk = $false }
        }
        $keysNote = $keysNotes -join '; '
        # DG to DO (ENGINE.25), hosts, when the real page holds the module, each failing by name: the command never written
        # into Input!B20; B20 kept past its frame; one command waiting, the first of two in a frame dropped; B20 written for a
        # version 4 cartridge too, whose Input rows the engine refuses; a command that holds not run; a command run while a
        # replay plays; a command's key taken with Ctrl held; its key's repeat running it again; and at rate 0 B20 left for
        # the step after a command's. And EY (CART.14's hand test, its fifth note): a keypad's digit running no command.
        $commandsMutants = @(
            @{ L = 'dg'; Name = 'the command never written'; Anchor = "    if (this._five()) out.push('(cell `"Input`" `"B20`" ' + quote(this.commandNow || '') + ')');   // the command that runs at the step (ENGINE.25)"
               With = '    // the command unwritten, by the control'
               Want = 'case commands.*commands frame 2: Input!B20 holds "", where the command count-up runs' },
            @{ L = 'dh'; Name = 'the command kept past its frame'; Anchor = "      this.commandNow = this._five() && this.waiting.length ? this.waiting.shift() : '';   // the command that runs at this step, one a frame (ENGINE.25)"
               With = '      this.commandNow = this._five() && this.waiting.length ? this.waiting.shift() : this.commandNow;'
               Want = 'case commands.*commands frame 3: Input!B20 holds "count-up", where no command runs and it is empty' },
            @{ L = 'di'; Name = 'one command waiting'; Anchor = '      this.waiting.push(cmd.name);'; With = '      this.waiting = [cmd.name];'
               Want = 'case commands.*commands frame 4: Input!B20 holds "count-down", where the command count-up runs' },
            @{ L = 'dj'; Name = 'the twentieth row for a version 4 cartridge'; Cases = 'views,commands'; Anchor = '  Host.prototype._five = function () { return !!this.cart && this.cart.spec >= 5; };'
               With = '  Host.prototype._five = function () { return !!this.cart && this.cart.spec >= 4; };'
               Want = 'case commands.*commands, version 4: the host was refused' },
            @{ L = 'dk'; Name = 'a command that holds not run'; Anchor = "    if (!cmd.holds) return no('it holds not now, as Commands!C' + cmd.row + ' says.');"; With = '    // the holds unasked, by the control'
               Want = 'case commands.*commands frame 16: count-up on the Ledger was run, where it holds not' },
            @{ L = 'dl'; Name = 'a command run while a replay plays'; Anchor = '    if (this.player) return no('; With = '    if (false) return no('
               Want = 'case commands.*commands: a command while a replay plays was run, where it is refused as an edit is' },
            @{ L = 'dm'; Name = 'a command''s key taken with Ctrl held'; Anchor = '    if (ev && (ev.ctrlKey || ev.metaKey || ev.altKey)) return null;   // a bare key, with no Ctrl, Cmd or Alt held (decision 52)'; With = '    // the bare key taken with Ctrl held, by the control'
               Want = 'case commands.*commands frame 12: Ctrl\+U on the Desk was taken' },
            @{ L = 'dn'; Name = 'a command''s key run again at its repeat'; Anchor = '    if (ev && ev.repeat && !(cmd.repeats && this.freshRepeat(ev))) return;'; With = '    // every repeat run, by the control'
               Want = 'case commands.*commands frame 11: Input!B20 holds "count-up", where no command runs and it is empty' },
            @{ L = 'do'; Name = 'the twentieth row left at rate 0'; Anchor = '    else if (atRateZero && this._five()) this._writeCommandRow(act.command !== undefined ? act.command : '''');'
               With = '    else if (atRateZero && this._five() && act.command !== undefined) this._writeCommandRow(act.command);'
               Want = 'case commands.*commands, rate 0: the step of the edit after the command sees Input!B20 "count-up"' },
            @{ L = 'ey'; Name = 'the keypad''s digits no digits'; Anchor = '    var row = keypadDigit(code, key !== undefined ? key : (ev ? ev.key : undefined)), name, c;'
               With = '    var row = null, name, c;'
               Want = 'case commands.*commands frame 38: the keypad''s 7 with Num Lock on was passed on and Input!B20 holds "", where the command seven, whose key is the digit row''s 7, takes it' },
            # MO to MR (CART.3's second slice, version 7), hosts, each failing the commands case by name over the module: a key with
            # modifiers taken with Shift held too; Cmd not taken for Ctrl; a key with modifiers read below version 7; and a key
            # with Shift left to the bare key of its code.
            @{ L = 'mo'; Name = 'a key with modifiers taken with more held'; Anchor = '    if (!!ev.shiftKey !== k.shift || !!ev.altKey !== k.alt) return false;'; With = '    if ((k.shift && !ev.shiftKey) || (k.alt && !ev.altKey)) return false;'
               Want = 'case commands.*commands, version 7, frame 6: Ctrl\+Shift\+U was taken, where it is passed on' },
            @{ L = 'mp'; Name = 'Cmd not taken for Ctrl'; Anchor = "    if (k.mod === 'either') { if (ctrl === meta) return false; }"; With = "    if (k.mod === 'either') { if (!ctrl || meta) return false; }"
               Want = 'case commands.*commands, version 7, frame 4: Cmd\+U was passed on, where it is taken' },
            @{ L = 'mq'; Name = 'a key with modifiers read below version 7'; Anchor = "    if (parts.length && !seven) return { error: 'version 7' };"; With = '    // the version unasked, by the control'
               Want = 'case commands.*commands, version 6: the host lists count-up KeyU, count-ten Ctrl\+KeyU' },
            @{ L = 'mr'; Name = 'a key with Shift left to the bare key'; Anchor = '        if (c.chord && !c.chord.bare && (c.chord.value === code || c.chord.value === row) && modifiersMatch(c.chord, ev)) return c;'
               With = '        if (c.chord && !c.chord.bare && !c.chord.shift && (c.chord.value === code || c.chord.value === row) && modifiersMatch(c.chord, ev)) return c;'
               Want = 'case commands.*commands, version 7, frame 5: Input!B20 holds "count-up", where the command count-hundred runs' }
        )
        $commandsNotes = New-Object System.Collections.Generic.List[string]
        $commandsJudged = New-Object System.Collections.Generic.List[object]
        $commandsOk = $true
        foreach ($mu in $commandsMutants) {
            if ($moduleReal -eq 0) { $commandsNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            if (([regex]::Matches($js, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/host.js exactly once"; exit 1 }
            $mutCmd = $js.Replace($mu.Anchor, $mu.With)
            $cmdApplied = $mutCmd -cne $js
            $fileCmd = Join-Path $tmp ($mu.L + '.host.js'); [System.IO.File]::WriteAllText($fileCmd, $mutCmd, $utf8)
            $cmdCases = if ($mu.ContainsKey('Cases')) { $mu.Cases } else { 'commands' }
            $rCmd = Invoke-Mutant (New-MutantPage $mu.L $template $fileCmd) $cmdCases
            $cmdJudge = Test-Mutant $rCmd $cmdCases
            $cmdFailed = @($cmdJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $commandsJudged.Add(@{ Name = $mu.Name; Problems = @($cmdJudge.Problems) })
            $commandsNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $cmdApplied, $cmdFailed))
            if (-not ($cmdApplied -and $cmdFailed -ge 1)) { $commandsOk = $false }
        }
        $commandsNote = $commandsNotes -join '; '
        # DP to DT (ENGINE.25's second slice), templates, each failing the commands case's page half by name, with or without the
        # module: the palette listing a game's command that holds not; the keymap refusing a game's commands, a binding of a
        # cartridge not loaded among them; a binding of a game's command pressed while it holds not, its key never passed on;
        # the list silent of a game's command key a person's binding shadows on the Screen; and, at the owner's hand test, the page's own commands ranked with a person's own and the game's, listed first in the palette and in the list.
        $pageMutants = @(
            @{ L = 'dp'; Name = 'a game''s command that holds not listed'; Anchor = '      if (c.arg || c.hidden || (c.game && !c.holds)) return;   // a game''s command that holds not is no line (ENGINE.25)'
               With = '      if (c.arg || c.hidden) return;'
               Want = 'case commands.*commands: the palette lists commandcard.count-down, which holds not' },
            @{ L = 'dq'; Name = 'a game''s commands unknown to the keymap'; Anchor = '    function known(name) { return builtin[name] || customs[String(name).toLowerCase()] || !!gameName(name); }'
               With = '    function known(name) { return builtin[name] || customs[String(name).toLowerCase()]; }'
               Want = 'case commands.*commands: the keymap naming a game''s commands was refused' },
            @{ L = 'dr'; Name = 'a binding of a command that holds not pressed'; Anchor = '    map = { bindings: map.bindings.filter(function (x) { return !x.game || (!!live && live(x.command)); }) };   // a game''s command, while it is live'
               With = '    map = { bindings: map.bindings };'
               Want = 'case commands.*commands: U on the Screen while count-up holds not presses commandcard.count-up' },
            @{ L = 'ds'; Name = 'a game''s command key unsaid'; Anchor = "    if (taken.length) out.push('shadows the game\'s command ' + andList(taken.map(function (c) { return '\'' + c.name + '\''; })) + ' on the Screen');"
               With = '    // the game''s command keys unsaid, by the control'
               Want = 'case commands.*commands: the list says of \(bind "U" pause\) beside the game''s U ""' },
            @{ L = 'dt'; Name = 'the page''s own commands listed first'; Anchor = '  function commandRank(c) { return c.custom ? 0 : c.game ? 1 : 2; }'
               With = '  function commandRank(c) { return 2; }'
               Want = 'case commands.*commands: an empty palette lists' }
        )
        $pageNotes = New-Object System.Collections.Generic.List[string]
        $pageJudged = New-Object System.Collections.Generic.List[object]
        $pageOk = $true
        foreach ($mu in $pageMutants) {
            if (([regex]::Matches($tpl, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in the template exactly once"; exit 1 }
            $mutPg = $tpl.Replace($mu.Anchor, $mu.With)
            $pgApplied = $mutPg -cne $tpl
            $tplPg = Join-Path $tmp ($mu.L + '.template.html'); [System.IO.File]::WriteAllText($tplPg, $mutPg, $utf8)
            $rPg = Invoke-Mutant (New-MutantPage $mu.L $tplPg $hostJs) 'commands'
            $pgJudge = Test-Mutant $rPg 'commands'
            $pgFailed = @($pgJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $pageJudged.Add(@{ Name = $mu.Name; Problems = @($pgJudge.Problems) })
            $pageNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $pgApplied, $pgFailed))
            if (-not ($pgApplied -and $pgFailed -ge 1)) { $pageOk = $false }
        }
        $pageNote = $pageNotes -join '; '
        # DX to EF (CART.12, version 6), hosts, each failing the settle case by name, five over the double and so with or without
        # the module: a host that never steps a settle; one whose act's place is 0; one whose press over a cell is no act; one
        # that never steps the load's act; and one that says nothing when K stops a settle. And four when the real page holds
        # the module: an act made during a settle cutting into it; the engine's release unmirrored, so that a second press on
        # one cell writes no press; a command's key at rate 0 left to the viewport; and a press read after the viewport's own
        # handler, whose focus scrolls the page under the point (found by a trial of the large board, its box below the fold).
        $settleMutants = @(
            @{ L = 'dx'; Name = 'a settle never stepped'; Anchor = '    while (!this.inFrame && this.handle && !this.player && (this.settling || this.edits.length)) {'
               With = '    while (!this.inFrame && this.handle && !this.player && this.edits.length) {'
               Want = 'case settle.*settle, the double: the load stands at frame 1, settling,' },
            @{ L = 'dy'; Name = 'an act cutting into a settle'; Module = $true; Anchor = '      if (this.settling) { if (!this._continue(win)) return; continue; }'
               With = '      if (this.settling && !this.edits.length) { if (!this._continue(win)) return; continue; }'
               Want = 'case settle.*settle, waiting: the edit made at the press''s act landed at frame \d+ and the spill reached K2 at frame' },
            @{ L = 'dz'; Name = 'the release unmirrored'; Module = $true; Anchor = '    if (this.settling && !was) this._released();'; With = '    // the release unmirrored, by the control'
               Want = 'case settle.*a second press on E2 read Input!B13 0 at its act''s frame 11' },
            @{ L = 'ea'; Name = 'an act''s place at 0'; Anchor = '    var want = { B11: String(p.col), B12: String(p.row),'; With = '    var want = { B11: ''0'', B12: ''0'','
               Want = 'case settle.*settle, the double: a press over C3 made the act \{"b13":1,"b11":0,"b12":0' },
            @{ L = 'eb'; Name = 'a press over a cell no act'; Anchor = "    this._on(root, 'mousedown', function (ev) { if (still() && self._pressActs()) self._pressAct(ev); }, true);"
               With = '    // the press at rate 0 no act, by the control'
               Want = 'case settle.*settle, the double: a press over C3 made the act null' },
            @{ L = 'ec'; Name = 'a command''s key at rate 0 the viewport''s'; Module = $true; Anchor = '      var cmd = still() ? self._commandKey(ev.code, ev) : null;'; With = '      var cmd = null;'
               Want = 'case settle.*settle: KeyS at rate 0 was passed on' },
            @{ L = 'ed'; Name = 'the load''s act unstepped'; Anchor = '    if (this._settles() && c.rate === 0 && this.playSeed === undefined && this.frame === 0) { this.edits.push({ load: true }); this._editFrames(this._window()); }'
               With = '    // the load''s act unstepped, by the control'
               Want = 'case settle.*settle, the double: the load stands at frame 0' },
            @{ L = 'ef'; Name = 'a press read after the viewport''s own'; Module = $true; Anchor = "    this._on(root, 'mousedown', function (ev) { if (still() && self._pressActs()) self._pressAct(ev); }, true);"
               With = "    this._on(root, 'mousedown', function (ev) { if (still() && self._pressActs()) self._pressAct(ev); });"
               Want = 'case settle.*settle: a press on E2 left frame \d+' },
            @{ L = 'ee'; Name = 'an unsettled act unsaid'; Anchor = "        this._answer('frame ' + n + ': ' + sa.what + ' did not settle in ' + countWords(steps + 1) + ' frames, the most its (settle ' + this.cart.settle + ') allows: the grid still moves, and waits for the next act (docs/SPEC.md section 5).');"
               With = '        // the unsettled act unsaid, by the control'
               Want = 'case settle.*settle, the double: the host said "the load did not settle in nine frames" 0 time' },
            # CART.9's fourth slice, decision 51: a settled act's frames and what each was for, and a command's name quoted
            @{ L = 'hw'; Name = 'a settle''s frames counted as its steps'; Anchor = "    return countWords(steps + 1) + ' frames: ' + parts.join(', ');"
               With = "    return countWords(steps) + ' frames: ' + parts.join(', ');"
               Want = 'case settle.*settle, the double: an act of 2 step\(s\) reads "two frames: it ran, it was released' },
            @{ L = 'hx'; Name = 'a command''s name unquoted'; Anchor = "  function commandWords(name) { return 'command \'' + name + '\''; }"
               With = "  function commandWords(name) { return 'command ' + name; }"
               Want = 'case settle.*settle, the double: a command reads "command one"' },
            @{ L = 'hy'; Name = 'a command''s release unsaid'; Anchor = "    if (steps >= 2) parts.push(released ? 'it was released' : 'the grid read it');"
               With = "    if (steps >= 2) parts.push('the grid read it');"
               Want = 'case settle.*settle, the double: an act of 2 step\(s\) reads "three frames: it ran, the grid read it' },
            # FG (CART.9's hand test of the second slice): a press an act whatever the cartridge reads, three frames that move
            # nothing on a cartridge that reads neither an act's place nor its press; its anchor since the third slice the line
            # that also asks whether the sheet's keys are the game's, which the mutant keeps.
            @{ L = 'fg'; Name = 'a press an act whatever is read'; Anchor = '    return this.actRead && this.gameKeysHere();'; With = '    return this.gameKeysHere();'
               Want = 'case settle.*settle, the double: a press over C3 of a cartridge reading no act''s place or press made 1 press' },
            # GB (CART.9's third slice, its rider, and the log a line a run after it): a log whose lines span loads, so that
            # a load's sentences are counted in an earlier load's lines and the bar skips them, the line before the Load left.
            @{ L = 'gb'; Name = 'a line across loads'; Anchor = '    var slot = this.run + '':'' + key, e = this.entries.get(slot);'; With = '    var slot = key, e = this.entries.get(slot);'
               Want = 'case settle.*settle, the double: a Load of the cartridge loaded again left the status line at' }
        )
        $settleNotes = New-Object System.Collections.Generic.List[string]
        $settleJudged = New-Object System.Collections.Generic.List[object]
        $settleOk = $true
        foreach ($mu in $settleMutants) {
            if ($mu.Module -and $moduleReal -eq 0) { $settleNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            if (([regex]::Matches($js, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/host.js exactly once"; exit 1 }
            $mutSt = $js.Replace($mu.Anchor, $mu.With)
            $stApplied = $mutSt -cne $js
            $fileSt = Join-Path $tmp ($mu.L + '.host.js'); [System.IO.File]::WriteAllText($fileSt, $mutSt, $utf8)
            $rSt = Invoke-Mutant (New-MutantPage $mu.L $template $fileSt) 'settle'
            $stJudge = Test-Mutant $rSt 'settle'
            $stFailed = @($stJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $settleJudged.Add(@{ Name = $mu.Name; Problems = @($stJudge.Problems) })
            $settleNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $stApplied, $stFailed))
            if (-not ($stApplied -and $stFailed -ge 1)) { $settleOk = $false }
        }
        $settleNote = $settleNotes -join '; '
        # FI to FT (SPEC.5), each failing the modes case by name. Templates, needing no module: FI, a key on a read sheet
        # opening a cell's edit; FJ, the last key read on every sheet at a rate, a work sheet's too; and FK, the palette's
        # place written beside the line it replaces, two lines the keymap refuses. Hosts over the double, needing no module:
        # FM, a work or a read sheet the game's where no game sheet is named; FN, a read sheet written by hand; FO, a
        # person's row into a read sheet written; FP, a sheet named by none the game's where a game sheet is named; and FT,
        # a game sheet's keys forgotten. And hosts when the real page holds the module: FR, a command's key run on every
        # sheet at rate 0; and FS, every key the game's at a rate. And the hand test's templates, needing no module: FU,
        # Enter on a read-only sheet left to the viewport; and FV, Tab left to the browser. And CART.9's third slice's host
        # over the module: FW, a press an act on every sheet, a work sheet's and a read sheet's too.
        $modesMutants = @(
            @{ L = 'fi'; Name = 'a key on a read sheet an edit'; Template = $true; Anchor = "    if (!at.editsHere) return 'read';"
               With = '    // a read sheet written by a key, by the control'
               Want = 'case modes.*modes: on a read sheet, x the page makes edit of the key, where read is due' },
            @{ L = 'fj'; Name = 'the last key read on every sheet'; Template = $true; Anchor = "    if ((at.rate > 0 && at.lastKeyRead && at.gameHere) || at.takes) return 'game';"
               With = "    if ((at.rate > 0 && at.lastKeyRead) || at.takes) return 'game';"
               Want = 'case modes.*modes: on a work sheet at a rate reading the last key, x the page makes game of the key, where edit is due' },
            @{ L = 'fk'; Name = 'the palette''s place written beside its line'; Template = $true; Anchor = "    var lines = String(text).split('\n').filter(function (l) { return !/^\s*\(palette\s/.test(l); });"
               With = "    var lines = String(text).split('\n');"
               Want = 'case modes.*modes, the palette''s place: that keymap moved to the bottom reads .* with 2 line\(s\) of the place' },
            @{ L = 'fm'; Name = 'a work or a read sheet the game''s'; Anchor = '    if (m.work || m.read) return false;'
               With = '    // a work or a read sheet the game''s where no game sheet is named, by the control'
               Want = 'case modes.*modes, the double: under a manifest naming no game sheet, its work sheet the game''s keys hold on State' },
            @{ L = 'fn'; Name = 'a read sheet written by hand'; Anchor = '  Host.prototype.editsHere = function () { return !this.sheetMode(this._shown()).read; };'
               With = '  Host.prototype.editsHere = function () { return true; };'
               Want = 'case modes.*modes, the double: Rules is "read", the game''s keys not holding and a person writing it' },
            @{ L = 'fo'; Name = 'a person''s row into a read sheet written'; Anchor = '    if (into !== null && this.sheetMode(into).read) {   // a read-only sheet (SPEC.5), its cartridge''s rows and the Write sheet''s still writing it'
               With = '    if (false) {'
               Want = 'case modes.*modes, the double: the row \(cell "Rules" "A1" 1\) was written, where it is refused' },
            @{ L = 'fp'; Name = 'a sheet named by none the game''s'; Anchor = '    return !(c.game && c.game.length);'
               With = '    return true;'
               Want = 'case modes.*modes, the double: Other is "", the game''s keys holding' },
            @{ L = 'ft'; Name = 'a game sheet''s keys forgotten'; Anchor = '    if (m.game) return true;'
               With = '    // a game sheet''s keys forgotten, by the control'
               Want = 'case modes.*modes, the double: Tray is "game", the game''s keys not holding' },
            @{ L = 'fu'; Name = 'Enter on a read-only sheet the viewport''s'; Template = $true; Anchor = "      return at.editsHere ? 'pass' : 'step';"
               With = "      return 'pass';"
               Want = 'case modes.*modes: on a read sheet, Enter the page makes pass of the key, where step is due' },
            @{ L = 'fv'; Name = 'Tab the browser''s'; Template = $true; Anchor = "      if (ev.key === 'Tab') return at.rate > 0 && at.gameHere ? 'game' : 'step';"
               With = "      if (ev.key === 'Tab') return at.rate > 0 && at.gameHere ? 'game' : 'pass';"
               Want = 'case modes.*modes: on a work sheet, Tab the page makes pass of the key, where step is due' },
            # CART.9's fourth slice, decisions 49 and 50: on a game sheet a person writes, a key is the game's, or =, or refused
            @{ L = 'ho'; Name = 'a stray key opening a game sheet''s cell'; Template = $true; Anchor = "    if (typed && at.gameSheet && ev.key !== '=') return 'stray';"
               With = '    // a stray key opening a game sheet''s cell, by the control'
               Want = 'case modes.*modes: on a game sheet, x, no key of the game''s the page makes edit of the key, where stray is due' },
            @{ L = 'hp'; Name = 'a game sheet''s = closed'; Template = $true; Anchor = "    if (typed && at.gameSheet && ev.key !== '=') return 'stray';"
               With = "    if (typed && at.gameSheet) return 'stray';"
               Want = 'case modes.*modes: on a game sheet, = the page makes stray of the key, where edit is due' },
            @{ L = 'hs'; Name = 'a game sheet''s Delete closed'; Template = $true; Anchor = "    if (typed && at.gameSheet && ev.key !== '=') return 'stray';"
               With = "    if (at.gameSheet && ev.key !== '=') return 'stray';"
               Want = 'case modes.*modes: on a game sheet, Delete the page makes stray of the key, where empty is due' },
            @{ L = 'ht'; Name = 'a stray key saying nothing'; Anchor = '    this._answerRefused(text);   // the log counts the repeats'
               With = '    // a stray key saying nothing, by the control'
               Want = 'case modes.*modes, the double: two stray keys on Tray made 2 refusal\(s\), said 0 time\(s\)' },
            @{ L = 'hu'; Name = 'a repeat standing under a key''s refusal'; Template = $true; Anchor = '  function barTakes(s, holdsKey) { return !s.repeat || !!s.act || holdsKey; }'
               With = '  function barTakes(s, holdsKey) { return !s.repeat || !!s.act; }'
               Want = 'case modes.*modes: the bar passes over a repeat over a key''s refusal, where it takes it' },
            @{ L = 'hv'; Name = 'every repeat in the bar'; Template = $true; Anchor = '  function barTakes(s, holdsKey) { return !s.repeat || !!s.act || holdsKey; }'
               With = '  function barTakes(s, holdsKey) { return true; }'
               Want = 'case modes.*modes: the bar takes a repeat, where it passes over it' },
            # NL (ENGINE.42): the bar of 2026-10-09 again, an act's answer said a second time passed over as the loop's
            # own repeat is, which the bar's table and the answers over the module each fail
            @{ L = 'nl'; Name = 'an act''s answer said again passed over'; Template = $true; Anchor = '  function barTakes(s, holdsKey) { return !s.repeat || !!s.act || holdsKey; }'
               With = '  function barTakes(s, holdsKey) { return !s.repeat || holdsKey; }'
               Want = 'case modes.*modes: the bar passes over a repeat answering an act, where it takes it' },
            @{ L = 'hq'; Name = 'no sheet a game sheet'; Anchor = '  Host.prototype.gameSheetHere = function () { return this.sheetMode(this._shown()).game; };'
               With = '  Host.prototype.gameSheetHere = function () { return false; };'
               Want = 'case modes.*modes, the double: Tray is "game", the game''s keys holding and a person writing it, no game sheet' },
            @{ L = 'hr'; Name = 'a sheet named by none a game sheet'; Anchor = '  Host.prototype.gameSheetHere = function () { return this.sheetMode(this._shown()).game; };'
               With = '  Host.prototype.gameSheetHere = function () { return this.gameKeysHere(); };'
               Want = 'case modes.*modes, the double: under a manifest naming no game sheet the game''s keys hold on Other and a person writes it, read as a game sheet' },
            @{ L = 'fr'; Name = 'a command''s key on every sheet'; Module = $true; Anchor = '    if (!this.gameKeysHere()) return null;   // no command''s key holds on a work or a read sheet (SPEC.5)'
               With = '    // a command''s key on every sheet, by the control'
               Want = 'case modes.*modes: M on Notes was taken' },
            @{ L = 'fs'; Name = 'every key the game''s at a rate'; Module = $true; Anchor = '    if (!code || !this.gameKeysHere()) return false;   // a work or a read sheet''s keys are not the game''s (SPEC.5)'
               With = '    if (!code) return false;'
               Want = 'case modes.*modes, at a rate: on Notes M was passed on and x left the last key "x"' },
            @{ L = 'fw'; Name = 'a press an act on every sheet'; Module = $true; Anchor = '    return this.actRead && this.gameKeysHere();'
               With = '    return this.actRead;'
               Want = 'case modes.*modes: a press over C3 on Notes was an act' }
        )
        $modesNotes = New-Object System.Collections.Generic.List[string]
        $modesJudged = New-Object System.Collections.Generic.List[object]
        $modesOk = $true
        foreach ($mu in $modesMutants) {
            if ($mu.Module -and $moduleReal -eq 0) { $modesNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            $source = if ($mu.Template) { $tpl } else { $js }
            $where = if ($mu.Template) { 'the template' } else { 'web/host.js' }
            if (([regex]::Matches($source, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in $where exactly once"; exit 1 }
            $mutMd = $source.Replace($mu.Anchor, $mu.With)
            $mdApplied = $mutMd -cne $source
            if ($mu.Template) {
                $fileMd = Join-Path $tmp ($mu.L + '.template.html'); [System.IO.File]::WriteAllText($fileMd, $mutMd, $utf8)
                $pageMd = New-MutantPage $mu.L $fileMd $hostJs
            } else {
                $fileMd = Join-Path $tmp ($mu.L + '.host.js'); [System.IO.File]::WriteAllText($fileMd, $mutMd, $utf8)
                $pageMd = New-MutantPage $mu.L $template $fileMd
            }
            $rMd = Invoke-Mutant $pageMd 'modes'
            $mdJudge = Test-Mutant $rMd 'modes'
            $mdFailed = @($mdJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $modesJudged.Add(@{ Name = $mu.Name; Problems = @($mdJudge.Problems) })
            $modesNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $mdApplied, $mdFailed))
            if (-not ($mdApplied -and $mdFailed -ge 1)) { $modesOk = $false }
        }
        $modesNote = $modesNotes -join '; '
        # EM to ES (ENGINE.26), when the real page holds the engine's module, the widths card being the module's: viewports,
        # each failing the widths case by name. Its widths one map for every sheet again, a column's letters alone, as they
        # were until Buffet's PLATE.1 and POT.11 hand tests; a clear that keeps them, so that a Load does; a sheet's region
        # estimated at the sheet shown's widths; a drag that raises no scroll, so that at rate 0 the columns it brings into
        # view stay unviewed; a drag that sets the sheet shown's width, not the one it was pressed on; a press that moved
        # nothing raising columnresize; and a load without keep forgetting its sheet's widths, as the Screen's tab loads it.
        $widthsMutants = @(
            @{ L = 'em'; Name = 'the widths one map'; Anchor = '    return this.widths[key] || (this.widths[key] = {});'; With = "    return this.widths[''] || (this.widths[''] = {});"
               Want = 'case widths.*widths frame 1: the viewport keeps the Ledger''s widths as \{"D":321\}, where its own are \{\}' },
            @{ L = 'en'; Name = 'the widths kept by clear'; Anchor = '    this.widths = {}; this.drag = null;'; With = '    this.drag = null;'
               Want = 'case widths.*widths, a Load: the viewport keeps the Desk''s widths as \{"D":361\}, where its own are \{\}' },
            @{ L = 'eo'; Name = 'a region estimated at the sheet shown''s widths'; Anchor = '    while (x < w && c < MAX_COLUMNS) { c++; x += columnWidthCss(model, this._widthsOf(name), c, layout); }'
               With = '    while (x < w && c < MAX_COLUMNS) { c++; x += columnWidthCss(model, this._widthsOf(this.active), c, layout); }'
               Want = 'case widths.*widths, the Ledger shown from the Desk: the viewport estimates the Ledger''s region as [A-Z]+\d+:[A-Z]+\d+, where its own widths lay' },
            @{ L = 'ep'; Name = 'a drag unsaid'; Anchor = "      if (now.window !== was) this._emit('scroll', now);"; With = '      // the drag unsaid, by the control'
               Want = 'case widths.*widths, the Ledger''s D narrowed: the viewport shows Ledger![A-Z]+\d+:[A-Z]+\d+, past the record''s window' },
            @{ L = 'eq'; Name = 'a drag the sheet shown''s'; Anchor = '      this._widthsOf(drag.sheet)[colName(drag.col)] = w;'; With = '      this._widthsOf(this.active)[colName(drag.col)] = w;'
               Want = 'case widths.*widths, a drag pressed on the Desk: the drag raised columnresize \{"sheet":"Desk","column":"D","width":321\}, where \{"sheet":"Desk","column":"D","width":361\} is due' },
            @{ L = 'er'; Name = 'a still press raised'; Anchor = "    if (drag.kind === 'resize' && drag.moved) {"; With = "    if (drag.kind === 'resize') {"
               Want = 'case widths.*widths, a press on the Desk''s B divider that moved nothing: it raised columnresize' },
            @{ L = 'es'; Name = 'a load without keep forgetting'; Anchor = '    var tabs = !keep || !this.records[name];'
               With = "    var tabs = !keep || !this.records[name];`n    if (!keep) this.widths[String(name).toLowerCase()] = {};"
               Want = 'case widths.*widths, the Screen''s tab again: the viewport keeps the Screen''s widths as \{\}, where its own are \{"B":114\}' }
        )
        $widthsNotes = New-Object System.Collections.Generic.List[string]
        $widthsJudged = New-Object System.Collections.Generic.List[object]
        $widthsOk = $true
        foreach ($mu in $widthsMutants) {
            if ($moduleReal -eq 0) { $widthsNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            if (([regex]::Matches($vpText, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in web/viewport.js exactly once"; exit 1 }
            $mutW = $vpText.Replace($mu.Anchor, $mu.With)
            $wApplied = $mutW -cne $vpText
            $fileW = Join-Path $tmp ($mu.L + '.viewport.js'); [System.IO.File]::WriteAllText($fileW, $mutW, $utf8)
            $rW = Invoke-Mutant (New-MutantPage $mu.L $template $hostJs '' '' $fileW) 'widths'
            $wJudge = Test-Mutant $rW 'widths'
            $wFailed = @($wJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $widthsJudged.Add(@{ Name = $mu.Name; Problems = @($wJudge.Problems) })
            $widthsNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $wApplied, $wFailed))
            if (-not ($wApplied -and $wFailed -ge 1)) { $widthsOk = $false }
        }
        $widthsNote = $widthsNotes -join '; '
        # mutant EH (CART.12's hand test, 2026-10-19; its second, the same day), when the real page holds the engine's
        # module: a host that shows a sheet without reading its columns whole first, so that its viewport lays a column
        # past the window at the default width, and the large board's columns of 21 pixels past the window are drawn
        # empty, at the load, at a jump of the scroll or when the box grows; the grid case's game half must fail it by
        # name at Superposition's load or its moves.
        $ehApplied = $false; $ehFailed = 0; $ehNote = 'the layout never learned: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorEH = '    this._learn(vp, name);'
            if (([regex]::Matches($js, [regex]::Escape($anchorEH))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorEH' is not in web/host.js exactly once"; exit 1 }
            $mutEH = $js.Replace($anchorEH, '    // the layout never learned, by the control')
            $ehApplied = $mutEH -cne $js
            $fileEH = Join-Path $tmp 'eh.host.js'; [System.IO.File]::WriteAllText($fileEH, $mutEH, $utf8)
            $rEH = Invoke-Mutant (New-MutantPage 'eh' $template $fileEH) 'grid'
            $jEH = Test-Mutant $rEH 'grid'
            $ehFailed = @($jEH.Problems | Where-Object { $_ -cmatch "case grid.*superposition frame 0, Field.*: the viewport shows Field![A-Z]+\d+:[A-Z]+\d+, past the record's window" }).Count
            $ehNote = "the layout never learned applied ($ehApplied) and failed the grid case ($ehFailed)"
        }
        $ehOk = ($moduleReal -eq 0) -or ($ehApplied -and $ehFailed -ge 1)
        # mutant EL (CART.12's second hand test, 2026-10-19), when the real page holds the engine's module: Superposition's
        # hand without the box's rule, a box beside a reading of nothing kept sealed; the committed replay, the owner's
        # session, seals a box on V21, itself a reading of nothing, which the cascade observed at M17 reaches at frame 33,
        # so the replay case must fail it by name at that frame.
        $elApplied = $false; $elFailed = 0; $elNote = 'the box kept sealed in the hand: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorEL = '      } else if (site === BOX) {'
            if (([regex]::Matches($superHandText, [regex]::Escape($anchorEL))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorEL' is not in cartridges/superposition/superposition.hand.js exactly once"; exit 1 }
            $mutEL = $superHandText.Replace($anchorEL, '      } else if (false) {')
            $elApplied = $mutEL -cne $superHandText
            $rEL = Invoke-Mutant (New-MutantPage 'el' $template $hostJs '' (New-HandCopy 'el' 'superposition/superposition.hand.js' $mutEL)) 'input,replay:superposition:33'
            $jEL = Test-Mutant $rEL 'input,replay:superposition:33'
            $elFailed = @($jEL.Problems | Where-Object { $_ -like "*case replay*superposition's committed replay, played on a fresh host, is not its hand's at frame 33*" }).Count
            $elNote = "the box kept sealed in the hand applied ($elApplied) and failed the replay case at frame 33 ($elFailed)"
        }
        $elOk = ($moduleReal -eq 0) -or ($elApplied -and $elFailed -ge 1)
        # mutant ET (CART.14's first slice, moved at its hand test), when the real page holds the engine's module: Seiyaku's
        # hand whose candidates forget the box, so that a domain filled keeps a value its box holds; the committed replay,
        # the owner's session since CART.14.1's second slice, first fills the domains at frame 12, so the replay case must
        # fail it by name at that frame.
        $etApplied = $false; $etFailed = 0; $etNote = 'the candidates blind to the box in the hand: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $seiyakuHandText = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/seiyaku/seiyaku.hand.js'))
            $anchorET = 'rows[u[0]][w] === 0 && cols[u[1]][w] === 0 && boxes[u[2]][w] === 0'
            if (([regex]::Matches($seiyakuHandText, [regex]::Escape($anchorET))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorET' is not in cartridges/seiyaku/seiyaku.hand.js exactly once"; exit 1 }
            $mutET = $seiyakuHandText.Replace($anchorET, 'rows[u[0]][w] === 0 && cols[u[1]][w] === 0')
            $etApplied = $mutET -cne $seiyakuHandText
            $rET = Invoke-Mutant (New-MutantPage 'et' $template $hostJs '' (New-HandCopy 'et' 'seiyaku/seiyaku.hand.js' $mutET)) 'input,replay:seiyaku:12'
            $jET = Test-Mutant $rET 'input,replay:seiyaku:12'
            $etFailed = @($jET.Problems | Where-Object { $_ -like "*case replay*seiyaku's committed replay, played on a fresh host, is not its hand's at frame 12:*" }).Count
            $etNote = "the candidates blind to the box in the hand applied ($etApplied) and failed the replay case at frame 12 ($etFailed)"
        }
        $etOk = ($moduleReal -eq 0) -or ($etApplied -and $etFailed -ge 1)
        # mutants KS, KT and KU (CART.14.1's second slice, decision 16), when the real page holds the engine's module:
        # Seiyaku's hand whose candidates forget the strikes, whose hidden singles read a row's places for a column's
        # and a column's for a row's, and whose filter strikes the marks it hides. In the owner's session the first
        # names another inference after P's first strikes and applies it at frame 63, the second applies a wrong
        # hidden single at frame 21, the second inference I applies, and the third keeps the marks it hid when M draws
        # them whole again at frame 36: the replay case must fail each by name at its frame. Since CART.14.1's third slice
        # the light's three, LY, LZ and MA, the same way: a reason never lit fails at frame 15, the first I lights; a
        # pointing's box no reason at frame 62, the first pointing P names; and a single's value not shown at its place,
        # drawn as its marks before it is applied, at frame 15.
        $ladderMutants = @(
            @{ L = 'ks'; Name = 'the candidates blind to the strikes'; Anchor = 'candidates.push(cand & ~struck[k]);'; With = 'candidates.push(cand);'; Frame = 63 },
            @{ L = 'kt'; Name = 'a hidden single read from the wrong unit'; Anchor = 'var places = u < 9 ? open.rows[u] : (u < 18 ? open.cols[u - 9] : open.boxes[u - 18]);'; With = 'var places = u < 9 ? open.cols[u] : (u < 18 ? open.rows[u - 9] : open.boxes[u - 18]);'; Frame = 21 },
            @{ L = 'ku'; Name = 'a filter that strikes the mark'; Anchor = '      else marks.push(m);'; With = '      else marks.push(filtered ? m & candidates[k] : m);'; Frame = 36 },
            @{ L = 'ly'; Name = 'a reason never lit'; Anchor = '    return reason ? 1 : 0;'; With = '    return 0;'; Frame = 15 },
            @{ L = 'lz'; Name = 'a pointing''s box no reason'; Anchor = 'else if (L.kind === 3) reason = u[2] + 1 === L.box || holding;'; With = 'else if (L.kind === 3) reason = holding;'; Frame = 62 },
            @{ L = 'ma'; Name = 'a single''s value not shown at its place'; Anchor = 'if (light === 2 && this.ladder.kind < 3) return this.ladder.value;'; With = 'if (light === 2 && this.ladder.kind < 1) return this.ladder.value;'; Frame = 15 }
        )
        $ladderOk = $true; $ladderNote = 'the ladder''s three and the light''s three in the hand: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $seiyakuHandNow = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/seiyaku/seiyaku.hand.js'))
            $ladderWords = @()
            foreach ($m in $ladderMutants) {
                if (([regex]::Matches($seiyakuHandNow, [regex]::Escape($m.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($m.Anchor)' is not in cartridges/seiyaku/seiyaku.hand.js exactly once"; exit 1 }
                $mutText = $seiyakuHandNow.Replace($m.Anchor, $m.With)
                $applied = $mutText -cne $seiyakuHandNow
                $want = 'input,replay:seiyaku:' + $m.Frame
                $r = Invoke-Mutant (New-MutantPage $m.L $template $hostJs '' (New-HandCopy $m.L 'seiyaku/seiyaku.hand.js' $mutText)) $want
                $j = Test-Mutant $r $want
                $failed = @($j.Problems | Where-Object { $_ -like "*case replay*seiyaku's committed replay, played on a fresh host, is not its hand's at frame $($m.Frame):*" }).Count
                if (-not ($applied -and $failed -ge 1)) { $ladderOk = $false }
                $ladderWords += "$($m.L.ToUpper()), $($m.Name), applied ($applied) and failed the replay case at frame $($m.Frame) ($failed)"
            }
            $ladderNote = $ladderWords -join '; '
        }
        # mutant EZ (CART.9's first slice), when the real page holds the engine's module: naught's hand that reads aut as
        # vel, the inclusive or for the exclusive; the stand-in's carry-in, written at frame 4752 under a all ones, first
        # gives an AUT two 1s, the low bit's sum, so the replay case must fail it by name at that frame.
        $ezApplied = $false; $ezFailed = 0; $ezNote = 'aut read as vel in the hand: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $naughtHandText = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/naught/naught.hand.js'))
            $anchorEZ = 'aut: { arity: 2, apply: function (a, b) { return a ^ b; }'
            if (([regex]::Matches($naughtHandText, [regex]::Escape($anchorEZ))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorEZ' is not in cartridges/naught/naught.hand.js exactly once"; exit 1 }
            $mutEZ = $naughtHandText.Replace($anchorEZ, 'aut: { arity: 2, apply: function (a, b) { return a | b; }')
            $ezApplied = $mutEZ -cne $naughtHandText
            $rEZ = Invoke-Mutant (New-MutantPage 'ez' $template $hostJs '' (New-HandCopy 'ez' 'naught/naught.hand.js' $mutEZ)) 'input,replay:naught:4752'
            $jEZ = Test-Mutant $rEZ 'input,replay:naught:4752'
            $ezFailed = @($jEZ.Problems | Where-Object { $_ -like "*case replay*naught's committed replay, played on a fresh host, is not its hand's at frame 4752:*" }).Count
            $ezNote = "aut read as vel in the hand applied ($ezApplied) and failed the replay case at frame 4752 ($ezFailed)"
        }
        $ezOk = ($moduleReal -eq 0) -or ($ezApplied -and $ezFailed -ge 1)
        # mutant FH (CART.9's hand test of the second slice), when the real page holds the engine's module: a host that plays a
        # replay's nineteenth row and never shows the sheet it names, so that Naught's replay plays its switches on the Lesson,
        # where the Bench its person showed is due: the replay case must count no naughtShown.
        $fhApplied = $false; $fhFailed = 0; $fhNote = 'the replay''s sheet unshown: not applicable, the real page holding no engine module'
        if ($moduleReal -gt 0) {
            $anchorFH = '      this._playedShown(rows);'
            if (([regex]::Matches($js, [regex]::Escape($anchorFH))).Count -ne 1) { Write-Output "FAIL: the anchor '$anchorFH' is not in web/host.js exactly once"; exit 1 }
            $mutFH = $js.Replace($anchorFH, '      // the replay''s sheet unshown, by the control')
            $fhApplied = $mutFH -cne $js
            $fileFH = Join-Path $tmp 'fh.host.js'; [System.IO.File]::WriteAllText($fileFH, $mutFH, $utf8)
            $rFH = Invoke-Mutant (New-MutantPage 'fh' $template $fileFH) 'input,replay:naught'
            $jFH = Test-Mutant $rFH 'input,replay:naught'
            $fhFailed = @($jFH.Problems | Where-Object { $_ -like '*the case replay at a ratio of 1 counted 0 naughtShown, below its floor of 18*' }).Count
            $fhNote = "the replay's sheet unshown applied ($fhApplied) and failed the replay case's naughtShown ($fhFailed)"
        }
        $fhOk = ($moduleReal -eq 0) -or ($fhApplied -and $fhFailed -ge 1)
        # mutants FX, FY, FZ and GA (CART.9's third slice), when the real page holds the engine's module: naught's hand, each
        # failing the replay case by name at the frame of the replay where it first leaves the engine. FX, a test that runs
        # on past a wrong input, at the owner's VEL for ET on II, frame 34; FY, the stars counted against the budget alone,
        # at VI's pass with three gates, two stars, frame 123; FZ, the due under test read from the switches as they stand,
        # at I's switch written over, frame 4801; and GA, a click that toggles no switch, at the owner's first click, frame
        # 15. And GW, GX, GY and GZ (its short slice): GW, a value read as a gate, at III's input emptied by Delete, frame
        # 52; GX, every level giving every gate, at the owner's VEL on II, which II does not give, frame 30; GY, an output's
        # error due, at the same Delete, frame 52, the Lab's due an error; and GZ, a test's last switches read as they stand,
        # the Lab's L at the load's second frame. And HE to HL (its fourth slice), the clocked levels': HE, a tick that moves
        # no flip-flop, at X's first tick, frame 737; HF, G leaving the flip-flops as they stand, at X's first run, frame 746;
        # HG, a run that counts no states, at X's toggle, frame 756; HH, ELIGE read as no gate of the set, at XI's first
        # gate, frame 766; HI, a machine's p and B counted and not drawn, at XV's first test, frame 2563; HJ, a word that
        # does not stand on the input that failed, where that test stops, frame 2564; HK, a line of no word read as LDI, at
        # the load, frame 1; HL, a switch written over taken at its word, at I's, frame 4801; and at its hand test HM, a digit on
        # the room that writes nothing, at IV's first, frame 83, and HN, a digit written over a gate, at IV's C3, frame 88.
        $naughtMutants = @(
            @{ L = 'fx'; Name = 'a test past a wrong input'; Frame = 34
               Anchor = '        return when(and([equal(l8, 1), less(l6, arith(''-'', l7, 1))]), function () { return 1; }, function () { return 0; });'
               With = '        return when(and([true, less(l6, arith(''-'', l7, 1))]), function () { return 1; }, function () { return 0; });' },
            @{ L = 'fy'; Name = 'the stars against the budget alone'; Frame = 123
               Anchor = '        return when(lessEqual(t, g), function () {'
               With = '        return when(lessEqual(t, f), function () {' },
            @{ L = 'fz'; Name = 'the due under test read from the switches'; Frame = 4801
               Anchor = '    return standing.map(function (v, s) { return settled(when(equal(here, 1), function () { return testInput(k, s, b6); }, function () { return v; })); });'
               With = '    return standing.map(function (v) { return settled(v); });' },
            @{ L = 'ga'; Name = 'a click that toggles nothing'; Frame = 15
               Anchor = '        if (is(''toggle'') || i.press) return arith(''-'', 1, lastS);'
               With = '        if (is(''toggle'')) return arith(''-'', 1, lastS);' },
            @{ L = 'gw'; Name = 'a value read as a gate'; Frame = 52
               Anchor = '        var gt = w && w.formula ? gateText(w.text) : '''';'
               With = '        var gt = w ? (w.formula ? gateText(w.text) : ''=?'') : '''';' },
            @{ L = 'gx'; Name = 'every level giving every gate'; Frame = 30
               Anchor = '      if (kinds[q] > level.gives) { outside++; if (!first) first = q + 1; }'
               With = '      if (kinds[q] > 7) { outside++; if (!first) first = q + 1; }' },
            @{ L = 'gy'; Name = 'an output''s error due'; Frame = 52
               Anchor = '    lab[''D'' + r] = held && differing(outs, owed) === 0 ? 1 : 0;'
               With = '    lab[''D'' + r] = held && !differing(outs, owed) ? 1 : 0;' },
            @{ L = 'gz'; Name = 'a test''s stars read from the gates as they stand'; Frame = 2
               Anchor = '      var last = settled(self.last(c + r));'
               With = '      var last = now;' },
            @{ L = 'he'; Name = 'a tick that moves no flip-flop'; Frame = 737
               Anchor = '        return asAFlipFlopTakes(own(board, at) ? board[at] : null);'
               With = '        return settled(lastS);' },
            @{ L = 'hf'; Name = 'G leaving the flip-flops as they stand'; Frame = 746
               Anchor = '    if ((is(''reset'') || (flipFlop && is(''run''))) && onLevel) return 0;'
               With = '    if (is(''reset'') && onLevel) return 0;' },
            @{ L = 'hg'; Name = 'a run that counts no states'; Frame = 756
               Anchor = '    else e3 = c3 !== 1 || c4 >= this.lastNumber(''E6'') || (c4 > 0 && c5 === 0) ? 0 : 1;'
               With = '    else e3 = c3 !== 1 || (c4 > 0 && c5 === 0) ? 0 : 1;' },
            @{ L = 'hh'; Name = 'ELIGE read as no gate of the set'; Frame = 766
               Anchor = '    if (starts(''=IF('') && f.slice(-1) === '')'' && second !== null && among(mid(f, 5, comma - 5)) && pair(mid(f, comma + 1, second - comma - 1), mid(f, second + 1, len - second - 1))) return 7;'
               With = '    if (false) return 7;' },
            @{ L = 'hi'; Name = 'a machine''s p and B counted, and not drawn'; Frame = 2563
               Anchor = '    if (k !== MACHINA || s < COUNTED) return bit(b6, s);'
               With = '    return bit(b6, s);' },
            @{ L = 'hj'; Name = 'a word that does not stand on the input that failed'; Frame = 2564
               Anchor = '      return result === 2 && !ticks ? lastS : aBitOf(word, s);'
               With = '      return aBitOf(word, s);' },
            @{ L = 'hk'; Name = 'a line of no word read as LDI'; Frame = 1
               Anchor = '    return (op < 0 ? 4 : op) + 8 * (x === null ? 0 : modulo(Math.floor(x), 16));'
               With = '    return (op < 0 ? 0 : op) + 8 * (x === null ? 0 : modulo(Math.floor(x), 16));' },
            @{ L = 'hm'; Name = 'a digit on the room that writes nothing'; Frame = 83
               Anchor = '    if (typed) this.derived = { k: shown - 1, at: i.row + '','' + i.col, value: is(''one'') ? 1 : 0 };'
               With = '    if (false) this.derived = { k: shown - 1, at: i.row + '','' + i.col, value: is(''one'') ? 1 : 0 };' },
            @{ L = 'hn'; Name = 'a digit written over a gate'; Frame = 88
               Anchor = ' && this.kinds[shown - 1][8 * (i.row - 3) + (i.col - 3)] === 0;'
               With = ';' },
            @{ L = 'hl'; Name = 'a switch written over taken at its word'; Frame = 4801
               Anchor = '    var held = differing(sw, inputs) === 0;'
               With = '    var held = true;' },
            @{ L = 'hz'; Name = 'an error''s kind read as #VALUE! whatever the error'; Frame = 4804
               Anchor = '        if (isErr(standing)) { error = place; kind = errorType(standing.error); }'
               With = '        if (isErr(standing)) { error = place; kind = 3; }' },
            @{ L = 'ia'; Name = 'the words of an error''s kind a place after its own'; Frame = 52
               Anchor = '    return place < 1 ? fault(VALUE) : ERRORS[place - 1];'
               With = '    return place < 1 ? fault(VALUE) : ERRORS[place % 8];' }
        )
        $naughtNotes = New-Object System.Collections.Generic.List[string]
        $naughtJudged = New-Object System.Collections.Generic.List[object]
        $naughtOk = $true
        if ($moduleReal -eq 0) { $naughtNotes.Add('naught''s hand at the levels: not applicable, the real page holding no engine module') }
        else {
            $naughtHandNow = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/naught/naught.hand.js'))
            foreach ($mu in $naughtMutants) {
                if (([regex]::Matches($naughtHandNow, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in cartridges/naught/naught.hand.js exactly once"; exit 1 }
                $mutNt = $naughtHandNow.Replace($mu.Anchor, $mu.With)
                $ntApplied = $mutNt -cne $naughtHandNow
                $ntCases = 'input,replay:naught:' + $mu.Frame
                $rNt = Invoke-Mutant (New-MutantPage $mu.L $template $hostJs '' (New-HandCopy $mu.L 'naught/naught.hand.js' $mutNt)) $ntCases
                $jNt = Test-Mutant $rNt $ntCases
                $ntFailed = @($jNt.Problems | Where-Object { $_ -like ("*case replay*naught's committed replay, played on a fresh host, is not its hand's at frame " + $mu.Frame + ':*') }).Count
                $naughtJudged.Add(@{ Name = $mu.Name; Problems = @($jNt.Problems) })
                $naughtNotes.Add(("{0} applied ({1}) and failed the replay case at frame {2} ({3})" -f $mu.Name, $ntApplied, $mu.Frame, $ntFailed))
                if (-not ($ntApplied -and $ntFailed -ge 1)) { $naughtOk = $false }
            }
        }
        $naughtNote = $naughtNotes -join '; '
        # mutants NM, NN, NO and NP (CART.3's third slice (c)), when the real page holds the engine's module: Brickwork's
        # hand, each failing the replay case by name at the frame of the owner's game where it first leaves the engine,
        # found by the replay case over the whole game (`replays=brickwork`) with the mutant's hand: NM, a slide stopping a
        # column short, at the owner's first slide, frame 409; NN, a cut taking a place in the deal, at the owner's second
        # cut, the Clipboard's brick swapped in, frame 5155; NO, a lay's rest restarted by a turn, at a turn of a brick
        # resting, frame 35015; and NP, the pace a power and not a product kept course by course, at the second course
        # cleared, frame 2524, its pace 56.454 by hand where the product is 56.45399999999999.
        $brickworkMutants = @(
            @{ L = 'nm'; Name = 'a slide stopping a column short'; Frame = 409
               Anchor = '    while (slide !== 0 && fitsIn(last.wall, kind, place(slidTo.course, slidTo.column + slide, slidTo.turn))) slidTo = place(slidTo.course, slidTo.column + slide, slidTo.turn);'
               With = '    while (slide !== 0 && fitsIn(last.wall, kind, place(slidTo.course, slidTo.column + 2 * slide, slidTo.turn))) slidTo = place(slidTo.course, slidTo.column + slide, slidTo.turn);' },
            @{ L = 'nn'; Name = 'a cut taking a place in the deal'; Frame = 5155
               Anchor = '    var bagEntry = this.entered && !fromClip;'
               With = '    var bagEntry = this.entered;' },
            @{ L = 'no'; Name = 'a lay''s rest restarted by a turn'; Frame = 35015
               Anchor = '    this.restingFor = first || this.entered ? 0 : moving ? (this.fell ? 0 : this.resting ? last.restingFor + 1 : last.restingFor) : last.restingFor;'
               With = '    this.restingFor = first || this.entered ? 0 : moving ? (this.fell || this.turned ? 0 : this.resting ? last.restingFor + 1 : last.restingFor) : last.restingFor;' },
            @{ L = 'np'; Name = 'the pace a power'; Frame = 2524
               Anchor = '    else { var p = last.pace; for (var nth = 1; nth <= 4; nth++) p *= this.fullCount >= nth ? quicken : 1; this.pace = p; }'
               With = '    else this.pace = s.startPace * Math.pow(quicken, last.level + this.fullCount);' }
        )
        $brickworkNotes = New-Object System.Collections.Generic.List[string]
        $brickworkJudged = New-Object System.Collections.Generic.List[object]
        $brickworkOk = $true
        if ($moduleReal -eq 0) { $brickworkNotes.Add('brickwork''s hand: not applicable, the real page holding no engine module') }
        else {
            $brickworkHandNow = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'cartridges/brickwork/brickwork.hand.js'))
            foreach ($mu in $brickworkMutants) {
                if (([regex]::Matches($brickworkHandNow, [regex]::Escape($mu.Anchor))).Count -ne 1) { Write-Output "FAIL: the anchor '$($mu.Anchor)' is not in cartridges/brickwork/brickwork.hand.js exactly once"; exit 1 }
                $mutBw = $brickworkHandNow.Replace($mu.Anchor, $mu.With)
                $bwApplied = $mutBw -cne $brickworkHandNow
                $bwCases = 'input,replay:brickwork:' + $mu.Frame
                $rBw = Invoke-Mutant (New-MutantPage $mu.L $template $hostJs '' (New-HandCopy $mu.L 'brickwork/brickwork.hand.js' $mutBw)) $bwCases
                $jBw = Test-Mutant $rBw $bwCases
                $bwFailed = @($jBw.Problems | Where-Object { $_ -like ("*case replay*brickwork's committed replay, played on a fresh host, is not its hand's at frame " + $mu.Frame + ':*') }).Count
                $brickworkJudged.Add(@{ Name = $mu.Name; Problems = @($jBw.Problems) })
                $brickworkNotes.Add(("{0} applied ({1}) and failed the replay case at frame {2} ({3})" -f $mu.Name, $bwApplied, $mu.Frame, $bwFailed))
                if (-not ($bwApplied -and $bwFailed -ge 1)) { $brickworkOk = $false }
            }
        }
        $brickworkNote = $brickworkNotes -join '; '
        # mutants AT, AU, AV and AW (ENGINE.16), each a game's page of Kairos alone, which must pass first: its
        # hand a frame late, answering each frame with the frame before it; its hand's Tally counting a stack at
        # the level above its own, which moves no light; its hand's block dropped, so that its replay is held to
        # its golden alone; and a template whose bench refuses a game's page wholesale in the loop too, as it did
        # before. Each must fail by name; the first three need the module's replay, the last nothing.
        $gameJudged = New-Object System.Collections.Generic.List[object]
        $gameNotes = New-Object System.Collections.Generic.List[string]
        $gameOk = $true
        $rG0 = Invoke-Planned (New-GamePage $tmp 'g0') '1' ''
        $jG0 = if ($rG0.Text -ne '') { Test-Loop $rG0.Text '1' $gameFloors $gameCases $gameAbsent } else { @{ Problems = @($rG0.Reason) } }
        if (@($jG0.Problems).Count -ne 0) { $gameOk = $false }
        $gameNotes.Add(("the game's page has {0} problem(s)" -f @($jG0.Problems).Count))
        $anchorAT = "    this.step(down('B5') || down('B10') || down('B13'), down('B6'));`n    return { plane: this.board(), cells: this.tally() };"
        $withAT = "    var late = { plane: this.board(), cells: this.tally() };`n    this.step(down('B5') || down('B10') || down('B13'), down('B6'));`n    return late;"
        $anchorAU = '        if (this.beneath) this.stacked[this.level - 1]++;'
        $withAU = '        if (this.beneath) this.stacked[Math.min(this.level, KAIROS.levels - 1)]++;'
        $anchorAW = "    if (MODE !== 'loop') {"
        foreach ($pair in @(@($kairosHandText, $anchorAT, 'cartridges/kairos/kairos.hand.js'), @($kairosHandText, $anchorAU, 'cartridges/kairos/kairos.hand.js'), @($tpl, $anchorAW, 'the template'))) {
            if (([regex]::Matches($pair[0], [regex]::Escape($pair[1]))).Count -ne 1) { Write-Output "FAIL: the anchor '$($pair[1])' is not in $($pair[2]) exactly once"; exit 1 }
        }
        $tplAW = Join-Path $tmp 'aw.template.html'; [System.IO.File]::WriteAllText($tplAW, $tpl.Replace($anchorAW, '    if (true) {'), $utf8)
        $gameMutants = @(
            @{ L = 'at'; Name = 'the hand a frame late'; Cases = 'replay'; Module = $true; Hand = $kairosHandText.Replace($anchorAT, $withAT)
               Want = "case replay.*kairos's committed replay, played on a fresh host, is not its hand's at frame 1: row \d+, column \d+ reads" },
            @{ L = 'au'; Name = 'the Tally a level up'; Cases = 'replay'; Module = $true; Hand = $kairosHandText.Replace($anchorAU, $withAU)
               Want = "case replay.*kairos's committed replay, played on a fresh host, is not its hand's at frame \d+: Tally!C\d+ holds" },
            @{ L = 'av'; Name = 'the hand''s block dropped'; Cases = 'replay'; Module = $true; NoHand = $true
               Want = 'the case replay at a ratio of 1 counted 1 alone, where it must count none' },
            @{ L = 'aw'; Name = 'the bench refusing a game''s page'; Cases = ''; Template = $tplAW
               Want = "the first line is not the loop oracle's header: loop: not on this page" }
        )
        foreach ($mu in $gameMutants) {
            if ($mu.Module -and $moduleReal -eq 0) { $gameNotes.Add(("{0}: not applicable, the real page holding no engine module" -f $mu.Name)); continue }
            if ($mu.NoHand) { $pageGm = New-GamePage $tmp $mu.L -NoHand }
            elseif ($mu.ContainsKey('Hand')) { $pageGm = New-GamePage $tmp $mu.L -Hand $mu.Hand }
            else { $pageGm = New-GamePage $tmp $mu.L -Template $mu.Template }
            # applied: the hand's text changed, the block absent from the page, or the template changed
            $gmText = if ($script:LoopMode -eq 'plan') { '' } else { [System.IO.File]::ReadAllText($pageGm) }   # the plan pass's build may still run
            if ($mu.NoHand) { $gmApplied = -not $gmText.Contains('<script id="hand-kairos"') }
            elseif ($mu.ContainsKey('Hand')) { $gmApplied = ($mu.Hand -cne $kairosHandText) -and $gmText.Contains('<script id="hand-kairos"') }
            else { $gmApplied = ([System.IO.File]::ReadAllText($mu.Template)) -cne $tpl }
            $rGm = Invoke-Mutant $pageGm $mu.Cases
            $gmJudge = Test-Mutant $rGm $mu.Cases $gameFloors
            $gmFailed = @($gmJudge.Problems | Where-Object { $_ -cmatch $mu.Want }).Count
            $gameJudged.Add(@{ Name = $mu.Name; Problems = @($gmJudge.Problems) })
            $gameNotes.Add(("{0} applied ({1}) and failed by name ({2})" -f $mu.Name, $gmApplied, $gmFailed))
            if (-not ($gmApplied -and $gmFailed -ge 1)) { $gameOk = $false }
        }
        $gameNote = $gameNotes -join '; '
        if ($script:LoopMode -eq 'plan') { return }   # the plan pass judges nothing (REPO.8)
        if ($script:LoopMode -eq 'run') { Write-Output (Get-PoolNote) }
        Write-Output ("control: the ladder's mutants in Seiyaku's hand: " + $ladderNote)
        Write-Output ("control: the real page has {0} problem(s); the raised cap applied ({1}) and failed the stall ({2}); the swapped writes applied ({3}) and lost the edit ({4}); the cut element left no block ({5}); the survival rule changed: {6}; the frame-0 draw cut applied ({7}) and failed the reload ({8}); the clear cut applied ({9}) and failed the refused load ({10}); the refusal's mark cut applied ({11}) and failed rate30 ({12}); the Camera read late applied ({13}) and failed the plane ({14}); the masked blit applied ({15}) and failed the pixels ({16}); the double's old 255 applied ({17}) and failed the plane ({18}); the library changed: {19}; the pointer without the Camera applied ({20}) and failed rate30 ({21}) and the input case ({22}); {23}; {24}; {25}; {26}; {27}; {28}; {29}; {30}; {31}; {32}; {33}; {34}; {35}; {36}; {37}; {38}; {39}; {40}; {41}; {42}; {43}; {44}; {45}; {46}; {47}; {48}; {49}; {50}; {51}; {52}; {53}; {54}" -f @($j0.Problems).Count, $aApplied, $aStall, $bApplied, $bLost, $cNoBlock, $dNote, $eApplied, $eFailed, $fApplied, $fFailed, $gApplied, $gFailed, $hApplied, $hFailed, $iApplied, $iFailed, $jApplied, $jFailed, $kNote, $lApplied, $lFailed, $lInput, $mnNote, $pqrNote, $sndNote, $xNote, $yNote, $zNote, $aaNote, $abNote, $gridNote, $aiNote, $tabsNote, $emptyNote, $stillNote, $viewsNote, $changesNote, $continueNote, $paletteNote, $keysNote, $commandsNote, $pageNote, $settleNote, $gameNote, $egNote, $ehNote, $elNote, $widthsNote, $etNote, $ezNote, $fhNote, $modesNote, $naughtNote, $brickworkNote)
        if (@($j0.Problems).Count -eq 0 -and $aApplied -and $aStall -ge 1 -and $bApplied -and $bLost -ge 1 -and $cNoBlock -and $dOk -and $eApplied -and $eFailed -ge 1 -and $fApplied -and $fFailed -ge 1 -and $gApplied -and $gFailed -ge 1 -and $hApplied -and $hFailed -ge 1 -and $iApplied -and $iFailed -ge 1 -and $jApplied -and $jFailed -ge 1 -and $kOk -and $lOk -and $mnOk -and $pqrOk -and $sndOk -and $xOk -and $yOk -and $zOk -and $aaOk -and $abOk -and $gridOk -and $aiOk -and $tabsOk -and $emptyOk -and $stillOk -and $viewsOk -and $changesOk -and $continueOk -and $paletteOk -and $keysOk -and $commandsOk -and $pageOk -and $settleOk -and $gameOk -and $egOk -and $ehOk -and $elOk -and $widthsOk -and $etOk -and $ladderOk -and $ezOk -and $fhOk -and $modesOk -and $naughtOk -and $brickworkOk) {
            Write-Output ('OK: the check passes the real page and the game''s page, and fails each of the ' + $(if ($moduleReal -gt 0) { 'three hundred and fifteen' } else { 'one hundred and forty-eight applicable' }) + ' mutants for its own reason, each proving it applied')
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
        foreach ($sj2 in $stillJudged) { foreach ($p in @($sj2.Problems) | Select-Object -First 3) { Write-Output ('  ' + $sj2.Name + ': ' + $p) } }
        foreach ($vj in $viewsJudged) { foreach ($p in @($vj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $vj.Name + ': ' + $p) } }
        foreach ($cj in $changesJudged) { foreach ($p in @($cj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $cj.Name + ': ' + $p) } }
        foreach ($kj in $continueJudged) { foreach ($p in @($kj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $kj.Name + ': ' + $p) } }
        foreach ($pj in $paletteJudged) { foreach ($p in @($pj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $pj.Name + ': ' + $p) } }
        foreach ($kj2 in $keysJudged) { foreach ($p in @($kj2.Problems) | Select-Object -First 3) { Write-Output ('  ' + $kj2.Name + ': ' + $p) } }
        foreach ($cmj in $commandsJudged) { foreach ($p in @($cmj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $cmj.Name + ': ' + $p) } }
        foreach ($pgj in $pageJudged) { foreach ($p in @($pgj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $pgj.Name + ': ' + $p) } }
        foreach ($stj in $settleJudged) { foreach ($p in @($stj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $stj.Name + ': ' + $p) } }
        foreach ($wj in $widthsJudged) { foreach ($p in @($wj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $wj.Name + ': ' + $p) } }
        foreach ($mj in $modesJudged) { foreach ($p in @($mj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $mj.Name + ': ' + $p) } }
        foreach ($nj in $naughtJudged) { foreach ($p in @($nj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $nj.Name + ': ' + $p) } }
        foreach ($bj in $brickworkJudged) { foreach ($p in @($bj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $bj.Name + ': ' + $p) } }
        foreach ($p in @($jG0.Problems) | Select-Object -First 3) { Write-Output ('  the game''s page: ' + $p) }
        foreach ($gj in $gameJudged) { foreach ($p in @($gj.Problems) | Select-Object -First 3) { Write-Output ('  ' + $gj.Name + ': ' + $p) } }
        exit 1
        }
        # REPO.8: -Jobs 1 runs the control's code once, each page built and run in its turn. Otherwise the plan pass
        # builds every page in the background and notes every run; the pool makes the runs side by side, the longest
        # first, and then each run of the sound case alone; and the run pass judges every mutant, each run answered
        # from the pool. The run pass, as the one pass of -Jobs 1, ends the script.
        if ($Jobs -le 1) { & $controlBody }
        $watch = [System.Diagnostics.Stopwatch]::StartNew()
        $script:LoopMode = 'plan'
        & $controlBody
        Wait-PageBuilds
        $script:PoolStats = @{ Builds = $script:Builds.Count; BuildSeconds = $watch.Elapsed.TotalSeconds }
        $pooled = @($script:Planned | Where-Object { -not $_.Alone } | Sort-Object -Property @{ Expression = { $_.Weight }; Descending = $true }, @{ Expression = { $_.Order }; Descending = $false })
        $watch.Restart()
        Invoke-LoopPool $pooled $Jobs $script:Answers
        $script:PoolStats.Pooled = $pooled.Count
        $script:PoolStats.PoolSeconds = $watch.Elapsed.TotalSeconds
        $script:PoolStats.Longest = 0.0
        $script:PoolStats.LongestName = ''
        foreach ($p in $pooled) {
            $a = $script:Answers[$p.Key]
            if ($a -and $a.Seconds -gt $script:PoolStats.Longest) { $script:PoolStats.Longest = $a.Seconds; $script:PoolStats.LongestName = (Split-Path -Leaf $p.Page) + ', ' + $p.Cases }
        }
        $script:PoolStats.Alone = $script:AloneRuns
        $script:PoolStats.AloneSeconds = $script:AloneSeconds
        $script:LoopMode = 'run'
        & $controlBody
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
# REPO.8: the sound case first and alone at the first ratio, since it renders in real time and a starved processor
# fails it; then side by side, -Jobs at a time, the first ratio's input and replay cases, its other cases, the second
# ratio's every case but the replay and sound cases, which draw nothing and map no pointer, and the game's page
# (ENGINE.16), at a ratio of 1 since it holds no grid cartridge: Kairos alone, its hand a block. Each run is judged
# by the cases it names, and every case runs at the first ratio.
$names = @($floors | ForEach-Object { $_.Case })
$runs = @(
    @{ Key = 'sound'; Label = 'ratio 1, the sound case alone'; Scale = $scales[0]; Cases = @('abi', 'sound') },
    @{ Key = 'replay'; Label = 'ratio 1, the input and replay cases'; Scale = $scales[0]; Cases = @('abi', 'input', 'replay') },
    @{ Key = 'save'; Label = 'ratio 1, the save case'; Scale = $scales[0]; Cases = @('abi', 'save') },
    @{ Key = 'keep'; Label = 'ratio 1, the keep case'; Scale = $scales[0]; Cases = @('abi', 'keep') },
    @{ Key = 'rest'; Label = 'ratio 1, the other cases'; Scale = $scales[0]; Cases = @($names | Where-Object { @('input', 'replay', 'sound', 'save', 'keep') -notcontains $_ }) },
    @{ Key = 'second'; Label = 'ratio 1.5, every case but replay, sound, save and keep'; Scale = $scales[1]; Cases = @($names | Where-Object { @('replay', 'sound', 'save', 'keep') -notcontains $_ }) }
)
$gameTmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_loop_game_' + [System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $gameTmp | Out-Null
try {
    $gamePage = ''
    $gameError = ''
    try { $gamePage = New-GamePage $gameTmp 'game' } catch { $gameError = $_.Exception.Message }
    $answers = @{}
    $answers['sound'] = Invoke-Loop $browser $Page $runs[0].Scale ($runs[0].Cases -join ',')
    $plan = New-Object System.Collections.Generic.List[object]
    foreach ($run in @($runs | Select-Object -Skip 1)) { $plan.Add(@{ Key = $run.Key; Page = $Page; Scale = $run.Scale; Cases = ($run.Cases -join ',') }) }
    if ($gamePage -ne '') { $plan.Add(@{ Key = 'game'; Page = $gamePage; Scale = '1'; Cases = '' }) }
    Invoke-LoopPool $plan $Jobs $answers
    foreach ($run in $runs) {
        $r = $answers[$run.Key]
        if ($r.Text -eq '') { $failed.Add("$($run.Label): $($r.Reason)"); Write-Output ("  {0}: {1}  FAIL" -f $run.Label, $r.Reason); continue }
        $j = Test-Loop $r.Text $run.Scale $floors $expectedCases @() $run.Cases
        Write-Output ("  {0} ({1:N1} s): {2}" -f $run.Label, $r.Seconds, $j.Header)
        foreach ($l in $j.Lines) { Write-Output ('  ' + $l) }
        foreach ($p in $j.Problems) { $failed.Add($p); Write-Output ("    {0}  FAIL" -f $p) }
    }
    if ($gameError -ne '') { $failed.Add("the game's page: " + $gameError); Write-Output ("  the game's page: {0}  FAIL" -f $gameError) }
    else {
        $r = $answers['game']
        if ($r.Text -eq '') { $failed.Add("the game's page: $($r.Reason)"); Write-Output ("  the game's page: {0}  FAIL" -f $r.Reason) }
        else {
            $j = Test-Loop $r.Text '1' $gameFloors $gameCases $gameAbsent
            $lastLine = @($r.Text -split "`n")[-1].Trim()
            Write-Output ("  the game's page, Kairos alone, ratio 1 ({0:N1} s): {1}" -f $r.Seconds, $lastLine)
            foreach ($l in $j.Lines) { Write-Output ('  ' + $l) }
            foreach ($p in $j.Problems) { $failed.Add("the game's page: " + $p); Write-Output ("    {0}  FAIL" -f $p) }
        }
    }
} finally {
    Remove-Item -Recurse -Force $gameTmp -ErrorAction SilentlyContinue
}
Write-Output ''
if ($failed.Count -eq 0) {
    Write-Output "=== CHECK: clean - every case OK, the replay, sound, save and keep cases at the first ratio and every other at both, every count at or above its floor, and the game's page's twenty cases OK with Alonzo's fifteen said absent ==="
    exit 0
}
Write-Output "=== CHECK: $($failed.Count) problem(s) ==="
$failed | ForEach-Object { Write-Output "  $_" }
exit 1
