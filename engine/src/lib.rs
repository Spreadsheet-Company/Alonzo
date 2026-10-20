//! Alonzo: the browser's Lisp machine. A game engine in WebAssembly whose
//! language is VLA, whose scene is VLA's grid, whose devices are sheets, and
//! whose first game is Frazaro, the spreadsheet.
//!
//! What the crate holds since `ENGINE.1`'s second slice (2026-10-09): the
//! engine's module, the eleven exports of `docs/SPEC.md` section 4.6 (`abi`) over
//! the language's machine, `vla_lang::machine`, with what the engine adds to
//! it (`cartridge`): the manifest read by the language's reader, the device
//! sheets' layouts checked at load and at every write, the engine's own
//! sheets (the Clock, the File, and the Input when a cartridge holds none),
//! the Clock's frame written as the first act of every step, `describe`, and
//! the engine's own refusals, the `cart` family of `data/messages.vla`. Since
//! `SPEC.3` (2026-10-10) it holds the pass too (`pass`): a cartridge's source
//! expanded by the language's expander into the rows a load takes, an act of
//! its own that the load never calls, run at the command line by
//! `examples/expand.rs` and in the page by the same function. Its
//! example, `examples/frames.rs`, is the native runner of the frame floors
//! (`CART.1`): Life's soup and the glider gun stepped through `Cartridge`,
//! every frame held to a Life written by hand, timed, and in its check mode
//! the allocations of a frame counted; since `ENGINE.9` each also at four
//! and sixteen times the window's area, built by the pass from its source
//! with a larger board, and the heap's bytes counted beside. The
//! host shim that drives the module is `web/host.js`; what it holds in the
//! order the roadmap lays it: the Screen device over the view record
//! (`KERNEL.5`, laid here), the loop (`ENGINE.1`), the frame path
//! (`ENGINE.2`), the Input and Clock devices (`ENGINE.3`), Audio (`ENGINE.4`),
//! File (`ENGINE.5`), and the accelerators, each behind the reference
//! (`ENGINE.6`).
//!
//! Three rules bind every line that lands here. The engine consumes
//! `vla-lang` and never `frazaro-core` (`AD-1`). It has a clock, and the
//! language has none (`AD-4`). Its imports are the host's functions, named
//! by hand as `extern "C"` and held to a list, and it depends on the
//! language crate and nothing else (`AD-5`): `tools/check_host_imports.ps1`,
//! `tools/check_host_exports.ps1` and `tools/check_engine_deps.ps1` hold the
//! three facts on the artifact and the manifests.
//!
//! # A first step
//!
//! A cartridge is rows in the one notation. The engine loads it, steps it
//! and answers a view of any of its sheets, here the third projection,
//! `values`, the record without its formulas (`vla-lang` 0.9.3). The crate's
//! page, `README.md`, shows the same example.
//!
//! ```
//! use alonzo::cartridge::Cartridge;
//! use vla_lang::machine::Viewed;
//!
//! let text = "(cartridge \"hello\"\n  (spec 3)\n  (title \"Hello\")\n  (rate 30)\n  (screen grid 4 2)\n  (seed 1))\n(sheet \"Screen\" visible)\n(formula \"Screen\" \"A1:D2\" \"=Clock!$B$1*COLUMN()\")\n";
//! let mut cart = Cartridge::load(text, "hello.vla", text.len()).expect("the cartridge loads");
//! assert!(cart.step(0).done, "the first frame, computed whole");
//! let Ok(Viewed::Text(record)) = cart.view("values", "Screen", Some("A1:D1")) else {
//!     panic!("a window of a sheet is a record");
//! };
//! assert!(record.contains("(value \"Screen\" \"D1\" 4)"), "{record}");
//! ```

pub mod abi;
pub mod cartridge;
pub mod pass;

/// Sand by hand (`CART.2`), the reference the engine's tests hold Sand's
/// frames to, compiled for the tests alone; the native runner includes the
/// same file by its path.
#[cfg(test)]
mod sand;

/// Kairos by hand (`CART.4`), the reference the engine's tests hold the
/// stacking game's frames to, compiled for the tests alone.
#[cfg(test)]
mod kairos;

/// Superposition by hand (`CART.12`), the reference the engine's tests hold
/// the large board's frames to, compiled for the tests alone; the native
/// runner and the playtest session include the same file by its path.
#[cfg(test)]
mod superposition;

/// Seiyaku by hand (`CART.14`), the reference the engine's tests hold the
/// puzzle's frames to, with the two solvers, the grader and the generator
/// that write and hold its book, compiled for the tests alone; the book's
/// writer includes the same file by its path.
#[cfg(test)]
mod seiyaku;

/// Naught: Vel et Aut by hand (`CART.9`), the netlists the bench's block and
/// the floors' two fixtures are written from, laid by fill and shuffled,
/// their census counted and their gates evaluated by hand, compiled for the
/// tests alone; the block's writer and the native runner include the same
/// file by its path.
#[cfg(test)]
mod naught;

/// SHA-256 in upper-case hex, the digest a replay names its cartridge by,
/// compiled for the tests alone (`AD-5`); the native runner includes the
/// same file by its path, to name each rung of the size ladder (`ENGINE.9`).
#[cfg(test)]
mod sha256;

/// The size ladder's rungs and the definition that builds a source on one
/// (`ENGINE.9`), compiled for the tests alone; the native runner includes
/// the same file by its path.
#[cfg(test)]
mod ladder;

/// The repository's `cartridges/` beside the crate, read at run time by the
/// tests that need it, each standing down by name where a package has none
/// (`REPO.4`), compiled for the tests alone.
#[cfg(test)]
mod repository;
