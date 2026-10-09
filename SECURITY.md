# SECURITY.md

*A place a report can land, and a stated commitment, before the engine runs
anyone's cartridge but its own. The threat model is written the day it does
(`ROADMAP.md`, `CART.2`), not here.*

## Reporting a vulnerability

**Contact: `english@spreadsheet.company`.** Do not open a public issue for
a vulnerability.

Please include the commit hash or the version you are running, the browser
if the issue is in the page, and the smallest cartridge or the smallest
input that reproduces it.

## Response commitment

We will acknowledge a report within three business days. We do not commit
to a fixed remediation timeline, since severity and complexity vary and a
promised deadline the project cannot reliably meet is worse than an honest
one. The reporter is kept informed of our assessment and progress until the
issue is resolved, and a critical, actively exploitable issue is
prioritized above all other work the moment it is confirmed.

## What a reviewer checks on the artifact, not on faith

The engine makes no outbound network call, ever: Frazaro's `SD-13` crosses
the road into this repository (`CHARTER.md`, section 8), and a multiplayer
game is fiction here, by file, if it is ever anything. A WebAssembly module
can reach the outside world only through the functions its host hands it,
listed in the module's import section, so the rule is a property of the
file. The check `tools/check_host_imports.ps1` reads that section on every
push and holds it to an allowlist written in the script: one module name,
`alonzo`, and under it the host's functions as `SPEC.md` names them, the
canvas, the audio graph, the input events, the animation frame and the file
picker, and nothing else. A name the list does not hold fails. A forbidden
name fails even if someone lists it: `fetch` first among them, then
`XMLHttpRequest`, `WebSocket` and anything that opens a socket, any WASI
module, and the names generated glue writes. And the section must equal the
list exactly, so a listed function the engine no longer calls fails too.
Today the list is empty and the count is pinned at zero: the empty engine
imports nothing, which Frazaro's `tools/check_core_imports.ps1 -Path <the
wasm>` confirms with the same reading of the same bytes. The host shim that
provides those functions is written by hand and read in review; the engine
takes no generated glue (`AD-5`).

A cartridge is a VLA program and its sheets. The engine reads no VLA and
evaluates no cell itself; every value is the language crate's, which has no
imports at all. What a cartridge can do is therefore what the devices let
it do: draw, sound, read the keys and the mouse, and read a file the person
picked. Nothing else exists to it. And a cartridge's formulas are the ones
it was loaded with: the step computes values and never formulas (`AD-7`),
so a cartridge cannot write code at run time, and the grid writes the grid
only in data, through the Write sheet's values; the test that holds it is
the language crate's, the formula cells equal before and after a step
(`SPEC.md`, section 13).
