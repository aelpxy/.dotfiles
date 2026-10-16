# Go guidelines

Target: Go 1.27, static Linux binaries (`CGO_ENABLED=0`), Alpine (musl) compatible.

## Principles

- Simple, explicit code first; optimize only with evidence (benchmark or profile).
- Smallest correct change; no unrelated refactors, renames, or reformatting.
- Stdlib before dependencies; every new module needs a clear reason.
- Small packages with a single purpose; no `util`, `common`, or `helpers` packages.
- Accept interfaces, return concrete types; define interfaces where they are consumed.
- Keep the zero value useful; avoid constructors that only set defaults.

## Layout

- `cmd/<binary>/main.go` for entrypoints, kept thin.
- `internal/` for everything not meant to be imported externally.
- No `pkg/` directory unless the code is genuinely a public library.

## Style

Follow Effective Go, Go Code Review Comments, and the Google Go Style Guide; rules below take precedence.

- Code must pass `golangci-lint run` with no issues.
- Use modern stdlib: `slices`, `maps`, `min`/`max`, `range` over ints and iterators, `log/slog`.
- Use `any` only when the type is truly unknown; prefer generics or concrete types.
- Generics only when two or more types use the code; no type parameters that only one type fills.
- Named constants over magic numbers and strings; `time.Duration` for all durations.
- Enums as typed constants with `iota`; start at 1 or define an explicit invalid zero value.
- No mutable package-level state and no `init()` with side effects; pass dependencies explicitly.

## Naming

- Short names for short scopes (`i`, `r`, `buf`); descriptive names for exported and long-lived identifiers.
- No stuttering: `container.New`, not `container.NewContainer`.
- Consistent initialisms: `ID`, `URL`, `HTTP`, `PID` (`containerID`, not `containerId`).
- Receiver names are one or two letters and consistent across methods; never `this` or `self`.
- Getters without `Get`: `c.Name()`, not `c.GetName()`.
- Single-method interfaces end in `-er`: `Reader`, `Mounter`.
- Unexported by default; export only what other packages need.

## Comments

- Avoid; when needed, one line on *why*. No restating code, commented-out code, banners, `TODO` without an issue ref, or doc comments repeating the name.

## Control flow

- Early returns and guard clauses; handle errors and edge cases first, keep the happy path left-aligned.
- No `else` after a `return`, `break`, `continue`, or `panic`.
- Maximum nesting depth of three; extract a function instead of nesting deeper.
- Keep functions short and focused on one job; split when a function needs section breaks to be understood.
- No naked returns; use named results only when they document meaning or are needed for `defer`.
- Prefer `switch` over long `if`/`else if` chains.

## API design

- Keep parameter lists short; group related parameters into a struct when there are more than four.
- No boolean flag parameters that change behavior; use separate functions or an options struct.
- Use an options struct for optional configuration; functional options only for public APIs with many options.
- Never store `context.Context` in a struct.
- Choose pointer or value receivers per type and use them consistently.
- Place a mutex directly above the fields it guards.

## Spacing

`gofmt` does not add blank lines; spacing is our responsibility. Code should read in paragraphs, never as a dense wall.

- Separate logical steps inside a function with a blank line (setup, work, result).
- Blank line after every `if err != nil { ... }` block before the next statement.
- Blank line before and after `if`, `for`, `switch`, and `select` blocks, unless at the start or end of the enclosing block.
- Keep `defer` directly below the call it pairs with (`Lock`/`Unlock`, `Open`/`Close`), then a blank line.
- Blank line before a `return` that follows other statements.
- Keep a variable declaration directly above its first use, without a gap, when they form one step.
- No blank line right after an opening `{` or right before a closing `}`.
- Group related struct fields, `const`s, and `var`s; separate groups with a blank line.
- One blank line between top-level declarations; never two.

```go
func (m *Manager) Start(ctx context.Context, name string) error {
    m.mu.Lock()
    defer m.mu.Unlock()

    c, err := m.lookup(name)
    if err != nil {
        return fmt.Errorf("lookup %s: %w", name, err)
    }

    if c.Running() {
        return ErrAlreadyRunning
    }

    if err := c.mountRootfs(); err != nil {
        return fmt.Errorf("mount rootfs: %w", err)
    }

    pid, err := c.spawn(ctx)
    if err != nil {
        return fmt.Errorf("spawn: %w", err)
    }

    m.track(c, pid)

    return nil
}
```

## Errors

- Always handle errors; never discard with `_` unless the reason is obvious.
- Wrap with context: `fmt.Errorf("mount overlay %s: %w", dir, err)`.
- Lowercase error messages, no trailing punctuation.
- Sentinel errors (`var ErrNotFound = errors.New(...)`) or typed errors for conditions callers branch on; check with `errors.Is`/`errors.As`.
- `panic` only for programmer errors, never for runtime failures.
- Either log an error or return it, never both.
- Use `errors.Join` to combine independent errors (e.g. multiple cleanup failures).

## JSON

