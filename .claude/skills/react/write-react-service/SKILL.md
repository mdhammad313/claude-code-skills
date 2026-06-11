---
name: write-react-service
description: Writes a React API service file when asked to create, add, or generate an API service, API module, or data fetching functions for a new backend endpoint. Enforces the lib/api/ pattern with ApiResponse wrapper, typed interfaces, and centralized api-client usage.
---

You are a senior React/Next.js engineer. Your job is to write a production-quality API service file following the established pattern in `lib/api/`.

## Phase 1 — Gather requirements

Ask the user for the following if not already provided:
- What resource does this service manage? (e.g., documents, offers, showings)
- What backend endpoints exist for it? (GET, POST, PUT, PATCH, DELETE)
- What fields does the resource have?
- Any filters or query parameters for list endpoints?

If already described, skip asking and proceed.

## Phase 2 — Explore the codebase

Before writing:
- Read `lib/api-client.ts` to understand `apiGet`, `apiPost`, `apiPut`, `apiPatch`, `apiDelete`, and the `ApiResponse<T>` type
- Read one existing service file in `lib/api/` (e.g., `properties.ts` or `documents.ts`) for the exact pattern
- Check `lib/api/` index file to understand how services are exported

## Phase 3 — Write the service

Write a complete `*.ts` service file in `lib/api/` following these rules:

### ApiResponse wrapper — always
- Every function MUST return `Promise<ApiResponse<T>>` — never return raw data or throw directly:
  ```ts
  export async function getDocuments(
    filters?: DocumentFilters,
    includeUserId: boolean = true
  ): Promise<ApiResponse<Document[]>> {
    return apiGet<Document[]>('/documents', filters, includeUserId)
  }
  ```
- Import `ApiResponse` and the api helpers from `../api-client`

### Interface definitions — always define them here
- Define the resource interface in this file — not in the component or hook:
  ```ts
  export interface Document {
    id: number
    title: string
    type: number          // integer enum, not string
    status: number        // integer enum, not string
    userId: number
    createdAt: string
    updatedAt: string
  }
  ```
- Define a separate filters interface for list endpoints:
  ```ts
  export interface DocumentFilters {
    userId?: number
    type?: number
    status?: number
    limit?: number
    offset?: number
    orderBy?: string
    order?: 'ASC' | 'DESC'
  }
  ```
- Define a separate create/update payload type:
  ```ts
  export interface CreateDocumentPayload {
    title: string
    type: number
    file: File
  }
  ```

### Enum types — integers, not strings
- NEVER type status/type fields as `string` in interfaces
- Use `number` with a comment or co-located numeric enum:
  ```ts
  export enum DocumentType {
    PASSPORT = 1,
    DRIVERS_LICENSE = 2,
    UTILITY_BILL = 3,
  }
  
  export enum DocumentStatus {
    PENDING = 1,
    APPROVED = 2,
    REJECTED = 3,
  }
  ```

### Function naming
- List: `getDocuments(filters?)`
- Single: `getDocument(id: number)`
- Create: `createDocument(payload: CreateDocumentPayload)`
- Update: `updateDocument(id: number, payload: UpdateDocumentPayload)`
- Delete: `deleteDocument(id: number)`
- Use domain-specific names when appropriate: `submitDocument`, `approveDocument`

### includeUserId parameter
- List and get functions that are user-scoped should accept `includeUserId: boolean = true`
- Pass it through to `apiGet` — the api-client handles injecting the user ID

### Error handling — do NOT catch in service files
- Service functions do NOT catch errors — they let `ApiResponse` carry the error
- Errors are caught by the api-client and returned as `{ success: false, error: string }`
- Never add try/catch blocks in service files

### FormData uploads
- For file upload endpoints, accept `FormData` directly and pass `Content-Type: multipart/form-data`:
  ```ts
  export async function uploadDocument(
    formData: FormData
  ): Promise<ApiResponse<Document>> {
    return apiPost<Document>('/documents/upload', formData)
  }
  ```
- The api-client handles FormData detection and sets the correct headers

## Output format

Produce a single complete `*.ts` file in `lib/api/`:
- Imports at top
- Enum definitions (if new enums are needed)
- Interface definitions (resource, filters, payloads)
- Exported async functions
- No default export — named exports only

Also note if the new service should be added to `lib/api/index.ts` for re-export.

---

Be specific. Use the exact `apiGet`, `apiPost`, `apiPut`, `apiPatch`, `apiDelete` function names from `api-client.ts`. Match the patterns in existing service files exactly.
