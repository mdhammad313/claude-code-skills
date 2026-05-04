# Example: `/onboard-me` output on cal.com

> This is real output from running `/onboard-me` on [cal.com](https://github.com/calcom/cal.com) — an open-source scheduling platform with 30k+ stars.

---

## Project Overview

Cal.com is an open-source scheduling infrastructure platform — the open-source alternative to Calendly. It allows individuals, teams, and organizations to manage availability, accept bookings, and integrate with external calendars and video conferencing tools. The platform is built as a monorepo serving both a hosted SaaS product and a self-hostable version.

---

## Tech Stack

| Technology | Role |
|---|---|
| Next.js 14 (App Router) | Frontend and API routes for the main web app |
| tRPC | End-to-end typesafe API layer between frontend and backend |
| Prisma | ORM for all database access |
| PostgreSQL | Primary database |
| Turborepo | Monorepo build orchestration |
| NextAuth.js | Authentication |
| Tailwind CSS | Styling |
| Playwright | End-to-end testing |
| Vitest | Unit testing |
| TypeScript | Used throughout — strict mode |

---

## Architecture

The repo is a Turborepo monorepo with two layers: `apps/` (deployable applications) and `packages/` (shared libraries).

```
apps/
  web/                  — Main Next.js application (the product)
  api/                  — Standalone API server
  storybook/            — Component development and documentation
packages/
  ui/                   — Shared component library (shadcn-based)
  prisma/               — Shared Prisma schema and client
  lib/                  — Shared business logic utilities
  trpc/                 — Shared tRPC router definitions
  types/                — Shared TypeScript type definitions
  config/               — Shared ESLint, TypeScript, Tailwind configs
  emails/               — Email templates (React Email)
  features/             — Feature-flag-gated modules
```

**Key architectural pattern:** All database access goes through `packages/prisma`. All API logic goes through tRPC routers in `packages/trpc`. The `apps/web` Next.js app consumes both — it never touches the database directly.

---

## Key Files to Read First

| File | Why it matters |
|---|---|
| `apps/web/app/layout.tsx` | Root layout — understand the provider tree before touching any UI |
| `packages/prisma/schema.prisma` | The full data model — read this before anything else if touching data |
| `packages/trpc/server/routers/` | All backend logic lives here — one file per domain |
| `apps/web/app/api/` | REST API endpoints (for webhooks and integrations) |
| `turbo.json` | Build pipeline — understand this before running any commands |
| `apps/web/next.config.js` | Next.js config with feature flags and redirects |
| `packages/lib/CalendarService.ts` | Core calendar integration logic — highly central |
| `.env.example` | 40+ env vars — read before local setup |

---

## How to Run Locally

```bash
# 1. Install dependencies (pnpm only — do not use npm or yarn)
pnpm install

# 2. Copy environment variables
cp .env.example .env

# 3. Fill in required vars in .env:
#    DATABASE_URL, NEXTAUTH_SECRET, NEXTAUTH_URL (minimum to boot)

# 4. Set up the database
pnpm db:migrate

# 5. Seed the database
pnpm db:seed

# 6. Start the dev server
pnpm dev
#    → web app at http://localhost:3000
#    → api at http://localhost:3002
```

---

## Common Workflows

**Run all tests:**
```bash
pnpm test          # unit tests (vitest)
pnpm test:e2e      # end-to-end (playwright)
```

**Work on a specific app only:**
```bash
pnpm --filter @calcom/web dev
pnpm --filter @calcom/api dev
```

**Add a database migration:**
```bash
# Edit packages/prisma/schema.prisma first, then:
pnpm db:migrate
# Never edit migration files manually after they've been applied
```

**Add a new tRPC endpoint:**
1. Add procedure to the relevant router in `packages/trpc/server/routers/`
2. Export it from the router index
3. Call it from the frontend with `trpc.routerName.procedureName.useQuery()`

---

## Gotchas & Non-Obvious Things

1. **Use `pnpm` only.** The repo has a `preinstall` script that blocks `npm` and `yarn`. Running either will error immediately.

2. **The Prisma client is a singleton in `packages/prisma`.** Never import `@prisma/client` directly in app code — always import from `@calcom/prisma`. Multiple instances cause connection pool exhaustion in dev.

3. **Feature flags are env-var driven.** A lot of UI conditionally renders based on `NEXT_PUBLIC_*` flags. If a component seems to be missing, check `apps/web/next.config.js` for feature flags before debugging the component itself.

4. **tRPC procedures are protected by middleware.** Most procedures require `authedProcedure` — calling an unprotected endpoint returns a cryptic 401. Check the procedure definition in `packages/trpc` before assuming a bug.

5. **The `apps/web` build is slow.** First build takes 3–5 minutes due to the number of routes. Use `pnpm --filter @calcom/web dev` for faster dev starts when only working on the frontend.

---

## Who Owns What

Based on git commit history:

| Area | Most active |
|---|---|
| Booking flow | Core team — high churn, touch carefully |
| Calendar integrations | Specialist contributors — complex, well-tested |
| UI components (`packages/ui`) | Active — PRs welcome, low risk |
| Prisma schema | Core team only — migrations require review |
| Email templates | Low churn — safe to modify |