- Use `encoding/json/v2` and `encoding/json/jsontext`; never import v1 `encoding/json`.
- Stream with `json.MarshalWrite` and `json.UnmarshalRead` instead of `Marshal`/`Unmarshal` into intermediate `[]byte`.
- Use `jsontext.Encoder`/`Decoder` for token-level streaming of large or unbounded payloads.
- Implement `MarshalerTo`/`UnmarshalerFrom` for custom types, not v1-style `MarshalJSON`/`UnmarshalJSON`.
- Prefer `omitzero` over `omitempty`.
- Keep v2's strict defaults (case-sensitive names, duplicate key and invalid UTF-8 rejection); do not relax them without a reason.

## Logging

- Structured logging with `log/slog` only; no `fmt.Println` or `log.Printf` outside `main`.
- Consistent lowercase snake_case keys: `slog.Info("container started", "container_id", id, "pid", pid)`.
- Pass the logger explicitly or via constructor; do not use the global default in libraries.

## Concurrency

- Every goroutine must have a clear owner and a way to stop; no fire-and-forget.
- Pass `context.Context` as the first parameter to anything that blocks or does I/O; respect cancellation.
- Use `sync.WaitGroup.Go` or `errgroup` to manage goroutine lifetimes.
- Shutdown: `signal.NotifyContext` for SIGINT/SIGTERM in `main`; stop servers with `http.Server.Shutdown` and a deadline, then wait for goroutines.
- Prefer channels for ownership transfer, mutexes for protecting shared state; keep critical sections small.
- Never copy types containing a `sync.Mutex`; pass them by pointer.
- Run tests with `-race`.

## Performance

- Measure first: `testing.B` with `b.Loop()`, `pprof`, and `benchstat` for comparisons.
- Preallocate when size is known: `make([]T, 0, n)`, `make(map[K]V, n)`.
- Avoid allocations in hot paths: reuse buffers, avoid `fmt.Sprintf` and `[]byte`/`string` conversions in loops, prefer `strconv` and `strings.Builder`.
- Check escape analysis with `go build -gcflags=-m` when optimizing allocation-heavy code.
- Use `sync.Pool` only for frequently allocated, short-lived objects, and only when profiling shows it helps.
- Stream with `io.Reader`/`io.Writer` instead of loading whole files or responses into memory.
- Wrap file and socket I/O in `bufio` when doing many small reads or writes.
- Prefer `io.Copy` between files and sockets so the runtime can use `splice`/`sendfile`.
- Pass large structs by pointer; keep small structs by value.
- Order struct fields to minimize padding in types allocated in large numbers.
- Set timeouts on all network clients and servers; never use `http.DefaultClient` for external calls.

## Linux and syscalls

- Use `golang.org/x/sys/unix` instead of the deprecated `syscall` package.
- Call `runtime.LockOSThread` before namespace operations (`setns`, `unshare`) that must stay on one thread.
- Close every file descriptor; use `O_CLOEXEC` and check `Close` errors on writes.

## Files, processes, config

- Atomic writes: temp file in the same dir, `Sync`, `os.Rename`; fsync the dir when durability matters.
- Open paths built from untrusted input through `os.Root`; never `filepath.Join` user input onto a trusted dir.
- Subprocesses: `exec.CommandContext` with separate args and a timeout, exit status checked; never `sh -c` with interpolation.
- Read env vars once at startup into one validated config struct; never `os.Getenv` deep in code. Invalid config fails fast with a clear message.

## Security

- Validate all external input at the boundary: names, paths, URLs, ports, sizes.
- Servers limit body size (`http.MaxBytesReader`), header size, and set read, write, and idle timeouts.
- SQL uses bound params only.
- Never log secrets, tokens, or user data.
- Constant-time secret comparison (`crypto/subtle`); store only hashes of tokens and passwords.

## Testing

- Table-driven tests with `t.Run` subtests; use `t.Parallel()` where safe.
- Test behavior through public APIs; avoid testing unexported internals.
- Use `t.TempDir()`, `t.Context()`, and `t.Cleanup()` instead of manual setup and teardown.
- No mocking frameworks; use small hand-written fakes behind interfaces.
- Tests needing root or special kernel features must skip cleanly when unavailable.
- Regression tests must fail without the fix.
- `testing/synctest` for time-dependent code instead of real sleeps.
- Fuzz tests (`testing.F`) for parsers and decoders.

## Commands

Done only when build, lint, and tests pass; report failures with output.

- Build: `CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" ./...`
- Test: `go test -race ./...`
- Lint: `golangci-lint run ./...` (config in `.golangci.yml`, includes `go vet` and `staticcheck`); must pass with zero issues.
- Format: `golangci-lint fmt`
- Never add `//nolint` or weaken `.golangci.yml` to silence a lint; fix the code. If a suppression is truly needed, it must name the linter and explain why.
- Vulnerabilities: `go tool govulncheck ./...`
- Tools: pin Go tools like `govulncheck` with `go get -tool` so `go tool` runs the pinned version; install `golangci-lint` as a binary, as its docs advise against `go tool`.
- Dependencies: `go mod tidy` after any import change.
- Bench: `go test -run=^$ -bench=. -benchmem ./...`
