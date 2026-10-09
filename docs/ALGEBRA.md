# ALONZO ALGEBRA - the formula language as the whole machine

*The horizon of this repository, as `Frazaro/docs/HORIZON.md` is Frazaro's: design theory, marked per idea, never a source of items. It records the sitting of 2026-10-08 in which the owner, in the mood for speculative design and scientific inquiry rather than engineering, put four questions to the engine as `CHARTER.md`, `SPEC.md` and `ROADMAP.md` stood that evening, and the session answered; written into this file the same night at the owner's word, under the name the owner gave it. The questions, in the owner's order: whether the standing decisions of a repository one day old are already pigeonholing an open-ended exploration of spreadsheet design theory, the owner standing by the decision to build a spreadsheet on a game engine and by two beliefs, that a WebAssembly engine fit for 2D physics can carry a spreadsheet with room to spare and that the engine's extensibility and portability will draw hackers a standalone spreadsheet would not; what Peirce, Church, McCarthy and Graham would each say a cell-oriented game-engine substrate should bring to a spreadsheet; what cell-oriented programming looks like, against PyGame's attempt to democratize game development, with the owner's hunch that VLA's macros erase whole classes of boilerplate by an order of magnitude, and an aside on the stacking game played with massive cells; and whether Alonzo, which began as a linear algebra visualizer, could carry extensive linear algebra to optimize the engine's transforms and to give the spreadsheet constraint satisfaction, the moon rather than the mud. The owner's closing sentence is this document's thesis (§1).*

