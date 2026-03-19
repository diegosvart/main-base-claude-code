# [PROJECT_NAME]

## Project

**Stack**: [STACK_LINE]
**Purpose**: [ONE_LINE_PURPOSE]
**Auth**: [AUTH_METHOD]

## Commands

```bash
[COMMANDS_BLOCK]
```

## Git Workflow

```
feature/* → develop → main
```

- New branch: `git checkout -b feature/[short-name]`
- One PR per feature, always toward `develop`
- Squash merge to `main` — clean releases only
- **Never commit**: `.env`, secrets, generated files

## Code Conventions

- Type hints required on all public functions
- `async def` for endpoints and DB operations
- Pydantic v2 — use `.model_dump()` not `.dict()`
- DB injection via `Depends(get_db)` — never global
- Business exceptions → `HTTPException` with descriptive `detail`
- Structured logs with `structlog` — no `print()`

## Architecture

```
[FOLDER_STRUCTURE]
```

**Rule**: `service.py` never imports from `infra/` — only via `ports.py`
**Rule**: No file over 400 lines — split before reaching the limit
**Rule**: Ports mandatory when a module has >1 external dependency

## Testing Rules

- TDD — write tests before implementation
- `pytest -xvs tests/unit/test_[module].py` for isolated testing
- Async fixtures: `@pytest.mark.asyncio` + `AsyncClient`
- Minimum coverage: 80% on `services/` and `repositories/`

## Security Baseline

- Secrets via environment variables only (`.env` + `python-dotenv`)
- Explicit `ALLOWED_HOSTS` and CORS in production
- Dependency audit: `pip audit` in CI
- Security headers via `starlette.middleware`

## Context Management

**When compacting**, preserve:
- Complete list of files modified in this session
- Architecture decisions made and their justification
- Current test state (passing, failing)
- Next agreed step
- Any workaround or noted technical debt

**Session hygiene**:
- `/compact` at 50% context — don't wait for auto-compact
- `/clear` between unrelated tasks
- `/btw` for quick questions that shouldn't enter context
- Use subagents to explore codebase — keep main context clean

## Active Agents

[AGENTS_LIST]

## Skills Available

[SKILLS_LIST]

## MCP Servers

[MCP_LIST]

## Discovery Artifacts

- `REQUIREMENTS.md` — functional requirements and scope
- `ARCHITECTURE.md` — stack decisions and ADRs
- `PLAN.md` — development phases and current status
- `OPEN_QUESTIONS.md` — conscious technical debt

## References

@REQUIREMENTS.md
@ARCHITECTURE.md
@PLAN.md
