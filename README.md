# Claude Code Skills

A collection of high-impact [Claude Code](https://claude.ai/code) skills for real developer workflows — not generic prompts, but structured playbooks that save hours.

## Why I built this

Every time I joined a new codebase I'd spend the first couple of hours just orienting — reading files, tracing entry points, figuring out how to run the thing locally. Every time I finished a PR I'd have to re-explain what I did to a PM in plain English. Every time I hit a tricky bug I'd reach for the same mental checklist. I got tired of doing the same thinking repeatedly. These skills encode that thinking once so Claude handles it every session.

## Skills

| Skill | What it does |
|---|---|
| [`/onboard-me`](#onboard-me) | Generates a personalized onboarding guide by reading your actual codebase |
| [`/rubber-duck`](#rubber-duck) | Structured debugging session that guides you to find the answer yourself |
| [`/explain-to-pm`](#explain-to-pm) | Translates your technical work into plain English for non-technical stakeholders |
| [`/tech-debt-radar`](#tech-debt-radar) | Scans your codebase and produces a prioritized, actionable tech debt map |

---

## Installation

### Install all skills

```bash
git clone https://github.com/mdhammad313/claude-code-skills.git
cp -r claude-code-skills/onboard-me ~/.claude/skills/
cp -r claude-code-skills/rubber-duck ~/.claude/skills/
cp -r claude-code-skills/explain-to-pm ~/.claude/skills/
cp -r claude-code-skills/tech-debt-radar ~/.claude/skills/
```

### Install a single skill

```bash
cp -r claude-code-skills/onboard-me ~/.claude/skills/
```

That's it. Open Claude Code and type `/onboard-me` to use it.

---

## Skills

### onboard-me

**What it does:** Reads your codebase — directory structure, git history, config files, entry points, CI/CD — and generates a personalized onboarding guide for a new developer joining the project.

**Output includes:**
- Project overview and tech stack
- Architecture and key files to read first
- How to run it locally (based on actual config found)
- Common workflows and CLI commands
- Gotchas and non-obvious things that would trip up a new dev

**Usage:**
```
/onboard-me
```

---

### rubber-duck

**What it does:** A structured rubber duck debugging session. Instead of jumping to solutions, it guides you through explaining your problem so clearly that you often find the answer yourself.

**How it works:**
1. Asks you to describe the goal, actual behavior, expected behavior, and what you've tried
2. Asks targeted follow-up questions one at a time
3. Reflects your problem back to you
4. Helps you generate and test hypotheses
5. Only offers its own analysis as a last resort

**Usage:**
```
/rubber-duck
```

---

### explain-to-pm

**What it does:** Takes your technical changes, decisions, or code and rewrites them in plain English for a product manager, executive, designer, or customer. Reads your recent git diff automatically if you don't provide context.

**Audience options:** PM, CEO, designer, customer, investor

**Usage:**
```
/explain-to-pm
```

---

### tech-debt-radar

**What it does:** Scans your entire codebase and produces a prioritized tech debt map — not just "here's bad code" but a scored, ranked list of what to fix first and why.

**Output includes:**
- Executive summary of overall codebase health
- Debt items scored by Impact (1–5) and Effort (1–5)
- Priority score (Impact ÷ Effort) so you know what to tackle first
- Quick Wins: high impact, low effort items to start with
- Watch List: high risk items that need planning
- Ignore List: things not worth fixing right now

**Categories:** Security · Performance · Maintainability · Test Coverage · Dependencies · Architecture · Dead Code

**Usage:**
```
/tech-debt-radar
```

---

## How Claude Code Skills Work

Skills are markdown files that teach Claude how to handle specific tasks — loaded once per session, triggered manually with `/skill-name` or automatically when relevant.

- Skills live in `~/.claude/skills/<skill-name>/SKILL.md`
- Skills marked `disable-model-invocation: true` only trigger when you explicitly type the command
- Skills marked `context: fork` run in an isolated subagent, keeping your main conversation clean

[Learn more about Claude Code Skills →](https://docs.anthropic.com/en/docs/claude-code/skills)

---

## Roadmap

Skills planned for future releases:

- `/standup-writer` — generates a daily standup update from your git activity and open PRs
- `/pr-reviewer` — reviews a PR for logic issues, edge cases, and code quality before you submit
- `/incident-summary` — turns a messy Slack thread or log dump into a structured incident report
- `/release-notes` — drafts release notes from merged PRs since the last tag

Have an idea? Open an issue.

---

## Contributing

Have a skill idea that would make this collection more useful? Open an issue or submit a PR.

Good skill candidates:
- Solves a real, recurring developer pain point
- Has structured output that's immediately actionable
- Works across different tech stacks (or is clearly scoped to one)

---

## License

MIT
