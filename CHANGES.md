# Change Cascade Checklist

> **Read this before committing any change to the Liftoff source repo.**
> Every change can ripple across multiple files. Check the relevant rows below.

| What Changed | Also Check |
|---|---|
| **Extension folder structure** (new files, sub-folders, renamed) | `install.sh`, `install.ps1`, `README.md` file tree, `GEMINI.md` Extension Folder Structure |
| **New extension added** | `extensions.json`, `README.md` extension table + count, `install.sh` / `install.ps1` if install logic changed |
| **Extension removed** | `extensions.json`, `README.md` extension table + count, any `workflows/` that reference it as a branch |
| **Skill convention changed** (e.g. workflow sub-files pattern) | `antigravity-standard/SKILL.md`, `GEMINI.md` Extension Folder Structure, `README.md` How Skills Work |
| **Session Start rules changed** | `GEMINI.md` Session Start section, liftoff trigger (same file), `init-project.md` if it affects scaffolding |
| **PROBE / init-project changed** | `workflows/init-project.md`, `README.md` if it affects user-facing descriptions |
| **Workflow chaining changed** (next step references) | All `workflows/*.md` files in affected extension, any extension that branches to/from it |
| **Install script logic changed** | Both `install.sh` AND `install.ps1` (keep them in sync) |
| **README.md file tree updated** | Verify it matches the actual folder structure (`find extensions/ -type f`) |
| **GEMINI.md rules changed** | `README.md` if it affects user-facing descriptions, `antigravity-standard/SKILL.md` if it affects skill conventions |
