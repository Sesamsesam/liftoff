---
name: extended-git
description: "Advanced Git tooling with Graphite and Greptile. Auto-upgrades git-flow to Level 2+ (feature branches always)."
category: workflow
---

# Extended Git

> **🤖 You don't need to do any of this manually.** This guide explains how this tool works so you can learn and understand it. But the agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

## What Is This?
An optional extension that upgrades your Git workflow with professional tools: **Graphite** for stacked PRs and **Greptile** for AI code review. When active, this extension enforces feature branches (Level 2+) to prevent contradictory advice between "push to main" (Level 1) and "create PRs" (Greptile).

## Why Does It Exist?
Once you're comfortable with basic Git, these tools dramatically improve code quality and collaboration. Graphite simplifies managing multiple related changes, and Greptile provides automated code review - like having a senior developer review every PR.

## What It Does For You
Every code change gets a second pair of eyes before going live. When you finish a feature, instead of pushing it straight to your main codebase, you create a **pull request** (PR) - a proposal that says "here's what I changed, review it before merging." Greptile's AI reviewer automatically checks that PR for bugs, security issues, and style problems you might miss. You get feedback in minutes, not hours.

---

## Activation
- Enable in `~/.gemini/settings/extensions.json`: `"extended-git": true`
- The agent offers this extension when the user works on a team project or asks about code review

## Conflict Resolution
> [!IMPORTANT]
> When `extended-git` is active, the `git-flow` skill's Level 1 (push to main) is disabled. Minimum workflow becomes Level 2 (feature branches) to ensure Greptile reviews work correctly.

---

## Graphite (Stacked PRs)

**What it does:** Lets you create chains of small, focused PRs that depend on each other - instead of one massive PR.

**Setup:**
```bash
brew install withgraphite/tap/graphite
gt auth --token <your-token>
```

**Basic workflow:**
```bash
# Start a new stack from main
gt create feat/auth-schema -m "feat: add auth database schema"

# Stack another PR on top
gt create feat/auth-ui -m "feat: add login and signup forms"

# Submit the entire stack
gt submit
```

## Greptile (AI Code Review)

**What it does:** Automatically reviews your PRs for bugs, security issues, and style problems.

**Setup:** Install the Greptile GitHub App on your repository.

**What it catches:**
- Security vulnerabilities (complements `security-guardian`)
- Performance issues
- Inconsistent naming or patterns
- Missing error handling
- Test coverage gaps
