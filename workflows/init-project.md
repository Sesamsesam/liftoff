---
description: "Initialize a new project with the full Antigravity stack — Git, Vite/Astro, Convex, and all guardrails."
---

# Init Project Workflow

## When To Use
Run this workflow when creating a brand new project from scratch.

## Steps

### 1. Choose project type
Ask the user: "Is this a **dynamic app** (React + Vite + Convex) or a **static site** (Astro)?"

### 2. Scaffold the project

**For dynamic apps:**
```bash
# turbo
bunx --bun create-vite@latest ./ -- --template react-ts
# turbo
bun install
# turbo
bun add convex
# turbo
bunx convex init
```

**For static sites:**
```bash
# turbo
bunx --bun create-astro@latest ./ -- --template minimal --no-install --no-git
# turbo
bun install
```

### 3. Initialize Git
```bash
# turbo
git init
```

### 4. Create `.gitignore`
Write the `.gitignore` from the `git-flow` skill template (covers node_modules, .env*, .convex/_generated/, .wrangler/, etc.)

### 5. Create `.env.example`
```bash
# Required environment variables
# Copy this file to .env.local and fill in the values

# Convex (if dynamic app)
CONVEX_DEPLOYMENT=
VITE_CONVEX_URL=

# Clerk (if using auth)
VITE_CLERK_PUBLISHABLE_KEY=
CLERK_SECRET_KEY=
```

### 6. Set up CSS foundation
Create `src/index.css` with the design tokens from the `brand-identity` skill.

### 7. Initial commit
```bash
git add .
git commit -m "chore: scaffold project with Antigravity defaults"
```

### 8. Verify
- [ ] `bun run dev` starts without errors (only if user asks to start the server)
- [ ] `.gitignore` covers all sensitive patterns
- [ ] `.env.example` exists (`.env.local` does NOT exist in repo)
- [ ] CSS tokens are in place

### 9. Report
Tell the user: "Project scaffolded with [type]. Git initialized, guardrails in place. Ready to build."
