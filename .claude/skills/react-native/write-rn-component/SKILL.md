---
name: write-rn-component
description: Writes a React Native reusable component when asked to create, add, or generate a component, card, button, input, or UI element for the mobile app. Enforces props interfaces, globalStyles tokens, StyleSheet usage, and callback-prop patterns.
---

You are a senior React Native engineer. Your job is to write a production-quality reusable component following the established patterns in the `components/` directory.

## Phase 1 — Gather requirements

Ask the user for the following if not already provided:
- What does this component render?
- What props does it need?
- Is it purely presentational, or does it need internal state?
- Which feature area does it belong to? (or is it a shared/common component?)

If already described, skip asking and proceed.

## Phase 2 — Explore the codebase

Before writing:
- Read one existing component in the same feature folder or `components/` root for patterns
- Read `styles/globalStyles.ts` for available `colors`, `spacing`, `typography`, `shadows` tokens
- Check if a similar component already exists to avoid duplication

## Phase 3 — Write the component

Write a complete `*.tsx` component file following these rules:

### Props interface — always defined and exported
- Define and export the props interface above the component:
  ```tsx
  export interface AvatarButtonProps {
    onPress: () => void
    size?: number
    showBorder?: boolean
  }
  ```
- Every prop must be explicitly typed — no `any`
- Optional props must have a default value in the destructuring:
  ```tsx
  export default function AvatarButton({ onPress, size = 36, showBorder = true }: AvatarButtonProps)
  ```

### Styling rules — StyleSheet only
- NEVER use inline styles in JSX — use `StyleSheet.create({})` at the bottom of the file
- ALWAYS use tokens from `globalStyles.ts`:
  ```tsx
  import { colors, spacing, typography } from '@/styles/globalStyles'
  
  const styles = StyleSheet.create({
    container: {
      borderRadius: 8,
      backgroundColor: colors.white,
      padding: spacing.md,
      ...shadows.floatingSm,
    },
  })
  ```
- Dynamic styles (e.g. a size prop) go in the JSX via style array:
  ```tsx
  style={[styles.avatar, { width: size, height: size, borderRadius: size / 2 }]}
  ```

### Callback props — never internal navigation
- Reusable components do NOT navigate directly — they call `onPress` callbacks:
  ```tsx
  // ❌ Wrong — component decides navigation
  const handlePress = () => navigation.navigate('Details', { id })
  
  // ✓ Correct — parent decides what happens
  export interface CardProps {
    onPress: (id: number) => void
  }
  ```
- Internal navigation is only acceptable for self-contained modal components

### Context usage
- Components CAN use context hooks (`useAuth`, `useRole`) for global state
- Components should NOT accept `userId` or `user` as props if it's available from context

### TouchableOpacity vs Pressable
- Use `TouchableOpacity` for simple press actions (buttons, cards)
- Use `Pressable` when you need pressed state styling or more complex interaction

### FlatList inside components
- NEVER use `map()` to render lists — always `FlatList` with `keyExtractor`:
  ```tsx
  <FlatList
    data={items}
    keyExtractor={(item) => item.id.toString()}
    renderItem={({ item }) => <ItemCard item={item} />}
  />
  ```

### Empty and loading states
- Components that receive data props should handle empty gracefully:
  ```tsx
  if (!items.length) {
    return <Text style={styles.emptyText}>No items available.</Text>
  }
  ```

### TypeScript rules
- No implicit `any`
- Export the props interface so parent components can use it for typing

## Output format

Produce a single complete `*.tsx` component file:
- All imports
- Exported props interface
- Component function with default export
- `StyleSheet.create({})` at the bottom

---

Be specific. Use actual color and spacing tokens from `globalStyles.ts`. Do not hardcode hex values or pixel sizes that should come from the design tokens.
