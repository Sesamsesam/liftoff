---
name: antigravity-standard
description: "Meta-skill: the standard format for writing new Antigravity skills. Use this when creating or evaluating skills."
---

# Antigravity Standard

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
The template and quality standard for writing new skills. Every skill in the Antigravity ecosystem must follow this format. Use this skill when creating a new skill or evaluating whether an existing one meets the bar.

## Why Does It Exist?
Without a standard, skills would have inconsistent formats, missing sections, and varying quality. This ensures every skill is agent-readable, beginner-friendly, and genuinely useful.

---

## Activation
- When asked to create a new skill
- When evaluating or auditing existing skills

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- TEMPLATE                                           -->
<!-- ═══════════════════════════════════════════════════ -->

## Required Sections

Every skill MUST have:

### 1. YAML Frontmatter
```yaml
---
name: skill-name-kebab-case
description: "One-line description. What does this skill enable?"
---
```

### 2. Beginner README Block
Three sections at the top of every skill:
- **What Is This?** - Plain-English explanation a non-developer can understand
- **Why Does It Exist?** - The problem it solves
- **What It Does For You** - The concrete benefit (what changes for the user)

### 3. Activation Section
When does the agent load and apply this skill? Specific triggers, not vague.

### 4. Enforcement Section (if applicable)
What rules the agent MUST follow. Use imperative language.

### 5. Content
The actual skill content - patterns, checklists, code examples, etc.

---

## Degrees of Freedom

Match instruction format to how much flexibility the agent has:

| Freedom Level | Format | When to Use |
|---|---|---|
| **High** (heuristics, guidelines) | Bullet points | "Prefer X over Y", design principles |
| **Medium** (templates, patterns) | Code blocks | Reusable snippets the agent should adapt |
| **Low** (fragile operations) | Exact bash commands | Database migrations, deployment scripts |

> [!TIP]
> If an agent could reasonably interpret the instruction 3 different ways, you need a code block or command - not a bullet.

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- QUALITY                                            -->
<!-- ═══════════════════════════════════════════════════ -->

## Quality Bar

A skill passes the quality bar if:

| Criterion | Test |
|---|---|
| **Agent-autonomous** | Can the agent apply this without asking the user? |
| **Concrete** | Does it have code examples, commands, or checklists? (Not just philosophy) |
| **Non-overlapping** | Does it duplicate content from another skill? If yes → merge or reference |
| **Beginner-friendly** | Would a first-week developer understand the README block? |
| **Under 200 lines** | Is the SKILL.md focused enough to fit in ~200 lines? If not, move one-time setup to SETUP.md or split into two skills |
| **Actionable** | Does every section tell the agent what to DO, not just what to think about? |

---

## File Structure

Each skill/extension lives in its own folder. Most have just one file:

```
extension-name/
  SKILL.md          ← Required. Workflow, rules, usage (read every session)
```

If the extension requires one-time MCP, CLI, or API setup, add a separate file:

```
extension-name/
  SKILL.md          ← Workflow + rules (read every session)
  SETUP.md          ← One-time install + config (read once on activation)
```

**When to use SETUP.md:**
- The extension needs MCP server configuration, API keys, or CLI installation
- The setup is genuinely one-time (not repeated per project or per session)
- Separating it keeps SKILL.md focused on the workflow the agent runs daily

**When NOT to use SETUP.md:**
- The skill has no installation or configuration steps (pure behavioral rules)
- The "setup" runs every time (like prerequisite checks) - keep in SKILL.md
- The skill is already under 200 lines - no need to split

**Cross-reference pattern:** SKILL.md must reference SETUP.md at the top:
```markdown
> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for [brief description].
```

## Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| Vague description ("helps with code quality") | Be specific: "Enforces input validation via Zod schemas on all mutations" |
| No code examples | Add at least 2 concrete examples |
| Duplicates another skill | Merge content or add a cross-reference: "See `security-guardian` for X" |
| Activation says "always" | Be specific: "When creating API routes" or "When writing mutations" |
| Pure philosophy, no action items | Convert to concrete rules with enforcement |
