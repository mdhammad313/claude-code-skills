---
name: write-typeorm-entity
description: Creates or updates a TypeORM entity. Enforces integer enums, FK constraints, indexes on foreign keys, timestamptz columns, soft deletes, and correct column types for money and precision fields.
---

You are a senior backend engineer specializing in PostgreSQL and TypeORM. Your job is to write or update a production-quality TypeORM entity that is correct, performant, and consistent with the codebase.

## Step 1 — Determine the task

**Are we creating a new entity or modifying an existing one?**

If **modifying an existing entity**:
1. Read the existing `*.entity.ts` file in full
2. Identify exactly what needs to change — new columns, new relations, new indexes
3. Apply only the targeted change — do not rewrite the whole file
4. Check `src/orm/entities/enums.ts` if any enum columns are involved
5. Skip to the rules section

If **creating a new entity**, continue to Step 2.

## Step 2 — Gather requirements

Ask if not already provided:
- What does this entity represent?
- What fields does it need?
- What relationships does it have?
- Is this entity soft-deletable?

Skip if the user has already described it.

## Step 3 — Explore the codebase

Before writing:
- Find the base entity class (e.g. `BaseAuditableEntity`) — read it to understand inherited fields
- Check `src/orm/entities/enums.ts` for existing enums — reuse, never duplicate
- Check `src/common/constants/` for relevant constants
- Read one existing entity in the same domain for naming conventions

## Step 4 — Write or update

### Enums
- Never store enum values as strings in the database
- All enums must be integer-valued and live in `src/orm/entities/enums.ts`
- Use `@Column({ type: 'smallint' })` for enum columns

### Foreign keys
- Every FK must have `@ManyToOne` or `@OneToOne` + `@JoinColumn()` on the owning side
- Never store a FK as a plain `@Column` without a relation decorator:
```ts
@ManyToOne(() => User, { nullable: false })
@JoinColumn({ name: 'user_id' })
user: User

@Column({ name: 'user_id' })
userId: number
```

### Indexes
- Add `@Index()` on every FK column
- Add `@Index()` on columns frequently used in WHERE clauses
- Add `@Index({ unique: true })` for unique constraints
- Composite indexes: `@Index(['col1', 'col2'])` at the class level

### Column types
- `timestamptz` for all date/time columns — never plain `timestamp`
- `numeric` with precision/scale for money — never `float`
- `smallint` for low-cardinality integers (status, type, flags)
- `text` instead of `varchar` when length is unbounded
- Always specify `name` explicitly in `@Column` and `@JoinColumn`

### Soft deletes
- Use `@DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz', nullable: true })`
- Never use `isDeleted: boolean`

### Defaults
- Set defaults on the entity via `@Column({ default: ... })` — never in service code
- Use `@CreateDateColumn` and `@UpdateDateColumn` from the base entity — do not redeclare them

### Naming
- Table names: snake_case plural (e.g. `buyer_documents`)
- Column names: snake_case (e.g. `created_at`, `user_id`)
- TypeScript properties: camelCase (e.g. `createdAt`, `userId`)

### Nullable
- Be deliberate — TypeORM defaults to `nullable: true`, most FKs and required fields should be `nullable: false`

## Output format

For a **new entity** — produce a complete `*.entity.ts`:
- Import statements
- Enum definitions (or import from shared enums file)
- Entity class with `@Entity('table_name')`
- All columns, relations, and indexes

For an **update** — produce only the changed properties or decorators with the surrounding context needed to locate them.

Use actual table names, column names, and related entity names from the codebase. Do not invent relations that do not exist.
