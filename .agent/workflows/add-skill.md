---
description: "Checklist of every file to update when adding a new skill, extension, or setup task to the Liftoff source repo."
---

# Add Skill / Extension / Setup Task

> **This is the single source of truth** for every file that must be updated when adding, removing, or modifying a component in the Liftoff source repo.

---

## Quick Reference

| Component Type | Source Dir | Installed To | Tracked In |
|---|---|---|---|
| Core Skill | `skills/<name>/SKILL.md` | `~/.gemini/skills/<name>/` | `install.sh` CORE_SKILLS array |
| Extension | `extensions/<name>/SKILL.md` | `~/.gemini/skills/<name>/` | `install.sh` install_extension calls + `extensions.json` |
| Setup Task | `setup/<name>/SKILL.md` | `~/.gemini/setup/<name>/` | `install.sh` SETUP_TASKS array + `extensions.json` |
| Workflow | `workflows/<name>.md` | `~/.gemini/workflows/` | `install.sh` (manual cp line) |

---

## Adding a Core Skill

### Files to update (5):

| # | File | What to update | Line/Section |
|---|---|---|---|
| 1 | `skills/<name>/SKILL.md` | **Create** the skill file | New file |
| 2 | `install.sh` | Add `"<name>"` to `CORE_SKILLS` array | ~Line 71 |
| 3 | `README.md` | Add row to **Core** table | "What's Inside > Core" section |
| 4 | `README.md` | Add entry to **File Structure > Global** tree | "File Structure" section |
| 5 | `README.md` | Update core skill count in **What You Get** table | "What You Get" row: "⚡ **N core skills**" |

### Optional:
- `global/GEMINI.md` - Only if the skill introduces new agent rules (e.g., Typography, Browser rules)

---

## Adding an Extension

### Files to update (7):

| # | File | What to update | Line/Section |
|---|---|---|---|
| 1 | `extensions/<name>/SKILL.md` | **Create** the extension file | New file |
| 2 | `settings/extensions.json` | Add `"<name>": false` entry | Alphabetical among extensions |
| 3 | `install.sh` | Add `install_extension "<name>"` under the correct profile tier | Profile section (~Lines 102-117) |
| 4 | `README.md` | Add row to **Extensions** table with correct profile tier | "What's Inside > Extensions" section |
| 5 | `README.md` | Add entry to **File Structure > Global** tree with `(extension)` tag | "File Structure" section |
| 6 | `README.md` | Update extension count in **What You Get** table | "What You Get" row: "🔌 **N optional extensions**" |
| 7 | `README.md` | Update profile description if extension adds a new category | Profile selection descriptions |

### Profile tiers in install.sh:
```
Profile 2 (Builder+):      Lines 102-105   - Infrastructure tools
Profile 3 (Researcher+):   Lines 107-111   - Research + planning tools
Profile 4 (Full):           Lines 113-117   - Advanced workflows
```

### Optional:
- `global/GEMINI.md` - Only if extension requires new agent rules or references

---

## Adding a Setup Task

### Files to update (4):

| # | File | What to update | Line/Section |
|---|---|---|---|
| 1 | `setup/<name>/SKILL.md` | **Create** the setup task file | New file |
| 2 | `install.sh` | Add `"<name>"` to `SETUP_TASKS` array | ~Line 86 |
| 3 | `settings/extensions.json` | Add `"setup-<name>": "pending"` entry | Top of file, before extensions |
| 4 | `README.md` | Add entry to **File Structure > Global** tree under `setup/` | "File Structure" section |

### Important:
- Setup entries use `"pending"` / `"done"` (not `true` / `false`)
- The `GEMINI.md` Session Start section already handles all `setup-*` entries generically - no update needed

---

## Adding a Workflow

### Files to update (3):

| # | File | What to update | Line/Section |
|---|---|---|---|
| 1 | `workflows/<name>.md` | **Create** the workflow file | New file |
| 2 | `install.sh` | Add `cp` line for the new workflow | After ~Line 81 |
| 3 | `README.md` | Add entry to **File Structure > Global** tree under `workflows/` | "File Structure" section |

---

## Removing a Component

Reverse the steps above for the component type. Additionally:
- Core skills: Remove from `CORE_SKILLS` array, delete `skills/<name>/` directory
- Extensions: Remove `install_extension` call, remove from `extensions.json`, delete `extensions/<name>/` directory
- Setup tasks: Remove from `SETUP_TASKS` array, remove `"setup-<name>"` from `extensions.json`, delete `setup/<name>/` directory

---

## Verification Command

Run this after any add/remove to check for sync issues:

```bash
// turbo
cd /path/to/antigravity-source-setup && \
echo "=== Skills in dir vs install.sh ===" && \
echo "Dir:" && ls skills/ | sort && \
echo "install.sh:" && grep -oP '"[^"]+"' install.sh | grep -v install_extension | head -7 | tr -d '"' | sort && \
echo "" && \
echo "=== Extensions in dir vs install.sh ===" && \
echo "Dir:" && ls extensions/ | sort && \
echo "install.sh:" && grep -oP 'install_extension "([^"]+)"' install.sh | sed 's/install_extension "//;s/"//' | sort && \
echo "" && \
echo "=== Extensions in dir vs extensions.json ===" && \
echo "Dir:" && ls extensions/ | sort && \
echo "JSON:" && grep -oP '"([^"]+)":\s*(false|true)' settings/extensions.json | sed 's/"//g;s/:.*//' | sort && \
echo "" && \
echo "=== Setup in dir vs install.sh ===" && \
echo "Dir:" && ls setup/ | sort && \
echo "install.sh:" && grep -oP 'SETUP_TASKS=\(([^)]+)\)' install.sh | grep -oP '"[^"]+"' | tr -d '"' | sort
```
