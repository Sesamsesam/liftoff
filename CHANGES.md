# Change Cascade Checklist

> **Read this before committing any change to the Liftoff source repo.**
> Every change can ripple across multiple files. Check the relevant rows below.

| What Changed | Also Check |
|---|---|
| **Extension folder structure** (new files, sub-folders, renamed) | `install.sh`, `install.ps1`, `README.md` file tree, `liftoff-lifecycle` Extension Folder Structure |
| **New extension added** | `extensions.json`, `README.md` extension table + count, `install.sh` / `install.ps1` if install logic changed |
| **Extension removed** | `extensions.json`, `README.md` extension table + count, any `workflows/` that reference it as a branch |
| **Skill convention changed** (e.g. workflow sub-files pattern) | `antigravity-standard/SKILL.md`, `liftoff-lifecycle` Extension Folder Structure, `README.md` How Skills Work |
| **Session Start rules changed** | `liftoff-lifecycle` Session Start section, liftoff trigger (same file), `init-project.md` if it affects scaffolding |
| **PROBE / init-project changed** | `workflows/init-project.md`, `README.md` if it affects user-facing descriptions |
| **Workflow chaining changed** (next step references) | All `workflows/*.md` files in affected extension, any extension that branches to/from it |
| **Install script logic changed** | Both `install.sh` AND `install.ps1` AND `update.sh` AND `update.ps1` (keep all four in sync) |
| **README.md file tree updated** | Verify it matches the actual folder structure (`find extensions/ -type f`) |
| **GEMINI.md rules changed** | `README.md` if it affects user-facing descriptions. Note: GEMINI.md is now minimal - most rules live in `liftoff-lifecycle` skill |
| **Lifecycle/platform rules changed** | `liftoff-lifecycle/SKILL.md`, `README.md`, `init-project.md`, `package-manager/SKILL.md` if they reference moved sections |
| **User extension paths changed** | `liftoff-lifecycle` Skill Creation section, `init-project.md` symlinks, `install.sh`/`install.ps1`/`update.sh`/`update.ps1`, `README.md` diagrams, Cloud Agent Support |
| **Security tools docs (Socket)** | `security-guardian/SKILL.md`, `extensions/security-tools/SKILL.md`, `extensions/extensions.json` entry if added |
