# Example: `/tech-debt-radar` output on cal.com

> This is real output from running `/tech-debt-radar` on [cal.com](https://github.com/calcom/cal.com).

---

## Executive Summary

The cal.com codebase is large, well-structured, and actively maintained — but carries meaningful tech debt in three areas: test coverage gaps in core booking logic, scattered `any` usage undermining TypeScript's value, and several high-churn files with growing complexity. The most urgent risks are in the payment and calendar integration layers, which have high business impact and limited test coverage. Overall health: **moderate** — solid foundation, specific hotspots that need attention.

---

## Debt Items

### [Test Coverage] Booking engine has no unit tests — Priority: 5.0 (Impact: 5 / Effort: 1)
- **Location:** `packages/trpc/server/routers/bookings.ts`
- **What it is:** The core booking creation and modification logic has integration tests via Playwright but no unit tests
- **Why it matters:** Any regression in booking logic directly breaks the product's core function — hard to catch without fast unit tests
- **How to fix it:** Add vitest unit tests starting with `handleNewBooking()` — mock the Prisma client, test the happy path and cancellation edge cases first

---

### [Security] Raw user input used in calendar query construction — Priority: 4.0 (Impact: 4 / Effort: 1)
- **Location:** `packages/lib/CalendarService.ts` lines 234–267
- **What it is:** Event title and description from user input are interpolated into calendar API calls without sanitization
- **Why it matters:** Potential for injection into downstream calendar APIs (Google, Outlook) — could corrupt calendar data
- **How to fix it:** Sanitize `title` and `description` fields through a whitelist filter before passing to any calendar adapter

---

### [Maintainability] 47 instances of `any` in tRPC routers — Priority: 3.3 (Impact: 4 / Effort: 1.2)
- **Location:** `packages/trpc/server/routers/` — spread across 12 files
- **What it is:** `// @ts-ignore` and explicit `any` types used as shortcuts, defeating TypeScript's guarantees
- **Why it matters:** Type errors in router inputs/outputs can reach the client silently — hard to debug, risky at runtime
- **How to fix it:** Run `grep -rn ": any\|@ts-ignore" packages/trpc/` and replace with proper types or `unknown` — start with the bookings router

---

### [Performance] N+1 queries in event type listing — Priority: 3.0 (Impact: 3 / Effort: 1)
- **Location:** `packages/trpc/server/routers/eventTypes.ts` lines 89–134
- **What it is:** `eventTypes.findMany()` followed by a per-event `user.findUnique()` inside a loop — produces N+1 database queries
- **Why it matters:** Slow dashboard load for users with many event types; gets worse at scale
- **How to fix it:** Add `include: { users: true }` to the `findMany` call to join in one query

---

### [Dependencies] 6 packages more than 2 major versions behind — Priority: 2.5 (Impact: 3 / Effort: 1.2)
- **Location:** Root `package.json` and `apps/web/package.json`
- **What it is:** `react-query` (v3 → v5), `zod` (v2 → v3), `date-fns` (v2 → v3) among others
- **Why it matters:** Security patches and breaking changes accumulate — harder to upgrade the further behind you fall
- **How to fix it:** Start with `zod` (smallest API surface change) — upgrade one package per sprint

---

### [Architecture] Feature flag logic duplicated across 23 components — Priority: 2.0 (Impact: 3 / Effort: 1.5)
- **Location:** `apps/web/components/` — scattered `process.env.NEXT_PUBLIC_*` checks
- **What it is:** Feature flag conditionals written inline in components rather than through a central abstraction
- **Why it matters:** Changing a flag's behavior requires finding and updating 20+ files — easy to miss one
- **How to fix it:** Create `packages/lib/featureFlags.ts` with typed flag accessors — replace inline checks incrementally

---

### [Dead Code] 11 exported functions with zero references — Priority: 1.5 (Impact: 1 / Effort: 0.5)
- **Location:** `packages/lib/` — various utility files
- **What it is:** Functions exported but never imported anywhere in the codebase
- **Why it matters:** Cosmetic debt — confuses new developers, inflates bundle size slightly
- **How to fix it:** Run `ts-prune` to generate the full list, delete in one PR

---

## Quick Wins
*Fix these first — high impact, low effort*

- **Booking unit tests** — add vitest coverage for `handleNewBooking()` in an afternoon
- **Calendar input sanitization** — 20-line fix, eliminates a real security surface
- **N+1 query fix** — one line change in `eventTypes.ts`, measurable perf gain

---

## Watch List
*High impact, needs planning*

- **TypeScript `any` cleanup** — 47 instances across 12 files, needs systematic approach
- **Dependency upgrades** — `react-query` v3→v5 has breaking API changes, needs a migration sprint

---

## Ignore List
*Not worth fixing now*

- **Dead code removal** — low risk, low reward, distracts from real issues
- **Feature flag architecture** — only becomes painful at much higher contributor count
