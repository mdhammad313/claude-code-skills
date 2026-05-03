# Project Context

## What this repo is

A collection of Claude Code skills for real developer workflows, built to be open-sourced and promoted via a LinkedIn video. The goal is to get developers to star and fork the repo.

## Skills built (all in `.claude/skills/` or installable from repo root)

| Skill | File | What it does |
|---|---|---|
| `/onboard-me` | `onboard-me/SKILL.md` | Reads the codebase + git history and generates a personalized dev onboarding guide |
| `/rubber-duck` | `rubber-duck/SKILL.md` | 5-phase structured debugging session — guides you to find the answer yourself |
| `/explain-to-pm` | `explain-to-pm/SKILL.md` | Translates technical changes into plain English for PMs, execs, designers |
| `/tech-debt-radar` | `tech-debt-radar/SKILL.md` | Scans codebase, scores debt by Impact ÷ Effort, produces prioritized action plan |

## LinkedIn video plan

- **Format:** Screen recording, 60–90 seconds, casual tone
- **Hero demo:** `/onboard-me` — clone an unfamiliar repo, type one command, get a full guide
- **Script + shot list:** `video-script.md`
- **LinkedIn caption + pinned comment:** also in `video-script.md`

## What's done

- [x] All 4 `SKILL.md` files written
- [x] `README.md` with install instructions + per-skill docs
- [x] `video-script.md` with full script, caption, and comment copy
- [x] Git repo initialized (`git init`, files staged)

## What's next

- [ ] Push to GitHub (create repo, add remote, push)
- [ ] Add demo GIFs to README for each skill (big driver of stars)
- [ ] Record the LinkedIn video using `video-script.md`
- [ ] Post video + pin comment with GitHub link

## Install command (for README / video)

```bash
git clone https://github.com/mdhammad313/claude-code-skills.git
cp -r claude-code-skills/onboard-me ~/.claude/skills/
```

## Skill design decisions

- `onboard-me` and `tech-debt-radar` use `context: fork` + `agent: Explore` so they run in an isolated subagent — keeps main conversation clean
- All 4 skills use `disable-model-invocation: true` — only triggered manually, never auto-invoked, because they have side effects or are user-initiated workflows
- No frameworks, no dependencies — pure markdown files anyone can drop into `~/.claude/skills/`
