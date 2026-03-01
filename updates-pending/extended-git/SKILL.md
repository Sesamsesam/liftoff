---
name: extended-git
description: "Advanced Git tooling with Graphite and Greptile. For advanced users or those who want to be at the top of their game."
---

# Extended Git

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. Set `"extended-git": true` in extensions.json to enable.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
An optional extension that upgrades your Git workflow with two professional tools:
- **Graphite** - stacked PRs (chains of small, focused pull requests instead of one giant change)
- **Greptile** - AI code review on every PR (catches bugs, security issues, style problems)

When active, the agent enforces feature branches (Level 2+) so everything goes through review.

## Why Does It Exist?
Once comfortable with basic Git (`git-flow` skill), these tools dramatically improve code quality. Every change gets AI review, big features get broken into reviewable pieces, and bugs are caught before production.

## What It Does For You
The agent creates stacked PRs via Graphite when you finish a feature. Greptile auto-reviews each one. You review the AI feedback and merge. Professional-grade workflow, fully automated.

---

## Activation
- Enable in `~/.gemini/extensions/extensions.json`: `"extended-git": true`
- Agent suggests this on team projects or code review requests

> [!IMPORTANT]
> When active, `git-flow` Level 1 (push to main) is disabled. Minimum is Level 2 (feature branches) for Greptile to work correctly.

<!-- ═══════════════════════════════════════════════════ -->
<!-- GRAPHITE                                           -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Graphite (Stacked PRs)

### Why Stacked PRs?

| Regular Git | With Graphite |
|---|---|
| One huge PR with 50 files | 5 small PRs with 10 files each |
| Reviews take days | Reviews take minutes |
| One blocked part blocks everything | Fix one piece independently |
| Complex rebasing on main updates | Auto-restack the entire chain |

### Installation

```bash
# macOS/Linux (recommended)
brew install withgraphite/tap/graphite

# npm alternative
npm install -g @withgraphite/graphite-cli
```

### Setup

```bash
gt auth --token <your-github-token>
gt init
```

> **Token:** Go to [app.graphite.dev](https://app.graphite.dev), sign in with GitHub, copy CLI token from settings.

### Day-to-Day Workflow

```bash
gt create feat/auth-schema -m "feat: add auth database schema"
# ... make changes, commit ...

gt create feat/auth-api -m "feat: add auth API endpoints"
# ... stack another PR on top ...

gt submit        # Push entire stack as connected PRs
gt restack       # Rebase all branches after a merge
```

### Key Commands

| Command | What It Does |
|---|---|
| `gt create <name>` | Create a new branch in the stack |
| `gt submit` | Push entire stack as connected PRs |
| `gt restack` | Rebase all after a merge |
| `gt log` | See current stack visually |
| `gt checkout <name>` | Jump between branches |
| `gt modify` | Amend current branch and auto-restack |

<!-- ═══════════════════════════════════════════════════ -->
<!-- GREPTILE                                           -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Greptile (AI Code Review)

An AI that reads your **entire codebase** (not just the diff) and reviews every PR. It understands how your change affects the rest of the system:

- "This function is called in 12 other places - did you account for that?"
- "This endpoint has no rate limiting, but your others do"
- "You're importing a deprecated method"

It **learns from your feedback** - consistently dismissed comment types get deprioritized.

### Setup

1. Sign in at [app.greptile.com](https://app.greptile.com) with GitHub
2. Connect repositories
3. Configure: severity threshold, PR summaries, auto-review filters

### What It Catches

| Category | Examples |
|---|---|
| **Security** | SQL injection, XSS, exposed secrets, missing auth |
| **Performance** | N+1 queries, unnecessary re-renders, missing indexes |
| **Code quality** | Inconsistent naming, dead code, missing error handling |
| **Patterns** | Deviating from project conventions |
| **Tests** | Missing coverage for new/changed code |

### What You See
- **Summary comment** explaining what the PR does
- **Inline comments** on specific lines with suggestions
- **Severity labels** (critical vs nice-to-have)

### Pricing
- **Free tier:** Public repos and small teams
- **Paid:** Private repos with larger codebases - [greptile.com/pricing](https://greptile.com/pricing)

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## How They Work Together

```
You write code
  → Agent creates stacked PRs via Graphite
  → Greptile auto-reviews each PR
  → You review feedback and merge
  → Graphite auto-restacks remaining PRs
```

---

## Agent Rules

- **Always use feature branches** - never push to main directly
- **Create stacked PRs** for features with >100 lines of changes
- **Wait for Greptile review** before suggesting merge (unless user says skip)
- **Explain Greptile feedback** in plain language for beginners
- **Guide setup** on first use - don't assume tools are installed
- **Check Homebrew** before suggesting `brew install` for Graphite
