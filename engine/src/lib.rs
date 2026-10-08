//! Alonzo: the browser's Lisp machine. A game engine in WebAssembly whose
//! language is VLA, whose scene is VLA's grid, whose devices are sheets, and
//! whose first game is Frazaro, the spreadsheet.
//!
//! The crate is empty on the day of the first commit (`REPO.1`): the
//! repository's `CHARTER.md` is its constitution, `ROADMAP.md` its work, and
//! `REARVIEW.md` its record. What it will hold, in the order the roadmap
//! lays it: the Screen device over the view record (`KERNEL.5`, laid here),
//! the loop (`ENGINE.1`), the frame path (`ENGINE.2`), the Input and Clock
//! devices (`ENGINE.3`), Audio (`ENGINE.4`), File (`ENGINE.5`), and the
//! accelerators, each behind the reference (`ENGINE.6`).
//!
//! Three rules bind every line that lands here. The engine consumes
//! `vla-lang` and never `frazaro-core` (`AD-1`). It has a clock, and the
//! language has none (`AD-4`). Its imports are the host's functions, named
//! by hand as `extern "C"` and held to a list, and it depends on the
//! language crate and nothing else (`AD-5`).
