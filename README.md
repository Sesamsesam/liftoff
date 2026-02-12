# Antigravity Source Setup

> **From 1,000 hours of trial and error to 50 hours of guided mastery.** This is your AI command center - whether you've never opened a code editor or you've been shipping software for a decade.

**Hey, I'm Sami.** I built Liftoff because I believe every professional deserves to be ridiculously good with AI - not someday, right now. Whether you're in finance, marketing, sales, design, or deep in code, this is the toolkit that makes it click. If you want to see what else I'm working on, come say hi at [samihermes.ai](https://samihermes.ai).

---

## What Is This?

The world changed. AI is no longer a tool reserved for engineers - it's the new operating layer for every professional. Accountants are automating reports. Salespeople are building custom CRMs. Marketers are spinning up landing pages before lunch. Video editors are programmatically chaing their vids. The professionals who thrive in the next decade won't be the ones who learned to code - they'll be the ones who learned to *command AI that codes for them*.

That's what Antigravity is. It's an AI-powered workspace (think: your command center) where you talk to an intelligent agent, and it builds, searches, connects, and automates on your behalf. You don't need to memorize syntax or understand server architecture. You describe what you want, and the agent handles the rest.

**This repo - Liftoff - is the startup pack that makes Antigravity extremely good at its job.** One install, and your AI agent goes from a blank slate where you need to direct it to a guided, battle-tested partner loaded with tools, ammo and best practices - this will save you a lot of time and you can outcompete people who just use Antigravity raw:

- **The F.O.R.G.E. methodology** - a step-by-step workflow where the agent plans before it builds, verifies as it goes, and never skips security. You approve every step
- **7 core skills** - security, error handling, Git version control, design systems, tech stack defaults, and integrations with tools like NotebookLM and Notion
- **3 optional extensions** - advanced Git workflows, research pipelines, and session memory so your AI remembers what you did yesterday
- **Professional-grade standards** - every project gets enterprise patterns without enterprise complexity, automatically

**If you're new to all of this** - don't worry. The agent walks you through everything. You don't need to understand half of what's inside. The skills and guardrails are working behind the scenes so you can focus on *what* you want to build, not *how* to build it.

**If you're already technical** - you'll feel this immediately. No more boilerplate security setups, no more forgotten `.gitignore` files, no more explaining your stack to a new AI session. This is the upgrade that makes your agent feel like a senior engineer instead of an intern.

---

## Quick Start

The install takes 30 seconds. You clone this repo, run the installer, and you're done - the skills get copied to your global Antigravity config. After that, you can delete the cloned folder. It's just the delivery vehicle.

(copy this and give it to Antigravity, or paste it into your terminal)
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

**After the install**, you're set up globally. Every new Antigravity session - in any project, anywhere on your machine - will have these skills active. To start your first real project:

```bash
cd ..                              # leave the liftoff folder
mkdir my-project && cd my-project  # create your actual project
```

Open that folder in your editor, start a conversation with Antigravity, and it will follow F.O.R.G.E. automatically. You can delete the `liftoff` folder whenever you want - it already did its job.

---

## What's Inside

### 🔧 Core (Always Installed)

| Component | What It Does |
|---|---|
| `GEMINI.md` | Global rules the agent follows in every project |
| `forge-methodology` | The F.O.R.G.E. workflow: Foundation → Outline → Rock'n'Roll → Guard → Evolve |
| `security-guardian` | 14-point security checklist - secrets, inputs, auth, dependencies |
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

**What happens when you activate it?** Setting an extension to `true` makes it available **globally** - meaning every new agent session, in any project, can now use that extension. You only need to flip it once.

**Why not just activate everything?** Some extensions change how the agent behaves in ways you might not always want. For example, `beads-workflow` makes the agent track session context and manage task persistence between conversations. That's powerful when you need it, but if you're doing a quick one-off task, you don't want the agent spending time on session management overhead. The toggle lets you control exactly which behaviors are active, so the agent stays focused on what matters for how you work right now.

---

## How Skills Work

Skills live in folders under `~/.gemini/skills/`. Each folder has one file called `SKILL.md` - the agent discovers and loads skills by looking for this exact filename. **The folder name is the skill's identity.**

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

The agent follows this cycle for every task. You never need to say "use FORGE" - it's the default behavior.

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
A: Yes. Every skill is a markdown file. Edit them directly - the agent reads them at runtime.

**Q: Do I need all the tools listed in `stack-pro-max`?**
A: No. Those are defaults. The agent adapts to whatever tools you have installed.

**Q: What if I don't use Convex/Clerk?**
A: The patterns still apply - just swap the specific tools. The security, error handling, and Git skills are framework-agnostic.

---

## Built By

**Sami Hermes** - AI educator, builder, and the person behind Antigravity.

I teach professionals from every background how to use AI as their unfair advantage. Liftoff is a core part of that mission - a free, open-source foundation so anyone can start strong.

- 🌐 [samihermes.ai](https://samihermes.ai)
- 🐙 [GitHub](https://github.com/sesamsesam)

---

## License

MIT - use it, fork it, improve it.
