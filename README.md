<div align="center">

# ⚡ Claude Code Skills

### Stop re-explaining yourself to Claude every session.

Skills · Hooks · CLAUDE.md Templates — encode your workflow once, Claude follows it forever.

<br>

[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)
[![Stars](https://img.shields.io/github/stars/mdhammad313/claude-code-skills?style=for-the-badge&color=yellow&logo=github)](https://github.com/mdhammad313/claude-code-skills/stargazers)
[![Skills](https://img.shields.io/badge/Skills-4-orange?style=for-the-badge)]()
[![Hooks](https://img.shields.io/badge/Hooks-6-purple?style=for-the-badge)]()
[![Templates](https://img.shields.io/badge/CLAUDE.md_Templates-6-green?style=for-the-badge)]()

<br>

<!-- Add your demo GIF here — 15–30s of /onboard-me running on a real repo works best -->

<br>

</div>

---

## Why I built this

Every time I joined a new codebase I'd spend the first couple of hours just orienting — reading files, tracing entry points, figuring out how to run the thing. Every time I finished a PR I'd re-explain it to a PM in plain English. Every time I hit a bug I'd reach for the same mental checklist.

I got tired of doing the same thinking repeatedly. These tools encode that thinking once, so Claude handles it every session.

---

## 📋 Example outputs

Not sure what you'll get? See real skill output on a production codebase:

- [`/onboard-me` on cal.com →](examples/onboard-me-output.md)
- [`/tech-debt-radar` on cal.com →](examples/tech-debt-radar-output.md)

---

## 🚀 Install

```bash
curl -fsSL https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master/install.sh | bash
```

Open Claude Code in any project and type a slash command. That's it.

---

## 🛠 Skills

Skills are slash commands you type in Claude Code. Each one runs a structured, multi-step workflow — not a one-shot prompt, but a playbook that produces consistent, actionable output every time.

<br>

### `/onboard-me`

> You just cloned a repo you've never seen.

Type `/onboard-me` and Claude reads the actual codebase — directory structure, git history, config files, entry points, CI/CD — and produces a personalized onboarding guide in under a minute.

**Output:** project overview · tech stack · architecture map · key files to read first · how to run it locally · gotchas that would trip up a new dev

```
/onboard-me
```

---

### `/rubber-duck`

> You're stuck on a bug and can't figure out why.

Claude doesn't hand you an answer. It guides you through explaining the problem so clearly that you usually find the fix yourself — 5 phases, one question at a time.

**Phases:** set the stage → go deeper → reflect back → generate hypotheses → last resort analysis

```
/rubber-duck
```

---

### `/explain-to-pm`

> You finished a PR. Now you have to explain it to someone who doesn't read code.

`/explain-to-pm` reads your recent `git diff` automatically and rewrites the change in plain English — tailored to whoever needs to hear it.

**Audience options:** PM · CEO · designer · customer · investor

```
/explain-to-pm
```

---

### `/tech-debt-radar`

> You know the codebase has problems. You don't know where to start.

Every debt item gets scored by Impact (1–5) and Effort (1–5). Priority = Impact ÷ Effort. You always know what to fix first.

**Output:** executive summary · ranked debt items · quick wins · watch list · ignore list

**Categories:** Security · Performance · Maintainability · Test Coverage · Dependencies · Architecture · Dead Code

```
/tech-debt-radar
```

---

## ⚡ Hooks

Hooks are shell commands that fire automatically on Claude Code events — before or after tool calls, when Claude stops, on notifications. Configure once in `.claude/settings.json` and forget about them.

| Hook | Trigger | What it does |
|---|---|---|
| **Auto-format** | After every file edit | Runs Prettier / Black on the changed file |
| **Block force-push** | Before any Bash command | Intercepts `git push --force` before it runs |
| **Test on save** | After every file write | Triggers your test suite automatically |
| **Desktop notification** | When Claude stops | Alerts you when a long task finishes |
| **Audit log** | After every Bash command | Logs every shell command Claude runs |
| **Block `rm -rf`** | Before any Bash command | Prevents destructive deletes without confirmation |

[See all hook examples with copy-paste config →](hooks/README.md)

---

## 📄 CLAUDE.md Templates

`CLAUDE.md` sits at the root of your project. Claude reads it at the start of every session — your stack, your commands, your conventions, what never to do. Write it once and Claude behaves correctly in that project forever.

Pick your stack and run from your project root:

```bash
# Next.js
curl -fsSL https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master/claude-md-templates/nextjs/CLAUDE.md -o CLAUDE.md

# Django
curl -fsSL https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master/claude-md-templates/django/CLAUDE.md -o CLAUDE.md

# Rails
curl -fsSL https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master/claude-md-templates/rails/CLAUDE.md -o CLAUDE.md

# Express / Node.js
curl -fsSL https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master/claude-md-templates/express/CLAUDE.md -o CLAUDE.md

# Monorepo
curl -fsSL https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master/claude-md-templates/monorepo/CLAUDE.md -o CLAUDE.md

# Generic starter
curl -fsSL https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master/claude-md-templates/base/CLAUDE.md -o CLAUDE.md
```

Open the file, fill in your commands and conventions, and you're done.

[See all templates →](claude-md-templates/README.md)

---

## 🧩 How Claude Code Skills work

Skills are markdown files in `~/.claude/skills/<skill-name>/SKILL.md`. Claude loads them at session start. Trigger them manually with `/skill-name`.

| Flag | What it does |
|---|---|
| `disable-model-invocation: true` | Only triggers when you type the command — never auto-invoked |
| `context: fork` | Runs in an isolated subagent, keeping your main conversation clean |
| `agent: Explore` | Uses a read-only agent for fast, non-destructive exploration |

[Learn more about Claude Code Skills →](https://docs.anthropic.com/en/docs/claude-code/skills)

---

## 🔨 Build your own skill

Copy [`TEMPLATE/SKILL.md`](TEMPLATE/SKILL.md) to `~/.claude/skills/your-skill-name/SKILL.md`.

A skill is just a markdown file — no code, no dependencies, no build step.

---

## 🗺 Roadmap

| Skill | What it will do |
|---|---|
| `/standup-writer` | Generate a standup update from your git activity and open PRs |
| `/pr-reviewer` | Full code review before you submit — logic gaps, edge cases, quality |
| `/incident-summary` | Turn a Slack thread or log dump into a structured incident report |
| `/release-notes` | Draft release notes from merged PRs since the last tag |

Have an idea? [Open an issue →](https://github.com/mdhammad313/claude-code-skills/issues)

---

## 🤝 Contributing

Use [`TEMPLATE/SKILL.md`](TEMPLATE/SKILL.md) as your starting point and open a PR.

Good skill candidates: solves a real recurring pain point · structured output · works across stacks.

---

<div align="center">

MIT License · Built for developers who use Claude Code seriously

[⭐ Star this repo](https://github.com/mdhammad313/claude-code-skills) if it saves you time

</div>
