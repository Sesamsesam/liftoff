#!/bin/bash
# ─────────────────────────────────────────────────────────
# Liftoff Eject - Clean Uninstaller (macOS/Linux)
# Removes all Liftoff global files, skills, extensions, and symlinks.
# Preserves user custom extensions and MCP settings.
# ─────────────────────────────────────────────────────────

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# ─── Temp copy logic (to prevent file lock during self-destruction) ───
TEMP_EJECT="/tmp/liftoff-eject-temp.sh"
if [ "${BASH_SOURCE[0]}" != "$TEMP_EJECT" ]; then
  cp "${BASH_SOURCE[0]}" "$TEMP_EJECT"
  chmod +x "$TEMP_EJECT"
  exec "$TEMP_EJECT" "$@"
fi

# Ensure temp script cleans itself up on exit
trap 'rm -f "$TEMP_EJECT"' EXIT

echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
echo -e "${RED}             LIFOFF EJECT / UNINSTALL      ${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
echo -e "Starting clean uninstallation of Liftoff..."

GEMINI_DIR="$HOME/.gemini"
SKILLS_DIR="$GEMINI_DIR/skills"
WORKFLOWS_DIR="$GEMINI_DIR/workflows"
EXTENSIONS_DIR="$GEMINI_DIR/extensions"
SETUP_DIR="$GEMINI_DIR/setup"

# 1. Read source repo path before deleting anything
SOURCE_DIR=""
if [ -f "$GEMINI_DIR/.liftoff-source" ]; then
  SOURCE_DIR=$(cat "$GEMINI_DIR/.liftoff-source")
fi

# 2. Clean up project-level symlinks
clean_project_symlinks() {
  local target_dir="$1"
  if [ -d "$target_dir/.gemini" ]; then
    echo -e "  Cleaning symlinks in: ${BLUE}$target_dir${NC}"
    # Remove files/symlinks
    rm -f "$target_dir/.gemini/GEMINI.md"
    rm -f "$target_dir/.gemini/extensions"
    rm -f "$target_dir/.gemini/user-extensions"
    rm -f "$target_dir/.gemini/.liftoff-init"
    # Delete .gemini if empty
    rmdir "$target_dir/.gemini" 2>/dev/null || true
  fi
}

echo -e "\n${BLUE}Searching for Liftoff symlinks in project folders...${NC}"
# Check current directory
clean_project_symlinks "."

# Check standard ~/dev/ folder (1 level deep)
if [ -d "$HOME/dev" ]; then
  for dir in "$HOME/dev"/*/; do
    if [ -d "$dir" ]; then
      clean_project_symlinks "${dir%/}"
    fi
  done
fi

# 3. Clean up global Liftoff files & folders
echo -e "\n${BLUE}Removing global Liftoff components...${NC}"

# Remove core workflows
rm -f "$WORKFLOWS_DIR/init-project.md"
rmdir "$WORKFLOWS_DIR" 2>/dev/null || true
echo "  ✓ Removed global workflows"

# Remove setup tasks
rm -rf "$SETUP_DIR/package-manager"
rmdir "$SETUP_DIR" 2>/dev/null || true
echo "  ✓ Removed setup tasks"

# Remove core skills
CORE_SKILLS=("forge-methodology" "security-guardian" "error-handling" "git-flow" "brand-identity" "stack-pro-max" "antigravity-standard" "liftoff-lifecycle" "liftoff-eject")
for skill in "${CORE_SKILLS[@]}"; do
  rm -rf "$SKILLS_DIR/$skill"
done
rmdir "$SKILLS_DIR" 2>/dev/null || true
echo "  ✓ Removed core skills"

# Remove default package extensions
DEFAULT_EXTS=("autorag-pipeline" "cloudflare-mcp" "firecrawl" "google" "minibook-pipeline" "notebooklm-research" "notion-publishing" "orbit-planning" "security-tools" "web-blog")
for ext in "${DEFAULT_EXTS[@]}"; do
  rm -rf "$EXTENSIONS_DIR/$ext"
done

# Prune extensions.json
if [ -f "$EXTENSIONS_DIR/extensions.json" ]; then
  if command -v python3 &>/dev/null; then
    python3 -c "
import json, os
with open('$EXTENSIONS_DIR/extensions.json') as f:
    data = json.load(f)
keys_to_remove = ['setup-package-manager', 'notebooklm-research', 'orbit-planning', 'cloudflare-mcp', 'firecrawl', 'minibook-pipeline', 'notion-publishing', 'autorag-pipeline', 'web-blog', 'google']
for k in keys_to_remove:
    data.pop(k, None)
# If only instructions remain, delete the file
if len(data) <= 1:
    os.remove('$EXTENSIONS_DIR/extensions.json')
else:
    with open('$EXTENSIONS_DIR/extensions.json', 'w') as f:
        json.dump(data, f, indent=2)
" 2>/dev/null || rm -f "$EXTENSIONS_DIR/extensions.json"
  else
    rm -f "$EXTENSIONS_DIR/extensions.json"
  fi
fi
rmdir "$EXTENSIONS_DIR" 2>/dev/null || true
echo "  ✓ Removed default extensions"

# Remove rules and tracking files
rm -f "$GEMINI_DIR/GEMINI.md"
rm -f "$GEMINI_DIR/.liftoff-source"
rm -f "$GEMINI_DIR/.liftoff-version"
echo "  ✓ Removed global rules and tracking files"

# 4. Remove cloned source repository
if [ -n "$SOURCE_DIR" ] && [ -d "$SOURCE_DIR" ]; then
  # Safe check to make sure we don't delete home or root
  if [ "$SOURCE_DIR" != "$HOME" ] && [ "$SOURCE_DIR" != "/" ]; then
    # Get absolute paths of CWD and SOURCE_DIR
    CWD_ABS=$(pwd -P)
    SOURCE_DIR_ABS=$(cd "$SOURCE_DIR" && pwd -P 2>/dev/null || echo "$SOURCE_DIR")

    if [[ "$CWD_ABS" == "$SOURCE_DIR_ABS"* ]]; then
      echo -e "  ${YELLOW}⚠️  Active workspace detected at: $SOURCE_DIR${NC}"
      echo -e "  Skipping deletion of the source repository folder because you are currently working inside it."
    else
      rm -rf "$SOURCE_DIR"
      echo -e "  ✓ Removed source repository clone: ${YELLOW}$SOURCE_DIR${NC}"
    fi
  fi
fi

# If the entire .gemini directory is empty (except for IDE data), we leave it
# but delete if empty.
rmdir "$GEMINI_DIR" 2>/dev/null || true

echo -e "\n${GREEN}✅ Eject complete!${NC}"
echo "All Liftoff files, skills, extensions, and project symlinks have been removed."
echo "Your custom user-extensions and MCP configurations remain untouched."
echo -e "${YELLOW}Please restart your editor / agent session to apply the changes.${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
