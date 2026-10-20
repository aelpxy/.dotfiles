# Rust guidelines

Stable Rust, edition 2024, `rust-version` pinned, Linux first. These rules override the Rust API Guidelines and std conventions.

## Principles

- Simple, explicit code; optimize only with benchmark/profile evidence.
- Smallest correct change; no unrelated refactors, renames, or reformatting.
- Std before deps; a new crate must be worth more than the lines it replaces.
- Make invalid states unrepresentable; parse untrusted input into validated types at the boundary, then trust the type.
- Small single-purpose modules; no `utils`/`common`/`helpers`/`misc`/`types` modules or crates.
- No abstraction without two real callers; no trait with one impl unless the other is a test fake.
- Extract duplicated code on the third copy, not before.

## Layout

- Multi-crate: workspace, `crates/<name>/`, virtual root `Cargo.toml`, `resolver = "3"`.
- Dependencies flow one way: I/O-free core types at the bottom, binaries on top, no cycles.
- `main.rs` is thin: parse args, build config, call the library, map errors to an exit code.
- `lib.rs`/`main.rs`/`mod.rs` only declare modules and re-export; no logic.
- One concern per file, split by entity or responsibility (`deployments.rs`, `transport.rs`), never by kind of code; under ~300 lines incl. tests.
- Split large `impl` blocks across files by concern (`impl Store` per entity module).
- Private serde/wire structs live next to their users.
- `pub(crate)` by default; `pub` only for other crates.

## Style

- `cargo fmt` defaults; clippy clean with `-D warnings`.
- Modern Rust: `let ... else`, `if let` chains, `impl Trait` args/returns, `LazyLock`/`OnceLock`, inline format args, `#[expect]` over `#[allow]`.
- Named constants with units (`CONNECT_TIMEOUT`, `MAX_BODY_BYTES`); `Duration` for durations, never bare integers.
- Imports grouped std / external / crate, blank-line separated; no globs except `use super::*` in tests and preludes.
- No `extern crate`, `#[macro_use]`, mutable globals, or `static mut`; pass dependencies explicitly.

## Naming

- std casing; acronyms are one word (`HttpClient`, `MachineId`).
- No stuttering (`deploy::Request`, not `deploy::DeployRequest`) unless re-exported elsewhere.
- Conversions: `as_` cheap borrow, `to_` expensive/owned, `into_` consumes self.
- Getters without `get_`. Constructors `new`/`with_*`; fallible ones return `Result` and are `new`/`parse`/`try_from`; `new` never panics.
- Booleans are predicates (`is_running`, `has_volume`).
- Short names for short scopes; descriptive for public or long-lived.

## Types

- Newtypes for IDs and validated values (`UserId(Uuid)`, `Port(NonZeroU16)`): private fields, built only via validating constructor/`TryFrom`/`FromStr`; implement only sensible traits (`Display`, `AsRef<str>`), never `Deref` to the inner type.
- Enums for states and choices, never strings, bools, or paired `Option`s: `Source::{Image(Ref), Build(Path)}`.
- `Option`/`NonZero*` over sentinels (`-1`, `0`, `""`); no `Option<bool>` or `Option<Option<T>>`.
- No behavior-changing `bool` params; use an enum or separate functions.
- Derive only what is used, in order: `Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord, Default, Serialize, Deserialize`. Every public type is `Debug`.
- Config structs implement `Default`; tests use `..Default::default()`.
- `#[must_use]` on pure fns, getters, builders; `const fn` where free.
- Parser validation also applies to stored data; tighten rules for new input at the write path, or old data stops loading.

## Numbers and indexing

- No numeric `as`; use `From`/`TryFrom` and decide what overflow means. If a lint can't express it, `#[expect(..., reason = "...")]`.
- Explicit `checked_`/`saturating_`/`wrapping_` wherever overflow is possible.
- No panicking indexing/slicing outside tests: `get`, `split_at_checked`, `first`, iterators, slice patterns.
- No string byte slicing; use `char_indices`, `split_once`, `strip_prefix`.
- Never `==` on floats.

## Control flow

- Early returns (`let ... else`, `?`, guards); happy path unindented; max nesting depth 3.
- Functions do one job, under ~80 lines; split if they need section comments.
- Match own enums exhaustively, no `_` arm (fine for foreign `#[non_exhaustive]`).
- Iterator chains when clear; `for` loops for side effects, stateful early exit, or more than ~4 adapters. No manual `Vec`-building loops that `map`/`filter`/`collect` express.
- No `collect::<Vec<_>>()` only to iterate again, `.iter().count()` on slices, or `.len() == 0`.
- No `return` on the last expression; no `else` after `return`/`break`/`continue`.
- No `std::process::exit` outside `main`, `panic` for control flow, or sleeping to wait (poll with a timeout or wait on a signal).

