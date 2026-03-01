---
name: beads-workflow
description: "Context persistence across AI sessions using Beads CLI. Never lose progress between conversations."
---

# Beads Workflow

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?

Every new AI conversation starts with a blank slate. Beads gives the agent **persistent memory** - it tracks tasks, decisions, and progress in a structured graph inside your project. Next session, one command loads everything back.

> **Heads up for beginners:** This extension uses a CLI (command-line tool), where you type commands instead of clicking buttons. Don't worry - the agent runs these commands for you. You just need to install it once.

## Why Does It Exist?

Without Beads, you waste 10-15 minutes re-explaining your project each session. The agent forgets decisions, loses track of tasks, and asks the same questions twice. Worse, if you had a long planning session with many side quests, the agent might deprioritize earlier context and miss things when you ask for a summary.

Beads solves this by persisting structured context - not a text dump, but a dependency-aware task graph with history, rationale, and progress tracking.

## Before vs After

**Without Beads:**
```
Session 1: "Build the user auth system"
  Agent: *builds it perfectly*

Session 2: "Continue working on the app"
  Agent: "What app? What auth system? Let me look around first..."
  You: *spends 15 minutes re-explaining*

Session 3: "We decided to use JWT tokens, remember?"
  Agent: "Let me check... can you point me to where?"
```

**With Beads:**
```
Session 2: "Continue working on the app"
  Agent: *runs bd ready*
  Agent: "Welcome back. Last session we completed JWT auth.
         Open tasks: dashboard UI (P0), email verification (P1).
         Ready to continue with the dashboard?"
```

One command. Full context. No re-explaining.

## What It Does For You

Session start: agent runs `bd ready` and picks up where you left off. Session end: agent runs `bd sync` to save progress. You just build.

---

## TL;DR Setup (macOS)

```bash
brew install beads       # 1. Install (need Homebrew? See the Homebrew skill)
cd your-project          # 2. Go to your project folder
bd init                  # 3. Initialize Beads in your project
```

Done. The agent handles `bd ready` / `bd sync` automatically from here.

> Windows/Linux or other install methods? See full setup below.

<!-- ═══════════════════════════════════════════════════ -->
<!-- SETUP & CONFIGURATION                              -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Activation
- Enable in `~/.gemini/extensions/extensions.json`: `"beads-workflow": true`
- The agent checks for Beads during Session Start (see `GEMINI.md`)

## Enforcement
- Agent MUST run `bd ready` at session start and `bd sync` at session end
- Agent MUST guide installation if Beads is not found

---

## Setup Guide

### Step 1: Install the Beads CLI

Beads is a system-wide tool (like `git`). Do NOT clone the repo into your project.

| Method | Command | Best For | Updates |
|---|---|---|---|
| **Homebrew** | `brew install beads` | macOS/Linux | `brew upgrade beads` |
| **bun** | `bun install -g --trust @beads/bd` | JS developers | `bun update -g @beads/bd` |
| **pnpm** | `pnpm install -g @beads/bd` | JS fallback | `pnpm update -g @beads/bd` |
| **Script** | `curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh \| bash` | Any platform | Re-run script |
| **Go** | `go install github.com/steveyegge/beads/cmd/bd@latest` | Go devs (1.24+) | Re-run command |

> **New to Homebrew?** If you don't have it installed, check the Homebrew skill guide - it walks you through from scratch just ask you agent to look at it.

### Step 2: Verify

```bash
bd version
bd help
```

If you see a version number and the help menu, you're good.

**"bd: command not found"?** Close and reopen your terminal, or run `source ~/.zshrc` (macOS) / `source ~/.bashrc` (Linux). Or just ask the agent to fix it for you.

### Step 3: Initialize in Your Project

```bash
cd your-project
bd init
```

Creates `.beads/` in your project (tracked by git so context persists across machines).

**Init options:**
```bash
bd init --quiet        # Minimal output
bd init --stealth      # Local only, nothing committed (for shared repos)
bd init --contributor  # Open-source contributions (stores in ~/.beads-planning)
```

### Step 4: Editor Integration

**Cursor:**
```bash
bd setup cursor
```
Creates `.cursor/rules/beads.mdc` so the agent knows about Beads.

**VS Code (MCP Server):**
```bash
uv tool install beads-mcp
```
Then create `.vscode/mcp.json`:
```json
{
  "servers": {
    "beads": {
      "command": "beads-mcp"
    }
  }
}
```
Run `bd init --quiet` and reload VS Code.

**Gemini / Antigravity:** No additional setup needed - this extension handles everything.

<!-- ═══════════════════════════════════════════════════ -->
<!-- DAY-TO-DAY FLOW                                    -->
<!-- ═══════════════════════════════════════════════════ -->

---

## How It Works Day-to-Day

You don't need to learn all of Beads to benefit. Here's the practical flow:

1. **Start a session** - The agent runs `bd ready` and loads your context automatically
2. **Work normally** - Just build. The agent tracks what's happening
3. **End a session** - The agent runs `bd sync` to save progress
4. **Next session** - Everything is right where you left it

That's it. The agent handles the commands. You just build.

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Commands Reference

These are the commands the agent uses behind the scenes. You can also run them manually:

| Command | What It Does |
|---|---|
| `bd ready` | Load context - shows open tasks and recent decisions |
| `bd sync` | Save session progress |
| `bd status` | Check what's currently tracked |
| `bd tasks` | List open tasks across sessions |
| `bd create "Title" -p 0` | Create a new task (P0 = highest) |
| `bd update <id> --claim` | Claim a task to work on |
| `bd show <id>` | Show details of a specific task |
| `bd dep add <child> <parent>` | Add a dependency between tasks |

**Priority levels:** P0 (critical), P1 (important), P2 (nice-to-have), P3 (someday)

---

## Session Integration

### Session Start
```bash
bd ready
```
Loads pending tasks, recent decisions, and project context from previous sessions (~1-2k tokens).

### Session End
```bash
bd sync
```
Persists: accomplishments, decisions + rationale, open tasks, patterns discovered.

---

## Rules for the Agent

- **Always `bd ready` at session start** when this extension is active
- **Always `bd sync` before session end** - never let work go unrecorded
- **Guide installation** if Beads not found - choose best method for user's setup
- **`bd init` in new projects** when this extension is active - ask first
- **Track meaningful decisions** - architectural choices go into Beads so future sessions remember WHY
- **Don't overwhelm beginners** - stick to `bd ready` / `bd sync`, introduce other commands gradually
- **Respect stealth mode** - for shared repos, suggest `--stealth` or `--contributor`
- **Summarize loaded context** - after `bd ready`, briefly tell the user what was loaded

Source: [steveyegge/beads](https://github.com/steveyegge/beads)
