# AGENTS.md — portfolio_gleam

## Stack

- **Language:** Gleam 1.16 (`.tool-versions`), target `javascript`
- **UI:** Lustre 5.x — mounts to `#app` in the DOM
- **Test:** gleeunit — test functions must end in `_test`
- **Dev tools:** lustre_dev_tools — provides build/watch/dev-server
- **Runtime:** Erlang/OTP 29, Node.js 26 (via asdf)

## Commands

| Command | Action |
|---|---|
| `gleam run -m lustre/dev start` | Start dev server (lustre_dev_tools) |
| `gleam test` | Run all tests |
| `gleam format src test` | Auto-format code |
| `gleam format --check src test` | CI format check (runs after tests in CI) |
| `gleam deps download` | Fetch dependencies |

## Structure

```
src/portfolio_gleam.gleam   — app entrypoint, mounts to #app
test/portfolio_gleam_test.gleam — test entrypoint (calls gleeunit.main())
```

## CI (`.github/workflows/test.yml`)

Order: `gleam deps download` → `gleam test` → `gleam format --check src test`

## Conventions

### Project
- No generated HTML in tree — lustre_dev_tools handles bundling
- `/build`, `/.lustre`, `/dist` are gitignored
- Use `gleam` CLI, not mix/rebar3
- All tests in `test/` using gleeunit
- Dev tool config lives in `gleam.toml` under `[tools.$TOOL_NAME]`, not separate config files

### Naming
- Module names are singular (`app/user`, not `app/users`)
- Acronyms are treated as single words (`parse_json`, not `parse_j_s_o_n`)
- Conversion functions: `x_to_y` pattern (`json_to_string`, not `json_into_string`)
- No abbreviations — always write full names (`capacity`, not `cap`)

### Imports
- Use qualified imports for functions and constants from other modules
- Types and record constructors may be unqualified if readability doesn't suffer
- Exception: Lustre HTML/event DSL functions (`div`, `button`, `text`, etc.) are imported unqualified per ecosystem convention

### Functions
- Always annotate argument types and return types on all module functions
- Fallible functions return `Result(a, e)`, never panic or return `Option`
- Error types should be descriptive with context-carrying variants

### Patterns to apply when relevant
- **Make invalid states impossible** — use custom types to encode business rules so illegal states can't be represented
- **Replace bools with custom types** — prefer `Role { Student | Teacher }` over `is_student: Bool`
- **Design descriptive errors** — error variants carry relevant data, not just names
- **Comment liberally** — explain *why* code exists, not just *what* it does
- **Sans-io pattern** — for API clients/SDKs, separate request construction from execution

### Anti-patterns to avoid
- Fragmented modules — don't prematurely split; large modules are fine
- Panicking in libraries — always return `Result`; panics are only for app entrypoints
- Global namespace pollution — prefix all modules under the package name
- Namespace trespassing — don't place modules in another package's namespace
- Grouping by design pattern — organise by business domain, not by pattern
- Check-then-assert — use pattern matching or combinators instead
- Using `Dynamic` with FFI — create precise types for interop boundaries
- Match-all variants in case expressions — always match each variant explicitly
- Category theory overuse — solve specific problems with specific concrete solutions