## Ownership

- Take `&str`, `&[T]`, `&Path`, `impl AsRef<_>`, `impl IntoIterator`; return owned values or `impl Iterator<Item = T> + '_` instead of a `Vec` iterated once.
- Take ownership only to store or move into a task.
- `.clone()`/`.to_string()` only when ownership is genuinely needed, never to appease the borrow checker; `Arc::clone(&x)`.
- `Cow<'_, str>` only on a measured hot path.
- Elide lifetimes; name them meaningfully (`'conn`) when needed.
- No `Rc<RefCell>`/`Arc<Mutex>` webs; restructure ownership or pass messages.
- `Box<dyn Trait>` only for open type sets; generics or enums for closed ones.
- `Box` for unsized/large values, `Arc` across tasks, `Rc` single-threaded only; `Arc<str>`/`Arc<[T]>` over `Arc<String>`/`Arc<Vec<T>>`.
- Interior mutability: `Cell`/`RefCell` single-threaded, `Mutex`/`RwLock`/atomics across threads, `arc-swap` for read-mostly config; never `RefCell` instead of passing `&mut`.

## API design

- At most 4 params; group related ones in a struct.
- Builders only for many optional fields (required ones in `new`, or `build()` returns `Result`); otherwise struct literals + `Default`.
- Generic public params (`impl Into<String>`, `impl AsRef<Path>`) sparingly, one level.
- Multiple or long bounds go in `where`.
- Implement std traits (`From`, `TryFrom`, `FromStr`, `Display`, `AsRef`, `IntoIterator`, `Default`) over ad-hoc methods; never implement `Into`.
- No `impl` blocks of unrelated helpers; no macros where a function works; no defensive checks for states the types rule out.
- Seal traits outside crates must not implement.
- Libraries: `///` on every public item, first line a one-sentence summary; document failure cases on the error enum variants, not per function; doc examples compile and run, no `ignore` without a reason.
- Semver; `cargo semver-checks` before releasing. Don't expose dependency types unless part of the contract (then re-export).
- `#[non_exhaustive]` on public enums, errors, and config structs that may grow; private fields with constructors on anything that may grow.

## Traits and generics

- Traits live where consumed, 1–3 methods; split large ones.
- Associated types for one natural choice per implementor; generic params when implemented many ways.
- Static dispatch by default; `dyn` for heterogeneous collections, plugin points, or compile time/size; keep `dyn` traits object-safe.
- Blanket impls only in the owning crate, only when every `T` qualifies.
- `Send + Sync + 'static` where values cross tasks/threads, never speculatively.
- No generic params that only one type fills.
- Closures: least restrictive bound the call site needs (`FnOnce` if called once).
- `Deref` only for smart pointers and transparent wrappers, never fake inheritance.
- Extension traits (`FooExt`) live in the module using them.

## Patterns

- Typestate (`Conn<Unauthed>` → `Conn<Authed>`) when misuse is a real bug, not for simple flags.
- RAII guards for cleanup so `?` can't leak. `Drop` never panics or blocks; async cleanup uses an explicit `async fn close`, `Drop` only logs if skipped.
- State machines: enum with per-state data, `fn next(self, event) -> Self`, exhaustive match.
- Actors: task owning state, bounded `mpsc` + `oneshot` replies, cloneable handle; not `Arc<Mutex<State>>`.
- Collect into `Result<Vec<_>, _>` to stop on the first error.

## Macros

- `macro_rules!` only for repetition functions can't remove (variadics, impls for many types); `compile_error!` for misuse, fully qualified paths (`$crate::`, `::std::`).
- Proc macros only in a dedicated `-macros` crate with trimmed `syn`/`quote` features, when declarative can't do it.

## Features and cfg

- Features are additive and build in any combination (`cargo hack check --feature-powerset` for libs); minimal defaults in libraries.
- `#[cfg]` on whole items/modules, not inside function bodies.
- `build.rs` only when unavoidable; deterministic, declares `rerun-if-changed`.

## Files, processes, time

