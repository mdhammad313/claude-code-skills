# CLAUDE.md Templates

`CLAUDE.md` is a file you put at the root of your project. Claude reads it at the start of every session — it's how you tell Claude your stack, your conventions, your commands, and what never to do. A good `CLAUDE.md` means you stop re-explaining yourself every session.

These templates are starting points. Pick the one closest to your stack, drop it in your project root, and fill in the blanks.

## Templates

| Stack | File | What it covers |
|---|---|---|
| **Base** | [`base/CLAUDE.md`](base/CLAUDE.md) | Generic starter for any project |
| **Next.js** | [`nextjs/CLAUDE.md`](nextjs/CLAUDE.md) | App Router, TypeScript, Tailwind, Prisma |
| **Django** | [`django/CLAUDE.md`](django/CLAUDE.md) | Django REST Framework, migrations, apps |
| **Rails** | [`rails/CLAUDE.md`](rails/CLAUDE.md) | MVC, ActiveRecord, Sidekiq, RSpec |
| **Express** | [`express/CLAUDE.md`](express/CLAUDE.md) | TypeScript, Prisma, Zod validation |
| **Monorepo** | [`monorepo/CLAUDE.md`](monorepo/CLAUDE.md) | pnpm workspaces, Turborepo, shared packages |

## Usage

```bash
# Copy a template to your project root
cp claude-code-skills/claude-md-templates/nextjs/CLAUDE.md your-project/CLAUDE.md
```

Then open it and fill in:
- The one-sentence project description at the top
- Your actual stack versions
- The exact commands that work in your project
- Any conventions or rules specific to your codebase

## What makes a good CLAUDE.md

**Commands are the most important section.** Claude runs tests, lints, and builds constantly. If those commands are wrong, everything breaks. Always verify these are accurate.

**Conventions should reflect YOUR project.** Don't leave generic placeholders — the value comes from specificity. "Use named exports" is useful. "Follow best practices" is useless.

**"Never do" is surprisingly powerful.** A short blocklist prevents Claude from making the same class of mistake repeatedly. Think about the last 3 things Claude did that annoyed you — most of them can be prevented with one line here.

**Keep it under 150 lines.** Claude reads the whole file every session. Long CLAUDE.md files get ignored. If it's growing, you're probably documenting things Claude should just infer from the code.
