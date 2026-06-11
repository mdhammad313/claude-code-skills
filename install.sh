#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
BASE_URL="https://raw.githubusercontent.com/mdhammad313/claude-code-skills/master"

GREEN='\033[0;32m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

CURSOR_MODE=false
for arg in "$@"; do
  [[ "$arg" == "--cursor" ]] && CURSOR_MODE=true
done

echo ""

if $CURSOR_MODE; then
  CURSOR_RULES_DIR=".cursor/rules"

  if [[ ! -f "package.json" && ! -f "nest-cli.json" && ! -f "tsconfig.json" ]]; then
    echo "Error: run this from inside your project root (no package.json found)."
    exit 1
  fi

  printf "${BOLD}Claude Code Skills — Cursor Rule Installer${RESET}\n"
  echo ""
  printf "${DIM}Installing NestJS Cursor rules into ${CURSOR_RULES_DIR}/${RESET}\n"
  echo ""

  mkdir -p "${CURSOR_RULES_DIR}"

  printf "${BOLD}NestJS / TypeORM${RESET}\n"
  declare -A NESTJS_CURSOR_RULES=(
    ["nestjs-service"]=".claude/skills/nestjs/write-nestjs-service/cursor-rule.mdc"
    ["nestjs-entity"]=".claude/skills/nestjs/write-typeorm-entity/cursor-rule.mdc"
    ["nestjs-dto"]=".claude/skills/nestjs/write-nestjs-dto/cursor-rule.mdc"
  )

  for rule_name in "${!NESTJS_CURSOR_RULES[@]}"; do
    src_path="${NESTJS_CURSOR_RULES[$rule_name]}"
    curl -fsSL "${BASE_URL}/${src_path}" -o "${CURSOR_RULES_DIR}/${rule_name}.mdc"
    printf "${GREEN}  ✓${RESET} ${CURSOR_RULES_DIR}/${rule_name}.mdc\n"
  done

  echo ""
  printf "${DIM}Done. Cursor will apply these rules automatically when editing matching files.${RESET}\n"
  echo ""
  printf "${DIM}  nestjs-service.mdc   → applied to src/**/*.service.ts${RESET}\n"
  printf "${DIM}  nestjs-entity.mdc    → applied to src/**/*.entity.ts${RESET}\n"
  printf "${DIM}  nestjs-dto.mdc       → applied to src/**/*.dto.ts${RESET}\n"
  echo ""

else
  printf "${BOLD}Claude Code Skills — Installer${RESET}\n"
  echo ""

  if ! command -v curl &>/dev/null; then
    echo "Error: curl is required. Install it and try again."
    exit 1
  fi

  mkdir -p "${SKILLS_DIR}"

  GENERAL_SKILLS=(onboard-me rubber-duck explain-to-pm tech-debt-radar)
  NESTJS_SKILLS=(write-nestjs-service write-typeorm-entity write-nestjs-dto)
  REACT_SKILLS=(write-react-component write-react-hook write-react-service)
  RN_SKILLS=(write-rn-screen write-rn-component write-rn-hook)

  printf "${BOLD}General${RESET}\n"
  for skill in "${GENERAL_SKILLS[@]}"; do
    mkdir -p "${SKILLS_DIR}/${skill}"
    curl -fsSL "${BASE_URL}/.claude/skills/${skill}/SKILL.md" -o "${SKILLS_DIR}/${skill}/SKILL.md"
    printf "${GREEN}  ✓${RESET} /${skill}\n"
  done

  echo ""
  printf "${BOLD}NestJS / TypeORM${RESET}\n"
  for skill in "${NESTJS_SKILLS[@]}"; do
    mkdir -p "${SKILLS_DIR}/${skill}"
    curl -fsSL "${BASE_URL}/.claude/skills/nestjs/${skill}/SKILL.md" -o "${SKILLS_DIR}/${skill}/SKILL.md"
    printf "${GREEN}  ✓${RESET} /${skill}\n"
  done

  echo ""
  printf "${BOLD}React / Next.js${RESET}\n"
  for skill in "${REACT_SKILLS[@]}"; do
    mkdir -p "${SKILLS_DIR}/${skill}"
    curl -fsSL "${BASE_URL}/.claude/skills/react/${skill}/SKILL.md" -o "${SKILLS_DIR}/${skill}/SKILL.md"
    printf "${GREEN}  ✓${RESET} /${skill}\n"
  done

  echo ""
  printf "${BOLD}React Native${RESET}\n"
  for skill in "${RN_SKILLS[@]}"; do
    mkdir -p "${SKILLS_DIR}/${skill}"
    curl -fsSL "${BASE_URL}/.claude/skills/react-native/${skill}/SKILL.md" -o "${SKILLS_DIR}/${skill}/SKILL.md"
    printf "${GREEN}  ✓${RESET} /${skill}\n"
  done

  echo ""
  printf "${DIM}Installed to ${SKILLS_DIR}${RESET}\n"
  echo ""
  echo "Open Claude Code in any project and type:"
  echo ""
  printf "${DIM}  /onboard-me             generate a personalized dev guide for any codebase${RESET}\n"
  printf "${DIM}  /rubber-duck            structured debugging to help you find the answer yourself${RESET}\n"
  printf "${DIM}  /explain-to-pm          translate your code changes into plain English${RESET}\n"
  printf "${DIM}  /tech-debt-radar        scan your codebase and prioritize what to fix first${RESET}\n"
  printf "${DIM}  /write-nestjs-service   write a NestJS service following best practices${RESET}\n"
  printf "${DIM}  /write-typeorm-entity   write a TypeORM entity with proper types and constraints${RESET}\n"
  printf "${DIM}  /write-nestjs-dto       write a NestJS DTO with validation and transforms${RESET}\n"
  printf "${DIM}  /write-react-component  write a Next.js component with Tailwind and TypeScript${RESET}\n"
  printf "${DIM}  /write-react-hook       write a React custom hook with API integration${RESET}\n"
  printf "${DIM}  /write-react-service    write a React API service module${RESET}\n"
  printf "${DIM}  /write-rn-screen        write a React Native screen with navigation and styling${RESET}\n"
  printf "${DIM}  /write-rn-component     write a React Native reusable component${RESET}\n"
  printf "${DIM}  /write-rn-hook          write a React Native custom hook with cleanup${RESET}\n"
  echo ""
fi
