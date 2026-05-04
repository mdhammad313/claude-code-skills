#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
BASE_URL="https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master"

GREEN='\033[0;32m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
printf "${BOLD}Claude Code Skills — Installer${RESET}\n"
echo ""

if ! command -v curl &>/dev/null; then
  echo "Error: curl is required. Install it and try again."
  exit 1
fi

mkdir -p "${SKILLS_DIR}"

SKILLS=(onboard-me rubber-duck explain-to-pm tech-debt-radar)

for skill in "${SKILLS[@]}"; do
  mkdir -p "${SKILLS_DIR}/${skill}"
  curl -fsSL "${BASE_URL}/${skill}/SKILL.md" -o "${SKILLS_DIR}/${skill}/SKILL.md"
  printf "${GREEN}  ✓${RESET} /${skill}\n"
done

echo ""
printf "${DIM}Installed to ${SKILLS_DIR}${RESET}\n"
echo ""
echo "Open Claude Code in any project and type:"
echo ""
printf "${DIM}  /onboard-me       generate a personalized dev guide for any codebase${RESET}\n"
printf "${DIM}  /rubber-duck      structured debugging to help you find the answer yourself${RESET}\n"
printf "${DIM}  /explain-to-pm    translate your code changes into plain English${RESET}\n"
printf "${DIM}  /tech-debt-radar  scan your codebase and prioritize what to fix first${RESET}\n"
echo ""
