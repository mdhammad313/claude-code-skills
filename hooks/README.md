# Claude Code Hooks

Hooks are shell commands that run automatically when Claude Code events fire — before or after tool calls, on notifications, when Claude stops. No prompt needed, no manual trigger. Claude does the work; the hook reacts.

## How hooks work

Add hooks to `.claude/settings.json` in your project (project-scoped) or `~/.claude/settings.json` (global, all projects):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "your shell command here"
          }
        ]
      }
    ]
  }
}
```

**Hook events:**

| Event | When it fires | Can block? |
|---|---|---|
| `PreToolUse` | Before Claude calls a tool | Yes — exit non-zero to block |
| `PostToolUse` | After Claude calls a tool | No |
| `Notification` | When Claude sends a notification | No |
| `Stop` | When Claude stops responding | No |

**The `matcher`** is a regex matched against the tool name (`Bash`, `Write`, `Edit`, `Read`, etc.).

**Blocking with PreToolUse:** If your hook exits non-zero, Claude sees the stdout as an error message and does not run the tool. Use this to enforce guardrails.

---

## Hook examples

### 1. Auto-format files after Claude edits them

Runs Prettier on any file Claude writes or edits. Falls back silently if Prettier isn't installed.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write \"$(echo $CLAUDE_TOOL_INPUT | jq -r '.file_path // .path // empty')\" 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

**Adapt it:** Replace `npx prettier` with `black`, `gofmt`, `rustfmt`, or whatever formatter your stack uses.

---

### 2. Block force-push to protected branches

Intercepts `git push --force` (or `--force-with-lease`) before it runs. Claude sees the error message and stops.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "cmd=$(echo $CLAUDE_TOOL_INPUT | jq -r '.command // empty'); if echo \"$cmd\" | grep -qE 'git push.*(--force|-f)'; then echo 'Blocked: force-push is not allowed. Use a regular push or ask the user to confirm.'; exit 1; fi"
          }
        ]
      }
    ]
  }
}
```

---

### 3. Run tests after Claude writes files

Triggers your test suite whenever Claude edits a source file. Keeps Claude honest — if it breaks tests, it knows immediately.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm test --silent 2>&1 | tail -5 || true"
          }
        ]
      }
    ]
  }
}
```

**Adapt it:** Replace `npm test` with `pytest -q`, `go test ./...`, `cargo test`, etc.

---

### 4. Desktop notification when Claude finishes

Fires when Claude stops responding — useful for long tasks so you don't have to watch the terminal.

**macOS:**
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude is done\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

**Linux (notify-send):**
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "notify-send 'Claude Code' 'Claude is done'"
          }
        ]
      }
    ]
  }
}
```

---

### 5. Audit log — record every Bash command Claude runs

Writes a timestamped log of every shell command Claude executes to `~/.claude/audit.log`. Useful for reviewing what Claude did in a long session.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"[$(date '+%Y-%m-%d %H:%M:%S')] $(echo $CLAUDE_TOOL_INPUT | jq -r '.command // empty')\" >> ~/.claude/audit.log"
          }
        ]
      }
    ]
  }
}
```

View the log: `cat ~/.claude/audit.log`

---

### 6. Block rm -rf

Prevents Claude from running destructive delete commands without an explicit stop.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "cmd=$(echo $CLAUDE_TOOL_INPUT | jq -r '.command // empty'); if echo \"$cmd\" | grep -qE 'rm\\s+-[a-z]*r[a-z]*f|rm\\s+-[a-z]*f[a-z]*r'; then echo 'Blocked: rm -rf requires explicit user confirmation. Ask the user before deleting recursively.'; exit 1; fi"
          }
        ]
      }
    ]
  }
}
```

---

## Combining hooks

All examples above can live in the same `settings.json`. Stack them under the same event key:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "..." }] },
      { "matcher": "Bash", "hooks": [{ "type": "command", "command": "..." }] }
    ],
    "PostToolUse": [
      { "matcher": "Write|Edit", "hooks": [{ "type": "command", "command": "..." }] }
    ],
    "Stop": [
      { "matcher": "", "hooks": [{ "type": "command", "command": "..." }] }
    ]
  }
}
```

---

## Tips

- Keep hook commands fast — they run synchronously and block Claude if slow
- Use `|| true` on PostToolUse hooks to prevent noise from non-fatal errors
- Test hooks manually in your terminal before adding them to settings
- Use project-scoped `.claude/settings.json` for team hooks, global `~/.claude/settings.json` for personal ones
- `jq` is required for hooks that parse tool input — install it with `brew install jq` or `apt install jq`

[Learn more about Claude Code Hooks →](https://docs.anthropic.com/en/docs/claude-code/hooks)
