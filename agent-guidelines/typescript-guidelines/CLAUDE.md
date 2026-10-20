# TypeScript guidelines

TypeScript 7, Node.js 24 LTS, ESM only, `pnpm`. Frontends are Vite + React with the React Compiler. These rules override common TypeScript and React conventions.

## Principles

- Simple, explicit code; optimize only with benchmark/profile evidence.
- Smallest correct change; no unrelated refactors, renames, or reformatting.
- Platform and stdlib before deps; a new package must be worth more than the lines it replaces.
- Make invalid states unrepresentable; parse untrusted input into validated types at the boundary, then trust the type.
- Small single-purpose modules; no `utils`/`helpers`/`common`/`misc` files.
- No abstraction without two real callers; extract duplicated code on the third copy, not before.

## Layout

- Node: `src/main.ts` is thin: load config, wire dependencies, start, handle shutdown.
- Frontend: `src/routes/` for routes, `src/features/<feature>/` for feature code (`api.ts`, `components/`, `use-*.ts`), `src/components/ui/` for shared primitives, `src/lib/` only for focused shared modules (`format.ts`, `toast.ts`).
- One concern per file, split by entity or responsibility, never by kind of code; under ~300 lines.
- No barrel files (`index.ts` re-exports); import from the defining module.
- Files and folders are kebab-case: `variable-dialog.tsx`, `use-service-scope.ts`.
- Generated code is named `*.gen.ts` and never edited by hand.

## Modules

- `"type": "module"` in every `package.json`; no `.cjs`/`.cts` files.
- No `require`, `module.exports`, `__dirname`, or `__filename`; use `import`, `export`, and `import.meta.dirname`/`import.meta.filename`.
- Node packages import relative files with the `.ts` extension (`./users.ts`); Vite apps use bundler resolution and the `@/` alias.
- Builtins with the `node:` prefix: `import { readFile } from 'node:fs/promises'`.
- Named exports only; default exports only where a tool requires them (`vite.config.ts`).
- Type-only imports use `type`: `import { Button, type ButtonProps } from '...'`.
- Top-level `await` over async IIFEs.
- Erasable syntax only, so Node runs files directly: no `enum`, `namespace`, parameter properties, or `import =`.

## Types

- No `any`; use `unknown` at boundaries and narrow it. No `@ts-ignore`; `@ts-expect-error` only with a reason.
- No non-null `!`. No `as` except `as const`; parse with zod or narrow with a type guard instead.
- `type` for object types, not `interface`.
- Unions over enums: string literal unions or `as const` objects with a derived union type.
- Discriminated unions for states and variants (`{ status: 'loading' } | { status: 'ready', data: T }`), never optional-field soup or paired booleans.
- `switch` over unions is exhaustive with no `default`, so adding a variant fails to compile.
- `readonly` on props and fields that never change; `readonly T[]` for inputs that aren't mutated.
- Branded types for IDs and validated values, built only by their parser: `z.uuid().brand<'UserId'>()`.
- `satisfies` to check a literal against a type without widening it.
- Infer local types; annotate exported function parameters and anything the inferred type gets wrong.
- Generics only when two or more types use the code; no type parameters that only one type fills.
- `undefined` for absence in TS code; `null` only where an API or React requires it.

## Validation

- `zod` at every boundary: HTTP bodies and responses, env, `localStorage`, URL search params, `JSON.parse`, message payloads.
- The schema is the source of truth: `const User = z.object(...)`, `type User = z.infer<typeof User>`.
- Never `response.json() as T`; parse it.

## Style

- Modern JS: `??`, `?.`, `??=`, `Object.hasOwn`, `structuredClone`, `.at(-1)`, `Array.prototype.toSorted`/`toReversed`, `Object.groupBy`, `Promise.withResolvers`.
- `for...of` over `.forEach`; `.map`/`.filter`/`.flatMap` when building arrays; `.reduce` only for simple sums.
- Named constants for magic numbers and strings; units in names (`CACHE_TTL_MS`, `MAX_BODY_BYTES`).
- No mutable module-level state or side effects on import; pass dependencies explicitly.
- Read env vars once at startup in `src/config.ts` into one validated config object; never `process.env` elsewhere.
- Template literals over concatenation; `===` only; curly braces on every block.
- Regexes use the `u` or `v` flag.

