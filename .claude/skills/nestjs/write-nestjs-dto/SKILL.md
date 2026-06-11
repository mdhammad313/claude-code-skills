---
name: write-nestjs-dto
description: Creates or updates a NestJS DTO. Enforces class-validator decorators, class-transformer transforms, integer enum validation, explicit types, and response DTO separation.
---

You are a senior NestJS engineer. Your job is to write or update production-quality DTO files that handle all input validation and transformation at the boundary — so services receive clean, typed, normalized data.

## Step 1 — Determine the task

**Are we creating a new DTO or modifying an existing one?**

If **modifying an existing DTO**:
1. Read the existing `*.dto.ts` file in full
2. Read the entity it maps to — match field names and types exactly
3. Identify exactly what needs to change — new fields, updated validation, new transforms
4. Apply only the targeted change — do not rewrite the whole file
5. Skip to the rules section

If **creating a new DTO**, continue to Step 2.

## Step 2 — Gather requirements

Ask if not already provided:
- What operation is this DTO for? (create, update, query/filter, response)
- What fields does it need?
- Which fields are optional vs required?
- Are there enum fields? What are the valid values?

Skip if the user has already described it.

## Step 3 — Explore the codebase

Before writing:
- Find the entity this DTO maps to — match field names and types exactly
- Check `src/orm/entities/enums.ts` for existing enums — import, never redefine
- Read existing DTOs in the same module for patterns

## Step 4 — Write or update

### Transforms — all normalization happens in the DTO, never in the service
```ts
// lowercase + trim
@Transform(({ value }) => typeof value === 'string' ? value.trim().toLowerCase() : value)
@IsString()
email: string

// trim only
@Transform(({ value }) => typeof value === 'string' ? value.trim() : value)
@IsString()
name: string

// string → number (query params)
@Transform(({ value }) => parseInt(value, 10))
@IsInt()
page: number
```

### Enums
- Never accept string enum values
- Use `@IsEnum` with integer enums imported from `src/orm/entities/enums.ts`
```ts
@IsEnum(DocumentType)
@IsInt()
type: DocumentType
```

### Optional fields
```ts
@IsOptional()
@IsString()
description?: string
```
- Never use `| null` unless the field is explicitly nullable in the database

### Nested objects
```ts
@ValidateNested()
@Type(() => AddressDto)
address: AddressDto
```

### Response DTOs
- Never return raw entity objects from controllers
- Use `@Exclude()` on sensitive fields, `@Expose()` on fields to include
- Use `excludeExtraneousValues: true` in the controller interceptor

### Update DTOs
- Extend the create DTO with `PartialType`:
```ts
export class UpdateUserDto extends PartialType(CreateUserDto) {}
```

### Validation decorators
- `@IsString()` for strings
- `@IsInt()` for integers — not `@IsNumber()` for whole numbers
- `@IsNumber()` for decimals
- `@IsBoolean()` for booleans
- `@IsEmail()` for email strings
- `@IsUUID()` for UUIDs
- `@IsDateString()` for ISO date strings
- `@IsArray()` + `@ArrayMinSize(1)` for arrays
- `@MinLength()` / `@MaxLength()` for string length
- `@Min()` / `@Max()` for numeric range

### What not to put in DTOs
- No business logic
- No database calls
- No service imports

## Output format

For **new DTOs** — produce the relevant files:
- `create-*.dto.ts` for creation
- `update-*.dto.ts` for updates (use `PartialType`)
- `query-*.dto.ts` for filters and pagination
- `*-response.dto.ts` for response shaping

For an **update** — produce only the changed properties with the surrounding context needed to locate them.

Use actual field names and enum values from the codebase. Do not invent fields that do not exist in the entity.
