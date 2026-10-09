//! Alonzo: the browser's Lisp machine. A game engine in WebAssembly whose
//! language is VLA, whose scene is VLA's grid, whose devices are sheets, and
//! whose first game is Frazaro, the spreadsheet.
//!
//! What the crate holds since `ENGINE.1`'s second slice (2026-10-09): the
//! engine's module, the eleven exports of `SPEC.md` section 4.6 (`abi`) over
//! the language's machine, `vla_lang::machine`, with what the engine adds to
//! it (`cartridge`): the manifest read by the language's reader, the device
//! sheets' layouts checked at load and at every write, the engine's own
//! sheets (the Clock, the File, and the Input when a cartridge holds none),
//! the Clock's frame written as the first act of every step, `describe`, and
//! the engine's own refusals, the `cart` family of `data/messages.vla`. The
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

pub mod abi;
pub mod cartridge;