## Naming

- camelCase values and functions, PascalCase types and components, SCREAMING_SNAKE_CASE module constants.
- Acronyms are one word: `userId`, `HttpClient`, `parseUrl`.
- Booleans are predicates: `isOpen`, `hasAccess`, `canEdit`.
- Short names for short scopes; descriptive for exported and long-lived ones.
- Hooks start with `use`; event handler props with `on`, handlers with `handle`.
- No Hungarian or type suffixes (`IUser`, `UserType`, `TUser`).

## Functions and control flow

- `function` declarations for named functions and components; arrows only for inline callbacks.
- Early returns and guard clauses; happy path unindented; max nesting depth 3.
- Functions do one job, under ~80 lines; split if they need section comments.
- At most 4 params; group related ones in an object.
- No boolean flag params that change behavior; use separate functions or a union option.
- No `else` after `return`/`throw`/`continue`; no nested ternaries; no reassigning params.

## Errors

- Throw only `Error` subclasses with `override readonly name`, grouped per domain in its own module; pass the original with `{ cause }`.
- Catch variables are `unknown`; narrow with `instanceof` before use.
- Messages lowercase, no trailing punctuation, say what was being done: `` `read config ${path}` ``.
- Never swallow errors with an empty `catch`; log or rethrow, not both.
- Expected failures that callers branch on are part of the return type (discriminated union) or a dedicated error class; never parse error messages.

## Async

- No floating promises: every promise is awaited, returned, or explicitly handled.
- Pass `AbortSignal` to anything long-running; `fetch` always gets a timeout (`AbortSignal.any([signal, AbortSignal.timeout(ms)])`).
- `Promise.all` for independent work; `await` in loops only when order matters, with a reason.
- No `.then` chains; `async`/`await` only.
- No `new Promise` around APIs that already return promises.
- Node shutdown: handle `SIGINT`/`SIGTERM`, stop accepting work, drain with a deadline.

## React

- Function components only; one exported component per file; props type named `<Component>Props` with `readonly` fields.
- The React Compiler memoizes; no manual `useMemo`, `useCallback`, or `memo`.
- No `useEffect` for derived state or for responding to events; compute during render or in the handler. Effects only sync with external systems.
- Server state in TanStack Query, forms in TanStack Form, URL state in TanStack Router search params validated with zod; no copying server data into `useState`.
- Stable keys from data, never array indexes.
- Accessible by default: semantic elements, `type` on every `<button>`, labels on inputs, no click handlers on non-interactive elements.
- No `dangerouslySetInnerHTML`.

## Files, processes, CLI

- Atomic writes: temp file in the same dir, `filehandle.sync()`, `rename`; fsync the dir when durability matters.
- Paths built with `node:path` `join`/`resolve`, never string concatenation; `mkdir(dir, { recursive: true })`; explicit `mode: 0o600` for secrets.
- Subprocesses: `execFile`/`spawn` with separate args, a `signal` or `timeout`, and the exit code checked.
- CLI args with `node:util` `parseArgs`; one module per subcommand.
- Config layered defaults → file → env → flags into the one validated config object.
- Exit codes `0` ok, `1` failure, `2` usage; set `process.exitCode` instead of calling `process.exit()`.
- Results to stdout, progress/diagnostics to stderr; `--json` for machine output; color only on a TTY and never with `NO_COLOR`.
- Destructive commands confirm unless `-y`; refuse without a TTY.

## Comments

- Avoid; when needed, one line on *why*. No restating code, commented-out code, banners, `TODO` without an issue ref, or doc comments repeating the name.

## Spacing

oxfmt keeps existing blank lines but adds none; code reads in paragraphs.

