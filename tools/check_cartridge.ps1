<#
check_cartridge.ps1 - every cartridge under cartridges/ is a cartridge as
docs/SPEC.md section 7 has it, read without an engine.

WHY: ENGINE.1's scoping, decision 11 (docs/REARVIEW.md). The engine refuses a
defective cartridge at load, by name (docs/SPEC.md section 4.2); but the language
crate's loader does not exist yet, and a cartridge in this repository is a
fixture of the floors and the demo a stranger copies first, so its shape is
held now, statically, on every push, and a defect fails here before any
engine reads the file. The reader of forms below is this script's own
(comments, strings with \" and \\, numbers, symbols, lists, each form's line),
since the engine reads no VLA and the language's reader lives in another
repository.

WHAT IT HOLDS, for each .vla under cartridges/, with the catalog's ids:
  - the license header as the first line, '; SPDX-License-Identifier: 0BSD'
    (section 7.1; tools/check_spdx.ps1 holds the map), and a (license ...)
    directive, when given, the header's twin;
  - the manifest form first, (cartridge "name" ...), the name lowercase
    letters, digits and hyphens; every directive present once and in range
    (cart-manifest-invalid): (spec 1..6), (title "..."), (rate 0..120),
    (screen plane w h) at most 320 by 200 or (screen grid w h) at most 80 by
    50, (seed 1..2147483646|host); author, license and notes optional and at
    most once, and settle (1..65536) too, a (spec 6) cartridge's at (rate 0)
    alone, and bound ("sheet" ...) too, a (spec 6) cartridge's at any rate,
    one sheet or more, each named once and held by the rows or the engine's
    own; and game, work and read ("sheet" ...) too, the keyboard's sheets, a
    (spec 6) cartridge's, game and work a grid's, each as bound names its
    sheets, and no sheet in work and in either other; an unknown directive
    refused; a (spec n) past 6 refused as cart-spec-unsupported;
  - every row after it one of section 7.3's kinds in its shape (grid-row-
    unknown, grid-row-malformed); a (derived ...) row is the host's and never
    a cartridge's;
  - the reserved names (cart-sheet-reserved): no sheet ending in .last, no
    sheet name longer than 26 characters; a device sheet's cells inside its
    section 3 layout (cart-device-cell-outside), and no formula where the
    host writes (cart-device-cell-formula);
  - one write per cell, across rows and range fills, both lines named
    (cart-cell-written-twice), a value row after its formula row excepted;
  - the Screen's cells inside the declared size when no Camera sheet is
    written (cart-screen-outside);
  - in plane mode, the Palette's sixteen rows: A1 to A16 holding 0 to 15 in
    order and B1 to B16 a color as #RRGGBB (cart-palette-invalid);
  - no NOW, TODAY, RAND or RANDBETWEEN in any formula, string literals
    aside (cart-formula-volatile, the Clock named).
And a baseline that pins how many: the cartridges counted, and each one's
rows as a floor that never goes down.

SINCE SPEC.3 (2026-10-10; docs/REARVIEW.md, decisions 28, 31 and 32): a
cartridge is the file of its folder's name, cartridges/<name>/<name>.vla,
the rule tools/build_web.ps1 and tools/check_web_offline.ps1 already keep;
beside it stands its source when it has one, <name>.source.vla, which the
pass expands into it (docs/SPEC.md section 7.8); a library is a file of
cartridges/ itself. Any other .vla under cartridges/ is refused, and each
kind is counted against its pin. Each source has its cartridge beside it,
whose second line is the banner naming it; a cartridge whose second line is
a banner names a source that is there. A source's rows are the pass's to
expand, and the golden, every cartridge the pass's expansion of its source,
is cargo test's (engine/src/pass.rs), so this check reads cartridges alone:
a cartridge holding a (defmacro ...) or an (include ...) is refused as a
source (cart-source-unexpanded), before its manifest, as the engine refuses
it; and (spec 3) is read beside 1 and 2.

