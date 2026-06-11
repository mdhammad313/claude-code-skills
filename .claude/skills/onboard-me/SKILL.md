---
name: onboard-me
description: Generates a personalized onboarding guide for a new developer joining the project. Reads the codebase, git history, and config files to produce a structured guide covering architecture, key files, workflows, and gotchas.
context: fork
agent: Explore
disable-model-invocation: true
---

You are onboarding a new developer to this codebase. Your job is to explore the project thoroughly and produce a clear, practical onboarding guide — not a generic overview, but one grounded in what's actually in this repo.

## Step 1 — Explore the project

Do the following in order:
- Read `README.md` (if it exists)
- Read `CLAUDE.md` (if it exists)
- List the top-level directory structure
- Identify the tech stack from config files (`package.json`, `requirements.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc.)
- Find the 5–10 most frequently changed files using git log: `git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -20`
- Read the last 20 commit messages: `git log --oneline -20`
- Identify entry points (e.g., `main.py`, `index.ts`, `app.py`, `server.js`)
- Find any CI/CD config (`.github/workflows/`, `Dockerfile`, `docker-compose.yml`)

## Step 2 — Produce the onboarding guide

Write a structured guide with these sections:

### Project Overview
What does this project do? One paragraph, plain English.

### Tech Stack
List the languages, frameworks, and key libraries with one-line descriptions of why each is used.

### Architecture
How is the project structured? Describe the main directories and what lives where. Include a simple directory tree of the most important paths.

### Key Files to Know
List the 8–12 most important files a new dev should read first. For each, explain what it does and why it matters.

### How to Run It Locally
Step-by-step setup instructions based on what you find (README, Makefile, scripts, Docker, etc.).

### Common Workflows
What does a typical day look like? Cover:
- How to run tests
- How to make and submit a change
- Any important CLI commands or scripts

### Gotchas & Non-Obvious Things
List 3–5 things that would trip up a new developer that aren't obvious from the README. Base these on patterns you see in the code or config (e.g., env vars, unusual conventions, tricky dependencies).

### Who Owns What
Based on git blame and commit history, identify which areas of the codebase have the most activity and who the main contributors are (if git history is available).

---

Be specific. Use actual file names and paths from the repo. Do not make things up. If you cannot find something, say so.
