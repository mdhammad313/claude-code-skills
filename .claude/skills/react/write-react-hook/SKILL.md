---
name: write-react-hook
description: Writes a React custom hook when asked to create, add, or generate a hook, data fetching logic, or reusable stateful logic for a Next.js feature. Enforces the project's hook pattern — ApiResponse wrapper, loading/error states, Socket.IO real-time updates, and stable callback refs.
---

You are a senior React engineer. Your job is to write a production-quality custom hook that follows the project's established patterns in `lib/hooks/`.

## Phase 1 — Gather requirements

Ask the user for the following if not already provided:
- What data does this hook fetch or manage?
- Which API service function does it call? (from `lib/api/`)
- Does it need real-time Socket.IO updates?
- What filters or parameters does it accept?

If already described, skip asking and proceed.

## Phase 2 — Explore the codebase

Before writing:
- Read the relevant API service file in `lib/api/` to understand the data shape and `ApiResponse<T>` type
- Read one existing hook in `lib/hooks/` (e.g., `useProperties.ts` or `useClients.ts`) for the exact pattern
- Check if Socket.IO events are relevant — look for `socket.on('resource:updated', ...)` patterns in existing hooks

## Phase 3 — Write the hook

Write a complete `use*.ts` hook file following these rules:

### Return shape — always an object
- Return an object with named properties — never a tuple (array):
  ```ts
  return { data, loading, error, refetch }
  ```
- Always include: `data` (typed), `loading: boolean`, `error: string | null`, `refetch: () => void`
- Add extra actions as needed: `create`, `update`, `delete`, etc.

### Data fetching pattern
```ts
const fetchData = useCallback(async () => {
  if (!userId) {
    setLoading(false)
    return
  }
  try {
    setLoading(true)
    setError(null)
    const response = await getItems(filters)
    if (response.success && response.data) {
      setItems(response.data)
    } else {
      setError(response.error || 'Failed to fetch')
    }
  } catch (err) {
    setError(err instanceof Error ? err.message : 'An error occurred')
  } finally {
    setLoading(false)
  }
}, [userId])
```

### Ref rules — prevent stale closures
- Use `useRef` for values used inside callbacks that shouldn't trigger re-renders:
  ```ts
  const filtersRef = useRef(filters)
  const scopeRef = useRef(scope)
  ```
- Update refs in useEffect when values change — do NOT read props directly inside callbacks

### Socket.IO real-time updates
- Only add Socket.IO if the data needs real-time updates (not all hooks need this)
- Pattern:
  ```ts
  useEffect(() => {
    if (!userId) return
    const socket = io(socketUrl, {
      auth: { token: token || undefined },
      transports: ['websocket', 'polling'],
    })
    socket.on('resource:updated', (updated: Resource) => {
      if (updated.userId === userId) fetchData()
    })
    return () => { socket.disconnect() }
  }, [userId, fetchData])
  ```
- Always return a cleanup function that disconnects the socket

### TypeScript rules
- Define and export the data type alongside the hook if it doesn't already exist in `lib/api/`
- Explicitly type all state variables:
  ```ts
  const [items, setItems] = useState<Item[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  ```
- Define and export the hook's options type and return type:
  ```ts
  export interface UseItemsOptions {
    scope?: 'buyer' | 'seller'
  }
  export interface UseItemsResult {
    items: Item[]
    loading: boolean
    error: string | null
    refetch: () => void
  }
  ```

### userId pattern
- Always get `userId` from `useUserId()` context hook — never accept it as a prop
- Guard all fetches: `if (!userId) { setLoading(false); return }`

### Error rules
- NEVER return null for error state — use `string | null`
- Catch and convert all errors to strings — never let errors bubble unhandled
- Reset error to `null` at the start of every fetch

### Initial state
- `loading` starts as `true` (data is loading on mount)
- `error` starts as `null`
- `data` starts as `[]` for lists, `null` for single items

## Output format

Produce a single complete `use*.ts` file in `lib/hooks/`:
- All imports
- Exported type definitions
- The hook function
- No default export — named export only

---

Be specific. Use actual API function names from `lib/api/`, actual Socket.IO event names from the codebase, and actual context hooks like `useUserId`. Do not invent APIs that don't exist.
