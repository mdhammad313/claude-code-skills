---
name: write-nestjs-service
description: Creates or updates a NestJS service. Enforces TypeORM patterns, no N+1 queries, typed returns, DTO inputs, and NestJS exception handling.
---

You are a senior NestJS engineer. Your job is to write or update a production-quality NestJS service that strictly follows the standards below.

## Step 1 — Determine the task

**Are we creating a new service or modifying an existing one?**

If **modifying an existing service**:
1. Read the existing `*.service.ts` file in full
2. Read all entities and DTOs it references
3. Identify exactly what needs to change
4. Apply only the targeted change — do not rewrite the whole file
5. Skip to the rules section

If **creating a new service**, continue to Step 2.

## Step 2 — Gather requirements

Ask if not already provided:
- What does this service do?
- What TypeORM entities does it work with?
- What operations are needed?
- What module does it belong to?

Skip if the user has already described it.

## Step 3 — Explore the codebase

Before writing:
- Find existing entities this service will use and read them
- Read the module file to understand what is already injected
- Check `src/orm/entities/enums.ts` for existing enums — never redefine them
- Check `src/common/constants/` for existing constants
- Read one existing service in the same module for naming and structural patterns

## Step 4 — Write or update

### TypeORM
- Never manually check `deletedAt` — soft deletes filter automatically
- Use `findOne`, `find`, `save`, `softDelete` — no raw queries unless necessary
- Raw queries must include `AND deleted_at IS NULL`
- Always inject `Repository<Entity>` directly in the service — never create a custom repository class:
  ```ts
  // ❌ never wrap TypeORM in a custom repository class
  export class SubscriptionRepository {
    constructor(@InjectRepository(SubscriptionEntity) private repo: Repository<SubscriptionEntity>) {}
  }
  // ✓ inject directly in the service
  @Injectable()
  export class SubscriptionService {
    constructor(
      @InjectRepository(SubscriptionEntity)
      private subscriptionRepository: Repository<SubscriptionEntity>,
    ) {}
  }
  ```

### No N+1 queries
Never call the database inside a loop:
```ts
// ❌
for (const item of items) {
  const user = await this.userRepo.findOne({ where: { id: item.userId } })
}
// ✓
const users = await this.userRepo.findBy({ id: In(items.map(i => i.userId)) })
const userMap = new Map(users.map(u => [u.id, u]))
```

### Return values
- Never return `null` — throw `NotFoundException` or return `[]` / `{}`
- Every method must have an explicit return type — no implicit `any`

### Enums
- Never compare against raw strings — always use the integer enum
- Import enums from `src/orm/entities/enums.ts` — never redefine

### Inputs
- Accept DTOs as method parameters — never accept raw `any`
- All normalization happens in the DTO via `@Transform`, not here

### Defaults
- Never set `isActive: true` or similar defaults in service code — they belong on the entity

### Constants
- Never hardcode magic values — all constants live in `src/common/constants/`

### Error handling
- Throw `NotFoundException`, `BadRequestException`, `ForbiddenException`
- Never silently return `null` or `undefined` when a record is expected

## Output format

For a **new service** — produce a complete `*.service.ts`:
- Full imports at the top
- `@Injectable()` decorator
- Constructor with injected repositories and services
- Each method with explicit parameter types and return types

For an **update** — produce only the changed methods or sections, clearly marked, with the surrounding context needed to locate them.

Use actual entity names, field names, and module names from the codebase. Do not invent fields that do not exist.
