# Resume Protocol

Executed when `/inception --resume` is called.
Detects session state from existing artifacts and memory, then continues from the right phase.

---

## Step 1 — Detect available memory

```bash
# Check if claude-mem is installed
ls ~/.claude/plugins/marketplaces/thedotmack/claude-mem 2>/dev/null && echo "CLAUDE_MEM=true" || echo "CLAUDE_MEM=false"
```

---

## Step 2A — Strategy A: claude-mem installed

Use `mem-search` to recover session state:

```
/mem-search "inception discovery session last state"
/mem-search "project requirements architecture plan"
```

Extract from results:
- Last phase completed
- Key decisions made
- Any open questions
- Next agreed step

Then scan disk for artifacts (Step 2B) and merge both sources.
Memory provides the *conversational context*; artifacts provide the *written state*.

---

## Step 2B — Scan artifacts on disk

```bash
ls -la REQUIREMENTS.md ARCHITECTURE.md PLAN.md OPEN_QUESTIONS.md CLAUDE.md 2>/dev/null
```

Map to phase state:

| Artifacts found | Resume from |
|---|---|
| None | Phase 1 — start fresh (offer to begin) |
| REQUIREMENTS only | Phase 3 — scope done, start technical decisions |
| REQUIREMENTS + ARCHITECTURE | Phase 4 — stack decided, build the plan |
| REQUIREMENTS + ARCHITECTURE + PLAN | Bootstrap — all discovery done, ready to clone template |
| All including CLAUDE.md | Project bootstrapped — ask what the user needs |

---

## Step 3 — Present state to user

Report what was found:

```
📂 Estado encontrado:
  ✅ REQUIREMENTS.md — scope y funcionalidades definidos
  ✅ ARCHITECTURE.md — stack: FastAPI + PostgreSQL + JWT auth
  ⬜ PLAN.md — pendiente
  ⬜ CLAUDE.md — pendiente

📍 Retomamos en: Fase 4 — Plan de desarrollo

¿Querés que te haga un resumen rápido de lo decidido antes de continuar, o arrancamos directamente?
```

---

## Step 4 — Offer brief summary before continuing

If user asks for summary, read the existing artifacts and synthesize in 5-7 lines:
- Problem being solved
- Scope and actors
- Stack chosen and key architecture decisions
- What's pending

Then continue from the detected phase using the normal SKILL.md flow.

---

## Edge cases

**Artifacts exist but are empty or corrupted**:
→ Report the issue, offer to restart that specific artifact.

**CLAUDE.md exists but no REQUIREMENTS/ARCHITECTURE/PLAN**:
→ The project was bootstrapped directly (not via inception). Load CLAUDE.md as context
and ask what the user needs — don't force the discovery flow.

**claude-mem installed but no relevant memories found**:
→ Fall back to Strategy B (disk artifacts only). Don't report the failure to the user
unless it's relevant.
