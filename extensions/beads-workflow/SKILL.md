---
name: beads-workflow
description: "Context persistence across AI sessions using Beads CLI. Never lose progress between conversations."
category: workflow
---

# Beads Workflow

> **Heads up for beginners:** This extension uses a **CLI (Command Line Interface)** - a text-based tool where you type commands instead of clicking buttons. If you've never used one, don't worry - it's simpler than it sounds and your AI agent handles most of the commands for you. In Short you will have to work with Antigravity through another app. But it's easy and you only need to do a few commands otherwise it just stays open in the background.
>
> **The good news:** However you really don't need to open a separate application. Your editor (VS Code, Cursor, Windsurf, Antigravity) has a **built-in terminal** right inside it. Press `` Ctrl+` `` (Windows/Linux) or `` Cmd+` `` (Mac) or look for the 'terminal' tab in your computer menu when using Antigravity. Click new and a terminal panel opens at the bottom of your editor. That's where Beads runs - same window, same workflow, no context switching.
>
> Once installed, the agent does the heavy lifting. You'll mainly just see it running `bd ready` (load context) and `bd sync` (save progress) automatically. Think of the CLI as the engine under the hood - you rarely need to touch it directly.

---

## TL;DR - This Is All You Actually Need

If you're on **macOS**, these 3 commands are the entire setup:

```bash
brew install beads       # 1. Install Beads (need Homebrew first? See the Homebrew skill)
cd your-project          # 2. Go to your project folder
bd init                  # 3. Initialize Beads in your project
```

**That's it.** After this, the agent handles everything automatically - `bd ready` on session start, `bd sync` on session end. You don't need to memorize any other commands.

**On Windows/Linux or prefer a different install method?** The full guide below has all the options. Everything below this point is just for deeper understanding - you do NOT need to read it all to use Beads. The agent can handle all.

---

## What Is Bead?

Every time you start a new AI conversation, the agent has no memory of what you did before. 

You have to re-explain your project, your decisions, what's done, and what's left or ask it to read up on the project to get context. It's like hiring a new contractor every morning who needs time to get up to speed. 

It's not too big a problem for Antigravity since it has a KI (knowledge) memory, but it still requires the agent to rediscover the project's context every time and either way it can result in inconsistencies if you are not thorough on a large project or have the right experience to recognize if the Agent is off point and sometimes on a big project even an Expert needs time to get into the groove - but with beads this is not an issue.

**Beads fixes this.** It's a CLI (command line interface) tool (created by Steve Yegge, ex-Google and ex-Amazon, he's a wizard 🧙) it gives your AI agent a persistent memory. 

It tracks tasks, decisions, progress, and context in a structured graph database that lives inside your project. When you start a new session, the agent loads everything up and picks up exactly where you left off.

A ‘graph’ just means a map of connected tasks (like a flowchart) showing what depends on what. Not equations and beads continues to keep track.

Think of it like this: without Beads, your AI has amnesia. With Beads, it has a detailed journal of everything that happens.

## Why Does It Exist?

AI coding agents are powerful, but they have a maximum of how much they can hold in memory per session. This creates real problems:

- You waste 10-15 minutes re-explaining your project every time
- Decisions get lost ("why did we use that library again?")
- Tasks fall through the cracks
- The agent makes the same mistakes twice because it doesn't remember the first time and you keep asking it the same stuff over and over again.
- or you have a long planning session with many side quests and sessions and it might eventually narrow context and when you ask to summarize at the end of it, it didn't understand you wanted everything since it deprioritized along the way if you didn't lock it in step by step.

Beads solves all of this by persisting structured context - not just a text dump, but an actual dependency-aware task graph with history, rationale, and progress tracking.

---

## Before vs After

### Without Beads 🌵

```
Session 1: "Build the user auth system"
  Agent: *builds it perfectly*

Session 2: "Continue working on the app"
  Agent: "What app? What auth system? Let me take a look first so I understand"
  You: *spends 15 minutes re-explaining or catching up*

Session 3: "We decided to use JWT tokens, remember?"
  Agent: "Let me check that first and can you specify where?."
  You: *Extra work for you*
```

### With Beads 🫰

```
Session 1: "Build the user auth system"
  Agent: *builds it, tracks progress in Beads*

Session 2: "Continue working on the app"
  Agent: *runs bd ready*
  Agent: "Welcome back. Last session we completed the JWT auth system.
         Open tasks: dashboard UI (P0), email verification (P1).
         Ready to continue with the dashboard?"
```

One command. Full context. No re-explaining.

---

## How to Set Up

### Step 1: Install the Beads CLI

Beads is a command-line tool you install once on your computer. You do NOT clone the Beads repo into your project - it's a system-wide tool like `git`.

**Pick the method that fits you best:**

#### Option A: Homebrew (macOS/Linux - Recommended)

```bash
brew install beads
```

This is the simplest option. Homebrew handles everything - installation, PATH setup, and future updates via `brew upgrade beads`.

> **New to Homebrew?** If you don't have it installed yet or aren't sure what it is, check the [Homebrew skill guide](../../skills/homebrew/SKILL.md) - it walks you through everything from scratch.

#### Option B: bun/pnpm (if you're in a JavaScript environment)

```bash
# Using bun (preferred)
bun install -g --trust @beads/bd

# Using pnpm (fallback)
pnpm install -g @beads/bd
```