- Blank line between logical steps (setup, work, result) and around multi-line `if`/`for`/`switch`/`try` blocks unless at block start/end.
- A `const` sits directly above its first use when they form one step.
- Blank line before a `return` that follows other statements.
- No blank line after `{` or before `}`; one blank line between top-level declarations, never two.

```ts
export async function startService(deps: Deps, name: ServiceName, signal: AbortSignal): Promise<MachineId> {
  const service = await deps.store.findService(name, signal)
  if (service === undefined) {
    throw new ServiceNotFoundError(`find service ${name}`)
  }

  if (service.state === 'running') {
    throw new ServiceAlreadyRunningError(`start service ${name}`)
  }

  const timeout = AbortSignal.any([signal, AbortSignal.timeout(START_TIMEOUT_MS)])
  const response = await fetch('/machines', { method: 'POST', body: JSON.stringify(service), signal: timeout })
  const machine = Machine.parse(await response.json())

  await deps.store.recordMachine(name, machine.id, signal)
  deps.logger.info({ service: name, machineId: machine.id }, 'machine started')

  return machine.id
}
```

## Logging

- Structured logs with `pino`, fields not interpolation: `logger.info({ machineId }, 'machine started')`.
- No `console.*` outside CLI output code.
- Never log secrets, tokens, or user data.

## Security

- Validate all external input at the boundary: names, paths (reject `..` and absolute paths where unexpected), URLs, ports, sizes.
- Servers limit body size, header size, and connection count, and set request timeouts.
- SQL uses bound params only.
- Subprocesses via `execFile`/`spawn` with separate args; never `exec` or `shell: true` with interpolation.
- Constant-time secret comparison (`crypto.timingSafeEqual`); store only hashes of tokens and passwords.

## Performance

- Measure first (`vitest bench`, `--cpu-prof`, React DevTools Profiler); compare against the previous commit before claiming a speedup.
- Stream large bodies and files (`ReadableStream`, `node:stream/promises` `pipeline`); never buffer unbounded data.
- `Map`/`Set` for lookups over arrays in hot paths; no spreading accumulators in loops.
- Lazy-load routes and heavy components; keep the initial bundle small.

## Dependencies

- Few, widely used, maintained packages; check last release, maintainers, and install size.
- Commit `pnpm-lock.yaml`; no git or URL deps.
- Approve build scripts explicitly with `pnpm approve-builds`; never allow all.
- `pnpm dlx` with pinned versions for one-off tools.

## Testing

- Vitest with explicit imports (`import { describe, expect, it } from 'vitest'`); tests next to the code as `<name>.test.ts`.
- Test behavior through public APIs, not internals.
- Table-driven with `it.each`.
- No mocking frameworks for our own code; hand-written fakes behind a parameter. `vi.fn` only for callbacks.
- Regression tests must fail without the fix.
- Fake timers (`vi.useFakeTimers`) instead of real sleeps.
- `toStrictEqual` over `toEqual`.

## Lints

- Copy `.oxlintrc.json` and `.oxfmtrc.json` to the project root and merge the strictness flags from `tsconfig.json` into the project's tsconfig.
- Dev deps: `typescript`, `@types/node`, `oxlint`, `oxlint-tsgolint` (type-aware rules), `oxfmt`, `vitest`.
- Vite apps keep their tsconfig's `lib` (`dom`), `jsx`, `module`/`moduleResolution: bundler`, and `types`; only the strictness flags are shared.
- Never weaken lints, tsconfig strictness, or formatter settings; fix the code.
- Suppress only with `// oxlint-disable-next-line <rule> -- <reason>` on the smallest scope; the reason says why the code is correct. No file-wide disables.

## Commands

Done only when types, lint, format, and tests pass; report failures with output.

- Types: `pnpm exec tsc --noEmit` (`tsc -b` with project references)
- Lint: `pnpm exec oxlint` (`--fix` for autofixes)
- Format: `pnpm exec oxfmt` (`--check` in CI)
- Test: `pnpm exec vitest run`
- Audit: `pnpm audit --prod`
