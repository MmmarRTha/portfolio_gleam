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
| `gleam run` | Start dev server (lustre_dev_tools) |
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

- No generated HTML in tree — lustre_dev_tools handles bundling
- `/build`, `/.lustre`, `/dist` are gitignored
- Use `gleam` CLI, not mix/rebar3
- All tests in `test/` using gleeunit
