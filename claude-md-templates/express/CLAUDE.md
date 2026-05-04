# CLAUDE.md

## Project
<!-- One sentence: what this project does and who it's for. -->
[Describe the project here]

## Stack
- Node.js [version]
- Express [version]
- TypeScript
- [ORM: Prisma / TypeORM / Drizzle]
- [DB: PostgreSQL / MySQL / MongoDB]
- [Auth: JWT / Passport / other]
- [Validation: Zod / Joi / other]

## Commands
```bash
# Dev server (with hot reload)
npm run dev

# Type check
npx tsc --noEmit

# Lint
npm run lint

# Format
npm run format

# Tests
npm test
npm test -- --testPathPattern=auth    # filter by name

# Build
npm run build

# Start production
npm start

# Database
npx prisma migrate dev          # create and apply migration
npx prisma migrate deploy       # apply in production
npx prisma generate             # regenerate client after schema change
```

## Architecture
```
src/
  routes/           — Express routers, one file per resource
  controllers/      — request handlers (thin, delegate to services)
  services/         — business logic
  middleware/        — auth, error handling, validation
  models/           — DB models / Prisma schema interactions
  types/            — shared TypeScript types and interfaces
  utils/            — pure utility functions
  config/           — environment config, constants
  app.ts            — Express app setup (no server.listen here)
  server.ts         — server entrypoint (listen lives here)
tests/              — mirrors src/ structure
```

## Route conventions
- RESTful routes: `GET /users`, `GET /users/:id`, `POST /users`, `PATCH /users/:id`, `DELETE /users/:id`
- Group routes by resource in `routes/` — one file per resource
- Mount all routes in `app.ts` with a versioned prefix: `/api/v1`
- Never put business logic in route files

## Controller conventions
- Controllers only: parse request, call service, send response
- Wrap every async controller in a `try/catch` or use an `asyncHandler` wrapper
- Always respond with a consistent shape: `{ data }` for success, `{ error }` for failure

## Services
- All database access goes through services, never directly in controllers
- Services return plain objects, not HTTP responses
- Keep services framework-agnostic — no `req`/`res` in service functions

## Validation
- Validate all request bodies at the route level using Zod (or Joi) before hitting the controller
- Return `400` with a clear message for validation failures
- Never trust user input — validate shape AND content

## Error handling
- Use a central error handler middleware mounted last in `app.ts`
- Define custom error classes that carry a `statusCode`
- Never expose stack traces or raw DB errors to API consumers

## Database
- Never auto-run migrations — always show the command and let the user run it
- Use transactions for multi-step writes
- Never use `SELECT *` in production queries — always select specific columns

## Never do
- Never use `any` in TypeScript — use `unknown` and narrow it
- Never log full request bodies (may contain passwords or tokens)
- Never commit `.env`
- Never call `eval()` or execute user input as code
- Never push directly to `main`

## Git
- Branch format: `type/short-description`
- Commit format: `type: description`
- Types: `feat` `fix` `refactor` `test` `docs` `chore`
