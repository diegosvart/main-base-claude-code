#!/bin/bash
# setup.sh — crea la estructura de directorios de main-base-claude-code
# Ejecutar desde la raíz del repo clonado: bash setup.sh

set -e

echo "🏗️  Creando estructura de main-base-claude-code..."

# ─── Directorios ───────────────────────────────────────────────
mkdir -p .claude/agents
mkdir -p .claude/commands
mkdir -p .claude/skills
mkdir -p skill/templates
mkdir -p machine-readable
mkdir -p docs/decisions
mkdir -p docs/phases    # generado en runtime por close-phase

echo "✅ Directorios creados:"
find . -type d -not -path "./.git/*" | sort | sed 's|./||' | awk '{print "   " $0}'

echo ""
echo "📋 Ahora copia cada archivo descargado a su ubicación:"
echo ""
echo "   RAÍZ:"
echo "   README.md  llms.txt  CHANGELOG.md  Makefile  .gitignore  .mcp.json"
echo ""
echo "   .claude/"
echo "   settings.json  SKILLS_CATALOG.md"
echo ""
echo "   .claude/agents/"
echo "   tl-orchestrator.md  architecture.md  backend.md  dba.md  frontend.md"
echo ""
echo "   .claude/commands/"
echo "   commit.md  new-feature.md  create-pr.md  review.md  close-phase.md  deploy.md"
echo ""
echo "   skill/"
echo "   SKILL.md  challenge-system.md  resume-protocol.md  analyze-protocol.md"
echo "   bootstrap.md  stack-selector.md  close-phase.md"
echo ""
echo "   skill/templates/"
echo "   REQUIREMENTS.template.md  ARCHITECTURE.template.md  PLAN.template.md"
echo "   OPEN_QUESTIONS.template.md  CLAUDE.template.md"
echo ""
echo "   machine-readable/"
echo "   index.yaml"
echo ""
echo "   docs/"
echo "   onboarding-prompt.md"
echo ""
echo "   docs/decisions/"
echo "   001-cli-over-mcp.md  002-screaming-plus-ports.md  003-claude-mem-referenced.md"
echo ""
echo "🏁 Cuando tengas todos los archivos en su lugar:"
echo "   git add -A"
echo "   git commit -m 'chore: initial template setup v1.0.0'"
echo "   git push origin main"
