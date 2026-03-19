# Analyze Protocol

Executed when `/inception --analyze [path]` is called.
Evaluates an existing repository against the 6-layer template standard,
detects gaps, and proposes an incremental adoption plan.

---

## Step 1 — Scan structure

```bash
cd [path]
find . -name "CLAUDE.md" -not -path "*/node_modules/*" 2>/dev/null
find . -path "*/.claude/*" -not -path "*/node_modules/*" 2>/dev/null
ls -la .mcp.json .gitignore Makefile 2>/dev/null
git log --oneline -10 2>/dev/null
```

---

## Step 2 — Evaluate 6 layers

Score each layer: ✅ Present · ⚠️ Partial · ❌ Missing

| Layer | Check |
|---|---|
| 1. CLAUDE.md | exists + has stack, commands, conventions |
| 2. Skills | `.claude/skills/` exists + has relevant skills |
| 3. Commands | `.claude/commands/` exists + has commit/pr/review |
| 4. Hooks | `.claude/settings.json` exists + has PostToolUse + SessionStart |
| 5. MCP | `.mcp.json` exists (even if empty is ok) |
| 6. Agents | `.claude/agents/` exists + has at least TL orchestrator |

---

## Step 3 — Detect architecture patterns

```bash
# Check folder structure
find . -type d -not -path "*/.git/*" -not -path "*/node_modules/*" \
  -not -path "*/__pycache__/*" | head -30

# Check for ports pattern
grep -r "from abc import" --include="*.py" -l 2>/dev/null | head -5
grep -r "ABC\|abstractmethod" --include="*.py" -l 2>/dev/null | head -5

# Check file sizes
find . -name "*.py" -not -path "*/node_modules/*" | \
  xargs wc -l 2>/dev/null | sort -rn | head -10
```

Flag:
- Files over 400 lines → Level 1 warning
- `service.py` importing from `infra/` directly → Level 2 warning
- No `tests/` directory → Level 2 warning
- No type hints in Python files → Level 1 warning

---

## Step 4 — Check for claude-mem

```bash
ls ~/.claude/plugins/marketplaces/thedotmack 2>/dev/null
```

---

## Step 5 — Present gap report

```
📊 Análisis de main-base-claude-code
Repo: [path]
Stack detectado: [Python/FastAPI/etc.]

CAPAS:
  ✅ Capa 1 — CLAUDE.md presente (68 líneas)
  ⚠️ Capa 2 — Skills: directorio existe pero está vacío
  ✅ Capa 3 — Commands: /commit y /review presentes
  ❌ Capa 4 — Hooks: settings.json no encontrado
  ✅ Capa 5 — MCP: .mcp.json presente
  ❌ Capa 6 — Agents: no encontrado

ARQUITECTURA:
  ⚠️ 3 archivos superan 400 líneas: services/user.py (680), ...
  ❌ Sin patrón de ports detectado
  ⚠️ Sin directorio tests/

MEMORIA:
  ❌ claude-mem no instalado

PLAN DE ADOPCIÓN SUGERIDO (orden de impacto):
  1. Agregar hooks base (settings.json) — impacto inmediato en quality gates
  2. Crear .claude/agents/tl-orchestrator.md — coordinación de trabajo
  3. Partir service.py en módulos + agregar ports.py
  4. Instalar claude-mem para continuidad de sesiones
  5. Agregar skills de dominio según stack

¿Arrancamos con el paso 1, o querés priorizar distinto?
```

---

## Step 6 — Incremental adoption

For each gap, offer to fix it immediately or add it to a migration plan.
Never force a full rewrite — propose gradual adoption.

If the user chooses to fix now:
- For missing CLAUDE.md: run the inception discovery flow (condensed — skip what's already clear)
- For missing hooks: generate `.claude/settings.json` with base hooks for detected stack
- For missing agents: install TL orchestrator + relevant stack agents
- For architecture gaps: propose a refactor plan as a feature branch, not a big-bang rewrite
