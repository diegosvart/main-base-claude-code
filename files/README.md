# main-base-claude-code

> Claude Code project template with inception agent, specialized subagents, and quality-enforced workflows. From idea to codebase in one structured discovery session.

Stop starting from scratch. A Claude Code base template that turns a project idea into a validated technical blueprint — architecture decided, agents ready, quality gates enforced — before the first line of code.

[![Claude Code](https://img.shields.io/badge/Claude_Code-compatible-534AB7?style=for-the-badge)](https://code.claude.com)
[![License](https://img.shields.io/badge/License-MIT-teal?style=for-the-badge)](./LICENSE)
[![Template](https://img.shields.io/badge/Type-Template-amber?style=for-the-badge)](https://github.com/diegosvart/main-base-claude-code)

---

## ⚡ Quick Start

**Onboarding interactivo** (sin clonar):

```bash
claude "Fetch and follow the onboarding instructions from: https://raw.githubusercontent.com/diegosvart/main-base-claude-code/main/docs/onboarding-prompt.md"
```

**Nuevo proyecto desde cero:**

```bash
# 1. Instala el skill global de inception
mkdir -p ~/.claude/skills/inception
curl -sL https://raw.githubusercontent.com/diegosvart/main-base-claude-code/main/skill/SKILL.md \
  -o ~/.claude/skills/inception/SKILL.md

# 2. Desde cualquier directorio vacío
/inception "describe tu idea de proyecto aquí"
```

**Retomar trabajo interrumpido:**

```bash
/inception --resume
```

**Analizar repo existente:**

```bash
/inception --analyze ./mi-proyecto
```

---

## 🏗️ Qué incluye este template

### 6 capas preconfiguradas

| Capa | Ubicación | Qué hace |
|---|---|---|
| 1. Memoria | `CLAUDE.md` | Contexto del proyecto — generado por inception |
| 2. Skills | `.claude/skills/` | Playbooks por dominio — instalados según stack |
| 3. Commands | `.claude/commands/` | Slash commands del ciclo Git |
| 4. Hooks | `.claude/settings.json` | Quality gates automáticos |
| 5. MCP | `.mcp.json` | Servers externos — vacío por default |
| 6. Agents | `.claude/agents/` | Subagentes especializados |

### 5 agentes especializados

- **TL / Orchestrator** — siempre activo, coordina y delega
- **Architecture Agent** — decisiones técnicas, ADRs, Screaming+ports
- **Backend Agent** — FastAPI, services, repositories, tests
- **DBA Agent** — schema, migraciones, queries, performance
- **Frontend Agent** — UI, components, accesibilidad

> Las herramientas de automatización (Playwright, n8n, scraping) son recomendadas por el Architecture Agent según el scope del proyecto.

### Inception agent — 3 modos

```
/inception "brief"        → Discovery completo (5 fases, 4 artefactos)
/inception --resume       → Retoma desde artefactos existentes
/inception --analyze path → Analiza repo existente, detecta gaps
```

---

## 📋 Artefactos del discovery

El inception agent produce estos archivos **en español** antes de tocar código:

| Archivo | Se escribe en | Contenido |
|---|---|---|
| `REQUIREMENTS.md` | Gate 2 | Funcionalidades, scope in/out, actores |
| `ARCHITECTURE.md` | Gate 3 | Stack, decisiones, trade-offs, portabilidad |
| `PLAN.md` | Gate 4 | Fases, dependencias, Definition of Done |
| `OPEN_QUESTIONS.md` | Progresivo | Deuda técnica consciente (decisiones nivel-3) |
| `CLAUDE.md` | Bootstrap | Síntesis ejecutable — en inglés |

---

## 🏛️ Principios de arquitectura

### Screaming + Ports (no Hexagonal puro)

```
app/
├── audit/           ← dominio visible (Screaming)
│   ├── router.py    ← capa HTTP
│   ├── service.py   ← lógica pura — solo importa ports.py
│   ├── schemas.py   ← contratos Pydantic
│   └── ports.py     ← interfaces abstractas (ABCs)
│
└── infra/           ← implementaciones concretas
    ├── db/          ← SQLAlchemy implements IRepository
    └── cache/       ← Redis implements ICacheStore
```

**Regla de ports:** obligatorio cuando un módulo tiene más de una dependencia externa. Opcional con una sola (típicamente solo DB).

**Regla de portabilidad:** el inception pregunta en la Fase 2 si algún módulo necesita ser reutilizable entre proyectos. Si sí → estructura preparada para extracción como paquete.

### Quality gates enforced por hooks

- `PostToolUse(Write)` → ruff format + ruff check automático
- `SessionStart` → muestra branch actual + últimos 5 commits
- `Stop` → notificación de tarea completada
- Hook de teardown → detecta merge, lista herramientas en contexto, consulta qué desmontar

---

## 🧠 Gestión de contexto y memoria

Este template está diseñado para trabajar con **[claude-mem](https://github.com/thedotmack/claude-mem)** — un plugin de Claude Code con 18k stars que preserva contexto entre sesiones.

```bash
# Instalar claude-mem (recomendado)
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

Con claude-mem instalado, `/inception --resume` usa `mem-search` para recuperar el estado exacto de la última sesión. Sin él, carga los artefactos en disco como fallback.

### Disciplina de sesión

```
/compact    → al llegar al 50% de contexto (no esperar auto-compact)
/clear      → entre tareas no relacionadas
/btw        → preguntas rápidas que no deben entrar al contexto
```

---

## 🔧 CLI-first

**Principio transversal:** siempre CLI sobre MCP.

- Operaciones Git → `gh` CLI
- Filesystem → bash commands
- MCP → solo cuando no existe alternativa CLI

---

## 📁 Estructura del repositorio

```
main-base-claude-code/
├── README.md                    ← este archivo
├── llms.txt                     ← índice para LLMs externos
├── CHANGELOG.md
├── Makefile                     ← test, lint, dev, migrate
├── .gitignore
├── .mcp.json                    ← vacío por default
│
├── machine-readable/
│   └── index.yaml               ← índice parseable para agentes
│
├── docs/
│   ├── onboarding-prompt.md     ← prompt de orientación rápida
│   └── decisions/               ← ADRs del template
│       ├── 001-cli-over-mcp.md
│       ├── 002-screaming-plus-ports.md
│       └── 003-claude-mem-referenced.md
│
├── skill/                       ← inception agent (instalar en ~/.claude/skills/)
│   ├── SKILL.md
│   ├── challenge-system.md
│   ├── resume-protocol.md
│   ├── analyze-protocol.md
│   ├── bootstrap.md
│   ├── stack-selector.md
│   ├── close-phase.md
│   └── templates/
│       ├── REQUIREMENTS.template.md
│       ├── ARCHITECTURE.template.md
│       ├── PLAN.template.md
│       ├── OPEN_QUESTIONS.template.md
│       └── CLAUDE.template.md
│
└── .claude/
    ├── settings.json            ← hooks base + sección dinámica
    ├── settings.local.json      ← gitignored
    ├── SKILLS_CATALOG.md        ← biblioteca de skills por dominio
    ├── commands/
    │   ├── commit.md
    │   ├── new-feature.md
    │   ├── create-pr.md
    │   ├── review.md
    │   ├── close-phase.md
    │   └── deploy.md            ← placeholder
    └── agents/
        ├── tl-orchestrator.md
        ├── architecture.md
        ├── backend.md
        ├── dba.md
        └── frontend.md
```

---

## 📚 Recursos relacionados

- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [claude-mem — Persistent memory](https://github.com/thedotmack/claude-mem)
- [Claude Code Ultimate Guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide) — Documentación exhaustiva de Claude Code (beginner to power user), con 111 templates, 257 preguntas de quiz, cheatsheet imprimible y workflows de automatización. Referencia principal para explorar capacidades avanzadas del IDE.
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)

---

## 📄 Licencia

MIT — libre para usar, modificar y distribuir.

> **Nota sobre claude-mem**: referenciado como plugin externo (AGPL-3.0). No incluye su código en este template.
