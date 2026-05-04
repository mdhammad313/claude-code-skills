# CLAUDE.md

## Project
<!-- One sentence: what this project does and who it's for. -->
[Describe the project here]

## Stack
- [Package manager: pnpm / npm / yarn workspaces / Turborepo / Nx]
- Packages: [list them — e.g. `web`, `api`, `mobile`, `packages/ui`, `packages/config`]
- TypeScript throughout

## Commands

### Root (run from repo root)
```bash
# Install all dependencies
pnpm install

# Build all packages
pnpm build
pnpm turbo build       # if using Turborepo

# Test all packages
pnpm test
pnpm turbo test

# Lint all
pnpm lint

# Type check all
pnpm typecheck
```

### Per-package (run from repo root with --filter)
```bash
# Dev server for a specific app
pnpm --filter web dev
pnpm --filter api dev

# Test a specific package
pnpm --filter @repo/ui test

# Add a dependency to a specific package
pnpm --filter web add react-query

# Add a shared/dev dependency at root
pnpm add -D typescript -w
```

## Workspace structure
```
apps/
  web/              — [e.g. Next.js frontend]
  api/              — [e.g. Express/Fastify backend]
  mobile/           — [e.g. React Native app]
packages/
  ui/               — shared component library
  config/           — shared ESLint, TypeScript, Tailwind configs
  types/            — shared TypeScript types
  utils/            — shared utility functions
turbo.json          — Turborepo pipeline config (if used)
pnpm-workspace.yaml — workspace definition
```

## Key rules for working in this repo

### Where to make changes
- Before editing, confirm which package the change belongs to
- Shared logic → `packages/` not duplicated in `apps/`
- App-specific logic stays in its app — do not reach across `apps/`

### Dependencies
- Shared devtools (TypeScript, ESLint configs) live at the root
- App/package-specific dependencies belong in that package's `package.json`
- Shared runtime code is a `packages/` package, imported explicitly — no symlink tricks

### TypeScript
- Each package has its own `tsconfig.json` that extends from `packages/config/tsconfig`
- Never edit the root `tsconfig.json` directly to fix a type error in one package
- Run `pnpm typecheck` from root before committing — a type error in one package can break others

### Building
- Packages that are consumed by other packages must be built first
- Turborepo handles build order automatically via `dependsOn` in `turbo.json`
- Never run package builds manually in CI — let Turborepo/the pipeline handle it

## Never do
- Never run `npm install` or `yarn` in this repo — use `pnpm` only
- Never add a dependency to the wrong package's `package.json`
- Never import across `apps/` — apps are isolated; share via `packages/`
- Never commit `node_modules/` or built artifacts (`dist/`, `.next/`, `build/`)
- Never push directly to `main`

## Git
- Branch format: `type/short-description`
- Commit format: `type(scope): description` — scope is the package name (e.g. `feat(web): add login page`)
- Types: `feat` `fix` `refactor` `test` `docs` `chore`
