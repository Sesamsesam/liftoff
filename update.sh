#!/bin/bash
# ─────────────────────────────────────────────────────────
# Antigravity Source Setup - Lightweight Updater
# Used by Session Start auto-update. NOT for first-time install.
# Nukes old files and replaces with fresh copies from source.
# ─────────────────────────────────────────────────────────

set -euo pipefail

# Paths
GEMINI_DIR="$HOME/.gemini"
SKILLS_DIR="$GEMINI_DIR/skills"
WORKFLOWS_DIR="$GEMINI_DIR/workflows"
EXTENSIONS_DIR="$GEMINI_DIR/extensions"
SETUP_DIR="$GEMINI_DIR/setup"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── SAFETY: NEVER touch user-extensions ───
# User-created extensions live in ~/.gemini/user-extensions/
# This directory is NOT part of the package and must NEVER be deleted,
# modified, or overwritten by the installer or updater.
USER_EXT_DIR="$GEMINI_DIR/user-extensions"

# ─── MCP Cleanup (every update kills zombies and removes legacy configs) ───
pkill -f "mcp-remote" 2>/dev/null || true
rm -f "$GEMINI_DIR/config/mcp_config.json"
rm -f "$GEMINI_DIR/antigravity/mcp_config.json"
rm -f "$GEMINI_DIR/antigravity-backup/mcp_config.json"

# ─── Overwrite GEMINI.md ───
cp "$SCRIPT_DIR/global/GEMINI.md" "$GEMINI_DIR/GEMINI.md"

# ─── Nuke and replace skills (preserve Machine Environment) ───
MACHINE_ENV_FILE=$(mktemp)
LIFECYCLE_FILE="$SKILLS_DIR/liftoff-lifecycle/SKILL.md"
if [ -f "$LIFECYCLE_FILE" ]; then
  sed -n '/^## Machine Environment$/,$p' "$LIFECYCLE_FILE" > "$MACHINE_ENV_FILE"
fi

rm -rf "$SKILLS_DIR"
mkdir -p "$SKILLS_DIR"
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  cp -r "$skill_dir" "$SKILLS_DIR/$skill_name"
done

# Re-append user's Machine Environment to fresh liftoff-lifecycle
if [ -s "$MACHINE_ENV_FILE" ]; then
  echo "" >> "$SKILLS_DIR/liftoff-lifecycle/SKILL.md"
  cat "$MACHINE_ENV_FILE" >> "$SKILLS_DIR/liftoff-lifecycle/SKILL.md"
fi
rm -f "$MACHINE_ENV_FILE"

# ─── Nuke and replace workflows ───
rm -rf "$WORKFLOWS_DIR"
mkdir -p "$WORKFLOWS_DIR"
cp "$SCRIPT_DIR/workflows"/*.md "$WORKFLOWS_DIR/" 2>/dev/null || true

# ─── Nuke and replace setup tasks ───
rm -rf "$SETUP_DIR"
mkdir -p "$SETUP_DIR"
for task_dir in "$SCRIPT_DIR/setup"/*/; do
  task_name=$(basename "$task_dir")
  cp -r "$task_dir" "$SETUP_DIR/$task_name"
done

# ─── Nuke extension folders and replace (preserve extensions.json settings) ───
# Remove all extension subdirectories (but keep extensions.json)
find "$EXTENSIONS_DIR" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} + 2>/dev/null || true

# Copy fresh extension folders from source
for ext_dir in "$SCRIPT_DIR/extensions"/*/; do
  ext_name=$(basename "$ext_dir")
  cp -r "$ext_dir" "$EXTENSIONS_DIR/$ext_name"
done

# Merge extensions.json (add new keys, preserve user values)
if [ -f "$EXTENSIONS_DIR/extensions.json" ]; then
  TEMP_MERGED=$(mktemp)
  python3 -c "
import json, sys
with open('$EXTENSIONS_DIR/extensions.json') as f: existing = json.load(f)
with open('$SCRIPT_DIR/extensions/extensions.json') as f: source = json.load(f)
for k, v in source.items():
    if k not in existing:
        existing[k] = v
with open('$TEMP_MERGED', 'w') as f: json.dump(existing, f, indent=2)
" 2>/dev/null
  cp "$TEMP_MERGED" "$EXTENSIONS_DIR/extensions.json"
  rm -f "$TEMP_MERGED"
else
  cp "$SCRIPT_DIR/extensions/extensions.json" "$EXTENSIONS_DIR/extensions.json"
fi

# ─── Update version tracking ───
if command -v git &> /dev/null && [ -d "$SCRIPT_DIR/.git" ]; then
  git -C "$SCRIPT_DIR" rev-parse HEAD > "$GEMINI_DIR/.liftoff-version" 2>/dev/null
fi