- Atomic writes: temp file in the same dir, `sync_all`, `rename`; fsync the dir when durability matters.
- `Path`/`PathBuf` joined with `.join`, never `String`/`format!`.
- `create_dir_all`; explicit perms for secrets (`0o600`).
- `Instant` for elapsed/deadlines; `SystemTime`/time crate for wall clock, stored UTC.
- Subprocesses: `tokio::process::Command`, `kill_on_drop(true)`, explicit stdio, timeout, exit status checked; separate args, never `sh -c` with interpolation.
- Read env vars once at startup into config; never `std::env::var` deep in code.

## CLI and config

- `clap` derive; one `Args` struct per subcommand, own module.
- Config layered defaults → file → env → flags into one validated struct at startup; invalid config fails fast with a clear message.
- Exit codes `0` ok, `1` failure, `2` usage; `main` returns `ExitCode` or `anyhow::Result<()>`.
- Results to stdout, progress/diagnostics to stderr; `--json` for machine output; color only on a TTY and never with `NO_COLOR`.
- Destructive commands confirm unless `-y`; refuse without a TTY.

## Errors

- Libraries: one `thiserror` enum per module/domain, variants named for what the caller can act on; never `anyhow`, `Box<dyn Error>`, or `String` errors. Binaries: `anyhow` + `.context()`/`.with_context()`.
- Never discard errors: no `let _ = fallible()`, `.ok()`, or source-losing `map_err(|_| ...)`. Log or return, not both.
- Dropping a result on purpose is typed and expected: `#[expect(clippy::let_underscore_must_use, reason = "...")] let _: Result<_, _> = tx.send(..);`, the reason saying why it's correct.
- Messages lowercase, no trailing punctuation, say what was being done: `"read config {path}"`.
- Keep the source chain with `#[source]`/`#[from]`; don't format the inner error into the message.
- Inspect via `std::iter::successors(Some(err), |e| e.source())` + `downcast_ref`/`is`, never message strings.
- No `unwrap`/`panic!`/`todo!`/`unimplemented!`/`unreachable!` outside tests; `expect` only for true invariants, with a message saying why.

## Comments

- Avoid; when needed, one line on *why*. No restating code, commented-out code, banners, `TODO` without an issue ref, or doc comments repeating the name.

## Spacing

rustfmt adds no blank lines; code reads in paragraphs.

- Blank line between logical steps (setup, work, result) and around multi-line `if`/`match`/`for`/`loop`/`select!` unless at block start/end.
- A `let` sits directly above its first use when they form one step.
- Blank line before a final expression/`return` that follows statements.
- No blank line after `{` or before `}`; one blank line between items, never two.

```rust
pub async fn start(&self, name: &ServiceName) -> Result<MachineId, StartError> {
    let Some(service) = self.store.service(name).await? else {
        return Err(StartError::NotFound(name.clone()));
    };

    if service.state == State::Running {
        return Err(StartError::AlreadyRunning);
    }

    let spec = MachineSpec::from(&service);
    let id = timeout(START_TIMEOUT, self.podman.create(&spec))
        .await
        .map_err(|_elapsed| StartError::Timeout)??;

    self.store.record_machine(name, &id).await?;
    tracing::info!(service = %name, machine_id = %id, "machine started");

    Ok(id)
}
```

## Unsafe

- `unsafe_code = "deny"` workspace-wide; code that needs it lives in one small module behind a safe API, marked `#[expect(unsafe_code, reason = "...")]`, every block with `// SAFETY:` stating the invariant.
- One unsafe op per block; `unsafe fn` needs a `# Safety` section.
- Miri in CI (`cargo +nightly miri test`).
- Never `transmute`, `mem::forget`, or `static mut`.

## Async and concurrency

- `tokio`, one runtime built in `main`.
- Never block: `tokio::fs`/`spawn_blocking` for file I/O, `spawn_blocking`/a thread for CPU work, no `std::thread::sleep`.
- Timeouts on every network call, subprocess, and external wait; streams also need an idle timeout and size cap.
- Never hold `std::sync` guards across `.await`; keep critical sections short; `tokio::sync::Mutex` only when the lock must span an await.
- Prefer message passing (`mpsc`, `oneshot`, `watch`) or `arc-swap` over locks; channels always bounded.
- Every task has an owner (`JoinSet`/`TaskTracker`), is cancelled via `CancellationToken` on SIGTERM/SIGINT, and awaited; no fire-and-forget spawn; handle `JoinError`.
- Shutdown: one token from `main`, child tokens per subsystem, `TaskTracker` awaited with a deadline.
- Cancel by drop via `select!`; dropping mid-way leaves nothing half-done; document non-cancel-safe futures.
- Request-scoped things (permits, shutdown watches) move into every task that outlives the request.
- Custom `Future`/`Stream`/`Body` stay `Unpin` (box the `Sleep`).

