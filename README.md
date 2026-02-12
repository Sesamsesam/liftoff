# Antigravity Source Setup

> Turn any AI coding agent into an enterprise-grade development partner — so a complete beginner can go from **1000 hours of mistakes to 50 hours of guided practice** with top-notch guardrails baked in.

---

## What Is This?
First if you don't understand what half of this means, don't worry the agent takes care of it all and guides you.

This is a one-command install that equips your AI coding agent (like Gemini, Cursor, Copilot) with:

- Samihermes.ai **F.O.R.G.E. methodology** — a step-by-step workflow that ensures your agent plans before coding, verifies as it builds, and never skips security
- **7 core skills** — security, error handling, Git, design tokens, tech stack defaults, and specific MCP server skills like notebookLM, notion and more
- **3 optional extensions** — advanced Git tooling, research workflows, and session persistence
- **Professional standards** — every project gets enterprise-grade patterns without enterprise complexity, you can literally have no Idea of How to even use AI powertools to become highly profecient FAST!

**You don't need to be an expert.** The agent enforces best practices automatically. You just build and use the AI tools.

---

## Quick Start

```bash
git clone https://github.com/sesamsesam/liftoff.git
cd liftoff
chmod +x install.sh
./install.sh
```

Choose your profile when prompted:

| Profile | What You Get |
|---|---|
| **1. Developer** | Core skills + workflows (recommended for most users) |
| **2. Researcher** | Developer + NotebookLM research extension |
| **3. Full** | Everything, including advanced Git + Beads session persistence |

That's it. Open your next project and the agent will follow F.O.R.G.E. automatically.

---

## What's Inside

### 🔧 Core (Always Installed)

| Component | What It Does |
|---|---|
| `GEMINI.md` | Global rules the agent follows in every project |
| `forge-methodology` | The F.O.R.G.E. workflow: Foundation → Outline → Rock'n'Roll → Guard → Evolve |
| `security-guardian` | 14-point security checklist — secrets, inputs, auth, dependencies |
| `error-handling` | Circuit breaker, structured reporting, graceful degradation |
| `git-flow` | Progressive Git workflow from beginner to team-ready |
| `brand-identity` | CSS design tokens for premium-looking UIs |
| `stack-pro-max` | Tech stack defaults (React + Vite + Convex + Clerk) |
| `antigravity-standard` | Template for creating new skills |
| `init-project` | Workflow to scaffold a new project with all guardrails |

### 🔌 Extensions and how to connect them (Opt-In)

| Extension | Profile | What It Does |
|---|---|---|
| `notebooklm-research` | Researcher+ | Research-to-Production pipeline with NotebookLM and how to connect antigravity |
| `extended-git` | Full | Graphite stacked PRs + Greptile AI code review |
| `beads-workflow` | Full | Cross-session context persistence |

Extensions are installed **dormant** (all set to `false` by default). To activate one, change its value to `true` in `~/.gemini/settings/extensions.json`:

```json
// Example: activating notebooklm-research while keeping the others off
{
  "extended-git": false,
  "beads-workflow": false,
  "notebooklm-research": true  // ← changed to true to activate
}
```

**What does dormant mean?** When an extension is set to `false`, the skill file is installed on your machine but the agent completely ignores it. It won't suggest it, use it, or even mention it. It's as if it doesn't exist.

**What happens when you activate it?** Setting an extension to `true` makes it available **globally** — meaning every new agent session, in any project, can now use that extension. You only need to flip it once.

**Why not just activate everything?** Some extensions change how the agent behaves in ways you might not always want. For example, `beads-workflow` makes the agent track session context and manage task persistence between conversations. That's powerful when you need it, but if you're doing a quick one-off task, you don't want the agent spending time on session management overhead. The toggle lets you control exactly which behaviors are active, so the agent stays focused on what matters for how you work right now.

---

## How Skills Work

Skills live in folders under `~/.gemini/skills/`. Each folder has one file called `SKILL.md` — the agent discovers and loads skills by looking for this exact filename. **The folder name is the skill's identity.**

```
skills/
  security-guardian/SKILL.md   ← Contains 14 security checks (one topic, many patterns)
  error-handling/SKILL.md      ← Contains 5 error patterns inside one file
```

**One folder = one topic. One SKILL.md = all the related patterns for that topic.**

You don't create a new folder for every small thing. Instead, you add new patterns as sections inside the existing `SKILL.md`. For example, `notebooklm-research/SKILL.md` could contain:

- **Skill 1**: The Research-to-Production pipeline (research → extract → ground → implement)
- **Skill 2**: Auto-add sources (automatically click "Add to Sources" after research is complete)

Both live inside the same `notebooklm-research/SKILL.md` because they're part of the same topic. The agent reads the full file and knows how to apply each pattern when relevant.

> **When to create a new folder**: Only when the topic is genuinely different. If you're adding something about video production, that's a new folder (`remotion-video/`). If you're adding a second NotebookLM workflow, it goes in the existing `notebooklm-research/SKILL.md`.

---

## How F.O.R.G.E. Works

```
Foundation → Understand the project, read existing code, ask questions
Outline    → Create a plan. NO code until you approve it
Rock'n'Roll → Build brick by brick, verify each step
Guard      → Security + error handling on every change (automatic)
Evolve     → Document what happened, persist knowledge for next session
```

The agent follows this cycle for every task. You never need to say "use FORGE" — it's the default behavior.

---

## File Structure

```
~/.gemini/
├── GEMINI.md                          # Global identity + rules
├── settings/
│   └── extensions.json                # Extension activation
├── skills/
│   ├── forge-methodology/SKILL.md     # Core workflow
│   ├── security-guardian/SKILL.md     # Security checklist
│   ├── error-handling/SKILL.md        # Error patterns
│   ├── git-flow/SKILL.md             # Git workflow
│   ├── brand-identity/SKILL.md        # Design tokens
│   ├── stack-pro-max/SKILL.md         # Tech stack
│   ├── antigravity-standard/SKILL.md  # Skill template
│   ├── extended-git/SKILL.md          # (extension)
│   ├── beads-workflow/SKILL.md        # (extension)
│   └── notebooklm-research/SKILL.md   # (extension)
└── workflows/
    └── init-project.md                # Project scaffolding
```

---

## FAQ

**Q: Will this break my existing setup?**
A: The installer backs up your existing `GEMINI.md` before overwriting. All other files are additive.

**Q: Can I customize the skills?**
A: Yes. Every skill is a markdown file. Edit them directly — the agent reads them at runtime.

**Q: Do I need all the tools listed in `stack-pro-max`?**
A: No. Those are defaults. The agent adapts to whatever tools you have installed.

**Q: What if I don't use Convex/Clerk?**
A: The patterns still apply — just swap the specific tools. The security, error handling, and Git skills are framework-agnostic.

---

## License

MIT — use it, fork it, improve it.
