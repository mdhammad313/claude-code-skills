# CLAUDE.md

## Project
<!-- One sentence: what this project does and who it's for. -->
[Describe the project here]

## Stack
- Next.js 14+ with App Router
- TypeScript (strict mode)
- Tailwind CSS
- [ORM: Prisma / Drizzle / other]
- [Auth: NextAuth / Clerk / other]
- [DB: PostgreSQL / SQLite / other]

## Commands
```bash
# Dev server
npm run dev

# Type check
npx tsc --noEmit

# Lint
npm run lint

# Format
npm run format

# Tests
npm test
npm test -- --testPathPattern=path/to/file

# Build
npm run build

# Database
npx prisma migrate dev       # apply migrations in dev
npx prisma migrate deploy    # apply migrations in prod
npx prisma studio            # GUI to inspect data
```

## Architecture
```
app/                  — App Router pages and layouts
  (auth)/             — route group: auth pages
  (dashboard)/        — route group: protected pages
  api/                — API route handlers
components/           — shared UI components
  ui/                 — primitive components (button, input, etc.)
lib/                  — utilities, helpers, shared logic
  db.ts               — Prisma client singleton
  auth.ts             — auth config and helpers
hooks/                — custom React hooks
types/                — shared TypeScript types
prisma/               — schema and migrations
public/               — static assets
```

## Component rules
- Server Components by default — add `"use client"` only when you need interactivity, browser APIs, or hooks
- Never fetch data inside Client Components — fetch in Server Components and pass as props
- Colocate components with the route that uses them; only promote to `components/` when shared by 2+ routes
- Use `loading.tsx` and `error.tsx` at the route level, not try/catch in every component

## TypeScript
- Strict mode is on — never use `any`, use `unknown` and narrow it
- Define types in `types/` only if shared across multiple modules; otherwise colocate
- Use `zod` for runtime validation at API boundaries and form inputs

## Tailwind
- No inline styles — use Tailwind classes only
- Avoid arbitrary values (`w-[347px]`) unless absolutely necessary
- Extract repeated class combinations into a component, not a `@apply` block

## API routes
- Validate all request bodies with `zod` before using them
- Return consistent shapes: `{ data: ... }` for success, `{ error: string }` for errors
- Never expose raw database errors to the client

## Database
- Never auto-run `prisma migrate dev` — always show the command and let the user run it
- Never use `prisma migrate reset` without explicit confirmation — it wipes data
- Prefer `prisma.$transaction` for multi-step writes

## Never do
- Never add `"use client"` to a component just to avoid a TypeScript error
- Never commit `.env` or `.env.local`
- Never push directly to `main`
- Never use `dangerouslySetInnerHTML` without sanitizing input

## Git
- Branch format: `type/short-description` (e.g. `feat/user-auth`, `fix/null-pointer`)
- Commit format: `type: description`
- Types: `feat` `fix` `refactor` `test` `docs` `chore`
