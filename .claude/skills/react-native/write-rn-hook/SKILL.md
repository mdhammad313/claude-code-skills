---
name: write-rn-hook
description: Writes a React Native custom hook when asked to create, add, or generate a hook, data fetching logic, or reusable stateful logic for the mobile app. Enforces mounted-flag cleanup, ApiResponse pattern, typed return interfaces, and Socket.IO integration when needed.
---

You are a senior React Native engineer. Your job is to write a production-quality custom hook following the established patterns in `src/hooks/`.

## Phase 1 — Gather requirements

Ask the user for the following if not already provided:
- What data or logic does this hook manage?
- Which API service does it call? (from `src/api/`)
- Does it need real-time Socket.IO updates?
- What options/parameters should it accept?

If already described, skip asking and proceed.

## Phase 2 — Explore the codebase

Before writing:
- Read the relevant API service file in `src/api/` for data types
- Read one existing hook in `src/hooks/` (e.g., `useTasks.ts` or `useShowings.ts`) for the exact pattern
- Check `src/api/httpClient.ts` for the `ApiResponse<T>` type
- Check `contexts/` for the auth context to understand how to get the current user

## Phase 3 — Write the hook

Write a complete `use*.ts` hook file following these rules:

### Return interface — always defined and exported
- Always define and export an interface for what the hook returns:
  ```ts
  export interface UseTasksResult {
    tasks: Task[]
    loading: boolean
    error: string | null
    fetchTasks: () => Promise<void>
    createTask: (payload: CreateTaskPayload) => Promise<boolean>
  }
  ```
- Return an object — never a tuple (array)
- Always include: `loading: boolean`, `error: string | null`

### Options interface — always defined and exported
  ```ts
  export interface UseTasksOptions {
    transactionId?: number
    autoFetch?: boolean
    useSocket?: boolean
  }
  
  export function useTasks(options: UseTasksOptions = {}): UseTasksResult {
    const { transactionId, autoFetch = true, useSocket = true } = options
  ```

### Mounted flag — mandatory for all async operations
- EVERY useEffect with async work must use a mounted flag to prevent state updates on unmounted components:
  ```ts
  useEffect(() => {
    let isMounted = true
    
    const load = async () => {
      const result = await tasksApi.getTasks()
      if (isMounted) {
        if (result.success && result.data) {
          setState(prev => ({ ...prev, tasks: result.data!, loading: false }))
        } else {
          setState(prev => ({ ...prev, error: result.error ?? 'Failed', loading: false }))
        }
      }
    }
    
    if (autoFetch) load()
    return () => { isMounted = false }
  }, [transactionId, autoFetch])
  ```

### safeSetState pattern — for complex hooks
- Use a single state object and a safe setter that checks mounted:
  ```ts
  const mountedRef = useRef(true)
  
  useEffect(() => {
    return () => { mountedRef.current = false }
  }, [])
  
  const safeSetState = useCallback((updates: Partial<HookState>) => {
    if (mountedRef.current) {
      setState(prev => ({ ...prev, ...updates }))
    }
  }, [])
  ```

### Stable callbacks — useCallback for all async functions
  ```ts
  const fetchTasks = useCallback(async () => {
    safeSetState({ loading: true, error: null })
    const result = await tasksApi.getTasks({ transactionId })
    if (result.success && result.data) {
      safeSetState({ tasks: result.data, loading: false })
    } else {
      safeSetState({ error: result.error ?? 'Failed to load tasks', loading: false })
    }
  }, [transactionId, safeSetState])
  ```

### Socket.IO integration — only when needed
  ```ts
  useEffect(() => {
    if (!useSocket || !transactionId) return
    
    const cleanup = SocketService.on('tasks:updated', (data) => {
      if (data.transactionId === transactionId) fetchTasks()
    })
    
    return cleanup
  }, [useSocket, transactionId, fetchTasks])
  ```

### TypeScript rules
- Explicitly type ALL state:
  ```ts
  interface HookState {
    tasks: Task[]
    loading: boolean
    error: string | null
  }
  
  const [state, setState] = useState<HookState>({
    tasks: [],
    loading: true,
    error: null,
  })
  ```
- No implicit `any` — type all API results, callback params, and return values
- Use `useRef<boolean>` for mounted flag, not a raw variable

### Error handling
- NEVER let errors go unhandled — always catch and convert to string
- Reset error to `null` at the start of every fetch
- Return empty arrays, never null, for list data

### Auth
- Get user from `useAuth()` context — never accept user/userId as hook parameters
- Guard fetches: if no user, set loading to false and return early

## Output format

Produce a single complete `use*.ts` file:
- All imports
- Exported interfaces (options, state, result)
- The hook function
- Named export only (no default export)

---

Be specific. Use actual API function names from `src/api/`, actual Socket.IO event names from `src/services/SocketService.ts`, and actual context hooks. Do not invent APIs or events that don't exist.