#### Option C: Quick Install Script (any platform)

```bash
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

The script auto-detects your platform and handles everything.

#### Option D: Go (for Go developers)

```bash
go install github.com/steveyegge/beads/cmd/bd@latest
```

Requires Go 1.24+.

| Method | Best For | Updates | Needs |
|---|---|---|---|
| **Homebrew** | macOS/Linux users | `brew upgrade beads` | Homebrew |
| **bun/pnpm** | JavaScript developers | `bun/pnpm update -g @beads/bd` | bun or Node.js |
| **Install script** | Quick setup, any platform | Re-run script | curl, bash |
| **Go** | Go developers | Re-run command | Go 1.24+ |


### Step 2: Verify It Worked

After installing, run:

```bash
bd version
bd help
```

If you see a version number and the help menu, you're good.

**If you see "bd: command not found"**, your terminal needs to know where Beads was installed. Close and reopen your terminal, or run `source ~/.zshrc` (macOS) / `source ~/.bashrc` (Linux) or simply just ask antigravity to do it for you. 
(Antigravity please do everything that you can for the user only ask use to do to manual steps on things you can't do)


### Step 3: Initialize Beads in Your Project

Navigate to your project folder and run:

```bash
cd your-project
bd init
```

This creates a `.beads/` directory in your project that stores the task graph. It's automatically added to your git history so context persists across machines.

**Useful init options:**

```bash
bd init --quiet      # Minimal output
bd init --stealth    # Use Beads locally without committing files (good for shared repos)
bd init --contributor  # For contributing to open-source projects (stores planning in ~/.beads-planning)
```


### Step 4: Set Up Your Editor Integration

Tell your editor's AI agent about Beads:

**For Cursor:**

```bash
bd setup cursor
```

This creates `.cursor/rules/beads.mdc` so the agent automatically knows about Beads.

**For VS Code with GitHub Copilot (MCP Server):**

1. Install the MCP bridge:
   ```bash
   uv tool install beads-mcp
   ```

2. Create `.vscode/mcp.json` in your project:
   ```json
   {
     "servers": {
       "beads": {
         "command": "beads-mcp"
       }
     }
   }
   ```

3. Initialize and reload:
   ```bash
   bd init --quiet
   ```
   Then reload VS Code.

**For Gemini / Antigravity (this agent):**

No additional setup needed. This extension handles everything. Once Beads is installed and `bd init` has been run in your project, this agent automatically uses `bd ready` on session start and `bd sync` on session end (see "Session Integration" below).

---

## How It Works Day-to-Day

You don't need to learn all of Beads to benefit from it. Here's the practical flow:

1. **Start a session** - The agent runs `bd ready` and loads your context automatically
2. **Work normally** - Just build. The agent tracks what's happening
3. **End a session** - The agent runs `bd sync` to save progress
4. **Start the next session** - Everything is right where you left it

That's it. The agent handles the Beads commands for you. You just build.

---

## Commands Reference

These are the commands the agent uses behind the scenes. You can also run them manually:

| Command | What It Does |
|---|---|
| `bd ready` | Load context for current session - shows open tasks and recent decisions |
| `bd sync` | Save session progress - persists what was accomplished |
| `bd status` | Check what's currently tracked |
| `bd tasks` | List open tasks across sessions |
| `bd create "Title" -p 0` | Create a new task (priority 0 = highest) |
| `bd update <id> --claim` | Claim a task to work on it |
| `bd show <id>` | Show details of a specific task |
| `bd dep add <child> <parent>` | Add a dependency between tasks |

**Priority levels:** P0 (critical/must-have), P1 (important), P2 (nice-to-have), P3 (someday)

---

## Session Integration

### Session Start

When Beads is active in `extensions.json`, the agent runs at the start of every session:

```bash
bd ready
```

This loads pending tasks, recent decisions, and project context from previous sessions. The agent gets a compact summary (~1-2k tokens) of everything it needs to continue your work.

### Session End

Before ending a session, the agent syncs progress:

```bash
bd sync
```

This persists:
- What was accomplished this session
- Decisions made and their rationale
- Open tasks for next session
- Patterns and insights discovered

---

## Activation

- Enable in `~/.gemini/settings/extensions.json`: `"beads-workflow": true`
- The agent checks for Beads during Session Start (see `GEMINI.md`)

---

## Rules for the Agent

- **Always run `bd ready` at session start** when this extension is active - this is how you get context from previous sessions
- **Always run `bd sync` before session end** - never let a session's work go unrecorded
- **Guide the user through installation** if Beads is not installed - walk them through the steps above, choosing the best install method for their setup
- **Use `bd init` in new projects** when the user is starting a project and this extension is active - ask first before initializing
- **Track meaningful decisions** - when the user makes an architectural or design decision, create a Beads task or note so future sessions remember WHY, not just what
- **Don't overwhelm beginners** - if the user is new, just use `bd ready` and `bd sync`. Introduce `bd create` and `bd update` gradually as they get comfortable
- **Respect stealth mode** - if the user is contributing to a shared repo they don't own, suggest `bd init --stealth` or `bd init --contributor`
- **Explain what happened** - when running `bd ready`, briefly summarize the loaded context for the user so they know what the agent remembers

Source: [steveyegge/beads](https://github.com/steveyegge/beads)
