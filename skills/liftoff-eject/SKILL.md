---
name: liftoff-eject
description: "Eject and fully uninstall Liftoff skills, global settings, and project symlinks from the system."
---

# Liftoff Eject Skill

> **This skill contains the instructions to cleanly uninstall and remove the Liftoff package.**

## Activation
- User says "eject", "uninstall liftoff", "remove liftoff", "delete liftoff" or equivalent requests to start fresh without Liftoff.

---

## Uninstallation Workflow

When the user requests to eject/uninstall Liftoff:

1. **Explain the Eject Action**:
   Inform the user of exactly what will be removed and what will be preserved:
   - **Removed**: Core Liftoff skills, workflows, default package extensions, `GEMINI.md` global rules, version tracking files, and project-level symlinks.
   - **Preserved**: User-created extensions (`user-extensions/`), any custom keys/configurations in `extensions.json`, and the IDE's MCP settings (`mcp_config.json`).

2. **Execute the Eject Script**:
   Do NOT ask the user to run the commands. Execute the appropriate eject script based on the OS:
   - **macOS/Linux**:
     ```bash
     bash ~/.gemini/skills/liftoff-eject/eject.sh
     ```
   - **Windows (PowerShell)**:
     ```powershell
     powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\skills\liftoff-eject\eject.ps1"
     ```

3. **Report Status**:
   Once execution finishes, explain that Liftoff has been completely removed. Recommend that the user restarts their editor / AI agent session to clear any cached rules or context.
