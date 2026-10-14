//! The repository beside the crate, for the tests that hold the engine to
//! its cartridges (`REPO.4`, the owner's second way, approved 2026-10-14). A
//! package is the crate's directory and nothing beside it, so the
//! repository's `cartridges/` travels with a clone and never with the crate.
//! A test that reads a cartridge reads it here, at run time, and never by
//! `include_str!`, which would keep a package's tests from building at all:
//! nine such includes did until this module, and `cargo test` over the
//! package of 0.1.0's first rehearsal failed at every one of them.
//!
//! Without `cartridges/` beside the crate a test that needs it stands down:
//! it says so on standard error, by its own name, and passes, so that `cargo
//! test` over the package runs every test that needs only the crate. Where
//! the repository must be whole, `ALONZO_REQUIRE_CARTRIDGES` set to anything
//! turns a stand-down into a failure: CI's crate job sets it, so no test of
//! the repository's is skipped there unseen, and runs the package's own tests
//! beside it without it. A file missing where `cartridges/` is there is no
//! stand-down but a defect, named by its path. `tools/check_crate_package.ps1`
//! holds every source of the crate to no build-time include outside its
//! directory.

use std::path::PathBuf;

/// The variable that makes a stand-down fail, set where the repository is
/// whole.
pub const REQUIRE: &str = "ALONZO_REQUIRE_CARTRIDGES";

/// The repository's `cartridges/` beside the crate, or `None` once the
/// calling test has stood down, named by its thread, which the test harness
/// names after the test.
pub fn cartridges() -> Option<PathBuf> {
    let dir = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../cartridges");
    if dir.is_dir() {
        return Some(dir);
    }
    let thread = std::thread::current();
    let test = thread.name().unwrap_or("a test");
    assert!(
        std::env::var_os(REQUIRE).is_none(),
        "{test}: no cartridges/ beside the crate, where {REQUIRE} says the repository is whole"
    );
    eprintln!("{test}: stands down, with no cartridges/ beside the crate: the test is the repository's (REPO.4)");
    None
}

/// The text of a file of `cartridges/`, by its path below it, or `None` once
/// the calling test has stood down.
pub fn read(file: &str) -> Option<String> {
    let path = cartridges()?.join(file);
    Some(std::fs::read_to_string(&path).unwrap_or_else(|e| panic!("{}: {e}", path.display())))
}
