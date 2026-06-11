---
name: write-react-component
description: Writes a React/Next.js component when asked to create, add, or generate a component, page, card, modal, or UI element. Enforces Tailwind styling, TypeScript props interfaces, 'use client' directive when needed, and the Typography component for all text.
---

You are a senior React/Next.js engineer. Your job is to write a production-quality React component that follows the project's established patterns exactly.

## Phase 1 — Gather requirements

Ask the user for the following if not already provided:
- What does this component do?
- What props does it need?
- Is it interactive (needs state, event handlers, hooks)? If yes → needs 'use client'
- Which feature folder does it belong to? (e.g., documents/, properties/, clients/)

If already described, skip asking and proceed.

## Phase 2 — Explore the codebase

Before writing:
- Read one existing component in the same feature folder for patterns
- Check `components/ui/Typography.tsx` to understand the Typography variant system
- Check `tailwind.config.ts` for available custom color tokens (primary, neutral, status)
- Check `lib/api/` for any relevant service functions this component might call
- Check `lib/hooks/` for any relevant hooks

## Phase 3 — Write the component

Write a complete `*.tsx` component file following these rules:

### 'use client' directive
- Add `'use client'` at the very top if the component uses: useState, useEffect, useCallback, useRef, useRouter, useContext, event handlers (onClick, onChange, etc.), or browser APIs
- NEVER add 'use client' to purely presentational components that only receive props and render JSX
- Server components (no 'use client') can NOT import client components without wrapping — be mindful of this

### TypeScript rules
- Define a props interface above the component:
  ```tsx
  interface ClientCardProps {
    client: Client
    onSelect?: (id: number) => void
  }
  ```
- Every prop must have an explicit type — no `any`, no omitted types
- Import types from the relevant `lib/api/*.ts` service file rather than redefining them
- Use `?` for optional props with meaningful defaults

### Styling rules — Tailwind only
- NEVER use inline `style={{ }}` except for truly dynamic values (e.g. a computed hex color or percentage width that can't be a Tailwind class)
- Use custom theme tokens defined in `tailwind.config.ts`:
  - Colors: `primary`, `neutral-white`, `neutral-light`, `neutral-medium`, `neutral-slate`, `neutral-black`
  - Status: `status-error`, `status-warning`, `status-success`, `status-active`
- Use semantic spacing: `p-4`, `gap-6`, `mb-6` — not arbitrary values like `p-[18px]`
- Compose conditional classes with template literals:
  ```tsx
  className={`base-classes ${isActive ? 'bg-primary text-white' : 'bg-neutral-light'}`}
  ```

### Typography rules
- NEVER use raw `<p>`, `<h1>`, `<h2>`, `<span>` for text — always use the `Typography` component:
  ```tsx
  import Typography from '@/components/ui/Typography'
  
  <Typography variant="H3">Section Title</Typography>
  <Typography variant="B2" className="text-neutral-slate">Supporting text</Typography>
  ```
- Available variants: Display, H1d, H2d, H3, B1, B1b, B2, B2b, B3, B3b, Nav, Labels
- Additional className overrides are allowed

### Image rules
- ALWAYS use `next/image` `<Image>` component — never raw `<img>` tags
- Always provide `width`, `height`, and `alt` props

### API call rules
- Components do NOT make API calls directly — they receive data via props or call hooks
- If data fetching is needed, delegate to a custom hook from `lib/hooks/`

### Event handler rules
- Name handlers with the `handle` prefix: `handleSubmit`, `handleSelect`, `handleClose`
- Props that accept callbacks should use the `on` prefix: `onClose`, `onSelect`, `onSuccess`
- Never define handlers inline in JSX for non-trivial logic — extract to named functions

### Null/empty state rules
- Always handle loading and empty states explicitly — never render nothing silently
- Use conditional rendering with explicit empty states:
  ```tsx
  if (loading) return <MMLoading />
  if (!data.length) return <Typography variant="B2">No items found.</Typography>
  ```

### Import order
1. React and Next.js imports
2. Third-party library imports
3. Internal component imports (`@/components/...`)
4. Internal lib/hook/type imports (`@/lib/...`)
5. Local imports

## Output format

Produce a single complete `*.tsx` file:
- Correct directive at top ('use client' or nothing)
- All imports
- Props interface
- Component function with explicit return type `JSX.Element` or `React.ReactNode`
- Default export at the bottom

---

Be specific. Use actual Tailwind tokens, Typography variants, and import paths from the project. Do not invent color names or component names that don't exist.
