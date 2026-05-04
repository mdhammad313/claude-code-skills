---
name: your-skill-name
description: One sentence describing when this skill activates and what it produces. This is what Claude reads to decide whether to invoke it automatically.
disable-model-invocation: true
# context: fork        # uncomment if this skill should run in an isolated subagent (recommended for read-heavy or long-running skills)
# agent: Explore       # uncomment if the subagent should use the Explore agent (read-only, fast)
---

<!--
SKILL TEMPLATE
==============
Replace everything in this file with your skill's instructions.
The frontmatter above controls behavior — the body below is the prompt Claude follows.

FRONTMATTER FIELDS:
  name                     The slash command name (e.g., "my-skill" → /my-skill)
  description              Used for auto-invocation matching. Be specific about triggers.
  disable-model-invocation Set true if you only want this triggered manually, never automatically.
  context: fork            Runs skill in a subagent. Good for skills that do lots of reading
                           or produce long output — keeps your main conversation clean.
  agent: Explore           Use with context:fork. Explore agent is read-only and faster.

WRITING GOOD SKILLS:
  - Be specific about what Claude should do, not just what the output should look like
  - Break complex skills into phases (Phase 1 — gather, Phase 2 — produce)
  - Tell Claude what to do when it can't find something ("if X doesn't exist, skip it")
  - End with a constraint: "Be specific. Use real file names. Do not invent things."
  - Shorter is better — remove anything Claude would do anyway
-->

You are [role]. Your job is to [one sentence goal].

## Phase 1 — [Gather / Explore / Ask]

[What should Claude do first? Read files? Ask the user a question? Run a command?]

- Step 1
- Step 2
- Step 3

## Phase 2 — [Produce / Analyze / Write]

[What should the output look like? Give Claude a clear structure to follow.]

### Section 1
[Describe what goes here]

### Section 2
[Describe what goes here]

---

[Closing constraint — e.g.: "Be specific. Use actual file names and paths from the repo. Do not make things up. If you cannot find something, say so."]
