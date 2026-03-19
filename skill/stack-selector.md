# Stack Selector

Maps the detected stack to skills, agents, and hook extensions.
Executed during bootstrap. Reads ARCHITECTURE.md for stack definition.

---

## Detection

Parse ARCHITECTURE.md for stack keywords:

```bash
grep -i "python\|fastapi\|django\|flask\|node\|react\|vue\|next\|postgres\|mysql\|mongo\|redis" \
  ARCHITECTURE.md 2>/dev/null | head -20
```

---

## Mapping table

### Python / FastAPI

```
Skills to install in .claude/skills/:
  - fastapi-patterns   (router, service, repository, schemas structure)
  - pytest-async       (AsyncClient, fixtures, conftest patterns)
  - alembic-migrations (migration workflow and naming conventions)
  - sqlalchemy-async   (async session patterns, N+1 prevention)

Agents to activate:
  - tl-orchestrator    (always)
  - architecture       (always)
  - backend            (always for Python projects)
  - dba                (if PostgreSQL or MySQL detected)
  - frontend           (if UI mentioned in REQUIREMENTS.md)

Hook extensions to add to settings.json:
  PostToolUse(Write *.py):
    - ruff format $file
    - ruff check --fix $file
    - mypy $file (on service.py and repositories/)

Additional Makefile targets:
  - make test → pytest -xvs --cov=app --cov-report=term-missing
  - make lint → ruff check . && ruff format . && mypy app/
  - make migrate → alembic upgrade head
  - make dev → uvicorn app.main:app --reload --port 8000
```

### Node / TypeScript

```
Skills to install:
  - typescript-patterns
  - jest-testing
  - prisma-orm (if Prisma detected)

Agents to activate:
  - tl-orchestrator, architecture, backend
  - frontend (if React/Vue/Next detected)

Hook extensions:
  PostToolUse(Write *.ts, *.js):
    - eslint --fix $file
    - prettier --write $file
```

### React / Vue / Next (frontend)

```
Skills to install:
  - component-structure
  - accessibility-patterns
  - storybook (optional — ask user)

Agents to activate:
  - frontend (primary)
  - tl-orchestrator, architecture
```

---

## Automation tools (Architecture Agent knowledge)

These are NOT separate agents. The Architecture Agent knows to recommend them
when the project scope includes automation, scraping, or workflow orchestration:

```
Playwright  → E2E testing, browser automation, scraping
n8n         → Visual workflow automation, integrations
Celery      → Background tasks, task queues (Python)
Scrapy      → Large-scale web scraping (Python)
```

When REQUIREMENTS.md mentions automation or scraping:
→ Architecture Agent proposes the appropriate tool in ARCHITECTURE.md
→ Stack selector adds the relevant skill if it exists

---

## Always install (every project)

```
Skills:
  (none base — commands cover the workflow)

Agents:
  - tl-orchestrator   (mandatory, always)
  - architecture      (mandatory, always)

Commands (already in template):
  - commit, new-feature, create-pr, review, close-phase, deploy (placeholder)
```

---

## Output

After running stack selector, report:
```
Stack detectado: [X]
Skills instalados: [list]
Agentes activos: [list]
Hooks adicionales: [list]
```
