---
name: git-flow
description: "Progressive Git workflow for solo developers. From complete beginner to team-ready."
category: workflow
---

# Git Flow
(THIS IS A MUST TO UNDERSTAND FOR ANY USER - an essential)

## What Is This?
A step-by-step guide to using Git - from "what is Git?" to professional team workflows. Your AI agent enforces the right level automatically based on the project context.

## Why Does It Exist?
Git is the universal tool for tracking code changes and collaborating. Without proper Git practices, you lose work, break things with no undo button, and can't collaborate effectively. This skill teaches you the right habits from day one.

## What It Does For You
The agent automatically writes proper commit messages, maintains `.gitignore`, and recommends the right Git workflow level for your situation. You learn professional Git practices by seeing them in action.

---

## Activation
- Every commit, branch creation, or deployment
- When starting a new project (init + `.gitignore` setup)
- When the user asks about version control

## Enforcement
- The agent MUST use Conventional Commits format
- The agent MUST verify `.gitignore` covers sensitive files before first commit
- The agent MUST recommend the appropriate workflow level based on context

---

## What Is Git? (For Complete Beginners)

Think of Git as a **save-game system for your code.** Every time you make a meaningful change, you "save" (commit) it with a description. If something breaks, you can always go back to any previous save.

**Key concepts:**
- **Repository (repo):** Your project folder, tracked by Git
- **Commit:** A saved snapshot of your code at a point in time
- **Branch:** A parallel version of your code (like a "what if" copy)
- **Push:** Upload your commits to GitHub (backup + sharing)
- **Pull:** Download the latest changes from GitHub

## Installing Git

**macOS:**
```bash
xcode-select --install
```

**Verify:**
```bash
git --version
```

---

## GitHub Setup (For Beginners)

Git tracks changes locally. **GitHub** stores your code online - backup, sharing, and collaboration. They both start with 'Git' but are different things. Git is the local tool Github is a service that uses Git.

### 1. Create a GitHub Account
Go to [github.com](https://github.com) and sign up. Free accounts include unlimited repositories.

### 2. Create Your First Repository
On GitHub, click **"New Repository"** → name it → select **Private** → click **Create**

### 3. Connect Your Agent (HTTPS - Easiest Method)

When the agent runs `git push` for the first time, your browser will open a GitHub login prompt. Sign in and authorize access. That's it - no keys, no tokens.

```bash
# The agent will set this up, but here's what happens:
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
# → Browser opens → Log in → Authorized ✅
```

> **Repo-level vs. Account-level access:**
> - **Repo-level**: The agent can only push/pull from the specific repo (your project) you connected. This is the default when you clone or add a remote for one repo.


> - **Account-level**: If think, 'why must I create a repo can't the agnet just handle that?' yes it can - you authorize the GitHub CLI (`gh auth login`) and you can do this first, then you don't even have to create a repo or click buttons and the agent can create new repos anytime you create a project ('Yo agent create a new repo on github for this project') then you don't have to do step 2 or 3 above - just ask the agent what to do. Only do this if you want the agent to scaffold entire projects for you (I use it).

> **SSH** is an alternative for advanced users (no browser prompts, key-based auth). The agent can help you set it up if you ask, but HTTPS works perfectly for most workflows, if you are interested in this then ask you AI.

---

## How Git Works: Save → Checkpoint → Push

Every time you finish a piece of work, three things happen:

```bash
# Stage all your changes (tells Git "I want to save these")
git add .

# Create a checkpoint with a description of what you changed
git commit -m "feat: add user profile page"

# Push your checkpoint to GitHub - this is what makes it live.
# If your website deployer (Cloudflare, Vercel, etc.) is connected
# to this repo, pushing to main triggers a rebuild.
# Your changes go live automatically after this command.
git push origin main
```

The agent will run these commands for you when you say "push to git" or "commit to git." You don't need to memorize them.

**But understanding the system matters.** Git is three things:
1. **Save** (`git add`) - select which changes to include
2. **Checkpoint** (`git commit`) - snapshot your code with a description you can always return to
3. **Push to live** (`git push`) - upload to GitHub, which triggers your website to rebuild with the new code

This allows you to revert to previous 'save games' if things break by referencing the commit code (a little snippet of ID you can see in the terminal when pushed or on github)

You ONLY push after you've tested locally and the agent has verified the code works. Pushing broken code means your live site breaks.

---

## Conventional Commits

Every commit message follows this format:

```
type: short description (imperative mood)
```

| Type | When |
|---|---|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation only |
| `chore:` | Maintenance (deps, config) |
| `refactor:` | Code restructure, no behavior change |
| `test:` | Adding or updating tests |

**Examples:**
```
feat: add dark mode toggle to settings
fix: resolve crash on empty search results
docs: update README with deployment steps
chore: upgrade convex to v1.18
refactor: extract payment logic into service module
test: add unit tests for auth middleware
```

---

## 5 Commands You'll Use 90% of the Time

| Command | What It Does |
|---|---|
| `git status` | Shows what's changed since last commit |
| `git add .` | Stages all changes for commit |
| `git commit -m "message"` | Saves a snapshot with a description |
| `git push origin main` | Uploads to GitHub |
| `git log --oneline -5` | Shows the last 5 commits |

---

## `.gitignore` Template

```gitignore
# Dependencies
node_modules/

# Environment
.env
.env.*
!.env.example

# Build output
dist/
.next/
.astro/

# Convex
.convex/_generated/

# Cloudflare
.wrangler/

# OS files
.DS_Store
Thumbs.db

# Security
*.pem
*.key
.antigravity/

# IDE
.idea/
.vscode/settings.json
```

---

## The Progressive Model

### Level 1: Solo Developer, Small Changes
> Direct push to `main` is OK. But with conditions:

**When:** You're working alone, changes are small and self-contained.

This is the Save → Checkpoint → Push flow described above. The agent handles it for you.

**Rules:**
- One logical change per commit
- Use Conventional Commits format
- Never commit secrets (agent checks automatically)
- Never commit broken code (agent checks automatically)

### Level 2: Solo Developer, Large Features
> Work on a separate branch, merge when complete.

**What this means:** Instead of pushing directly to `main`, you create a separate copy of your code called a "branch." You make all your changes there. When the feature is done and tested, you merge it back into `main`. This way, `main` always has working code.

**When:** The feature takes multiple commits, or you want to experiment without risk.

**Key concepts:**
- **Branch** = a parallel copy of your code where you can break things safely
- **Merge** = combining your branch back into `main` when it's ready
- Branch names follow a convention: `feat/description`, `fix/description`, `chore/description`

### Level 3: Team or AI Review
> Branch → Pull Request → Review → Merge

**What this means:** Same as Level 2, but before merging, you create a "Pull Request" (PR) on GitHub. This lets a teammate or an AI reviewer check your code before it goes into `main`. Think of it as a quality gate.

**When:** Working with a team, or when you want AI-assisted code review for extra safety.

**Key concepts:**
- **Pull Request (PR)** = a request to merge your branch, with a review step in between
- **Code review** = someone (or an AI) reads your changes and catches issues before they ship

> **Want Levels 2 and 3 handled automatically?** Activate the `extended-git` extension and the agent will manage branches, PRs, and AI code review for you. See `~/.gemini/extensions/extended-git/SKILL.md` for details.
