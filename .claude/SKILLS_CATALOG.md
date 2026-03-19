# Skills Catalog

Library of available skills per domain.
Each agent has a base minimum — additional skills can be installed as needed.

Installed skills live in `.claude/skills/[skill-name]/SKILL.md`.
Install via: `mkdir -p .claude/skills/[name] && cp [source] .claude/skills/[name]/SKILL.md`

---

## Base minimum per agent (always installed)

| Agent | Base skills |
|---|---|
| TL / Orchestrator | *(commands cover the workflow — no skills needed)* |
| Architecture | `review` command |
| Backend (Python) | `fastapi-patterns`, `pytest-async` |
| DBA | `alembic-migrations`, `sqlalchemy-async` |
| Frontend | `component-structure` |

---

## Python / FastAPI

| Skill | Triggers | What it provides |
|---|---|---|
| `fastapi-patterns` | new endpoint, router, service, repository | Full templates: router/service/repository/schemas, dependency injection patterns |
| `pytest-async` | test, pytest, fixture, AsyncClient | conftest.py patterns, async fixtures, factory_boy, coverage config |
| `alembic-migrations` | migration, alembic, schema change | Naming conventions, revision workflow, rollback patterns |
| `sqlalchemy-async` | query, relationship, N+1, session | Async session patterns, eager/lazy loading, query optimization |

---

## Architecture

| Skill | Triggers | What it provides |
|---|---|---|
| `screaming-ports` | ports, hexagonal, reusable module | Pattern templates: ports.py ABC, infra/ implementation, service.py constraints |
| `adr-template` | architecture decision, ADR | Standard ADR format and examples |

---

## Frontend (React / Vue / Next)

| Skill | Triggers | What it provides |
|---|---|---|
| `component-structure` | component, UI, React, Vue | Component folder structure, co-located tests, prop typing |
| `accessibility-patterns` | accessibility, a11y, ARIA, keyboard | ARIA patterns, focus management, color contrast rules |
| `storybook` | story, visual test, component library | Storybook config and story templates |

---

## Context & Memory

| Skill | Triggers | What it provides |
|---|---|---|
| `mem-search` | last session, what was I doing, resume | Queries claude-mem for session history (requires claude-mem installed) |

---

## External resources

| Tool | Install | License |
|---|---|---|
| `claude-mem` | `/plugin marketplace add thedotmack/claude-mem` | AGPL-3.0 |
| `fastapi-templates` (FastMCP) | `mkdir -p .claude/skills/fastapi-templates && curl ...` | Check source |

---

## Adding a new skill

```bash
# Create skill directory
mkdir -p .claude/skills/[skill-name]

# Create SKILL.md with required frontmatter
cat > .claude/skills/[skill-name]/SKILL.md << 'EOF'
---
name: [skill-name]
description: >
  [What it does and when Claude should auto-activate it.
  Include key trigger phrases.]
---

# [Skill Name]

[Content]
EOF
```

Then add the entry to this catalog so agents know it exists.

---

## Notes

- Skills are loaded on demand — they consume zero tokens until activated
- Keep each SKILL.md under 200 lines — move detail to reference files in the same folder
- Name skills with gerunds when possible: `generating-reports` not `report-generator`
- The `description` field is what Claude reads to decide when to activate — make it specific