## Logging

- `tracing` with structured fields, not interpolated: `info!(machine_id = %id, "machine started")`.
- Lowercase messages, snake_case fields.
- Transitions `info`, retries `warn`, failures `error`, chatty `debug`/`trace`.
- No `println!`/`eprintln!`/`dbg!` outside CLI output code.
- Never log secrets, tokens, or user data; wrap them in a type with a redacting `Debug`.

## Serde

- `deny_unknown_fields` on config/manifest input; `rename_all = "snake_case"` (or the wire format's) on every type.
- Explicitly tagged enums (`tag = "type"`); no untagged input enums unless unavoidable.
- `skip_serializing_if = "Option::is_none"` over nulls.
- Verify real wire shapes (curl, spec) before writing types; never guess fields.

## Security

- Validate all external input at the boundary: names, paths (reject `..`/absolute where unexpected), URLs, ports, sizes.
- Servers limit body size, header size, and connection count.
- SQL uses bound params only.
- TLS via `rustls`, never OpenSSL.
- Constant-time secret comparison; store only hashes of tokens and passwords.

## Performance

- Measure first (`criterion`/`divan`, `cargo flamegraph`/`perf`); compare against the previous commit before claiming a speedup.
- No needless hot-path allocation: reuse buffers, `with_capacity`, `write!` into existing buffers over `format!`.
- Stream bodies/files (`AsyncRead`/`AsyncWrite`/`Stream`); never buffer unbounded data.
- `Bytes` for shared network buffers; avoid `Vec<u8>` copies between layers.
- Box large enum variants and futures.
- Default `HashMap` hasher unless profiling says otherwise and keys aren't attacker-controlled.
- Release: `lto = "thin"`, `codegen-units = 1`, `panic = "abort"` for binaries that don't need unwinding.

## Dependencies

- Declared once in `[workspace.dependencies]`, used as `dep = { workspace = true }`, `default-features = false` with only needed features.
- Few, widely used, maintained crates; check last release, maintainers, transitive weight.
- No wildcard or git deps in released code; commit `Cargo.lock` for binaries.
- `cargo deny check` (config in `deny.toml`) and `cargo machete` pass.

## Testing

- Unit tests at the bottom of the file in `#[cfg(test)] mod tests`; shared fixtures in `#[cfg(test)] mod testing`.
- Integration tests in `crates/<name>/tests/`, one file per scenario area, via the public API.
- Test behavior from outside (real sockets, `tempfile`), not internals.
- No mocking frameworks; hand-written fakes behind a trait only where the real dependency can't run.
- Regression tests must fail without the fix.
- External-service tests: `#[ignore = "requires <thing>"]`, run in CI with `--include-ignored`.
- Table-driven `(input, expected)` loops with assert messages naming the case.
- `proptest` for parsers and invariants.
- `#[tokio::test]`; `tokio::time::pause` instead of real sleeps.
- `unwrap`/`expect`/indexing allowed in `#[test]` fns; helpers outside use `expect("why it holds")`.

## Lints

- Workspace root `Cargo.toml` includes the block from `lints.toml`; each crate sets `[lints] workspace = true`; copy `clippy.toml` and `deny.toml` alongside.
- Binary-only crates may put `#![expect(clippy::print_stdout, reason = "cli output")]` atop the CLI output module.
- Library crates add `#![warn(missing_docs)]` to `lib.rs`; Cargo rejects per-crate `[lints]` overrides alongside `workspace = true`.
- Never weaken lints, `clippy.toml`, or `-D warnings`; fix the code.
- Suppress only with `#[expect(clippy::x, reason = "...")]` on the smallest item, never `#[allow]`; crate-wide only if the whole crate is the reason; the reason says why the code is correct.
- No `#[allow(dead_code)]` (delete it); no `_`-prefixed names hiding values that should be used.

## Commands

Done only when fmt, clippy, and tests pass; report failures with output.

- `cargo fmt --all` (`--check`)
- `cargo clippy --workspace --all-targets --all-features -- -D warnings`
- `cargo test --workspace --all-features` (or `cargo nextest run`), plus `--include-ignored` when services are available
- `RUSTDOCFLAGS="-D warnings" cargo doc --workspace --no-deps`
- `cargo deny check`, `cargo machete`
- `cargo +nightly miri test -p <crate>`
- `cargo build --release`