SINCE ENGINE.3'S SECOND SLICE (2026-10-10; docs/REARVIEW.md, decisions 8 and 11):
a cartridge's folder may hold its replay, <name>.replay.vla, and the replay's
golden, <name>.golden.vla, one of each a cartridge, each counted against its
pin. A replay is read as docs/SPEC.md section 7.6 has it: the license header; its
header (replay "<name>" (spec n) (cartridge "<SHA-256>") (seed n)), the name
its folder's, the spec 1 to 3, the digest PowerShell's SHA-256 of the
cartridge beside it over its LF bytes, the seed a whole number from 1 to
2147483646 and the manifest's when the manifest names one; then frames
ascending from 1, each one form, (frame n row ...), holding cell and formula
rows alone, a form outside a frame refused and a (derived ...) row refused,
being re-derived as a replay plays. A golden has
its replay beside it, and is a record whose one (window ...) row names a
sheet the record holds, every cell, formula and value row that sheet's. What
the replay plays to is the loop oracle's, which holds the page's player to
the golden byte for byte (tools/check_host_loop.ps1, the replay case), and
cargo test's, a player of the engine's own, made general by ENGINE.4's second
slice over every folder holding a replay: the input card's, Kairos's (since
CART.4's second slice), Sand's (since CART.2's second slice) and the sound
card's.

SINCE ENGINE.4 (2026-10-10; docs/REARVIEW.md, decisions 4 and 9): the Audio
sheet's value cells are judged as the host judges a voice at run time
(docs/SPEC.md section 3.6): a wave in column B one of square, triangle, sawtooth
or sine, compared without case; a note in column C a number from 0 to 127;
a volume in column D a number from 0 to 1. A formula there is the host's to
judge after each step, which says a voice that is no voice once and silences
it; a value written wrong is a typo this check can name before any run.

-Control copies cartridges/ to a scratch folder and proves the check on it,
a fresh copy for every case: the clean copy passes, and so do Life written
to (spec 3), Life written to (spec 4) with its Camera's third row, Life written to
(spec 5) with its Commands sheet, Life written to (spec 4) with a sheet named
Commands of its own, Life written to (spec 6) at rate 0 with (settle 8), and
Life written to (spec 6) bounding its Screen, (bound "Screen"), the grid
card written to (spec 6), its Screen the game's and read and its Camera read,
and Life written to (spec 6), its Screen read;
fifty-three mutants must each fail for its own reason, each
asserting its anchor once and proving it applied before the check is asked.
Thirteen are of life.vla: a directive dropped, a rate of 121, a screen 321
wide, a cell written twice, a cell outside the Screen, a Palette index out
of order, a color that is not #RRGGBB, NOW() in the rule, a sheet named
Board.last, the header dropped, an unknown row kind, a formula into
Input!B1, and the file renamed out of its folder's name, which the count
must catch. Seven are SPEC.3's: a (spec 7) since CART.12 made 6 a page
this version reads, a macro left in a cartridge,
an include before a cartridge's manifest, a source whose cartridge is gone,
a banner naming a source that is not there, a stray .vla in a cartridge's
folder, and a second library. Nine are ENGINE.3's, of the input card's
replay and golden: a digest that is not the cartridge's, a replay named for
another folder, a (spec 7), a seed of 0, frames out of order, a derived row,
a row outside a frame, a golden without its window row, and a golden whose
replay is gone. Three are ENGINE.4's: the sound card's voice 2 written the
wave "triangel", and Life given an Audio sheet whose voice 1 has the note
130, and one whose voice 1 has the volume "loud". Three are ENGINE.18's,
version 4's rows held to a (spec 4) cartridge: Life given a Camera's third
row and an Input sheet's nineteenth row at its (spec 2), each outside its
layout, and a formula into Input!B19 at (spec 4), a cell the host writes.
Five are ENGINE.25's, version 5's sheet and row held to a (spec 5) cartridge:
a cell of the Commands sheet outside A1:D101 at (spec 5), an Input sheet's
twentieth row at (spec 4), a formula into Input!B20 at (spec 5), a command's
name that is no name, and a command's name written twice. Three are CART.12's,
version 6's directive held to a (spec 6) cartridge at rate 0: (settle 8) at
(spec 5), (settle 8) at (rate 30), and (settle 0). Four are its hand test's,
version 6's second directive: (bound "Screen") at (spec 5), a bound naming a
sheet no row holds, one naming a sheet twice, and one naming none. Six are
SPEC.5's, the keyboard's sheets: (game "Screen") at (spec 5), (work "Screen")
in plane mode, a read sheet no row holds, one named twice, a game directive
naming none, and the grid card's Screen in game and in work.

SINCE ENGINE.18 (2026-10-15; docs/REARVIEW.md, decision 1): (spec 4) is read,
for a cartridge and for a replay's header, and version 4's two rows, the
Input sheet's nineteenth (A19:B19, B19 the host's) and the Camera's third
(A3:B3), are inside their layouts for a (spec 4) cartridge alone; a
cartridge written to 1 to 3 keeps version 3's.

SINCE ENGINE.25 (2026-10-17; docs/REARVIEW.md, decision 6): (spec 5) is read,
for a cartridge and for a replay's header, and version 5's sheet and row, the
Commands sheet (A1:D101) and the Input sheet's twentieth (A20:B20, B20 the
host's), are a (spec 5) cartridge's alone, the Commands sheet's names held as
the engine holds them at load (cart-command-invalid): each value of column A from
row 2 lowercase letters, digits and hyphens, and no name written twice. A
cartridge written to 1 to 4 keeps version 4's layouts, and a sheet of its named
Commands is its own.

SINCE CART.12 (2026-10-18; docs/REARVIEW.md, decision 66): (spec 6) is read, for
a cartridge and for a replay's header, and version 6's directive, (settle K), a
whole number from 1 to 65536, is a (spec 6) cartridge's at (rate 0) alone, as the
engine reads it; version 6 adds no sheet and no row, its layouts version 5's. Since
its hand test (2026-10-19), version 6's second directive, (bound "<sheet>" ...),
the sheets a viewport draws to their extent and no further, is a (spec 6)
cartridge's at any rate, each sheet a text named once and one the rows hold or
the engine makes, Clock, File or Input, as the engine reads it at the load.

SINCE SPEC.5 (2026-10-20; docs/REARVIEW.md, decision 1): version 6's keyboard's
sheets, (game "<sheet>" ...), (work "<sheet>" ...) and (read "<sheet>" ...),
the sheets whose keys are the game's, the sheets a person types into and the
sheets no person writes, are a (spec 6) cartridge's, game and work a grid's
and read any cartridge's, each naming its sheets as bound names its own, and
no sheet in work and in game or read, as the engine reads them.

SINCE REPO.8 (2026-10-24): within one run a cartridge's verdict is kept by
its path and its bytes, a replay's by its path, its bytes and its
cartridge's, and a golden's by its path and its bytes, each read from those
files alone; the control tests its tree again for every mutant, every
folder rule and count as before, and reads again only the files whose bytes
the mutant changed. The control went from 520 s to 29 to 32 on the owner's
machine.

House style (tools/check_*.ps1): PowerShell 5.1, host-free, no network; a
hardcoded, reviewable baseline that pins how many; exit 0 clean, exit 1 with
every problem named.

Usage:  powershell -File tools\check_cartridge.ps1
        powershell -File tools\check_cartridge.ps1 -Control
#>
param(
    [string]$Root = '',
    [switch]$Control
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
if ($Root -eq '') { $Root = $repoRoot }

# --- the baseline: how many cartridges, and each one's rows as a floor ---
# 2026-10-08, ENGINE.1: one, Life, 51 rows (two sheet rows, the Palette's
# forty-eight cells, the rule over the interior in one formula row).
# 2026-10-09, ENGINE.2: two, the test card beside it, 112 rows (three sheet
# rows, the Palette's forty-eight cells, the Camera's four and its value row,
# the Screen's fifty-six: every kind of value and of formula, 960 cells).
# 2026-10-09, CART.1: three, Gosper's glider gun beside them, 88 rows (three
# sheet rows, the Palette's forty-eight cells, the Seed's thirty-six, Life's
# rule over the interior in one formula row, its first frame the Seed's).
# 2026-10-10, SPEC.3: three still, each now the pass's expansion of its source,
# cartridges/<name>/<name>.source.vla, over one library, cartridges/console.vla;
# their rows unchanged, so the floors stand.
# 2026-10-10, ENGINE.3: four, the input card beside them, 136 rows (seven sheet
# rows, the Palette's forty-eight cells, the Keys sheet's thirty, the Camera's
# four and its value row, the Tally's labels, counts and dice, the Write row,
# the Panel's lamps and the Screen's one formula: 1,517 cells, 1,411 of them
# formula cells), written as a source over the library, which gains the Keys
# sheet's macros; the other three's rows unchanged.
# 2026-10-10, ENGINE.3's second slice: the input card's replay and its golden,
# cartridges/inputcard/inputcard.replay.vla (the loop oracle's input case as
# the host recorded it: 26 frames, 19 of them written, 130 rows, the seed
# 12345) and inputcard.golden.vla (the Tally sheet's record at its end, the
# window A1:E20); the cartridges' rows unchanged.
# 2026-10-10, at the owner's word: the library renamed cartridges/common.vla,
# with on, cells and formulas, which name a sheet once over a run of its rows;
# the sources rewritten over them, and the cartridges' rows unchanged.
# 2026-10-10, ENGINE.4's first slice: five, the sound card beside them, 117
# rows (seven sheet rows, the Palette's forty-eight cells, the Keys sheet's
# twenty, the Knobs' six, the Score's labels and timing, the Audio sheet's
# header, two waves and ten formulas, the Log's six formula rows and the
# Screen's two, its waterfall: 1,592 formula cells), written as a source over
# the library, which gains audio; the other four's rows unchanged.
# 2026-10-10, ENGINE.4's second slice: the sound card's replay and its golden,
# cartridges/soundcard/soundcard.replay.vla (the loop oracle's audio case over
# the module as the host recorded it: 240 frames, 18 of them written, the last
# empty, 88 rows, the manifest's seed 1) and soundcard.golden.vla (the Log sheet's
# record at its end, the window A1:M32, the last 32 frames of the four
# voices); the cartridges' rows unchanged.
# 2026-10-11, CART.2's first slice: six, Sand beside them, 81 rows (eight
# sheet rows, the Palette's forty-eight cells, the walls' two and Stay's
# border's three, the Brush's four labels and four formulas, the Gate's two,
# Parity's one, State's label and formula, Stay's one fill and the Screen's
# two, the Tally's two labels and two fills: 126,449 formula cells), written
# as a source over the library, which gains nothing; the other five's rows
# unchanged.
# 2026-10-12, CART.2's third slice: Sand with water, 86 rows (nine sheet rows,
# Side's among them, Side's border's three, and Side's one fill: 189,017
# formula cells); the other five's rows unchanged.
# 2026-10-12, CART.2's playtest pass: the brush read from the Gate's rows,
# 87 rows (the Gate's third fill, the material in the disc's rows: 189,215
# formula cells), and the rate of 60; the other five's rows unchanged.
# 2026-10-12, CART.2's second slice: Sand's replay and its golden,
# cartridges/sand/sand.replay.vla (the owner's painting session on the
# finished toy: 2,085 frames, 576 of them written, the last empty, 870 rows,
# the manifest's seed 1) and sand.golden.vla (the Tally sheet's record at its
# end, the window A1:B199); the cartridges' rows unchanged.
# 2026-10-12, ENGINE.8's first slice: seven, the grid card beside them, 150
# rows (two sheet rows, the Camera's four cells, twenty-six formats and
# twenty-three looks, the gridlines, four column rows and two row rows, the
# Screen's sixty-eight value cells and fifteen formulas, the stripe's one
# fill among them, four styles and a sentence: 3,278 formula cells), the
# first grid cartridge, written as a source over the library with a macro of
# its own; the other six's rows unchanged.
# 2026-10-12, CART.4's first slice: eight, Kairos beside them, 378 rows (twelve
# sheet rows, the Palette's forty-eight cells with sixteen formats and sixteen
# looks, the Keys' twenty, the Camera's four, the Levels' table and settings,
# the State's labels and thirty-one cells, the Gate's six fills and a row of
# values, the Tower's one row, WIN's picture, the Screen's three fills, the
# Audio sheet's voices, the Tally's counts, and the Write sheet's header and
# its two rows: 350 formula cells), the first game, a plane drawn in Lovelace
# Lavender, written as a source over the library, which gains
# every, since, looks, camera and put; the input card and the grid card
# rewritten over put, looks and camera; the other seven's rows unchanged.
# 2026-10-12, CART.4's second slice: Kairos's replay and its golden,
# cartridges/kairos/kairos.replay.vla (the owner's two games: 3,469 frames,
# 127 of them written, the last empty, 273 rows, the manifest's seed 1) and
# kairos.golden.vla (the Tally sheet's record at its end, the window
# A1:D23); the cartridges' rows unchanged.
# 2026-10-18, CART.12's fourth slice: Superposition's replay and its golden,
# cartridges/superposition/superposition.replay.vla (a stand-in for the
# owner's session, recorded by the page's own host and recorder: 27 acts over
# 113 frames at rate 0, 28 of them written, a settle's frames holding no row,
# the host's seed 20261018) and superposition.golden.vla (the Tally sheet's
# record at its end, the window R1:R513, each row's sum of its sites' codes);
# the cartridges' rows unchanged.
# 2026-10-19, CART.12's hand test: Superposition 631 rows, three column rows
# more, the Observer's A and B and the Constants' A, widths for the labels and
# for the seed, which the screen had cut to #######; and the owner's own
# session in place of the stand-in, superposition.replay.vla (18 acts over 118
# frames in one world, 19 of them written, a settle's frames holding no row,
# the seed the page chose, 1071231759; recorded on the cartridge before the
# widths and carried onto this one, its header renamed and its rows as
# recorded) and superposition.golden.vla (the Tally's record at its end, the
# window R1:R513); the other eight's rows unchanged.
# 2026-10-19, CART.12's second hand test: Superposition 636 rows, its lattice
# moved to A1, no spacer row or column, and bound there by version 6's second
# directive, (bound "Field"): the Field's widths a column fewer, 512, its rule
# and the Readings' each four parts, the corner's, the first row's, the first
# column's and the rest's, and a box beside a reading of nothing opened; the
# owner's replay carried onto it, each act's place a row up and a column left
# with the lattice (118 frames, 19 written), and its golden the Tally's record
# over R1:R512; the other eight's rows unchanged.
# 2026-10-19, CART.14's first slice: Seiyaku, the tenth cartridge, 4,222 rows,
# 3,521 of them its book's givens, a puzzle a row of the hidden Book, written
# into its source by engine/examples/seiyaku.rs; its replay, a stand-in the
# owner's session replaces (64 acts over 191 frames), and its golden, the
# Constraints sheet's record at its end over A1:D57; the other nine's rows
# unchanged.
# 2026-10-19, CART.14's hand test: Seiyaku 4,263 rows, its variables twice as
# large, 12.57 characters by 66 points, its marks laid in five lines, and the
# keys beside the Board, K1:L9 on the canvas's gray, J a gutter (41 rows: 18
# cells, 18 styles, 2 formats and 3 columns); the owner's session its replay in
# place of the stand-in (35 acts over 104 frames), carried onto the cartridge
# as its notes left it, no cell it writes or reads moved, and its golden the
# Constraints sheet's record at its end; the other nine's rows unchanged.
# 2026-10-20, CART.9's first slice: Naught, the eleventh cartridge, 86 rows,
# its bench a 16-bit adder and an 8 by 8 multiplier, 400 gates, its block
# written into its source by engine/examples/naught.rs; its replay, a stand-in
# the owner's session replaces (38 switches written over 78 frames, each act and
# its settle two), and its golden, the Bench's record at its end over A1:BI17;
# the other ten's rows unchanged. Its (settle 65536), added at the slice's hand
# test, is a directive of the manifest and no row.
# 2026-10-20, CART.9's second slice and its hand test: 120 rows, the Lesson's
# 19 (its sheet, its column and 17 lines) and the bench's 15 names in its row
# 1, the bench a row lower; its stand-in written again, its golden over A1:BI18.
# 2026-10-20, CART.9's third slice: 675 rows, the game's nine levels between the
# Lesson and the Bench, a sheet each, with the Lab, the Count, the Camera and
# the Commands, and the Lesson's 20 lines leading into them; its replay the
# bench and then the levels (71 acts over 706 frames more), its golden the
# Bench's record at its end as before. At its hand test, 2026-10-21, the
# owner's session the replay's first 45 frames, I and II played, the stand-in
# after it, the levels III to IX, the bench and a switch written over, 782
# frames; its golden the Bench's record at its end still.
# 2026-10-24, CART.9's short slice: 756 rows, the Count gone for the Gates, a
# level's room read by its formulas' texts (ISFORMULA, FORMULATEXT), its kinds
# and six columns more of the Lab, and the Lesson's 21st line; its replay the
# owner's 45 frames played against the new cartridge, then the stand-in, 794
# frames; its golden the Bench's record, its sheets' list naming the Gates.
# 2026-10-24, ENGINE.28: the grid card 229 rows by its rows 17 and 18, a format's
# font and alignment (slice 1), then 253 by row 18's edges, P18 to W18, eight
# formats, cells and styles (slice 2); 2026-10-29, at its hand test, 264, the
# edges moved off the narrow, hidden and styled columns to row 2, I2 to P2, and
# an edge beside the hidden column and one beside the hidden row, three formats more.
# 2026-10-29, ENGINE.28's third slice: Seiyaku 4,205 rows, its boxes drawn by
# their edges and its digits by their fonts, its gridlines off: nine formats by
# a variable's place in its box where two tints were, 54 for its 108 looks where
# 108 were, its keys' three where two were, and the keys' styles four by range
# where eighteen were (formats 112 to 66, styles 99 to 85); at the owner's two
# looks its marks centered in their thirds, the Board and the Constraints game
# sheets and read-only (SPEC.5), and the Board moved to B2 behind a margin column
# and row, two rows more, so that its frame draws on every side; its replay
# carried, each act's place a column and a row on, and its golden unchanged.
$expectedCartridges = 11
$expectedSources = 11
$expectedLibraries = 1
$expectedReplays = 7
$expectedGoldens = 7
$rowFloors = @{ 'cartridges/life/life.vla' = 51; 'cartridges/gun/gun.vla' = 88; 'cartridges/testcard/testcard.vla' = 112; 'cartridges/inputcard/inputcard.vla' = 136; 'cartridges/soundcard/soundcard.vla' = 117; 'cartridges/sand/sand.vla' = 87; 'cartridges/gridcard/gridcard.vla' = 264; 'cartridges/kairos/kairos.vla' = 378; 'cartridges/superposition/superposition.vla' = 636; 'cartridges/seiyaku/seiyaku.vla' = 4205; 'cartridges/naught/naught.vla' = 756 }
$waves = @('square', 'triangle', 'sawtooth', 'sine')   # the OscillatorNode's own words, a voice's wave (docs/SPEC.md section 3.6)

# --- section 7 and section 3, as data ---
$requiredDirectives = @('spec', 'title', 'rate', 'screen', 'seed')
$optionalDirectives = @('author', 'license', 'notes', 'settle', 'bound', 'game', 'work', 'read')
$rowKinds = @('sheet', 'cell', 'formula', 'value', 'name', 'column', 'format', 'style', 'gridlines', 'sentence', 'table', 'refers', 'look', 'row')
# A format row's groups after its wrap (ENGINE.28, over vla-lang 0.11.0's KERNEL.50): each a list headed font, align
# or border, each head at most once; what a group holds is the loader's to refuse by name, which the engine's load
# of every cartridge holds elsewhere in this check.
function Test-Groups($items) {
    $seen = @{}
    for ($gi = 5; $gi -lt $items.Count; $gi++) {
        $g = $items[$gi]
        if (-not (Test-Kind $g 'list') -or $g.Items.Count -eq 0 -or -not (Test-Kind $g.Items[0] 'symbol')) { return $false }
        $head = $g.Items[0].Text
        if ($head -cne 'font' -and $head -cne 'align' -and $head -cne 'border') { return $false }
        if ($seen.ContainsKey($head)) { return $false }
        $seen[$head] = $true
    }
    return $true
}
function New-Rect([int]$top, [int]$left, [int]$bottom, [int]$right) { return @{ T = $top; L = $left; B = $bottom; R = $right } }
$layouts = @{
    'palette' = @((New-Rect 1 1 16 3)); 'input' = @((New-Rect 1 1 10 5), (New-Rect 11 1 18 2)); 'keys' = @((New-Rect 1 1 10 5))
    'clock' = @((New-Rect 1 1 3 2)); 'audio' = @((New-Rect 1 1 5 4)); 'file' = @((New-Rect 1 1 3 2)); 'camera' = @((New-Rect 1 1 2 2))
    'write' = @((New-Rect 1 1 1048576 3))
}
$hostCells = @{ 'input' = @((New-Rect 1 2 10 5), (New-Rect 11 2 18 2)); 'clock' = @((New-Rect 1 2 3 2)); 'file' = @((New-Rect 1 2 2 2)) }
# Version 4's (ENGINE.18), a (spec 4) cartridge's alone: the Input sheet's nineteenth row, the sheet shown, and the
# Camera's third, the sheet the game shows.
$layouts4 = $layouts.Clone(); $layouts4['input'] = @((New-Rect 1 1 10 5), (New-Rect 11 1 19 2)); $layouts4['camera'] = @((New-Rect 1 1 3 2))
$hostCells4 = $hostCells.Clone(); $hostCells4['input'] = @((New-Rect 1 2 10 5), (New-Rect 11 2 19 2))
# Version 5's (ENGINE.25), a (spec 5) cartridge's alone: the Input sheet's twentieth row, the command that runs, and the
# Commands sheet, a device of version 5's and a sheet of the cartridge's own before it.
$layouts5 = $layouts4.Clone(); $layouts5['input'] = @((New-Rect 1 1 10 5), (New-Rect 11 1 20 2)); $layouts5['commands'] = @((New-Rect 1 1 101 4))
$hostCells5 = $hostCells4.Clone(); $hostCells5['input'] = @((New-Rect 1 2 10 5), (New-Rect 11 2 20 2))
$header = '; SPDX-License-Identifier: 0BSD'

# ---- the reader: forms with their lines ----
function Read-Forms([string]$text) {
    $forms = New-Object System.Collections.Generic.List[object]
    $stack = New-Object System.Collections.Generic.List[object]
    $i = 0; $n = $text.Length; $line = 1
    while ($i -lt $n) {
        $ch = $text[$i]
        if ($ch -eq "`n") { $line++; $i++; continue }
        if ([char]::IsWhiteSpace($ch)) { $i++; continue }
        if ($ch -eq ';') { while ($i -lt $n -and $text[$i] -ne "`n") { $i++ }; continue }
        if ($ch -eq '(') { $stack.Add(@{ Kind = 'list'; Items = (New-Object System.Collections.Generic.List[object]); Line = $line }); $i++; continue }
        if ($ch -eq ')') {
            if ($stack.Count -eq 0) { throw "line ${line}: a closing parenthesis with nothing open" }
            $top = $stack[$stack.Count - 1]; $stack.RemoveAt($stack.Count - 1); $i++
            if ($stack.Count -eq 0) { $forms.Add($top) } else { $stack[$stack.Count - 1].Items.Add($top) }
            continue
        }
        if ($ch -eq '"') {
            $sb = New-Object System.Text.StringBuilder; $start = $line; $i++
            while ($true) {
                if ($i -ge $n) { throw "line ${start}: a string is not closed" }
                $c = $text[$i]
                if ($c -eq '\') { if ($i + 1 -lt $n) { [void]$sb.Append($text[$i + 1]) }; $i += 2; continue }
                if ($c -eq '"') { $i++; break }
                if ($c -eq "`n") { $line++ }
                [void]$sb.Append($c); $i++
            }
            $atom = @{ Kind = 'string'; Value = $sb.ToString(); Line = $start }
        } else {
            $j = $i
            while ($j -lt $n -and -not [char]::IsWhiteSpace($text[$j]) -and $text[$j] -ne '(' -and $text[$j] -ne ')' -and $text[$j] -ne '"' -and $text[$j] -ne ';') { $j++ }
            $tok = $text.Substring($i, $j - $i); $i = $j
            if ($tok -match '^-?(\d+\.?\d*|\.\d+)([eE][-+]?\d+)?$') { $atom = @{ Kind = 'number'; Text = $tok; Value = [double]$tok; Line = $line } }
            else { $atom = @{ Kind = 'symbol'; Text = $tok; Line = $line } }
        }
        if ($stack.Count -eq 0) { $forms.Add($atom) } else { $stack[$stack.Count - 1].Items.Add($atom) }
    }
    if ($stack.Count -gt 0) { throw "line $($stack[0].Line): a form is not closed" }
    return ,$forms
}
function Test-Kind($d, [string]$kind) { return ($null -ne $d) -and ($d.Kind -eq $kind) }
function Test-Sym($d, [string]$text) { return (Test-Kind $d 'symbol') -and ($d.Text -ceq $text) }
function Test-Whole($d) { return (Test-Kind $d 'number') -and ($d.Text -match '^\d+$') }
function Test-Value($d) {
    if ($null -eq $d) { return $false }
    if ($d.Kind -eq 'string' -or $d.Kind -eq 'number') { return $true }
    if ($d.Kind -eq 'symbol') { return ($d.Text -ceq 'true') -or ($d.Text -ceq 'false') }
    if ($d.Kind -eq 'list') { return ($d.Items.Count -eq 2) -and ((Test-Sym $d.Items[0] 'error') -or (Test-Sym $d.Items[0] 'date')) -and (Test-Kind $d.Items[1] 'string') }
    return $false
}
function Show-Datum($d) {
    if ($null -eq $d) { return 'nothing' }
    if ($d.Kind -eq 'string') { return '"' + $d.Value + '"' }
    if ($d.Kind -eq 'list') { return 'a list' }
    return $d.Text
}

# ---- addresses ----
function ConvertFrom-Letters([string]$s) { $c = 0; foreach ($ch in $s.ToUpperInvariant().ToCharArray()) { $c = $c * 26 + ([int]$ch - 64) }; return $c }
function Get-Rect([string]$t) {
    $m = [regex]::Match($t, '^\$?([A-Za-z]{1,3})\$?(\d{1,7})(?::\$?([A-Za-z]{1,3})\$?(\d{1,7}))?$')
    if (-not $m.Success) { return $null }
    $row1 = [int]$m.Groups[2].Value; $col1 = ConvertFrom-Letters $m.Groups[1].Value
    if ($m.Groups[3].Success) { $row2 = [int]$m.Groups[4].Value; $col2 = ConvertFrom-Letters $m.Groups[3].Value } else { $row2 = $row1; $col2 = $col1 }
    $rect = New-Rect ([Math]::Min($row1, $row2)) ([Math]::Min($col1, $col2)) ([Math]::Max($row1, $row2)) ([Math]::Max($col1, $col2))
    if ($rect.T -lt 1 -or $rect.L -lt 1 -or $rect.B -gt 1048576 -or $rect.R -gt 16384) { return $null }
    return $rect
}
function Test-Inside($rects, [int]$row, [int]$col) {
    foreach ($q in $rects) { if ($row -ge $q.T -and $row -le $q.B -and $col -ge $q.L -and $col -le $q.R) { return $true } }
    return $false
}
# Every cell of a rectangle inside the union of the rectangles of a layout.
function Test-AllInside($rects, $rect) {
    foreach ($q in $rects) { if ($rect.T -ge $q.T -and $rect.B -le $q.B -and $rect.L -ge $q.L -and $rect.R -le $q.R) { return $true } }
    if (($rect.B - $rect.T + 1) * ($rect.R - $rect.L + 1) -gt 10000) { return $false }
    for ($row = $rect.T; $row -le $rect.B; $row++) { for ($col = $rect.L; $col -le $rect.R; $col++) { if (-not (Test-Inside $rects $row $col)) { return $false } } }
    return $true
}
function Test-AnyInside($rects, $rect) {
    foreach ($q in $rects) { if ($rect.T -le $q.B -and $rect.B -ge $q.T -and $rect.L -le $q.R -and $rect.R -ge $q.L) { return $true } }
    return $false
}
function Test-Overlap($a, $b) { return ($a.T -le $b.B) -and ($a.B -ge $b.T) -and ($a.L -le $b.R) -and ($a.R -ge $b.L) }

# ---- one cartridge ----
function Test-Cartridge([string]$path) {
    $problems = New-Object System.Collections.Generic.List[string]
    $specN = 0   # the page's version the manifest names, once read: version 4's layouts are its alone
    $raw = [System.IO.File]::ReadAllText($path)
    $text = $raw -replace "`r`n", "`n"
    $firstLine = ($text -split "`n", 2)[0]
    if ($firstLine -cne $header) { $problems.Add("line 1: the license header is not the first line, '$header' (docs/SPEC.md section 7.1)") }
    try { $forms = Read-Forms $text } catch { $problems.Add($_.Exception.Message); return @{ Problems = $problems; Rows = 0; Cells = 0; Formulas = 0 } }
    if ($forms.Count -eq 0) { $problems.Add('the file holds no form'); return @{ Problems = $problems; Rows = 0; Cells = 0; Formulas = 0 } }

    # -- a source is the pass's, refused before its manifest as the engine refuses it --
    foreach ($f in $forms) {
        if ((Test-Kind $f 'list') -and $f.Items.Count -gt 0 -and (Test-Kind $f.Items[0] 'symbol') -and (@('defmacro', 'include') -contains $f.Items[0].Text)) {
            $problems.Add("line $($f.Line): cart-source-unexpanded: the file holds a ($($f.Items[0].Text.ToLowerInvariant()) ...) form, so it is a cartridge's source, which the pass expands into the rows a load takes (docs/SPEC.md section 7.8)")
            return @{ Problems = $problems; Rows = 0; Cells = 0; Formulas = 0 }
        }
    }

    # -- the manifest --
    $man = $forms[0]
    $mode = ''; $width = 0; $height = 0
    if (-not (Test-Kind $man 'list') -or $man.Items.Count -lt 2 -or -not (Test-Sym $man.Items[0] 'cartridge') -or -not (Test-Kind $man.Items[1] 'string')) {
        $problems.Add("line $($man.Line): cart-manifest-invalid: the first form is not (cartridge `"name`" ...)")
    } else {
        $name = $man.Items[1].Value
        if ($name -cnotmatch '^[a-z0-9][a-z0-9-]*$') { $problems.Add("line $($man.Line): cart-manifest-invalid: the name `"$name`" is not lowercase letters, digits and hyphens") }
        $seen = @{}
        $keyed = @{}   # version 6's keyboard's sheets (SPEC.5): game, work and read, each a map of its names
        for ($k = 2; $k -lt $man.Items.Count; $k++) {
            $d = $man.Items[$k]
            if (-not (Test-Kind $d 'list') -or $d.Items.Count -eq 0 -or -not (Test-Kind $d.Items[0] 'symbol')) { $problems.Add("line $($d.Line): cart-manifest-invalid: $(Show-Datum $d) is not a directive"); continue }
            $dn = $d.Items[0].Text
            if (($requiredDirectives + $optionalDirectives) -cnotcontains $dn) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn ...) is not a directive this version knows"); continue }
            if ($seen.ContainsKey($dn)) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn ...) is given twice"); continue }
            $seen[$dn] = $d
            $args1 = $d.Items.Count - 1
            switch -CaseSensitive ($dn) {
                'spec' {
                    if ($args1 -ne 1 -or -not (Test-Whole $d.Items[1])) { $problems.Add("line $($d.Line): cart-manifest-invalid: (spec ...) holds one whole number") }
                    elseif ([int]$d.Items[1].Text -gt 6 -or [int]$d.Items[1].Text -lt 1) { $problems.Add("line $($d.Line): cart-spec-unsupported: (spec $($d.Items[1].Text)); this version reads 1, 2, 3, 4, 5 and 6") }
                    else { $specN = [int]$d.Items[1].Text }
                }
                'title' { if ($args1 -ne 1 -or -not (Test-Kind $d.Items[1] 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: (title `"...`") holds one text") } }
                'rate' { if ($args1 -ne 1 -or -not (Test-Whole $d.Items[1]) -or [int]$d.Items[1].Text -gt 120) { $problems.Add("line $($d.Line): cart-manifest-invalid: (rate $(Show-Datum $d.Items[1])); a rate is a whole number from 0 to 120") } }
                'screen' {
                    if ($args1 -ne 3 -or -not (Test-Kind $d.Items[1] 'symbol') -or -not (Test-Whole $d.Items[2]) -or -not (Test-Whole $d.Items[3])) { $problems.Add("line $($d.Line): cart-manifest-invalid: (screen plane|grid width height)") }
                    else {
                        $mode = $d.Items[1].Text; $width = [int]$d.Items[2].Text; $height = [int]$d.Items[3].Text
                        $limit = if ($mode -ceq 'plane') { @(320, 200) } elseif ($mode -ceq 'grid') { @(80, 50) } else { $null }
                        if ($null -eq $limit) { $problems.Add("line $($d.Line): cart-manifest-invalid: the screen's mode is $mode, not plane or grid") }
                        elseif ($width -lt 1 -or $height -lt 1 -or $width -gt $limit[0] -or $height -gt $limit[1]) { $problems.Add("line $($d.Line): cart-manifest-invalid: the screen $mode $width by $height is past the limit of $($limit[0]) by $($limit[1]) (docs/SPEC.md section 10)") }
                    }
                }
                'seed' {
                    $ok = ($args1 -eq 1) -and ((Test-Sym $d.Items[1] 'host') -or ((Test-Whole $d.Items[1]) -and [double]$d.Items[1].Text -ge 1 -and [double]$d.Items[1].Text -le 2147483646))
                    if (-not $ok) { $problems.Add("line $($d.Line): cart-manifest-invalid: (seed $(Show-Datum $d.Items[1])); a seed is a whole number from 1 to 2147483646, or host") }
                }
                'settle' {
                    $ok = ($args1 -eq 1) -and (Test-Whole $d.Items[1]) -and [double]$d.Items[1].Text -ge 1 -and [double]$d.Items[1].Text -le 65536
                    if (-not $ok) { $problems.Add("line $($d.Line): cart-manifest-invalid: (settle $(Show-Datum $d.Items[1])); a settle is the most steps an act settles in, a whole number from 1 to 65536") }
                }
                'bound' {
                    $boundNames = @{}
                    if ($args1 -lt 1) { $problems.Add("line $($d.Line): cart-manifest-invalid: (bound ...) names one sheet or more, each a text") }
                    for ($bi = 1; $bi -le $args1; $bi++) {
                        $bn = $d.Items[$bi]
                        if (-not (Test-Kind $bn 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: (bound ...) names one sheet or more, each a text"); break }
                        if ($boundNames.ContainsKey($bn.Value.ToLowerInvariant())) { $problems.Add("line $($d.Line): cart-manifest-invalid: (bound ...) names each sheet once"); break }
                        $boundNames[$bn.Value.ToLowerInvariant()] = $bn.Value
                    }
                }
                { $_ -ceq 'game' -or $_ -ceq 'work' -or $_ -ceq 'read' } {
                    $keyedNames = @{}
                    if ($args1 -lt 1) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn ...) names one sheet or more, each a text") }
                    for ($ki = 1; $ki -le $args1; $ki++) {
                        $kn = $d.Items[$ki]
                        if (-not (Test-Kind $kn 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn ...) names one sheet or more, each a text"); break }
                        if ($keyedNames.ContainsKey($kn.Value.ToLowerInvariant())) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn ...) names each sheet once"); break }
                        $keyedNames[$kn.Value.ToLowerInvariant()] = $kn.Value
                    }
                    $keyed[$dn] = $keyedNames
                }
                'license' {
                    if ($args1 -ne 1 -or -not (Test-Kind $d.Items[1] 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: (license `"...`") holds one SPDX identifier") }
                    elseif ($d.Items[1].Value -cne '0BSD') { $problems.Add("line $($d.Line): cart-manifest-invalid: the license directive says $($d.Items[1].Value) and the header 0BSD") }
                }
                default { if ($args1 -ne 1 -or -not (Test-Kind $d.Items[1] 'string')) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($dn `"...`") holds one text") } }
            }
        }
        foreach ($rd in $requiredDirectives) { if (-not $seen.ContainsKey($rd)) { $problems.Add("line $($man.Line): cart-manifest-invalid: the manifest has no ($rd ...) directive; every directive is given (docs/SPEC.md section 7.2)") } }
        # version 6's settle (CART.12): a (spec 6) cartridge's alone, at (rate 0) alone
        if ($seen.ContainsKey('settle')) {
            $sl = $seen['settle'].Line
            if ($specN -lt 6) { $problems.Add("line $($sl): cart-manifest-invalid: (settle ...) is a directive of version 6's, where the cartridge says (spec $specN)") }
            $rd = if ($seen.ContainsKey('rate')) { $seen['rate'] } else { $null }
            if ($null -ne $rd -and $rd.Items.Count -eq 2 -and (Test-Whole $rd.Items[1]) -and [int]$rd.Items[1].Text -gt 0) { $problems.Add("line $($sl): cart-manifest-invalid: (settle ...) with (rate $($rd.Items[1].Text)): a cartridge settles at (rate 0) alone") }
        }
        # version 6's bound (CART.12's hand test): a (spec 6) cartridge's alone, at any rate
        if ($seen.ContainsKey('bound') -and $specN -lt 6) { $problems.Add("line $($seen['bound'].Line): cart-manifest-invalid: (bound ...) is a directive of version 6's, where the cartridge says (spec $specN)") }
        # version 6's keyboard's sheets (SPEC.5): a (spec 6) cartridge's; game and work a grid's; no work sheet in another
        foreach ($kd in @('game', 'work', 'read')) {
            if (-not $seen.ContainsKey($kd)) { continue }
            $kl = $seen[$kd].Line
            if ($specN -lt 6) { $problems.Add("line $($kl): cart-manifest-invalid: ($kd ...) is a directive of version 6's, where the cartridge says (spec $specN)") }
            if ($kd -cne 'read' -and $mode -ceq 'plane') { $problems.Add("line $($kl): cart-manifest-invalid: ($kd ...) in plane mode: a plane cartridge's keys are its canvas's, and (game ...) and (work ...) name a grid's sheets") }
        }
        if ($keyed.ContainsKey('work')) {
            foreach ($other in @('game', 'read')) {
                if (-not $keyed.ContainsKey($other)) { continue }
                foreach ($low in @($keyed['work'].Keys)) {
                    if ($keyed[$other].ContainsKey($low)) { $problems.Add("line $($seen['work'].Line): cart-manifest-invalid: `"$($keyed['work'][$low])`" is named in (work ...) and in ($other ...): a work sheet's keys are a person's, typed into its cells") }
                }
            }
        }
    }

    # -- the rows --
    $writes = New-Object System.Collections.Generic.List[object]
    $formulaCells = @{}
    $sheetsNamed = @{}
    $cells = 0; $formulas = 0
    for ($k = 1; $k -lt $forms.Count; $k++) {
        $f = $forms[$k]
        if (-not (Test-Kind $f 'list') -or $f.Items.Count -eq 0 -or -not (Test-Kind $f.Items[0] 'symbol')) { $problems.Add("line $($f.Line): grid-row-unknown: $(Show-Datum $f) is not a row"); continue }
        $kind = $f.Items[0].Text
        if ($kind -ceq 'derived') { $problems.Add("line $($f.Line): grid-row-unknown: a (derived ...) row is the host's write, never a cartridge's (docs/SPEC.md section 3.9)"); continue }
        if ($rowKinds -cnotcontains $kind) { $problems.Add("line $($f.Line): grid-row-unknown: ($kind ...) is not a row this version takes (docs/SPEC.md section 7.3)"); continue }
        $it = $f.Items
        $shapeOk = switch -CaseSensitive ($kind) {
            'sheet' { $it.Count -eq 3 -and (Test-Kind $it[1] 'string') -and ((Test-Sym $it[2] 'visible') -or (Test-Sym $it[2] 'hidden')) }
            'cell' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Value $it[3]) }
            'formula' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Kind $it[3] 'string') -and $it[3].Value.StartsWith('=') }
            'value' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Value $it[3]) }
            'name' { $it.Count -eq 3 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') }
            'column' { $it.Count -eq 6 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') }
            'format' { $it.Count -ge 5 -and (Test-Whole $it[1]) -and (Test-Groups $it) }
            'style' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Whole $it[3]) }
            'gridlines' { $it.Count -eq 3 -and (Test-Kind $it[1] 'string') -and ((Test-Sym $it[2] 'on') -or (Test-Sym $it[2] 'off')) }
            'sentence' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Kind $it[2] 'string') -and (Test-Whole $it[3]) }
            'look' { $it.Count -eq 4 -and (Test-Kind $it[1] 'string') -and (Test-Value $it[2]) -and (Test-Whole $it[3]) }
            'row' { $it.Count -eq 5 -and (Test-Kind $it[1] 'string') -and (Test-Whole $it[2]) }
            default { $true }
        }
        if (-not $shapeOk) { $problems.Add("line $($f.Line): grid-row-malformed: the ($kind ...) row is not in its shape (docs/SPEC.md section 7.3)"); continue }
        # every sheet a row names: the reserved names
        if ($kind -cne 'name' -and $kind -cne 'format' -and $kind -cne 'table' -and $kind -cne 'refers' -and (Test-Kind $it[1] 'string')) {
            $sheet = $it[1].Value
            $sheetsNamed[$sheet.ToLowerInvariant()] = $sheet
            if ($sheet -match '(?i)\.last$') { $problems.Add("line $($f.Line): cart-sheet-reserved: the sheet $sheet ends in .last, the name of a twin (docs/SPEC.md section 3.10)") }
            elseif ($sheet.Length -gt 26) { $problems.Add("line $($f.Line): cart-sheet-reserved: the sheet name $sheet is longer than 26 characters, so its twin would pass Excel's 31") }
        }
        if ($kind -cne 'cell' -and $kind -cne 'formula' -and $kind -cne 'value') { continue }
        $sheet = $it[1].Value; $key = $sheet.ToLowerInvariant()
        $rect = Get-Rect $it[2].Value
        if ($null -eq $rect) { $problems.Add("line $($f.Line): grid-row-malformed: `"$($it[2].Value)`" is not a cell or a range"); continue }
        if ($kind -ceq 'value') {
            if ($rect.T -ne $rect.B -or $rect.L -ne $rect.R) { $problems.Add("line $($f.Line): grid-row-malformed: a value row names one cell") }
            elseif (-not $formulaCells.ContainsKey($key + '|' + $rect.T + '|' + $rect.L)) { $problems.Add("line $($f.Line): grid-row-malformed: the value row of $sheet!$($it[2].Value) follows no formula row of that cell") }
            continue
        }
        $area = ($rect.B - $rect.T + 1) * ($rect.R - $rect.L + 1)
        $cells += $area
        if ($kind -ceq 'formula') {
            $formulas += $area
            if ($area -le 100000) { for ($row = $rect.T; $row -le $rect.B; $row++) { for ($col = $rect.L; $col -le $rect.R; $col++) { $formulaCells[$key + '|' + $row + '|' + $col] = $true } } }
            $bare = [regex]::Replace($it[3].Value, '"(?:[^"]|"")*"', '""')
            $vm = [regex]::Match($bare, '(?i)(?<![A-Za-z0-9_.!$])(NOW|TODAY|RANDBETWEEN|RAND)\s*\(')
            if ($vm.Success) { $problems.Add("line $($f.Line): cart-formula-volatile: the formula of $sheet!$($it[2].Value) calls $($vm.Groups[1].Value.ToUpperInvariant()), which reads the wall clock or the dice; the Clock sheet's frame and seed are the only clock and dice (docs/SPEC.md section 3.5)") }
        }
        $lay = if ($specN -ge 5) { $layouts5 } elseif ($specN -ge 4) { $layouts4 } else { $layouts }; $hosted = if ($specN -ge 5) { $hostCells5 } elseif ($specN -ge 4) { $hostCells4 } else { $hostCells }
        if ($lay.ContainsKey($key) -and -not (Test-AllInside $lay[$key] $rect)) { $problems.Add("line $($f.Line): cart-device-cell-outside: $sheet!$($it[2].Value) is outside the layout of the $sheet sheet (docs/SPEC.md section 3)") }
        if ($kind -ceq 'formula' -and $hosted.ContainsKey($key) -and (Test-AnyInside $hosted[$key] $rect)) { $problems.Add("line $($f.Line): cart-device-cell-formula: $sheet!$($it[2].Value) holds a formula where the host writes values") }
        $writes.Add(@{ Key = $key; Sheet = $sheet; Rect = $rect; Line = $f.Line; Text = $it[2].Value; Kind = $kind; Value = $it[3] })
    }

    # -- one write per cell: single cells by key, ranges against everything --
    $singles = New-Object 'System.Collections.Generic.Dictionary[string,int]'
    $ranges = New-Object System.Collections.Generic.List[object]
    foreach ($w in $writes) {
        $r0 = $w.Rect
        if ($r0.T -eq $r0.B -and $r0.L -eq $r0.R) {
            $ck = $w.Key + '|' + $r0.T + '|' + $r0.L
            if ($singles.ContainsKey($ck)) { $problems.Add("line $($w.Line): cart-cell-written-twice: $($w.Sheet)!$($w.Text) is written at line $($singles[$ck]) and again here") }
            else { $singles[$ck] = $w.Line }
        } else { $ranges.Add($w) }
    }
    foreach ($a in $ranges) {
        foreach ($b in $writes) {
            if ([object]::ReferenceEquals($a, $b) -or $a.Key -ne $b.Key -or -not (Test-Overlap $a.Rect $b.Rect)) { continue }
            $isRange = -not ($b.Rect.T -eq $b.Rect.B -and $b.Rect.L -eq $b.Rect.R)
            if ($isRange -and $b.Line -lt $a.Line) { continue }   # a pair of ranges is named once, from the earlier
            $problems.Add("line $($b.Line): cart-cell-written-twice: $($b.Sheet)!$($b.Text) writes cells the range $($a.Sheet)!$($a.Text) at line $($a.Line) writes too")
        }
    }

    # -- the Screen inside its declared size when there is no Camera sheet --
    if ($width -gt 0 -and -not $sheetsNamed.ContainsKey('camera')) {
        foreach ($w in $writes) { if ($w.Key -eq 'screen' -and ($w.Rect.B -gt $height -or $w.Rect.R -gt $width)) { $problems.Add("line $($w.Line): cart-screen-outside: Screen!$($w.Text) is past the declared $width by $height, and no Camera sheet places a window") } }
    }

    # -- the Palette's sixteen rows, in plane mode --
    if ($mode -ceq 'plane') {
        $pal = @{}
        foreach ($w in $writes) {
            if ($w.Key -ne 'palette' -or $w.Kind -ne 'cell') { continue }
            for ($row = $w.Rect.T; $row -le $w.Rect.B; $row++) { for ($col = $w.Rect.L; $col -le $w.Rect.R; $col++) { $pal[[string]$row + '|' + $col] = $w.Value } }
        }
        for ($row = 1; $row -le 16; $row++) {
            $ix = $pal[[string]$row + '|1']; $color = $pal[[string]$row + '|2']
            if ($null -eq $ix -or -not (Test-Kind $ix 'number') -or [double]$ix.Text -ne ($row - 1)) { $problems.Add("cart-palette-invalid: Palette!A$row holds $(Show-Datum $ix), and the index $($row - 1) belongs there (docs/SPEC.md section 3.2)") }
            if ($null -eq $color -or -not (Test-Kind $color 'string') -or $color.Value -cnotmatch '^#[0-9A-Fa-f]{6}$') { $problems.Add("cart-palette-invalid: Palette!B$row holds $(Show-Datum $color), not a color as #RRGGBB") }
        }
    }

    # -- the Audio sheet's value cells, judged as the host judges a voice (ENGINE.4, decision 4) --
    foreach ($w in $writes) {
        if ($w.Key -ne 'audio' -or $w.Kind -ne 'cell') { continue }
        $d = $w.Value
        for ($row = [Math]::Max(2, $w.Rect.T); $row -le [Math]::Min(5, $w.Rect.B); $row++) {
            for ($col = [Math]::Max(2, $w.Rect.L); $col -le [Math]::Min(4, $w.Rect.R); $col++) {
                $at = 'Audio!' + [char](64 + $col) + $row
                $num = if (Test-Kind $d 'number') { [double]$d.Text } else { $null }
                if ($col -eq 2 -and -not ((Test-Kind $d 'string') -and ($waves -ccontains $d.Value.ToLowerInvariant()))) {
                    $problems.Add("line $($w.Line): $at holds $(Show-Datum $d), which is no voice's wave: square, triangle, sawtooth or sine, compared without case (docs/SPEC.md section 3.6); the host would silence the voice")
                } elseif ($col -eq 3 -and -not ($null -ne $num -and $num -ge 0 -and $num -le 127)) {
                    $problems.Add("line $($w.Line): $at holds $(Show-Datum $d), which is no voice's note: a number from 0 to 127, MIDI's range (docs/SPEC.md section 3.6); the host would silence the voice")
                } elseif ($col -eq 4 -and -not ($null -ne $num -and $num -ge 0 -and $num -le 1)) {
                    $problems.Add("line $($w.Line): $at holds $(Show-Datum $d), which is no voice's volume: a number from 0 to 1 (docs/SPEC.md section 3.6); the host would silence the voice")
                }
            }
        }
    }
    # -- the Commands sheet's names, a (spec 5) cartridge's (ENGINE.25; docs/SPEC.md section 3.10): each value of column A
    # from row 2 a command's name, lowercase letters, digits and hyphens, and no name written twice, as the engine holds them --
    if ($specN -ge 5) {
        $named = @{}
        foreach ($w in @($writes | Where-Object { $_.Key -eq 'commands' -and $_.Kind -eq 'cell' -and $_.Rect.L -le 1 -and $_.Rect.B -ge 2 } | Sort-Object { $_.Rect.T })) {
            $d = $w.Value
            if ((Test-Kind $d 'string') -and $d.Value -eq '') { continue }
            for ($row = [Math]::Max(2, $w.Rect.T); $row -le $w.Rect.B; $row++) {
                if (-not ((Test-Kind $d 'string') -and $d.Value -cmatch '^[a-z0-9-]+$')) { $problems.Add("line $($w.Line): cart-command-invalid: Commands!A$row holds $(Show-Datum $d), which is no command's name: lowercase letters, digits and hyphens (docs/SPEC.md section 3.10)"); break }
                if ($named.ContainsKey($d.Value)) { $problems.Add("line $($w.Line): cart-command-invalid: Commands!A$row names $($d.Value), as A$($named[$d.Value]) does"); break }
                $named[$d.Value] = $row
            }
        }
    }
    # -- version 6's bound (CART.12's hand test): each sheet one the rows hold, or one the engine makes at the load --
    if ($null -ne $man -and $man.Items.Count -ge 2) {
        for ($k = 2; $k -lt $man.Items.Count; $k++) {
            $d = $man.Items[$k]
            if (-not (Test-Kind $d 'list') -or $d.Items.Count -lt 2 -or -not (Test-Sym $d.Items[0] 'bound')) { continue }
            for ($bi = 1; $bi -lt $d.Items.Count; $bi++) {
                $bn = $d.Items[$bi]
                if (-not (Test-Kind $bn 'string')) { continue }
                $low = $bn.Value.ToLowerInvariant()
                if (-not $sheetsNamed.ContainsKey($low) -and @('clock', 'file', 'input') -notcontains $low) { $problems.Add("line $($d.Line): cart-manifest-invalid: (bound `"$($bn.Value)`") names a sheet the cartridge does not hold") }
            }
        }
    }
    # -- version 6's keyboard's sheets (SPEC.5): each sheet one the rows hold, or one the engine makes, as bound's --
    if ($null -ne $man -and $man.Items.Count -ge 2) {
        for ($k = 2; $k -lt $man.Items.Count; $k++) {
            $d = $man.Items[$k]
            if (-not (Test-Kind $d 'list') -or $d.Items.Count -lt 2 -or -not ((Test-Sym $d.Items[0] 'game') -or (Test-Sym $d.Items[0] 'work') -or (Test-Sym $d.Items[0] 'read'))) { continue }
            for ($ki = 1; $ki -lt $d.Items.Count; $ki++) {
                $kn = $d.Items[$ki]
                if (-not (Test-Kind $kn 'string')) { continue }
                $low = $kn.Value.ToLowerInvariant()
                if (-not $sheetsNamed.ContainsKey($low) -and @('clock', 'file', 'input') -notcontains $low) { $problems.Add("line $($d.Line): cart-manifest-invalid: ($($d.Items[0].Text) `"$($kn.Value)`") names a sheet the cartridge does not hold") }
            }
        }
    }
    return @{ Problems = $problems; Rows = $forms.Count - 1; Cells = $cells; Formulas = $formulas }
}

# The banner on the second line of a cartridge the pass wrote, naming its
# source: engine/src/pass.rs's banner, word for word.
function Get-Banner([string]$sourceFile) { return "; Expanded by the pass from ${sourceFile}: edit that file, then expand it again." }
$bannerOpens = '; Expanded by the pass from '

# A file's second line, its line ending dropped, or ''.
function Get-SecondLine([string]$path) {
    $parts = ([System.IO.File]::ReadAllText($path) -replace "`r`n", "`n") -split "`n", 3
    if ($parts.Count -ge 2) { return $parts[1] }
    return ''
}

# ---- a replay and its golden (ENGINE.3's second slice; docs/SPEC.md section 7.6) ----
# A file's SHA-256 over its text with LF line ends, upper-case hex: what a replay's header names
# its cartridge by, as tools/check_frame_floors.ps1 digests a fixture and the host its cartridge.
function Get-LfDigest([string]$path) {
    $text = [System.IO.File]::ReadAllText($path) -replace "`r`n", "`n"
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { $hash = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($text)) } finally { $sha.Dispose() }
    return (($hash | ForEach-Object { $_.ToString('X2') }) -join '')
}
# The seed a cartridge's manifest names, a number or host, from its one (seed ...) directive line; '' with none.
function Get-ManifestSeed([string]$path) {
    $m = [regex]::Match(([System.IO.File]::ReadAllText($path)), '(?m)^\s*\(seed\s+(host|\d+)\)')
    if ($m.Success) { return $m.Groups[1].Value }
    return ''
}
function Test-Replay([string]$path, [string]$name, [string]$cartridgePath) {
    $problems = New-Object System.Collections.Generic.List[string]
    $result = @{ Problems = $problems; Frames = 0; Rows = 0; Last = 0; Seed = '' }
    $text = [System.IO.File]::ReadAllText($path) -replace "`r`n", "`n"
    if (($text -split "`n", 2)[0] -cne $header) { $problems.Add("line 1: the license header is not the first line, '$header'") }
    try { $forms = Read-Forms $text } catch { $problems.Add($_.Exception.Message); return $result }
    $shape = '(replay "<name>" (spec <n>) (cartridge "<SHA-256>") (seed <n>))'
    $h = $null
    if ($forms.Count -gt 0) { $h = $forms[0] }
    if (-not (Test-Kind $h 'list') -or $h.Items.Count -lt 2 -or -not (Test-Sym $h.Items[0] 'replay') -or -not (Test-Kind $h.Items[1] 'string')) { $problems.Add("the first form is not a replay's header, $shape"); return $result }
    if ($h.Items[1].Value -cne $name) { $problems.Add("line $($h.Line): the header names $($h.Items[1].Value), and the replay stands in the folder of $name") }
    $given = @{}
    for ($i = 2; $i -lt $h.Items.Count; $i++) {
        $d = $h.Items[$i]
        if (-not (Test-Kind $d 'list') -or $d.Items.Count -ne 2 -or -not (Test-Kind $d.Items[0] 'symbol') -or @('spec', 'cartridge', 'seed') -cnotcontains $d.Items[0].Text) { $problems.Add("line $($h.Line): the header holds $(Show-Datum $d), and a replay's header is $shape"); continue }
        if ($given.ContainsKey($d.Items[0].Text)) { $problems.Add("line $($h.Line): the header gives ($($d.Items[0].Text) ...) twice") }
        $given[$d.Items[0].Text] = $d.Items[1]
    }
    foreach ($k in @('spec', 'cartridge', 'seed')) { if (-not $given.ContainsKey($k)) { $problems.Add("line $($h.Line): the header has no ($k ...), and a replay's header is $shape") } }
    if ($given.ContainsKey('spec')) {
        $s = $given['spec']
        if (-not (Test-Whole $s) -or $s.Value -lt 1 -or $s.Value -gt 6) { $problems.Add("line $($h.Line): (spec $(Show-Datum $s)): a replay is written to the page's version 1, 2, 3, 4, 5 or 6") }
    }
    if ($given.ContainsKey('cartridge')) {
        $c = $given['cartridge']
        if (-not (Test-Kind $c 'string') -or $c.Value -cnotmatch '^[0-9A-F]{64}$') { $problems.Add("line $($h.Line): (cartridge $(Show-Datum $c)) is not a SHA-256 in sixty-four upper-case hex digits") }
        else {
            $want = Get-LfDigest $cartridgePath
            if ($c.Value -cne $want) { $problems.Add("line $($h.Line): the header names the cartridge $($c.Value), and $name.vla's SHA-256 over its LF bytes is ${want}: a replay plays only on the file it was recorded from") }
        }
    }
    if ($given.ContainsKey('seed')) {
        $s = $given['seed']
        if (-not (Test-Whole $s) -or $s.Value -lt 1 -or $s.Value -gt 2147483646) { $problems.Add("line $($h.Line): (seed $(Show-Datum $s)): a seed is a whole number from 1 to 2147483646") }
        else {
            $result.Seed = $s.Text
            $named = Get-ManifestSeed $cartridgePath
            if ($named -match '^\d+$' -and [double]$named -ne $s.Value) { $problems.Add("line $($h.Line): (seed $($s.Text)), and $name.vla's manifest says (seed $named): a replay of it holds its manifest's seed") }
        }
    }
    # the frames ascending from 1, each one form holding cell and formula rows alone
    $frame = 0
    for ($i = 1; $i -lt $forms.Count; $i++) {
        $f = $forms[$i]
        $head = ''
        if ((Test-Kind $f 'list') -and $f.Items.Count -ge 1 -and (Test-Kind $f.Items[0] 'symbol')) { $head = $f.Items[0].Text }
        if ($head -cne 'frame') { $problems.Add("line $($f.Line): $(if ($head) { "($head ...)" } else { Show-Datum $f }) outside a frame: every form after a replay's header is a frame, (frame n row ...), holding the rows written before that step"); continue }
        $n = $null
        if ($f.Items.Count -ge 2) { $n = $f.Items[1] }
        if (-not (Test-Whole $n) -or $n.Value -le $frame) { $problems.Add("line $($f.Line): (frame $(Show-Datum $n) ...) follows $(if ($frame) { "(frame $frame ...)" } else { 'the header' }), and a replay's frames ascend from 1"); continue }
        $frame = $n.Value; $result.Frames++
        for ($j = 2; $j -lt $f.Items.Count; $j++) {
            $row = $f.Items[$j]
            $rowHead = ''
            if ((Test-Kind $row 'list') -and $row.Items.Count -ge 1 -and (Test-Kind $row.Items[0] 'symbol')) { $rowHead = $row.Items[0].Text }
            if ($rowHead -ceq 'derived') { $problems.Add("line $($row.Line): a (derived ...) row: the host's derived writes are re-derived as a replay plays and never logged (docs/SPEC.md section 7.6)"); continue }
            if ($rowHead -cne 'cell' -and $rowHead -cne 'formula') { $problems.Add("line $($row.Line): $(if ($rowHead) { "($rowHead ...)" } else { Show-Datum $row }) in frame $frame, and a frame holds cell and formula rows alone"); continue }
            $ok = ($row.Items.Count -eq 4) -and (Test-Kind $row.Items[1] 'string') -and (Test-Kind $row.Items[2] 'string') -and ($null -ne (Get-Rect $row.Items[2].Value)) -and (Test-Value $row.Items[3])
            if ($ok -and $rowHead -ceq 'formula') { $ok = (Test-Kind $row.Items[3] 'string') -and $row.Items[3].Value.StartsWith('=') }
            if (-not $ok) { $problems.Add("line $($row.Line): the row is not ($rowHead `"sheet`" `"address`" value)"); continue }
            $result.Rows++
        }
    }
    $result.Last = $frame
    return $result
}
function Test-Golden([string]$path) {
    $problems = New-Object System.Collections.Generic.List[string]
    $result = @{ Problems = $problems; Sheet = ''; Window = ''; Rows = 0 }
    $text = [System.IO.File]::ReadAllText($path) -replace "`r`n", "`n"
    if (($text -split "`n", 2)[0] -cne $header) { $problems.Add("line 1: the license header is not the first line, '$header'") }
    try { $forms = Read-Forms $text } catch { $problems.Add($_.Exception.Message); return $result }
    $result.Rows = $forms.Count
    $windows = @($forms | Where-Object { (Test-Kind $_ 'list') -and $_.Items.Count -ge 1 -and (Test-Sym $_.Items[0] 'window') })
    if ($windows.Count -ne 1) { $problems.Add("the golden holds $($windows.Count) (window ...) row(s), and a golden is the record of one window of one sheet, its window row naming the sheet (docs/SPEC.md section 7.6)"); return $result }
    $w = $windows[0]
    if ($w.Items.Count -ne 3 -or -not (Test-Kind $w.Items[1] 'string') -or -not (Test-Kind $w.Items[2] 'string') -or $null -eq (Get-Rect $w.Items[2].Value)) { $problems.Add("line $($w.Line): the window row is not (window `"sheet`" `"range`")"); return $result }
    $sheet = $w.Items[1].Value
    $result.Sheet = $sheet; $result.Window = $w.Items[2].Value
    $sheets = @($forms | Where-Object { (Test-Kind $_ 'list') -and $_.Items.Count -ge 2 -and (Test-Sym $_.Items[0] 'sheet') -and (Test-Kind $_.Items[1] 'string') } | ForEach-Object { $_.Items[1].Value })
    if ($sheets -cnotcontains $sheet) { $problems.Add("line $($w.Line): the window names the sheet $sheet, which no (sheet ...) row of the record holds") }
    foreach ($f in $forms) {
        if (-not (Test-Kind $f 'list') -or $f.Items.Count -lt 2) { continue }
        foreach ($kind in @('cell', 'formula', 'value')) {
            if ((Test-Sym $f.Items[0] $kind) -and (-not (Test-Kind $f.Items[1] 'string') -or $f.Items[1].Value -cne $sheet)) { $problems.Add("line $($f.Line): a ($kind ...) row of $(Show-Datum $f.Items[1]), and the golden is the record of $sheet") }
        }
    }
    return $result
}

# ---- a file's verdict kept by its bytes (REPO.8) ----
# A cartridge's verdict reads its file alone, a replay's its file and its cartridge's, a golden's its file alone; so
# within one run each is kept by the path and the bytes it was read from and answered again while they are the same,
# and the control, which tests its tree again for every mutant, reads again only the files a mutant changed.
$script:Kept = @{}
function Get-ByteDigest([string]$path) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { return [System.BitConverter]::ToString($sha.ComputeHash([System.IO.File]::ReadAllBytes($path))) } finally { $sha.Dispose() }
}

# ---- every cartridge, source and library of a tree, against the baseline ----
function Test-Tree([string]$root) {
    $problems = New-Object System.Collections.Generic.List[string]
    $lines = New-Object System.Collections.Generic.List[string]
    $dir = Join-Path $root 'cartridges'
    $all = @()
    if (Test-Path -LiteralPath $dir) { $all = @(Get-ChildItem -LiteralPath $dir -Recurse -Filter '*.vla' -File | Sort-Object FullName) }
    # The folder rule: a cartridge is the file of its folder's name, its source
    # <name>.source.vla beside it, its replay <name>.replay.vla and that replay's
    # golden <name>.golden.vla, and a library a file of cartridges/ itself.
    $cartridges = New-Object System.Collections.Generic.List[object]
    $sources = New-Object System.Collections.Generic.List[object]
    $replays = New-Object System.Collections.Generic.List[object]
    $goldens = New-Object System.Collections.Generic.List[object]
    $libraries = New-Object System.Collections.Generic.List[object]
    foreach ($file in $all) {
        $rel = ($file.FullName.Substring($root.TrimEnd('\', '/').Length + 1)) -replace '\\', '/'
        $parts = $rel.Split('/')
        $entry = @{ Rel = $rel; Path = $file.FullName; Name = '' }
        if ($parts.Count -eq 2) { $libraries.Add($entry) }
        elseif ($parts.Count -eq 3 -and $parts[2] -ceq ($parts[1] + '.vla')) { $entry.Name = $parts[1]; $cartridges.Add($entry) }
        elseif ($parts.Count -eq 3 -and $parts[2] -ceq ($parts[1] + '.source.vla')) { $entry.Name = $parts[1]; $sources.Add($entry) }
        elseif ($parts.Count -eq 3 -and $parts[2] -ceq ($parts[1] + '.replay.vla')) { $entry.Name = $parts[1]; $replays.Add($entry) }
        elseif ($parts.Count -eq 3 -and $parts[2] -ceq ($parts[1] + '.golden.vla')) { $entry.Name = $parts[1]; $goldens.Add($entry) }
        else { $problems.Add("${rel}: neither a cartridge (cartridges/<name>/<name>.vla), its source, replay or golden (<name>.source.vla, <name>.replay.vla, <name>.golden.vla beside it) nor a library (a file of cartridges/ itself)") }
    }
    if ($cartridges.Count -ne $expectedCartridges) { $problems.Add("found $($cartridges.Count) cartridge(s) under cartridges/, and the baseline pins ${expectedCartridges}; a cartridge added, removed or renamed out of its folder's name moves the pin in this file") }
    if ($sources.Count -ne $expectedSources) { $problems.Add("found $($sources.Count) source(s) under cartridges/, and the baseline pins ${expectedSources}; a source added or removed moves the pin in this file") }
    if ($replays.Count -ne $expectedReplays) { $problems.Add("found $($replays.Count) replay(s) under cartridges/, and the baseline pins ${expectedReplays}; a replay added or removed moves the pin in this file") }
    if ($goldens.Count -ne $expectedGoldens) { $problems.Add("found $($goldens.Count) golden(s) under cartridges/, and the baseline pins ${expectedGoldens}; a golden added or removed moves the pin in this file") }
    if ($libraries.Count -ne $expectedLibraries) { $problems.Add("found $($libraries.Count) library(ies) under cartridges/, and the baseline pins ${expectedLibraries}; a library added or removed moves the pin in this file") }
    # Each source has its cartridge beside it, whose second line names it.
    foreach ($s in $sources) {
        $twin = Join-Path (Split-Path -Parent $s.Path) ($s.Name + '.vla')
        if (-not (Test-Path -LiteralPath $twin)) { $problems.Add("$($s.Rel): has no cartridge beside it, $($s.Name).vla, which the pass writes (cargo run --release --example expand)"); continue }
        $second = Get-SecondLine $twin
        if ($second -cne (Get-Banner ($s.Name + '.source.vla'))) { $problems.Add("$($s.Rel): the second line of $($s.Name).vla is not the banner naming this source, but '$second': expand the source again") }
    }
    foreach ($c in $cartridges) {
        $rel = $c.Rel
        $key = 'cartridge|' + $c.Path + '|' + (Get-ByteDigest $c.Path)
        if (-not $script:Kept.ContainsKey($key)) { $script:Kept[$key] = Test-Cartridge $c.Path }
        $t = $script:Kept[$key]
        foreach ($p in $t.Problems) { $problems.Add("${rel}: $p") }
        # A cartridge the pass wrote names a source that is there.
        $second = Get-SecondLine $c.Path
        $origin = ', written by hand'
        if ($second.StartsWith($bannerOpens)) {
            $want = $c.Name + '.source.vla'
            $origin = ', the pass''s expansion of ' + $want
            if ($second -cne (Get-Banner $want) -or -not (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $c.Path) $want))) { $problems.Add("${rel}: its banner, '$second', names a source that is not there; the pass names $want beside it") }
        }
        $note = ("  {0}: {1} rows, {2:N0} cells written, {3:N0} of them formula cells{4}" -f $rel, $t.Rows, $t.Cells, $t.Formulas, $origin)
        if (-not $rowFloors.ContainsKey($rel)) { $problems.Add("${rel}: not in the baseline; add its row floor to this file") }
        elseif ($t.Rows -lt $rowFloors[$rel]) { $problems.Add("${rel}: $($t.Rows) rows, below its floor of $($rowFloors[$rel])"); $note += ", BELOW THE FLOOR of $($rowFloors[$rel])" }
        elseif ($t.Rows -gt $rowFloors[$rel]) { $note += ", above the floor of $($rowFloors[$rel]) - raise it in this file" }
        else { $note += ', at its floor' }
        $lines.Add($note + $(if ($t.Problems.Count) { "  FAIL ($($t.Problems.Count))" } else { ', every rule of section 7 holds' }))
    }
    $lines.Add(("  {0} source(s), each beside the cartridge whose banner names it, and {1} library(ies): {2}" -f $sources.Count, $libraries.Count, ((@($libraries | ForEach-Object { $_.Rel })) -join ', ')))
    # A replay has its cartridge beside it, whose digest its header names; a golden its replay.
    foreach ($rp in $replays) {
        $cart = Join-Path (Split-Path -Parent $rp.Path) ($rp.Name + '.vla')
        if (-not (Test-Path -LiteralPath $cart)) { $problems.Add("$($rp.Rel): has no cartridge beside it, $($rp.Name).vla, whose replay it would be"); continue }
        $key = 'replay|' + $rp.Path + '|' + (Get-ByteDigest $rp.Path) + '|' + (Get-ByteDigest $cart)
        if (-not $script:Kept.ContainsKey($key)) { $script:Kept[$key] = Test-Replay $rp.Path $rp.Name $cart }
        $t = $script:Kept[$key]
        foreach ($p in $t.Problems) { $problems.Add("$($rp.Rel): $p") }
        $lines.Add(("  {0}: {1} frame(s) written of {2}, {3} row(s), the seed {4}{5}" -f $rp.Rel, $t.Frames, $t.Last, $t.Rows, $t.Seed, $(if ($t.Problems.Count) { "  FAIL ($($t.Problems.Count))" } else { ", the header naming $($rp.Name).vla by its digest; every rule of section 7.6 holds" })))
    }
    foreach ($g in $goldens) {
        if (-not (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $g.Path) ($g.Name + '.replay.vla')))) { $problems.Add("$($g.Rel): has no replay beside it, $($g.Name).replay.vla, whose end it would hold"); continue }
        $key = 'golden|' + $g.Path + '|' + (Get-ByteDigest $g.Path)
        if (-not $script:Kept.ContainsKey($key)) { $script:Kept[$key] = Test-Golden $g.Path }
        $t = $script:Kept[$key]
        foreach ($p in $t.Problems) { $problems.Add("$($g.Rel): $p") }
        $lines.Add(("  {0}: the record of {1}'s window {2}, {3} row(s){4}" -f $g.Rel, $t.Sheet, $t.Window, $t.Rows, $(if ($t.Problems.Count) { "  FAIL ($($t.Problems.Count))" } else { ', its replay beside it' })))
    }
    return @{ Problems = $problems; Lines = $lines }
}

if ($Control) {
    $tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('alonzo_cart_' + [System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tmp | Out-Null
    try {
        # A pristine copy, and a fresh tree from it for every case, so that a
        # case that removes or adds a file leaves nothing for the next.
        $pristine = Join-Path $tmp 'pristine'
        Copy-Item -LiteralPath (Join-Path $Root 'cartridges') -Destination $pristine -Recurse
        $tree = Join-Path $tmp 'tree'
        function Reset-Tree {
            if (Test-Path -LiteralPath $tree) { Remove-Item -LiteralPath $tree -Recurse -Force }
            New-Item -ItemType Directory -Path $tree | Out-Null
            Copy-Item -LiteralPath $pristine -Destination (Join-Path $tree 'cartridges') -Recurse
        }
        $lf0 = [System.IO.File]::ReadAllText((Join-Path $pristine 'life/life.vla')) -replace "`r`n", "`n"
        $utf8 = New-Object System.Text.UTF8Encoding($false)
        $verdicts = New-Object System.Collections.Generic.List[string]
        $ok = $true
        Reset-Tree
        $clean = Test-Tree $tree
        if ($clean.Problems.Count -eq 0) { $verdicts.Add('the clean copy passes') } else { $ok = $false; $verdicts.Add("the clean copy fails: $($clean.Problems -join ' | ')") }
        $library = "; SPDX-License-Identifier: 0BSD`n(defmacro (x) (y))`n"
        $mutants = @(
            @{ Name = 'a directive dropped'; Anchor = '(rate 30)'; With = ''; Want = 'has no (rate ...) directive' },
            @{ Name = 'a rate of 121'; Anchor = '(rate 30)'; With = '(rate 121)'; Want = '(rate 121); a rate is' },
            @{ Name = 'a screen 321 wide'; Anchor = '(screen plane 320 200)'; With = '(screen plane 321 200)'; Want = 'the screen plane 321 by 200 is past the limit' },
            @{ Name = 'a cell written twice'; Append = '(cell "Palette" "C2" "twice")'; Want = 'cart-cell-written-twice: Palette!C2' },
            @{ Name = 'a cell outside the Screen'; Append = '(cell "Screen" "A201" 1)'; Want = 'cart-screen-outside: Screen!A201' },
            @{ Name = 'a Palette index out of order'; Anchor = '(cell "Palette" "A2" 1)'; With = '(cell "Palette" "A2" 2)'; Want = 'cart-palette-invalid: Palette!A2 holds 2' },
            @{ Name = 'a color that is not #RRGGBB'; Anchor = '"#FFFFFF"'; With = '"white"'; Want = 'cart-palette-invalid: Palette!B2 holds "white"' },
            @{ Name = 'NOW() in the rule'; Anchor = 'Clock!$B$1=1'; With = 'NOW()>0'; Want = 'cart-formula-volatile' },
            @{ Name = 'a sheet named Board.last'; Append = '(cell "Board.last" "A1" 1)'; Want = 'cart-sheet-reserved: the sheet Board.last' },
            @{ Name = 'the header dropped'; Anchor = $header; With = '; no license'; Want = 'the license header is not the first line' },
            @{ Name = 'an unknown row kind'; Append = '(paint "Screen" "A1" 1)'; Want = 'grid-row-unknown: (paint ...)' },
            @{ Name = 'a formula into Input!B1'; Append = '(formula "Input" "B1" "=1")'; Want = 'cart-device-cell-formula: Input!B1' },
            @{ Name = 'the file renamed out of its folder''s name'; Rename = 'life.txt'; Want = ("found {0} cartridge(s)" -f ($expectedCartridges - 1)) },
            @{ Name = 'Life written to (spec 3)'; Anchor = '(spec 2)'; With = '(spec 3)'; Want = '' },
            @{ Name = 'a (spec 7)'; Anchor = '(spec 2)'; With = '(spec 7)'; Want = 'cart-spec-unsupported: (spec 7)' },
            # CART.12: version 6's directive, (settle K), a (spec 6) cartridge's at (rate 0) alone
            @{ Name = 'Life written to (spec 6) at rate 0, settling'; Anchor = "(spec 2)`n  (title `"Life`")`n  (rate 30)"; With = "(spec 6)`n  (title `"Life`")`n  (rate 0)`n  (settle 8)"; Want = '' },
            @{ Name = 'a settle at (spec 5)'; Anchor = "(spec 2)`n  (title `"Life`")`n  (rate 30)"; With = "(spec 5)`n  (title `"Life`")`n  (rate 0)`n  (settle 8)"; Want = '(settle ...) is a directive of version 6''s, where the cartridge says (spec 5)' },
            @{ Name = 'a settle at a rate'; Anchor = '(spec 2)'; With = '(spec 6) (settle 8)'; Want = '(settle ...) with (rate 30): a cartridge settles at (rate 0) alone' },
            @{ Name = 'a settle of 0'; Anchor = "(spec 2)`n  (title `"Life`")`n  (rate 30)"; With = "(spec 6)`n  (title `"Life`")`n  (rate 0)`n  (settle 0)"; Want = '(settle 0); a settle is the most steps' },
            # CART.12's hand test: version 6's second directive, (bound "<sheet>" ...), a (spec 6) cartridge's at any rate
            @{ Name = 'Life written to (spec 6), its Screen bound'; Anchor = '(spec 2)'; With = "(spec 6)`n  (bound `"Screen`")"; Want = '' },
            @{ Name = 'a bound at (spec 5)'; Anchor = '(spec 2)'; With = "(spec 5)`n  (bound `"Screen`")"; Want = '(bound ...) is a directive of version 6''s, where the cartridge says (spec 5)' },
            @{ Name = 'a bound naming a sheet no row holds'; Anchor = '(spec 2)'; With = "(spec 6)`n  (bound `"Board`")"; Want = '(bound "Board") names a sheet the cartridge does not hold' },
            @{ Name = 'a bound naming a sheet twice'; Anchor = '(spec 2)'; With = "(spec 6)`n  (bound `"Screen`" `"screen`")"; Want = '(bound ...) names each sheet once' },
            @{ Name = 'a bound naming no sheet'; Anchor = '(spec 2)'; With = "(spec 6)`n  (bound)"; Want = '(bound ...) names one sheet or more, each a text' },
            # SPEC.5: version 6's keyboard's sheets, (game ...), (work ...) and (read ...), game and work a grid's
            @{ Name = 'the grid card written to (spec 6), its sheets by mode'; File = 'gridcard/gridcard.vla'; Anchor = '(spec 3)'; With = "(spec 6)`n  (game `"Screen`")`n  (read `"Camera`" `"Screen`")"; Want = '' },
            @{ Name = 'Life written to (spec 6), its Screen read'; Anchor = '(spec 2)'; With = "(spec 6)`n  (read `"Screen`")"; Want = '' },
            @{ Name = 'a game sheet at (spec 5)'; File = 'gridcard/gridcard.vla'; Anchor = '(spec 3)'; With = "(spec 5)`n  (game `"Screen`")"; Want = '(game ...) is a directive of version 6''s, where the cartridge says (spec 5)' },
            @{ Name = 'a work sheet in plane mode'; Anchor = '(spec 2)'; With = "(spec 6)`n  (work `"Screen`")"; Want = '(work ...) in plane mode: a plane cartridge''s keys are its canvas''s' },
            @{ Name = 'a read sheet no row holds'; Anchor = '(spec 2)'; With = "(spec 6)`n  (read `"Board`")"; Want = '(read "Board") names a sheet the cartridge does not hold' },
            @{ Name = 'a read sheet named twice'; Anchor = '(spec 2)'; With = "(spec 6)`n  (read `"Screen`" `"screen`")"; Want = '(read ...) names each sheet once' },
            @{ Name = 'a game directive naming none'; File = 'gridcard/gridcard.vla'; Anchor = '(spec 3)'; With = "(spec 6)`n  (game)"; Want = '(game ...) names one sheet or more, each a text' },
            @{ Name = 'a sheet in game and in work'; File = 'gridcard/gridcard.vla'; Anchor = '(spec 3)'; With = "(spec 6)`n  (game `"Screen`")`n  (work `"screen`")"; Want = '"screen" is named in (work ...) and in (game ...): a work sheet''s keys are a person''s' },
            # ENGINE.18: version 4's rows, the Camera's third and the Input sheet's nineteenth, a (spec 4) cartridge's alone
            @{ Name = 'Life written to (spec 4), its Camera of three rows'; Anchor = '(spec 2)'; With = '(spec 4)'; Append = '(cell "Camera" "B3" "Screen")'; Want = '' },
            @{ Name = 'a Camera''s third row at (spec 2)'; Append = '(cell "Camera" "B3" "Screen")'; Want = 'cart-device-cell-outside: Camera!B3' },
            @{ Name = 'an Input sheet''s nineteenth row at (spec 2)'; Append = '(cell "Input" "A19" "sheet")'; Want = 'cart-device-cell-outside: Input!A19' },
            @{ Name = 'a formula into Input!B19 at (spec 4)'; Anchor = '(spec 2)'; With = '(spec 4)'; Append = '(formula "Input" "B19" "=1")'; Want = 'cart-device-cell-formula: Input!B19' },
            # ENGINE.25: version 5's sheet and row, the Commands sheet and the Input sheet's twentieth, a (spec 5) cartridge's alone
            @{ Name = 'Life written to (spec 5), its Commands sheet'; Anchor = '(spec 2)'; With = '(spec 5)'; Append = "(cell `"Commands`" `"A1`" `"name`")`n(cell `"Commands`" `"A2`" `"count-up`")`n(cell `"Commands`" `"D2`" `"KeyU`")"; Want = '' },
            @{ Name = 'a sheet named Commands of its own at (spec 4)'; Anchor = '(spec 2)'; With = '(spec 4)'; Append = '(cell "Commands" "E2" "Buy 1")'; Want = '' },
            @{ Name = 'a Commands sheet''s cell outside its layout at (spec 5)'; Anchor = '(spec 2)'; With = '(spec 5)'; Append = '(cell "Commands" "E2" 1)'; Want = 'cart-device-cell-outside: Commands!E2' },
            @{ Name = 'an Input sheet''s twentieth row at (spec 4)'; Anchor = '(spec 2)'; With = '(spec 4)'; Append = '(cell "Input" "A20" "command")'; Want = 'cart-device-cell-outside: Input!A20' },
            @{ Name = 'a formula into Input!B20 at (spec 5)'; Anchor = '(spec 2)'; With = '(spec 5)'; Append = '(formula "Input" "B20" "=1")'; Want = 'cart-device-cell-formula: Input!B20' },
            @{ Name = 'a command''s name that is no name'; Anchor = '(spec 2)'; With = '(spec 5)'; Append = '(cell "Commands" "A2" "Buy 1")'; Want = 'cart-command-invalid: Commands!A2 holds "Buy 1"' },
            @{ Name = 'a command''s name written twice'; Anchor = '(spec 2)'; With = '(spec 5)'; Append = "(cell `"Commands`" `"A2`" `"note`")`n(cell `"Commands`" `"A3`" `"note`")"; Want = 'cart-command-invalid: Commands!A3 names note, as A2 does' },
            @{ Name = 'a macro left in a cartridge'; Append = '(defmacro (x) (y))'; Want = 'cart-source-unexpanded: the file holds a (defmacro ...)' },
            @{ Name = 'an include before a cartridge''s manifest'; Anchor = $header; With = ($header + "`n(include `"../common.vla`")"); Want = 'cart-source-unexpanded: the file holds a (include ...)' },
            @{ Name = 'a source whose cartridge is gone'; Remove = 'gun/gun.vla'; Want = 'gun.source.vla: has no cartridge beside it' },
            @{ Name = 'a banner naming a source that is not there'; Anchor = 'from life.source.vla'; With = 'from lives.source.vla'; Want = 'names a source that is not there' },
            @{ Name = 'a stray .vla in a cartridge''s folder'; Add = 'life/notes.vla'; Want = 'life/notes.vla: neither a cartridge' },
            @{ Name = 'a second library'; Add = 'extra.vla'; Want = 'found 2 library(ies)' },
            # ENGINE.3's second slice: the input card's replay and its golden
            @{ Name = 'a replay naming another digest'; File = 'inputcard/inputcard.replay.vla'; Pattern = '\(cartridge "[0-9A-F]{64}"\)'; With = ('(cartridge "' + ('0' * 64) + '")'); Want = 'a replay plays only on the file it was recorded from' },
            @{ Name = 'a replay named for another folder'; File = 'inputcard/inputcard.replay.vla'; Anchor = '(replay "inputcard"'; With = '(replay "life"'; Want = 'the header names life, and the replay stands in the folder of inputcard' },
            @{ Name = 'a replay of a (spec 7)'; File = 'inputcard/inputcard.replay.vla'; Anchor = '(spec 3)'; With = '(spec 7)'; Want = '(spec 7): a replay is written to the page''s version 1, 2, 3, 4, 5 or 6' },
            @{ Name = 'a replay''s seed of 0'; File = 'inputcard/inputcard.replay.vla'; Pattern = '\(seed \d+\)\)'; With = '(seed 0))'; Want = '(seed 0): a seed is a whole number from 1 to 2147483646' },
            @{ Name = 'a replay''s frames out of order'; File = 'inputcard/inputcard.replay.vla'; Anchor = "(frame 3`n"; With = "(frame 30`n"; Want = 'follows (frame 30 ...), and a replay''s frames ascend from 1' },
            @{ Name = 'a derived row in a replay'; File = 'inputcard/inputcard.replay.vla'; Anchor = "(frame 1`n"; With = "(frame 1`n  (derived `"Tally`" `"B20`" 1)`n"; Want = 'a (derived ...) row: the host''s derived writes are re-derived' },
            @{ Name = 'a row outside a replay''s frames'; File = 'inputcard/inputcard.replay.vla'; Anchor = "(frame 1`n"; With = "(cell `"Input`" `"B1`" 0)`n(frame 1`n"; Want = '(cell ...) outside a frame: every form after a replay''s header is a frame' },
            @{ Name = 'a golden without its window row'; File = 'inputcard/inputcard.golden.vla'; Pattern = '\(window "Tally" "[A-Z]+[0-9]+:[A-Z]+[0-9]+"\)\n'; With = ''; Want = 'the golden holds 0 (window ...) row(s)' },
            @{ Name = 'a golden whose replay is gone'; Remove = 'inputcard/inputcard.replay.vla'; Want = 'inputcard.golden.vla: has no replay beside it' },
            # ENGINE.4: the Audio sheet's value cells
            @{ Name = 'a wave that is no wave'; File = 'soundcard/soundcard.vla'; Anchor = '(cell "Audio" "B3" "triangle")'; With = '(cell "Audio" "B3" "triangel")'; Want = 'Audio!B3 holds "triangel", which is no voice''s wave' },
            @{ Name = 'a note past 127'; Append = '(cell "Audio" "C2" 130)'; Want = 'Audio!C2 holds 130, which is no voice''s note' },
            @{ Name = 'a volume that is no number'; Append = '(cell "Audio" "D2" "loud")'; Want = 'Audio!D2 holds "loud", which is no voice''s volume' }
        )
        foreach ($mu in $mutants) {
            Reset-Tree
            $life = Join-Path $tree 'cartridges/life/life.vla'
            $applied = $false
            if ($mu.ContainsKey('Rename')) {
                Rename-Item -LiteralPath $life -NewName $mu.Rename
                $applied = (-not (Test-Path -LiteralPath $life)) -and (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $life) $mu.Rename))
            } elseif ($mu.ContainsKey('Remove')) {
                $target = Join-Path $tree ('cartridges/' + $mu.Remove)
                Remove-Item -LiteralPath $target -Force
                $applied = -not (Test-Path -LiteralPath $target)
            } elseif ($mu.ContainsKey('Add')) {
                $target = Join-Path $tree ('cartridges/' + $mu.Add)
                $applied = -not (Test-Path -LiteralPath $target)
                [System.IO.File]::WriteAllText($target, ($library -replace "`n", "`r`n"), $utf8)
                $applied = $applied -and (Test-Path -LiteralPath $target)
            } else {
                # life.vla unless the mutant names its file; an anchor or a pattern met exactly once, or a row appended
                $rel = 'life/life.vla'
                if ($mu.ContainsKey('File')) { $rel = $mu.File }
                $target = Join-Path $tree ('cartridges/' + $rel)
                $orig = $lf0
                if ($rel -ne 'life/life.vla') { $orig = [System.IO.File]::ReadAllText((Join-Path $pristine $rel)) -replace "`r`n", "`n" }
                if ($mu.ContainsKey('Anchor')) {
                    if (([regex]::Matches($orig, [regex]::Escape($mu.Anchor))).Count -ne 1) { $ok = $false; $verdicts.Add("$($mu.Name): the anchor $($mu.Anchor) is not in $rel exactly once"); continue }
                    $mut = $orig.Replace($mu.Anchor, $mu.With)
                } elseif ($mu.ContainsKey('Pattern')) {
                    if (([regex]::Matches($orig, $mu.Pattern)).Count -ne 1) { $ok = $false; $verdicts.Add("$($mu.Name): the pattern $($mu.Pattern) is not in $rel exactly once"); continue }
                    $mut = [regex]::Replace($orig, $mu.Pattern, $mu.With.Replace('$', '$$'))
                } else { $mut = $orig + $mu.Append + "`n" }
                if ($mu.ContainsKey('Append') -and ($mu.ContainsKey('Anchor') -or $mu.ContainsKey('Pattern'))) { $mut = $mut + $mu.Append + "`n" }   # both, ENGINE.18's
                [System.IO.File]::WriteAllText($target, ($mut -replace "`n", "`r`n"), $utf8)
                $back = [System.IO.File]::ReadAllText($target) -replace "`r`n", "`n"
                $applied = ($back -ne $orig) -and ($back -ceq $mut)
            }
            if (-not $applied) { $ok = $false; $verdicts.Add("$($mu.Name): the mutation did not apply"); continue }
            $r = Test-Tree $tree
            if ($mu.Want -eq '') {
                if ($r.Problems.Count -eq 0) { $verdicts.Add("$($mu.Name): passes, as it should") }
                else { $ok = $false; $verdicts.Add("$($mu.Name): FAILED but should pass: $($r.Problems -join ' | ')") }
                continue
            }
            $hit = @($r.Problems | Where-Object { $_.Contains($mu.Want) }).Count
            if ($hit -ge 1) { $verdicts.Add("$($mu.Name): fails, as it should") }
            elseif ($r.Problems.Count -gt 0) { $ok = $false; $verdicts.Add("$($mu.Name): fails, but without '$($mu.Want)': $($r.Problems -join ' | ')") }
            else { $ok = $false; $verdicts.Add("$($mu.Name): PASSED but should fail") }
        }
        foreach ($v in $verdicts) { Write-Output ('control: ' + $v) }
        if ($ok) { Write-Output 'OK: the check passes the clean copy, Life written to (spec 3), Life written to (spec 4) with its Camera''s third row, Life written to (spec 5) with its Commands sheet, Life written to (spec 4) with a sheet named Commands of its own, Life written to (spec 6) at rate 0, settling, Life written to (spec 6), its Screen bound, the grid card written to (spec 6), its sheets by mode, and Life written to (spec 6), its Screen read, and fails each of the fifty-three mutants for its own reason, each proving it applied'; exit 0 }
        Write-Output 'FAIL: the control did not behave as the header says'
        exit 1
    } finally {
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    }
}

Write-Output '=== THE CARTRIDGES: EACH A CARTRIDGE AS docs/SPEC.md SECTION 7 HAS IT, READ WITHOUT AN ENGINE (ENGINE.1) ==='
$tr = Test-Tree $Root
$tr.Lines | ForEach-Object { Write-Output $_ }
Write-Output ''
if ($tr.Problems.Count -eq 0) {
    Write-Output ("=== CHECK: clean - {0} cartridge(s), each holding to section 7, at or above its floor; {1} source(s), {2} replay(s) with {3} golden(s), and {4} library(ies) beside them ===" -f $expectedCartridges, $expectedSources, $expectedReplays, $expectedGoldens, $expectedLibraries)
    exit 0
}
Write-Output "=== CHECK: $($tr.Problems.Count) problem(s) ==="
$tr.Problems | ForEach-Object { Write-Output "  $_" }
exit 1
