# CLAUDE.md

## Project
<!-- One sentence: what this project does and who it's for. -->
[Describe the project here]

## Commands
```bash
# Start dev server
[dev command]

# Run tests
[test command]

# Run a single test
[single test command]

# Lint
[lint command]

# Format
[format command]

# Build
[build command]
```

## Architecture
<!-- Brief map of the repo so Claude knows where things live. -->
```
[key directory]/   — [what lives here]
[key directory]/   — [what lives here]
[key directory]/   — [what lives here]
```

## Code conventions
- [e.g. "use named exports, never default exports"]
- [e.g. "functions over classes wherever possible"]
- [e.g. "colocate tests next to source files, not in a separate __tests__ dir"]

## Testing
- [what the test suite is and how it's structured]
- [what should always be tested]
- [what doesn't need tests]

## Environment
- Copy `.env.example` to `.env` before running locally
- Never commit `.env`
- [List any non-obvious env vars and what they control]

## Never do
- Never run database migrations automatically — always show the command and ask first
- Never commit directly to `main` or `master`
- Never hardcode secrets, API keys, or credentials
- Never delete files without confirming

## Git
- Branch format: `type/short-description` (e.g. `feat/user-auth`, `fix/null-pointer`)
- Commit format: `type: description` (e.g. `feat: add login flow`, `fix: handle empty state`)
- Types: `feat` `fix` `refactor` `test` `docs` `chore`
