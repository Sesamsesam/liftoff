---
name: beads-workflow
description: "Context persistence across AI sessions using Beads CLI. Never lose progress between conversations."
category: workflow
---

# Beads Workflow

## What Is This?
An optional extension that integrates the **Beads CLI** — a tool that saves your AI session context (decisions, progress, patterns) so future sessions pick up right where you left off. No more re-explaining your project to the agent.

## Why Does It Exist?
AI sessions are ephemeral — the agent forgets everything when the conversation ends. Beads solves this by persisting structured context that the next session can load automatically.

## What It Does For You
Your AI remembers decisions, discovered patterns, and open tasks from last time. When you start a new session, it picks up right where you left off — no re-explaining your project, no lost progress.

---

## Activation
- Enable in `~/.gemini/settings/extensions.json`: `"beads-workflow": true`
- The agent checks for Beads during Session Start (see `GEMINI.md`)

---

## Session Start Integration

When Beads is active, the agent runs at the start of every session:

```bash
bd ready
```

This loads any pending tasks, recent decisions, and project context from previous sessions.

## Session End Integration

Before ending a session, the agent syncs progress:

```bash
bd sync
```

This persists:
- What was accomplished
- Decisions made and their rationale
- Open tasks for next session
- Patterns discovered

## Commands Reference

| Command | What It Does |
|---|---|
| `bd ready` | Load context for current session |
| `bd sync` | Save session progress |
| `bd status` | Check what's tracked |
| `bd tasks` | List open tasks across sessions |