*What this document is not. It is not a roadmap: nothing here is an item, it mints no ID here or in `Frazaro/docs/ID_REGISTRY.md`, and an idea here that is ever picked up goes onto `ROADMAP.md` under its family, or onto Frazaro's roadmap under the department that owns it, and takes its ID there. Its recommendations are the sitting's, unadjudicated until the owner takes or leaves each by a dated line, which §8 records, and a change to `SPEC.md` is a new version of that page, `SPEC.2` when one is wanted, never an edit made from here. Where this file and the code disagree, the code is right. Marks are the charter's: every idea is* **math exists**, **engineering** *or* **fiction**; *an argument about the present is* **exhibit** *(a dated, public, checkable fact, its source in §9),* **shelf** *(a claim a file in this repository or Frazaro's already makes, cited) or* **recommendation** *(the sitting's advice); every figure is a* **measurement**, *a* **prediction** *or* **derived**. *An idea with no mark is a vibe, and this file keeps none. Frazaro's standing decisions that bind here are named where they bind: `SD-7` (no mechanism without the sentence that needs it), `SD-13` (no outbound call, ever), `SD-18` (VBA the reference), `SD-22`, `SD-23`, `SD-24`, `SD-30`, `SD-32`, `SD-33`, `SD-34`, `SD-35`, the owner's veto of `GENSYM` and, by the veto's own words, of `eval` (§2.3), and this repository's `AD-1` to `AD-6`. Licence CC-BY-4.0, under the map's rule for `docs/**`.*

---

## 1. The thesis: everything in the formula language

The owner's sentence, 2026-10-08, after the answer of §6: *"exposing everything to the formula language is exactly the shift away from current-state spreadsheeting toward a more tenfold-horsepower formula language which Alonzo+Frazaro will eventually converge upon."* This file reads the whole sitting through it. The phrase it replaces is the owner's own first framing, linear algebra "under the hood", declined by the sitting for the house's reason: the project's whole bet is that nothing is under the hood. Every value is a cell, every device is a sheet, every act is a row in one notation, and an accelerator must equal the naive frames cell for cell or it is not merged (*shelf*: `AD-6`; `SPEC.md` §6 rule 7; `ROADMAP.md`, `ENGINE.6`). A matrix under the hood is a library a function calls, which exists and is called numpy; a matrix in the cells is a range anyone can read, a solve is frames anyone can watch, and the native code sits behind the reference where a measurement asks for it. The second is what no spreadsheet has, and it is the stronger moonshot.

What first class means in this house, so that the phrase cannot drift: a thing is first class in the formula language when it is a cell or a range (the data), a row in the treaty's notation (the file), a projection the view call answers (the picture), and a sentence Frazaro translates (the door), with a golden for each. The paradigms this sitting found in the engine, time (§2.1, §3 correction 4), reflection (`AD-6`) and linear algebra (§6), each pass that test, and nothing of theirs lives in a library a cartridge cannot see. (*recommendation*)

Two of the owner's beliefs, weighed. That a WebAssembly engine built for games can carry a spreadsheet with room to spare is already supported on the shelf: a spreadsheet's window costs a tenth of the frame budget on canvas (*shelf*: `CHARTER.md` §7, the measurement of 2026-10-08), and the two-million line is a fantasy console's budget (*shelf*: `CHARTER.md` §3). That the cool factor pulls hackers is the charter's §6 hypothesis and stays *fiction* until the count. The sitting's addition: the spreadsheet crowd's own uses, a model stepped through time and a Monte Carlo under ten thousand seeds (§5.3), may pull harder than the hackers, and the specification underwrites them least.

## 2. Four readers of the engine, each with an ask

*The sitting's reading of each; the asks are* recommendations *unless marked otherwise.*

### 2.1 Peirce, the logician

He would recognize the grid at once, since a cell holds all three of his signs. The value is an icon, a quality one sees; the address is an index, a finger pointing; the formula is a symbol, a law that produces the value (*exhibit*: the trichotomy of 1867, refined in the Syllabus of 1903, §9). The formula bar's three lines, a cell's value, its formula and the sentence that wrote it, are the triad made visible (*shelf*: `SD-24`), and he would call that the right instinct. Then two objections and a gift.

- **Blank is not zero.** On his sheet of assertion a blank asserts nothing; writing asserts. The specification reads an empty Screen cell as colour 0 and Life's empty border as dead (*shelf*: `SPEC.md` §3.1, Appendix A), which conflates no assertion with an asserted zero. It costs something concrete later: a composite of layers needs a transparent cell, and blank is the natural one (§3, correction 3). The ask: blank reads as transparent in the plane, over a clear colour; Life draws the same. (*engineering*)
- **The book of sheets.** His later graphs bind the sheet of assertion into a book of sheets, tinctured, to speak of states other than the actual (*exhibit*: the Prolegomena of 1906, §9). `X.last` is one page back, a hardware register. The replay is the whole book, and the determinism rules make every page re-derivable from a save (*shelf*: `SPEC.md` §6, §7.5, §7.6). The ask: step back as a first-class act of the host, a save every k frames and a replay from the nearest. At a rate of thirty it is a rewind; for the spreadsheet it is undo, which no spreadsheet has had; and at rate zero (§3, correction 4) the two are one act. (*engineering*)
- **The light cone.** "Why is this cell this value?" is abduction, and he held that all necessary reasoning is diagrammatic (*exhibit*, §9). Across frames the dependency cone of a cell widens by one cell per frame through the twin edges, so the cone walk the reader already does (*shelf*: `frazaro reflect --cone`, oracle 8) plus the `.last` edges computes it. An auditor asking about frame 100 gets the cells that could have caused it, which is a diagram and not a stack trace. (*engineering*; the walk exists, the twin edges are a day's addition)

### 2.2 Church, the theorist

He would name the thing the specification built, because it has a name and a literature. A frame is a synchronous instant. The twin is Lustre's `pre`. The acyclic rule is Lustre's causality check. The first-frame `IF` over `Clock!B1` is Lustre's initialization arrow `->`. The seven determinism rules are the synchronous hypothesis. Caspi, Pilaud, Halbwachs and Plaice published the language in 1987, and SCADE, the industrial Lustre, is used for Airbus flight-control software (*exhibits*, §9). The mark is *math exists*, and it vindicates decision 2 of the specification, the twin sheet over a `LAST()` function: `pre` is a stream operator and never a call. What the circular-reference hack of the Life-in-Excel tradition groped toward (*shelf*: `SPEC.md` §2, why a sheet and not a function), Lustre wrote down, and this engine puts it in the sheet. His asks:

- **Say what the step is.** Each frame is a total function, since the graph is finite and acyclic and every function of the subset returns an error value rather than diverging (*shelf*: `SPEC.md` §4.4, an error is a value). The cartridge is therefore a productive stream transformer, inputs in and frames out, never stuck, which is why a replay is a proof. Write that sentence into `SPEC.md` §2 as the engine's one theorem. (*math exists*; the writing is a line)
- **Relative references are de Bruijn indices.** `R[-1]C[0]` names a cell by its distance from the binder, as de Bruijn names a variable by its distance from its lambda (*exhibit*: 1972, §9). A shared formula over a range is one closed term applied at every position, and `KERNEL.20`'s vectorization is beta-reduction in bulk (*shelf*: `BETA_ROADMAP.md`, `KERNEL.20`; `CHARTER.md` §4, the frame). Naming the shape as a term is what a compiler to a GPU kernel would want later (§5.5). (*math exists*)
- **The clock calculus.** The one thing Lustre has that the specification lacks is sub-sampled streams, `when` and `current`. A cell that changes every fourth frame is written here as keep-last, and the evaluator cannot see that it is idle three frames in four. Lustre's compiler knows statically which cells are inactive at an instant. Adopt that analysis as the theory behind dirty regions (`ENGINE.6`); it is published, and it is the typed answer to when a cell changes. (*math exists*)
- **Own the transcendentals.** Rule 5 admits the native runner may differ from the module in the last bit of a transcendental function, and Fragments has `SIN` in its replay golden (*shelf*: `SPEC.md` §6 rule 5, Appendix C). Vendor fdlibm's algorithms into the language crate, a few hundred lines and no dependency, so that native and wasm agree bit for bit and the treaty keeps its goldens on both. (*engineering*)

### 2.3 McCarthy, the practical theorist

He would ask one question: can the grid write the grid? Today, no. Every formula is first-order, and `eval` happens once, at build time, in Frazaro's expander (*shelf*: `SPEC.md` §12, an interpreter for a cartridge's procedures is not in this version). Then he would point at the problem he named with Hayes in 1969, the frame problem (*exhibit*, §9). The only way a cell keeps state in the specification is the shape below, a frame axiom written by hand for every fluent and re-evaluated every frame to conclude that nothing happened:

```text
=IF(event, new, Me.last!B5)
```

The logic community's answer was the law of inertia: a value persists unless something writes it. The `write` call implements that law for the host, and nothing lets the program use it.

**The ask, narrowed the same hour: a Write sheet of values.** An effect sheet whose rows are `(cell "<sheet>" "<addr or range>" <value>)` rows in the one notation, read by the host after the step and fed back through `write` before the next. It is Elm's command, and CALLOSUM already says the page is Elm (*shelf*: `web/CALLOSUM.md` §6; *exhibit*: the Elm architecture, §9). It is within `AD-6`, since every pending write is a cell anyone can view; within zero imports, since the host pulls; within determinism, since the writes are a function of the frame; and a write that would cross a rule is refused by name and printed, as `SD-30` wants. What it buys: state as values that cost nothing to keep, events as writes, and the frame problem solved as the host already solves it. Two costs to write down: a value written over a formula cell replaces the formula, as the host's write does, and splits a shared shape, so a cartridge writes values into value sheets and keeps its rules where they are; and derived writes are not logged, since the replay re-derives them. (*recommendation*)

*The correction.* The sitting's first draft, in the session, let the Write sheet carry `(formula ...)` rows too, so that a cartridge could change its own rules as it went, the universal function in the sheet's own terms. Found the same hour, on the shelf: the owner's veto of `GENSYM` carries `eval` with it in its own words, *"`eval` was never proposed and stays off the table by the identical reasoning - runtime-arbitrary-code-execution is the same wall's other, more obvious breach. Kept here, permanently, precisely so a future session doesn't re-propose it without this context"* (*shelf*: `Frazaro/docs/BETA_ROADMAP.md`, the `GENSYM` entry). A formula computed at run time and installed is that breach, and the rows it would write are code. The ask is therefore values only, which are data, the same kind of write the host makes eighteen times a frame into the Input sheet, and the formula half is not proposed. A cartridge whose structure must change with play keeps its rules fixed and its values moving, as every cartridge in `SPEC.md` does.

### 2.4 Graham, the industry voice

He would grant that the Blub argument runs both ways (*exhibit*: "Beating the Averages", 2001, §9). The spreadsheet crowd does not know it is missing a step function and macros; the game crowd does not know it is missing a dependency graph and reflection; each is sold the other's thing. Then four hard questions.

- **What does a visitor see in ten seconds?** PICO-8 won on immediacy, and `SD-33` already says no blank page. The engine's equivalent is `AD-6`: a game running and a cell edited while it runs. Life with the rule's `3` in a cell a visitor changes to `4` is the demo. Ship it on a static page before any crate publishes. (*recommendation*)
- **Measure the succinctness claim.** An order of magnitude is a prediction and should be written before `CART.4` lands (*exhibit*: "Succinctness is Power", 2002). The sitting's own, 2026-10-08 (*prediction*): the plumbing goes to zero lines, the logic shrinks three to five times, and ten times only where a macro is domain-specific; the count is Stacker in VLA against a PICO-8 Stacker clone in Lua, lines of each.
- **The `GENSYM` veto is the one place the house cut against Lisp.** Much of *On Lisp* is macros that introduce hidden temporaries (*exhibit*, 1993). The owner's reason stands as written: determinism, and a name with a trace to something a person wrote. The sitting notes, and does not propose, that the house already has a rule for generated names, deterministic, derivable, injective, under a reserved prefix (*shelf*: the Frazaro memory on generated names), and that a name a macro derives from its own name and the row the caller supplied, `env.8.age`, has exactly that trace and that determinism, since the row is an argument the caller wrote (*shelf*: `SPEC.md` Appendix C, one argument a line). Whether that is a gensym or a naming convention is the owner's reading to make, by the veto's own reasons and not Graham's. (*recommendation*: none; a note)
- **Who pays?** A crowd the charter has not named. The frame model is Simulink's: the unit delay block is the twin, a block diagram is a sheet, and controls engineers already live in Excel and Simulink both (*exhibit*, §9). They would read Fragments as a patch they recognize (§5.4).

## 3. The course corrections, ranked, and what stands

*Each a* recommendation *for a `SPEC.2`, unadjudicated; the three the sitting would decide before `ENGINE.1` starts are the first, the second and the fourth, since they change what the first cartridges look like.*

1. **The grid writes the grid, in values, and smart recalculation is designed in.** The state model has a cost and a power problem. The cost has a known answer, a cell dirty only when an input changed, with a twin edge counted as changed only when its cell changed at the last step; that is the spreadsheet's own machinery since the 1980s and belongs in `KERNEL.7`'s design even if a measurement switches it on (`ENGINE.6`, `AD-3`'s spirit). The power has no answer in the specification: §2.3's Write sheet of values. It changes how every cartridge is written, so it is decided now even if built after `CART.1`. The owner's stacking game is the case: with it the tower is seven values written on a freeze; without it the tower is a formula per cell per frame, and an unbounded tower is a cost that grows with height for a game of one button (§4).
2. **One model, two renderers, not two modes.** The specification copies the split of 1981, graphics or text (*shelf*: `SPEC.md` §1), which is what consoles spent the next decade escaping with tile and sprite layers (*exhibit*: the Famicom of 1983, §9). Unify at the model: a sheet has values and a declared map from value to look. The Palette is that map for the plane; a `style` row keyed by value is that map for the grid. `SD-32` holds, since the map is declared and only the value changes, and "fills that change per frame" leaves §12 of the specification. The stacking game needs this on day one: big coloured blocks and a score in text on one sheet. (*engineering*)
3. **State the gather cost, and answer it with projections.** "A sprite is a range" is true and incomplete (*shelf*: `SPEC.md` §1, §3.1). Compositing by formula means every Screen cell asks every sprite where it is, and a camera by `INDEX` spends the whole budget on scrolling (*derived*, at 30 frames a second against §3 of the charter, which gives a frame about 66,000 evaluations):

   | drawn by formula | evaluations a frame | against the frame's budget |
   |---|---|---|
   | 50 sprites over 64,000 cells | 3,200,000 | fifty times it |
   | a camera over 64,000 cells | 64,000 | all of it |

   Varvara keeps a sprite port for exactly this reason, and PICO-8's `camera()` is one call because the offset is applied at the draw and not per pixel (*exhibits*, §9). Both fixes are pure projections, so `AD-4` puts them in the language crate and the plane stays golden. The camera is a cell the host reads after the step and passes as the view call's window, which the call already takes (*shelf*: `SPEC.md` §4.5). The composite is the plane of a Screen plus a Sprites sheet of rows, each a source range at a position, drawn in order with blank transparent (§2.1), at the cost of the sprites' cells and not the screen's. (*engineering*)
4. **Rate zero.** "A spreadsheet is a game whose frame rate is one" is the slogan (*shelf*: `CHARTER.md` §1); the truth is rate zero, a step on every write, which is what the Frazaro page's debounced rebuild already is (*shelf*: `REARVIEW.md`, the fan-out table). Allow `(rate 0)` in the manifest. Then Frazaro is a cartridge with no special case, the Clock's frame number is the edit count, the replay is the undo history, `SD-22`'s source apart from the changes is the cartridge apart from its replay, and step back is undo. (*engineering*)
5. **A fourth benchmark that is a model, not a game.** The §6 hypothesis of the charter has a workload mismatch the charter half-sees in its own "why it might be false". Life is dense, uniform and full-sweep; a financial model is sparse, irregular and incremental. A hacker who makes Life fast with SIMD, one instruction over many cells, has not made a single-cell edit in a hundred-thousand-formula model fast. Sand tests the graph, which is closer. The honest instrument is the study's own fixture as a cartridge: `frazaro reflect find_a.xlsx`, a manifest in front of the rows, one input driven from the Clock (*shelf*: `SPEC.md` §7.4, the thesis as a command line; `Frazaro/scripts/study/`). Then transfer is measured and not inferred. (*recommendation*; `~days` once the loop exists)
6. **Limits in formula cells, not only in Screen size.** 320 by 200 is a draw limit and should say so. The compute limit is formula cells a frame, which `load` can count after the fills. A seven-wide stacking game and Life are the same budget class under one and not the other. (*recommendation*)
7. **The transcendentals and the derived names**, as §2.2 and §2.4 have them.

**What stands**, because the reading above vindicates it and the sitting would not reopen it: zero imports; the twin sheet over a function; the cell as the unit; one file with every directive required; the volatile functions refused; the budget in cells; the replay as the oracle; the canvas; the three crates and the one-way arrow (*shelf*: `SPEC.md` §11, decisions 1 to 3, 7, 11 and 12; `CHARTER.md` §4, §7).

## 4. The stacking game in cells, and what cell-oriented programming looks like

The owner's aside, 2026-10-08: the stacking game played with massive cells as the blocks, so the grid is seven cells wide by however tall the tower grows, unbounded, with varying challenges along the way, a build that is not the cabinet's. In the specification plus the corrections above: the Screen is a window the host views over a Tower sheet, placed by a Camera cell; the Tower holds values only; a Levels sheet is the difficulty curve as a table; the State sheet is as `CART.4`'s scoping has it (*shelf*: `ROADMAP.md`, `CART.4`).

```text
; freeze, a name:            =AND(Input!B5 = 1, Input.last!B5 = 0)
; State!B2, the row:         =IF(freeze, State.last!B2 + 1, State.last!B2)
; State!B3, the slider:      =MOD(State.last!B3 + State.last!B4 * tick, 7)
; Camera!B1, read by host:   =MAX(1, State!B2 - 12)
; Write!B2, one of seven:    =IF(AND(freeze, lit1), "A" & State!B2, "")    with Write!A2 = Tower, Write!C2 = 1
; Tower:  values, 0 or 1, written on a freeze; no formula anywhere in it, so height costs nothing
; Levels: a row a height band: width, period, drift, fog; the cabinet's operator menu made public
; a style row maps value 1 on Tower to a lit fill; the score is a text cell above the window
```

Without correction 1 the tower is a formula per cell per frame and the unbounded part is a cost that grows with height. Without correction 2 the score cannot share a sheet with the blocks. Without correction 3 the window is fifteen rows of `INDEX` every frame. The "varying challenges" are the Levels table, and `CART.4`'s claim against the cabinet generalizes: the whole difficulty curve is a sheet anyone reads and forks. (*engineering* throughout)

**Against PyGame.** The owner's comparison: PyGame democratized game development by abstracting complexity away, and VLA's macros may abstract it away by an order of magnitude more. What cell-oriented programming looks like to someone who knows PyGame (*exhibit*: pygame.org, the init, loop, event, clock and flip shape, §9):

| PyGame | Alonzo |
|---|---|
| `init`, the loop, the event pump, `Clock.tick`, `flip` | nothing; the host is the loop and the cells are the screen |
| a `Sprite` class with `update` and `draw` | a row of an Entities sheet, x, y, vx, vy, frame; one `(entity ...)` macro call |
| `Rect.colliderect` | a comparison of four cells |
| `Surface.blit` at an offset | a row of the Sprites sheet (§3, correction 3), or a range fill |
| `pygame.time.get_ticks()` | the Clock's frame cell |
| `random.seed`, `random.random` | the Clock's seed cell and the dice cell |
| save and load, written by hand | a save is a cartridge (*shelf*: `SPEC.md` §7.5) |
| a replay system, written by hand | the Input log (*shelf*: `SPEC.md` §7.6) |
| a debugger | `view` of any sheet while it runs, the twins included (`AD-6`) |

The right column is why the hunch is right about plumbing and half right about logic. Macros erase whole classes of boilerplate, the loop, the entity lifecycle, the save system, the replay, because those are the host's and the frame's and were never the game's. They do not shrink a game's rules, which are formulas either way. The claim that survives is large and measurable: §2.4's prediction, three to five times on the whole and zero lines of plumbing.

## 5. What each crowd gets, and the far horizon

*The sitting's pitch to each, as* recommendations.

### 5.1 The web crowd

A sandbox verified on the artifact: an import section of zero entries means a cartridge cannot phone home, and anyone can check the section rather than trust the page (*shelf*: `CHARTER.md` §2; `tools/check_host_imports.ps1`). One text file that gists, diffs and forks. A host in a few hundred lines of plain JavaScript, so a port is a weekend, which is uxn's lesson (*shelf*: `CHARTER.md` §5). The ask: state the host's size as a limit in `SPEC.md` §10, so that a port knows what it is signing up for.

### 5.2 The gaming crowd

Determinism by construction gives replays, speedrun verification and tool-assisted play for free (*shelf*: `SPEC.md` §6 rule 4, Doom's demo contract), and a seed plus an input log fits in a link's hash, so proof of play is a URL with no server and no call, `SD-13` intact. `AD-6` is a cheat engine and a mod loader built in: every game is open while it runs. The honest gaps: sprites and scroll until correction 3, four chip-tune voices until the patch sheet (*shelf*: `SPEC.md` §12).

### 5.3 The spreadsheet crowd

The one the specification underwrites least, and it may be the largest. A monthly model is a frame loop unrolled in space, one column a month. Rolled up in time it is one column of formulas stepped twelve times, and the corkscrew, opening balance equals last closing balance, is one twin reference, `=Balance.last!B5`. The audit is per formula instead of per cell; the saves are the period-end snapshots; the replay is every assumption ever entered. A projection that shows frames as columns gives the analyst the familiar sheet back, and it is a pure function of the replay, so it is the language's by `AD-4` and the projections seam takes it (*shelf*: `BETA_ROADMAP.md`, `KERNEL.12`). A Monte Carlo is the same cartridge under ten thousand seeds, run headless by the native runner, the distribution printed as a sheet and checkable by anyone with the seed list; no spreadsheet does that deterministically, and it is a sharper answer to CALLOSUM's wall question than enumeration (*shelf*: `web/CALLOSUM.md` §5, the wall question). The one honesty: a rolled model is causal, so a formula that reads the future, a payback period over the whole horizon, is a projection over the replay and not a cell. (*engineering* throughout; the frames-as-columns projection is `~days` once the loop exists)

### 5.4 A crowd the charter has not named

Controls engineers, for whom this is Simulink with cells and SCADE with a formula bar (§2.2, §2.4), and Fragments is the demo they would recognize (*shelf*: `SPEC.md` Appendix C).

### 5.5 The far horizon

*Fiction until measured.* A shared formula in R1C1 is a kernel (§2.2). A host can read the shapes through `describe`, compile them to WebGPU's shading language, run them on the GPU and write the results back through `write`, with the module's naive frames as the reference it must equal, which keeps zero imports and keeps the engine the oracle. It is where the charter's 120 million cells a second would come from (*shelf*: `CHARTER.md` §3), nearer than a decade if the shapes are named as terms now, and it is the reason §6's fourth speed advantage is written as a pass over terms and not as a library.

## 6. Linear algebra, first class

*The owner's fourth question, and the one the file is named for. Alonzo began as a linear algebra visualizer, which the owner took to be the next leap in spreadsheets if mathematical optimization were built in and democratized through natural language. The question: could the engine carry extensive linear algebra, to optimize its transforms and to give the spreadsheet constraint satisfaction? The answer is yes, and more cheaply than the question assumes, because the engine as specified is already an iterative linear solver that nobody had named.*

**What the house already holds.** `OPTIMIZE` is answer-set programming over cells, grounded through DATALOG's fixpoint: the discrete half of optimization, shipped (*shelf*: `Frazaro/docs/OPTIMIZATION.md`; `VLA_Optimize.bas`). `GOAL` is one-dimensional bisection over a monotone formula, with `OPTIMIZE` when the unknowns are whole numbers (*shelf*: `Frazaro/docs/SINGULARITY.md`, 5.2). CALLOSUM's second tectonic move is multi-way constraints, a spreadsheet one can tell the answer, with Sketchpad, ThingLab and Cassowary on its shelf and `OPTIMIZE` named as the solver substrate; its wall question is sensitivity and Monte Carlo (*shelf*: `web/CALLOSUM.md` §5). `KERNEL.7` computes the fifteen functions three in four spreadsheets use and labels the rest `not computed here`; `KERNEL.8` adds lookups and spills (*shelf*: `BETA_ROADMAP.md`). Nowhere in either roadmap is a matrix function, a derivative or a continuous solver. This is a new line with three neighbours waiting for it, not an extension of one.

### 6.1 The frame is already an iterative solver

The two classical iterative methods for a linear system are the charter's two special cases of the frame (*shelf*: `CHARTER.md` §4, the frame). Jacobi's method reads only the last iteration, which is the synchronous frame. The Gauss-Seidel method reads this iteration's earlier cells and the last iteration's later ones, which is the scan-order frame (*exhibits*: Jacobi 1845, Seidel 1874, §9). Both are one row of a cartridge, and the rate cell is the iteration rate:

```text
; heat, one Jacobi sweep a frame: the mean of four neighbours in the last frame
(formula "Screen" "B2:LG199" "=0.25*(Screen.last!A2+Screen.last!C2+Screen.last!B1+Screen.last!B3)")
; the same solve as Gauss-Seidel: left and above from this frame, right and below from the last
(formula "Screen" "B2:LG199" "=0.25*(A2+Screen.last!C2+B1+Screen.last!B3)")
```

The second is a chain through the intra-frame graph, as Sand's is, so it tests the real machinery, and unlike Sand it is linear. Power iteration converges to an eigenvector a frame at a time. Gradient descent is each parameter reading its own twin and a gradient cell. A simplex tableau pivots once a frame. Every method of a numerical analysis course is a formula of the last frame, and the rate is the iteration rate, so a cartridge that declares a rate of 600 and is drawn at 60 runs ten sweeps a draw (*shelf*: `SPEC.md` §5, the accumulator). The visualizer the owner began with is not lost. It is the engine's native genre, and it costs nothing beyond `KERNEL.7`'s arithmetic and `SUMPRODUCT`. (*math exists*, every method; *engineering*, the cartridges)

### 6.2 Transforms are six cells

A 2D affine transform is a 2 by 3 range. Composition is `MMULT` of two ranges. A scene graph is a sheet where each row's transform is the product of its parent's and its own, which the intra-frame graph evaluates in order. The compositor projection of §3, correction 3, takes a Sprites sheet with those six cells per row and places each source cell by them, nearest neighbour, in cells, so that the plane stays the oracle. The host may draw through the canvas's own transform as an accelerator, measured and held equal to the projection, which is rule 3 renting what the draw call already does (*shelf*: `CHARTER.md` §4 rule 3). A 3D rasterizer is the same projection with triangles and the gather problem of correction 3, *fiction* for this decade; 2D affine is *engineering*.

### 6.3 Physics and constraints are one solver

This is the part that makes the owner's intuition exactly right rather than roughly right. A rigid-body engine's contact solve is a linear complementarity problem, and the method every 2D engine uses, Catto's sequential impulses in Box2D, is Gauss-Seidel over the contact constraints (*exhibits*: Catto 2006; Cottle, Pang and Stone 1992, §9). Cassowary, the solver CALLOSUM already names and the one inside Apple's Auto Layout, is an incremental simplex over linear constraints (*exhibit*: Badros, Borning and Stuckey 2001, §9). An LP solver for "minimize cost subject to" is the same simplex. So the crates not overlapping in a game, the layout of a screen, the revolver that must not exceed its facility, and the production plan that meets demand are one algorithm family over cells. (*math exists* throughout)

### 6.4 The Jacobian is the one projection that serves all four

The dependency graph the reader already walks is a computational graph. Give every function of the subset a derivative rule, a table and therefore data, and the chain rule over the graph yields the Jacobian of any cell against any inputs, forward or reverse mode, as a pure function of the model: automatic differentiation, Wengert 1964 (*exhibit*, §9), on `AD-4`'s golden side. One projection, printed in the house's relation shape, pays into four things:

- **Sensitivity**, the wall question answered exactly: the gradient row is the tornado chart without enumeration.
- **Goal seek in many variables**: Newton's method, each step a linearize-and-solve and each step a frame one can watch; `GOAL` grows from bisection to the real thing.
- **The constraint Jacobian** for contacts (§6.3) and for Cassowary, which is the same matrix a physics step needs.
- **The spectrum**: a linear frame is a matrix, and its dominant eigenvalue says whether a feedback loop in a model explodes, decays or oscillates. Interest funded by a revolver that funds interest is the circular reference modelers fear in Excel; here it is a twin edge with a number beside it. That is an auditor's tool nobody has, and it is where the visualizer origin and the third gear meet (*shelf*: `Frazaro/docs/SINGULARITY.md`).

```text
(partial "Model!D9" "Model!B2" 0.35)      ; the Jacobian as rows: dProfit/dPrice, one row a nonzero
(coef "Screen!B2" "Screen.last!A2" 0.25)  ; a linear frame as rows: the matrix the step multiplies by
```

(*math exists*, the differentiation; *engineering*, the table and the pass; `~weeks`)

### 6.5 The fourth speed advantage

CALLOSUM names three structural advantages over Excel's engine: one sentence evaluates as a vector, nothing unchanged recomputes, identical shapes are computed once by content address (*shelf*: `web/CALLOSUM.md` §12.6). Linear algebra adds a fourth that is specific to it. A static pass can tell which formulas are linear in their inputs, and a linear region of a frame is one sparse matrix-vector multiply, among the most optimized kernels in computing, with no interpreter in the loop. A financial model's roll-forward is linear in its state, so most of a model is that region. *Prediction*, 2026-10-08, for the fluid cartridge of §7 to test: a linear frame compiled to a stencil runs at tens of millions of cells a second in single-threaded wasm, an order of magnitude over the two-million floor. The charter's 1080p number stays a GPU's job (§5.5).

### 6.6 The junction with what exists

`OPTIMIZE`'s search plus an LP relaxation per node is branch and bound (*exhibit*: Land and Doig 1960, §9), which is every mixed-integer solver. A clause learner plus a simplex theory is DPLL(T) with linear arithmetic, which is Z3's shape (*exhibits*: Dutertre and de Moura 2006; de Moura and Bjørner 2008, §9). In one line, the moon is that `OPTIMIZE` becomes an SMT solver whose theory is linear arithmetic over cells. Nothing in it needs the world to change. (*math exists*)

## 7. The ladder, the cracks, the sentences, and the mud

**The mud and the moon.** The owner's question: isn't shooting for the moon how meaningful discoveries are made, and why play in the mud? Moonshots that landed had a ladder of instruments, each paying for itself, and the charter's own rule is the instrument before the operation (*shelf*: `ROADMAP.md`, the order and why). Life and Sand are not the mud. They are Mercury and Gemini: the floor and the graph, without which no accelerator can be held to a reference and the hypothesis cannot be counted. What the moon should decide is which rungs come next, so that every rung points at it. (*recommendation*)

| rung | what it is | what it pays | mark, size |
|---|---|---|---|
| 1 | `SUMPRODUCT`, `MMULT`, `TRANSPOSE` in the language's subset, with the summation order stated | a matrix is a range; transforms and scene graphs | engineering, `~days` |
| 2 | the numerical cartridges: heat, power iteration, descent, a pivot a frame | the visualizer reborn; the engine's second demo, the one the Essence of Linear Algebra crowd shares (*exhibit*, §9) | engineering, `~days` |
| 3 | a fluid cartridge, Stam's method of 2003, a Gauss-Seidel pressure solve, after Sand (*exhibit*, §9) | the first linear game; the first accelerator a stranger writes for love is a stencil path that transfers to every linear model | engineering, `~weeks` |
| 4 | the derivative table and the Jacobian projection | sensitivity, Newton `GOAL`, the spectrum | math exists, `~weeks` |
| 5 | the linear-region pass and its compiled step, behind the naive reference | the fourth speed advantage, measured on rung 3 | engineering, `~weeks` |
| 6 | an LP solver in pure Rust inside the language crate, held to the cell tableau of rung 2 | `OPTIMIZE`'s continuous half, then the MILP junction | engineering, `~quarter` |
| 7 | contacts as a complementarity problem over rung 6's machinery | a physics cartridge; the falling-block game's successor | math exists, `~weeks` |
| 8 | Cassowary-shaped multi-way constraints as sentences | CALLOSUM's move 2, type either cell | math exists, `~quarter` |

*The sizes are predictions in the house's units until a closed item records what one cost.*

**Three cracks the line opens**, each a decision rather than a risk:

1. **Floating point and the bit-exact golden.** An accelerator that reorders a sum changes the last bit, and rule 7 is cell for cell. The rule that keeps both: parallelize across cells, never within one. SIMD over many cells keeps each cell's operation order; a SIMD reduction inside one `SUM` does not. Iterative methods need no tolerance, since the golden is the state after n frames. A direct method such as `MINVERSE` is a function with its algorithm written in the specification, so its bits are the specification's. Excel's own `MINVERSE` will not match those bits, and Excel's arithmetic is documented to keep fifteen significant digits and to round results very close to zero (*exhibit*: Microsoft's floating-point page, §9), so even a `SUM` may differ from a cached value in the last place. The policy has to be written before `KERNEL.7`'s oracle, which compares computed values against Excel's cached ones: the language's own functions carry no tolerance, and the Excel library's agreement with cached values carries a stated one. Linear algebra only makes that decision urgent. (*recommendation*)
2. **Which crate.** The engine depends on the language crate and nothing else (`AD-5`), so for a game to have a matrix, the matrix and derivative primitives must be the language's, pure and golden-able (`AD-4`). Excel's names and tolerances stay in the core's library and map onto them through the registry seam. That line is drawn before rung 1, and it is the owner's. (*recommendation*)
3. **The cost of rung 6.** The house keeps zero dependencies. A simplex with bounds in pure Rust is a few thousand lines (*prediction*), written in-house or vendored under the house's own name, and it is the one rung that is not a weekend. Rungs 1 to 5 are small and spectacular; rung 6 is the price of the continuous half, and it is paid once.

**What the door says**, since Frazaro is the compiler (*shelf*: `SPEC.md` §7.4) and the democratization the owner means is the sentence:

```text
Let the transform of Ship be a rotation by Heading about its centre, then a move to Position.
Diffuse Heat into its neighbours at a rate of 0.1 each frame.
Solve for Price so that Profit is 100,000.
Which inputs move Profit most?
Minimize Cost, keeping every Demand met and no Line over its Capacity.
Keep the Crates from overlapping and the Ship inside the Screen.
```

The first two are rows. The third is Newton over rung 4. The fourth is the gradient row. The fifth is rung 6. The sixth is rung 7 in a game and rung 8 in a layout, and they are the same solver. A cell has always been a one-way function. The Jacobian makes it two-way locally and the simplex makes it two-way globally for the linear case, and "tell the sheet the answer and it finds the inputs" is the sentence spreadsheets should have accepted from the start. (*recommendation*; the sentences are shapes and not grammar, written here first so that no mechanism below precedes the sentence that needs it, `SD-7` as `CHARTER.md` §8 cites it for the physics engine)

**The one change the sitting would make in the roadmap today:** the second game repository after Sand, so that the first accelerator a stranger writes for love is a linear one (rung 3). (*recommendation*)

## 8. What this document hands to each file

*Nothing here is an item; this is where each idea would go if the owner picks it up.*

- **To `SPEC.2`, when one is wanted:** §3's corrections 1 to 4 and 6; §2.1's transparent blank and step back; §2.2's theorem sentence; §6.2's Sprites rows with six cells of transform; and the Write sheet of values, with the `eval` correction beside it so that the formula half is never re-proposed. *`SPEC.2` was minted and built from this list the same evening, 2026-10-08, at the owner's word: corrections 1 to 4 and 6, the theorem sentence, the Camera and the Write sheet of values, one write per cell and the limits restated, as `SPEC.md` version 2, approved by the owner the same evening with `AD-7` adopted and the charter amended first; the transparent blank, the composite and the Sprites rows wait for a version 3.*
- **To `ROADMAP.md`:** candidates only, minted at the owner's call: under `CART`, the fluid cartridge (rung 3) and the numerical cartridges (rung 2); under `ENGINE`, the frames-as-columns projection (§5.3) and the model-as-cartridge benchmark (§3, correction 5).
- **To Frazaro's roadmap, by the department that owns each:** rung 1 to `KERNEL.7` or `KERNEL.8`'s function slices; the floating-point policy to `KERNEL.7`'s oracle, before it is written; rung 4 to the third gear beside `GOAL`; rungs 6 and 8 to `OPTIMIZE` and CALLOSUM's move 2. The derived-name note of §2.4 stays here; nothing goes to the `GENSYM` entry.
- **To `CHARTER.md`:** made 2026-10-08 at `SPEC.2`'s approval, the owner's amendment: `AD-7` as the seventh rule of §4, and the pointer to this file from §8, what is not built.
- **To the memory:** the owner's thesis sentence of §1, and that every recommendation here is unadjudicated.

## 9. Sources for the outside facts

- Peirce, C. S., "On a New List of Categories", *Proceedings of the American Academy of Arts and Sciences* 7, 1867, and the Syllabus of 1903 (the icon, index and symbol); "Prolegomena to an Apology for Pragmaticism", *The Monist* 16, 1906 (the sheet of assertion, the tinctures and the book of sheets; "all necessary reasoning without exception is diagrammatic").
- Caspi, P., Pilaud, D., Halbwachs, N. and Plaice, J., "LUSTRE: A declarative language for programming synchronous systems", POPL 1987; Halbwachs, N., Caspi, P., Raymond, P. and Pilaud, D., "The synchronous data flow programming language LUSTRE", *Proceedings of the IEEE* 79(9), 1991 (`pre`, `->`, `when`, `current`; the causality check). SCADE, Ansys (formerly Esterel Technologies), used for Airbus flight-control software by the vendor's own account. https://www.ansys.com/products/embedded-software/ansys-scade-suite
- de Bruijn, N. G., "Lambda calculus notation with nameless dummies", *Indagationes Mathematicae* 34, 1972.
- Church, A., "An Unsolvable Problem of Elementary Number Theory", *American Journal of Mathematics* 58, 1936; "A Formulation of the Simple Theory of Types", *Journal of Symbolic Logic* 5, 1940.
- McCarthy, J. and Hayes, P. J., "Some Philosophical Problems from the Standpoint of Artificial Intelligence", *Machine Intelligence* 4, 1969 (the frame problem named). McCarthy, J., "Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I", *Communications of the ACM* 3(4), 1960 (`eval`).
- The Elm Architecture: Czaplicki, E., the Elm guide, the model, the update and the command. https://guide.elm-lang.org/architecture/
- Graham, P., "Beating the Averages", 2001; "Succinctness is Power", 2002; "The Hundred-Year Language", 2003; "Do Things that Don't Scale", 2013; *On Lisp*, Prentice Hall, 1993. https://paulgraham.com/articles.html
- MathWorks, Simulink, the Unit Delay block (`1/z`). https://www.mathworks.com/help/simulink/slref/unitdelay.html
- Nintendo's Famicom of 1983 and its picture processor: background tiles and sprites as separate layers (Wikipedia, "Picture Processing Unit").
- Varvara's Screen device and its sprite port; PICO-8's `camera()`: as `SPEC.md` §14 cites them. https://wiki.xxiivv.com/site/varvara.html https://www.lexaloffle.com/dl/docs/pico-8_manual.html
- pygame, the library and its documentation: `pygame.init`, the event loop, `Clock.tick`, `Surface.blit`, `display.flip`, the `Sprite` class. https://www.pygame.org/docs/
- Jacobi, C. G. J., "Ueber eine neue Auflösungsart der bei der Methode der kleinsten Quadrate vorkommenden lineären Gleichungen", *Astronomische Nachrichten* 22, 1845. Seidel, L., "Über ein Verfahren, die Gleichungen, auf welche die Methode der kleinsten Quadrate führt, sowie lineäre Gleichungen überhaupt, durch successive Annäherung aufzulösen", *Abhandlungen der Bayerischen Akademie der Wissenschaften* 11, 1874.
- Catto, E., "Fast and Simple Physics using Sequential Impulses", Game Developers Conference, 2006; Box2D. https://box2d.org/ Cottle, R. W., Pang, J.-S. and Stone, R. E., *The Linear Complementarity Problem*, Academic Press, 1992.
- Badros, G. J., Borning, A. and Stuckey, P. J., "The Cassowary Linear Arithmetic Constraint Solving Algorithm", *ACM Transactions on Computer-Human Interaction* 8(4), 2001; Apple's Auto Layout is built on it, by Apple's own account.
- Stam, J., "Real-Time Fluid Dynamics for Games", Game Developers Conference, 2003 (diffuse, advect, project; the Gauss-Seidel relaxation in `lin_solve`).
- Wengert, R. E., "A simple automatic derivative evaluation program", *Communications of the ACM* 7(8), 1964. Griewank, A. and Walther, A., *Evaluating Derivatives*, SIAM, second edition, 2008.
- Land, A. H. and Doig, A. G., "An automatic method of solving discrete programming problems", *Econometrica* 28(3), 1960 (branch and bound).
- Dutertre, B. and de Moura, L., "A Fast Linear-Arithmetic Solver for DPLL(T)", CAV 2006. de Moura, L. and Bjørner, N., "Z3: An Efficient SMT Solver", TACAS 2008.
- Microsoft, "Floating-point arithmetic may give inaccurate results in Excel": fifteen significant digits, and the rounding of results very close to zero. https://learn.microsoft.com/en-us/office/troubleshoot/excel/floating-point-arithmetic-inaccurate-result
- Sanderson, G., "Essence of linear algebra", 3Blue1Brown, 2016, the audience rung 2 names. https://www.3blue1brown.com/topics/linear-algebra
- Sketchpad (Sutherland, 1963), ThingLab (Borning, 1979), Hyvönen and De Pascale (1996): as `web/CALLOSUM.md` §11 cites them.
- In this repository: `CHARTER.md` §1 to §8; `SPEC.md` §1 to §7, §10 to §12, Appendices A to C; `ROADMAP.md`, `AD-1` to `AD-6`, `CART.4`, `ENGINE.6`; `REARVIEW.md`, the sittings of 2026-10-08. In the Frazaro repository: `docs/BETA_ROADMAP.md` (`KERNEL.7`, `KERNEL.8`, `KERNEL.12`, `KERNEL.20`, the `GENSYM` entry, `OPTIMIZE`), `docs/SINGULARITY.md` (Stage 5), `docs/OPTIMIZATION.md`, `web/CALLOSUM.md` §5, §6, §12.6, `conformance/README.md`, `scripts/study/`.
