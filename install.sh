#!/bin/bash
# ─────────────────────────────────────────────────────────
# Antigravity Source Setup - Installer
# One-command install for AI agent guardrails, skills, and workflows
# ─────────────────────────────────────────────────────────

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Paths
GEMINI_DIR="$HOME/.gemini"
SKILLS_DIR="$GEMINI_DIR/skills"
WORKFLOWS_DIR="$GEMINI_DIR/workflows"
SETTINGS_DIR="$GEMINI_DIR/settings"
SETUP_DIR="$GEMINI_DIR/setup"
EXTENSIONS_DIR="$SKILLS_DIR"  # Extensions are stored alongside skills
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${PURPLE}"
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║        ANTIGRAVITY SOURCE SETUP           ║"
echo "  ║   Enterprise-grade AI coding guardrails   ║"
echo "  ╚═══════════════════════════════════════════╝"
echo -e "${NC}"

# ─── Profile Selection ───
echo -e "${BLUE}Choose your profile:${NC}"
echo ""
echo "  1) ${GREEN}Starter${NC}    - Core AI skills and workflows (recommended)"
echo "  2) ${BLUE}Builder${NC}    - 1 + deploy to the web, manage databases and storage via Cloudflare"
echo "  3) ${YELLOW}Researcher${NC} - 1 + 2 + deep research pipelines and strategic project planning"
echo "  4) ${PURPLE}Full${NC}       - Everything enabled"
echo ""
read -rp "Enter 1, 2, 3, or 4 [default: 1]: " PROFILE
PROFILE=${PROFILE:-1}

# ─── Validate ───
if [[ ! "$PROFILE" =~ ^[1-4]$ ]]; then
  echo -e "${RED}Invalid selection. Please run again and choose 1, 2, 3, or 4.${NC}"
  exit 1
fi

# ─── Create directories ───
echo -e "\n${BLUE}Creating directories...${NC}"
mkdir -p "$SKILLS_DIR"
mkdir -p "$WORKFLOWS_DIR"
mkdir -p "$SETTINGS_DIR"
mkdir -p "$SETUP_DIR"

# ─── Backup existing GEMINI.md ───
if [ -f "$GEMINI_DIR/GEMINI.md" ]; then
  BACKUP_NAME="GEMINI.md.backup.$(date +%Y%m%d_%H%M%S)"
  echo -e "${YELLOW}Existing GEMINI.md found - backing up as $BACKUP_NAME${NC}"
  cp "$GEMINI_DIR/GEMINI.md" "$GEMINI_DIR/$BACKUP_NAME"
fi

# ─── Install Core Identity (Phase 1) ───
echo -e "${GREEN}Installing core identity...${NC}"
cp "$SCRIPT_DIR/global/GEMINI.md" "$GEMINI_DIR/GEMINI.md"
cp "$SCRIPT_DIR/settings/extensions.json" "$SETTINGS_DIR/extensions.json"

# ─── Install Skills (Phase 2) ───
echo -e "${GREEN}Installing skills...${NC}"
CORE_SKILLS=("forge-methodology" "security-guardian" "error-handling" "git-flow" "brand-identity" "stack-pro-max" "antigravity-standard")

for skill in "${CORE_SKILLS[@]}"; do
  mkdir -p "$SKILLS_DIR/$skill"
  cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
  echo "  ✓ $skill"
done

# ─── Install Workflows (Phase 3) ───
echo -e "${GREEN}Installing workflows...${NC}"
cp "$SCRIPT_DIR/workflows/init-project.md" "$WORKFLOWS_DIR/init-project.md"
echo "  ✓ init-project"

# ─── Install Setup Tasks (Phase 3.5) ───
echo -e "${GREEN}Installing setup tasks...${NC}"
SETUP_TASKS=("package-manager")

for task in "${SETUP_TASKS[@]}"; do
  mkdir -p "$SETUP_DIR/$task"
  cp "$SCRIPT_DIR/setup/$task/SKILL.md" "$SETUP_DIR/$task/SKILL.md"
  echo "  ✓ $task (will run on first session)"
done

# ─── Install Extensions (based on profile) ───
install_extension() {
  local ext_name="$1"
  mkdir -p "$EXTENSIONS_DIR/$ext_name"
  cp "$SCRIPT_DIR/extensions/$ext_name/SKILL.md" "$EXTENSIONS_DIR/$ext_name/SKILL.md"
  echo "  ✓ $ext_name (installed, dormant - activate in extensions.json)"
}

if [[ "$PROFILE" -ge 2 ]]; then
  echo -e "${GREEN}Installing infrastructure extensions...${NC}"
  install_extension "cloudflare-mcp"
fi

if [[ "$PROFILE" -ge 3 ]]; then
  echo -e "${GREEN}Installing research extensions...${NC}"
  install_extension "notebooklm-research"
  install_extension "orbit-planning"
fi

if [[ "$PROFILE" -ge 4 ]]; then
  echo -e "${GREEN}Installing advanced extensions...${NC}"
  install_extension "extended-git"
  install_extension "beads-workflow"
fi

# ─── Summary ───
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "  ${BLUE}Profile:${NC}        $([ "$PROFILE" = "1" ] && echo "Starter" || ([ "$PROFILE" = "2" ] && echo "Builder" || ([ "$PROFILE" = "3" ] && echo "Researcher" || echo "Full")))"
echo -e "  ${BLUE}GEMINI.md:${NC}      $GEMINI_DIR/GEMINI.md"
echo -e "  ${BLUE}Skills:${NC}         $SKILLS_DIR/ (${#CORE_SKILLS[@]} core skills)"
echo -e "  ${BLUE}Setup tasks:${NC}    $SETUP_DIR/ (${#SETUP_TASKS[@]} pending)"
echo -e "  ${BLUE}Workflows:${NC}      $WORKFLOWS_DIR/"
echo -e "  ${BLUE}Extensions:${NC}     $SETTINGS_DIR/extensions.json"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Open any project and start a conversation with your AI agent"
echo "  2. The agent will automatically follow F.O.R.G.E. methodology"
echo "  3. To activate extensions, edit: $SETTINGS_DIR/extensions.json"
echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
