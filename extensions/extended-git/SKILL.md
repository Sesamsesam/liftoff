---
name: extended-git
description: "Advanced Git tooling with Graphite and Greptile. Auto-upgrades git-flow to Level 2+ (feature branches always)."
category: workflow
---

# Extended Git

> **🤖 You don't need to do any of this manually.** This guide explains how this tool works so you can learn and understand it. But the agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when. Set it to 'true' in the extensions.json under the settings folder to enable it.  

## What Is This?

An optional extension that upgrades your Git workflow with two professional tools:

- **Graphite** - Makes it easy to create chains of small, focused pull requests (called "stacked PRs") instead of one giant change
- **Greptile** - An AI that automatically reviews your code for bugs, security issues, and style problems before it goes live

When this extension is active, the agent enforces feature branches (Level 2+) to make sure everything goes through review. This prevents contradictory advice between "push to main" (Level 1 in git-flow) and "create PRs for review" (what Greptile needs).

## Why Does It Exist?

Once you're comfortable with basic Git (the `git-flow` skill handles that), these tools dramatically improve your code quality and workflow. Without them:

- You push code and hope it's fine
- Big changes are hard to review because there's too much to look at
- Bugs slip through because no one catches them before they go live

With them:
- Every change gets a second pair of AI eyes automatically
- Big features get broken into small, reviewable pieces
- You catch bugs, security issues, and style problems before they reach production

## What It Does For You

When you finish a feature, instead of pushing it straight to your main codebase, you create a **pull request** (PR) - a proposal that says "here's what I changed, review it before merging." Greptile's AI reviewer automatically checks that PR for bugs, security issues, and style problems. You get feedback in minutes, not hours.

Graphite takes it further - instead of one massive PR that's hard to review, you create a **stack** of small PRs that build on each other. Each one is easy to understand and review. Graphite handles all the complex Git operations (rebasing, updating dependencies) that would normally make this workflow painful.

---

## Activation

- Enable in `~/.gemini/settings/extensions.json`: `"extended-git": true`
- The agent suggests this extension when you work on a team project or ask about code review

> [!IMPORTANT]
> When `extended-git` is active, the `git-flow` skill's Level 1 (push to main) is disabled. The minimum workflow becomes Level 2 (feature branches) to ensure Greptile reviews work correctly. The agent handles this automatically.

---

## Graphite (Stacked PRs)

### What Is It?

Think of building a house. You don't wait until the entire house is done to inspect it - you inspect the foundation, then the framing, then the plumbing, each as separate steps. Graphite lets you do the same with code changes - stack small, focused changes on top of each other, each reviewable on its own.

### Why It's Better Than Regular Git

| Regular Git | With Graphite |
|---|---|
| One huge PR with 50 files changed | 5 small PRs with 10 files each |
| Reviewers take days because it's overwhelming | Reviews take minutes because each piece is small |
| If one part needs changes, the whole PR is blocked | Fix one piece without affecting the others |
| Complex rebasing when main branch updates | Graphite handles rebasing the entire stack automatically |

### Installation

```bash
# macOS/Linux (recommended)
brew install withgraphite/tap/graphite

# npm alternative
npm install -g @withgraphite/graphite-cli
```

### Setup

```bash
# Authenticate with your GitHub account
gt auth --token <your-github-token>

# Initialize in your repo
gt init
```

> **Where to get your token:** Go to [app.graphite.dev](https://app.graphite.dev), sign in with GitHub, and copy your CLI token from the settings page. The agent will walk you through this.

### Day-to-Day Workflow

The agent handles all of this, but here's what's happening under the hood:

```bash
# Start a new feature from main
gt create feat/auth-schema -m "feat: add auth database schema"
# ... make changes, commit ...

# Stack another PR on top (builds on the previous one)
gt create feat/auth-api -m "feat: add auth API endpoints"
# ... make changes, commit ...

# Stack a third PR on top
gt create feat/auth-ui -m "feat: add login and signup forms"

# Submit the entire stack for review
gt submit

# When the first PR gets approved and merged, restack the rest
gt restack
```

### Key Commands

| Command | What It Does |
|---|---|
| `gt create <name>` | Create a new branch in the stack |
| `gt submit` | Push the entire stack as connected PRs |
| `gt restack` | Rebase all branches in the stack after a merge |
| `gt log` | See your current stack visually |
| `gt checkout <name>` | Jump between branches in the stack |
| `gt modify` | Amend the current branch and auto-restack |

---

## Greptile (AI Code Review)

### What Is It?

An AI that reads your entire codebase - not just the lines you changed - and reviews every pull request automatically. It understands how your change affects the rest of the system, catches bugs you might miss, and explains its reasoning with inline comments.

### Why It's Powerful

Most code review tools only look at the **diff** (the lines that changed). Greptile builds a graph of your entire codebase, so it understands:

- "This function you changed is called in 12 other places - did you account for that?"
- "This new endpoint doesn't have rate limiting, but your other endpoints do"
- "You're importing a deprecated method - use the new one instead"

It also **learns from your team's feedback** over time. If you consistently dismiss certain types of comments, it adapts and stops flagging those patterns.

### Installation

Greptile is a GitHub App - no CLI to install. The setup is:

1. **Go to** [app.greptile.com](https://app.greptile.com) and sign in with GitHub
2. **Connect your repositories** - choose which repos Greptile should review
3. **Configure review settings**:
   - **Severity threshold:** Low (more comments) to High (critical issues only)
   - **PR summaries:** Get an overview of what changed with optional diagrams
   - **Auto-review filters:** Only review PRs with certain labels if you prefer

> **The agent will walk you through this.** You just need to approve the GitHub App installation when prompted.

### What It Catches

| Category | Examples |
|---|---|
| **Security** | SQL injection, XSS, exposed secrets, missing auth checks |
| **Performance** | N+1 queries, unnecessary re-renders, missing indexes |
| **Code quality** | Inconsistent naming, dead code, missing error handling |
| **Patterns** | Deviating from established project conventions |
| **Tests** | Missing test coverage for new/changed code |

### What You See

When you open a PR, Greptile adds:
- A **summary comment** at the top explaining what the PR does
- **Inline comments** on specific lines with suggestions and explanations
- A **severity label** so you know what's critical vs. nice-to-have

### Pricing

- **Free tier:** Works for public repos and small teams
- **Paid plans:** For private repos with larger codebases - check [greptile.com/pricing](https://greptile.com/pricing)

---

## How They Work Together

```
You write code
  → Agent creates stacked PRs via Graphite (small, focused changes)
  → Greptile auto-reviews each PR (catches bugs and issues)
  → You review the AI feedback and merge
  → Graphite auto-restacks the remaining PRs
```

This gives you a professional-grade development workflow that many engineering teams at top companies use - but automated and accessible even if you're working solo.

---

## Agent Rules

- **Always use feature branches** when this extension is active - never push to main directly
- **Create stacked PRs** for features with more than ~100 lines of changes
- **Wait for Greptile review** before suggesting merge (unless the user explicitly says to skip)
- **Explain Greptile feedback** in plain language if the user is a beginner
- **Guide the user** through Graphite/Greptile setup on first use - don't assume they're installed
- **Check Homebrew** is available before suggesting `brew install` for Graphite (link to homebrew skill if not)
