# Close Phase

Executed automatically when a merge or PR close is detected via gh CLI,
or manually via `/close-phase [phase-name]`.

---

## Trigger detection (automatic)

```bash
# Check for recently merged PRs on develop or main
gh pr list --state merged --base develop --limit 5 --json number,title,mergedAt 2>/dev/null
gh pr list --state merged --base main --limit 5 --json number,title,mergedAt 2>/dev/null
```

If a merge is detected that matches a phase in PLAN.md → trigger close-phase flow.

---

## Step 1 — Identify closed phase

Read PLAN.md and find the phase that matches the merged PR/branch.

```bash
cat PLAN.md
git log --oneline -10
```

---

## Step 2 — Update PLAN.md

Mark the phase as done:

```markdown
## Phase 1 — [Name]  ✅ CLOSED [date]
...
```

Update the "Current phase" indicator at the top of PLAN.md.

---

## Step 3 — Generate phase summary

Write to `docs/phases/phase-[N]-summary.md`:

```markdown
# Phase [N] — [Name] — Summary

**Closed**: [date]
**Branch**: [branch name]
**PR**: [PR number and title]

## What was built
[List of features/modules implemented]

## Architecture decisions made
[Any decisions taken during this phase — reference OPEN_QUESTIONS.md if relevant]

## Files modified
[Key files changed]

## Tests added
[Test coverage delta if available]

## Next phase
[Name and first task of the next phase]
```

---

## Step 4 — List mounted context tools

Scan for active tools and MCP servers:

```bash
# Check active MCP servers
cat .mcp.json 2>/dev/null

# Check which skills were loaded in this phase
# (infer from git log and session if available)
```

Present to user:

```
🔧 Herramientas montadas en contexto:

MCP Servers activos:
  • github MCP
  • [others if configured]

Skills cargados esta fase:
  • fastapi-patterns
  • pytest-async
  • alembic-migrations

¿Cuáles seguirás necesitando en la próxima fase?
(Las que no necesites las desactivamos para liberar ventana de contexto)
```

---

## Step 5 — Teardown based on user response

If user says to unmount specific tools:

```bash
# Disable MCP server
# Edit .mcp.json to comment out or remove the server

# For skills — they're loaded on demand so no action needed
# Just note which ones to prioritize in next phase
```

Confirm:
```
✅ Contexto optimizado para la Fase [N+1]:
  Activos: [remaining tools]
  Desactivados: [removed tools]

Próximo paso: [first task of next phase from PLAN.md]
```

---

## Manual invocation

`/close-phase auth-module` → runs full flow above, looks for "auth" in PLAN.md phases
`/close-phase` (no args) → shows current phase and asks which one to close
