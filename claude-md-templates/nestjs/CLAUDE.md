# CLAUDE.md

## Project
<!-- One sentence: what this project does and who it's for. -->
[Describe the project here]

## Stack
- NestJS
- TypeORM + PostgreSQL
- [Auth: JWT / Passport / other]
- [Other: Redis / Bull / Mailer / etc.]

## Commands
```bash
# Dev
npm run start:dev

# Build
npm run build

# Tests
npm run test
npm run test:e2e

# Lint
npm run lint

# Migrations
npm run migration:generate -- -n MigrationName
npm run migration:run
npm run migration:revert
```

## Architecture
```
src/
  modules/              — feature modules (users, payments, etc.)
    <module>/
      <module>.module.ts
      <module>.controller.ts
      <module>.service.ts
      dto/
  orm/
    entities/           — shared TypeORM entities
      enums.ts          — ALL integer enums live here, nowhere else
    migrations/
  common/
    constants/          — all magic values, limits, config keys
```

## TypeORM
- Never manually check `deletedAt` — soft deletes filter automatically via `@DeleteDateColumn`
- Always inject `Repository<Entity>` directly in the service — never create a custom repository class wrapping TypeORM operations
- Raw queries must include `AND deleted_at IS NULL`

## No N+1 queries
Never query the database inside a loop:
```ts
// ❌
for (const item of items) {
  const user = await this.userRepo.findOne({ where: { id: item.userId } })
}
// ✓
const users = await this.userRepo.findBy({ id: In(items.map(i => i.userId)) })
const userMap = new Map(users.map(u => [u.id, u]))
```

## Enums
- Always integer-valued — never strings
- All enums live in `src/orm/entities/enums.ts` — never redefine elsewhere
- Use `@Column({ type: 'smallint' })` for enum columns

## Column types
- `timestamptz` for all date/time columns — never plain `timestamp`
- `numeric` with precision/scale for money — never `float`
- `smallint` for low-cardinality integers (status, type, flags)
- `text` instead of `varchar` when length is unbounded
- Always specify `name` explicitly in `@Column` and `@JoinColumn`

## Entities
- Set defaults via `@Column({ default: ... })` on the entity — never in service code
- Every FK must have `@ManyToOne`/`@OneToOne` + `@JoinColumn()` — never a plain `@Column` alone
- Add `@Index()` on every FK column and every column used in WHERE clauses
- Soft-deletable entities use `@DeleteDateColumn` — never an `isDeleted: boolean`

## DTOs
- All normalization (trim, lowercase, type coercion) via `@Transform` — never in the service
- Use `@IsEnum` with integer enums — never accept string enum values
- Optional fields: `@IsOptional()` + `?` in TypeScript
- Use `PartialType` for update DTOs
- Never return raw entity objects — always use response DTOs

## Services
- Never return `null` — throw `NotFoundException` or return `[]` / `{}`
- All method parameters must use DTOs — never accept raw `any`
- Every method must have an explicit return type
- Throw NestJS built-in exceptions: `NotFoundException`, `BadRequestException`, `ForbiddenException`
- All constants in `src/common/constants/` — never inline magic values

## Auto-trigger

When **creating** a new `*.service.ts` — read and follow `~/.claude/skills/write-nestjs-service/SKILL.md`
When **creating** a new `*.entity.ts` — read and follow `~/.claude/skills/write-typeorm-entity/SKILL.md`
When **creating** a new `*.dto.ts` — read and follow `~/.claude/skills/write-nestjs-dto/SKILL.md`

## Never do
- Never use string enums anywhere
- Never query inside a loop
- Never return `null` from a service method
- Never set defaults in service code
- Never expose raw entity objects from controllers
- Never commit `.env` files
- Never run `migration:revert` without explicit confirmation
- Never push directly to `main`
