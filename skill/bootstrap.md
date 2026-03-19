# Bootstrap

Executed after all 4 gates are confirmed.
Clones the template, configures the project, installs stack-specific layers.

---

## Step 1 — Confirm project name

```
¿Cómo se llama el proyecto? (será el nombre del directorio y del repo)
```

Normalize: lowercase, hyphens, no spaces. Example: `audit-system`

---

## Step 2 — Clone template via gh CLI

```bash
# Clone without creating a GitHub repo yet
gh repo clone diegosvart/main-base-claude-code [project-name]
cd [project-name]

# Remove template git history
rm -rf .git
git init
git add -A
git commit -m "chore: bootstrap from main-base-claude-code template"
```

---

## Step 3 — Run stack selector

Load `stack-selector.md` and execute the mapping for the detected stack.
This installs the correct skills and activates the right agents.

---

## Step 4 — Generate CLAUDE.md

Use `templates/CLAUDE.template.md` as base.
Fill in all placeholders from the discovery artifacts:
- Project name and purpose → from REQUIREMENTS.md
- Stack → from ARCHITECTURE.md
- Auth method → from ARCHITECTURE.md
- Commands → from stack-selector output
- Git workflow → standard (feature/* → develop → main)
- Agents list → from stack-selector output

Write the final CLAUDE.md to the project root.

---

## Step 5 — Configure .gitignore

Add stack-specific entries based on detected stack:

```bash
# Python base
cat >> .gitignore << 'EOF'

# Python
__pycache__/
*.py[cod]
.venv/
*.egg-info/
.pytest_cache/
.mypy_cache/
.ruff_cache/
htmlcov/

# Environment
.env
.env.local
.env.*.local

# Claude Code personal
.claude/settings.local.json
EOF
```

---

## Step 6 — Create GitHub repo and push

```bash
gh repo create [project-name] --private --source=. --remote=origin --push
```

If user wants public:
```bash
gh repo create [project-name] --public --source=. --remote=origin --push
```

---

## Step 7 — Create develop branch

```bash
git checkout -b develop
git push -u origin develop
```

Set develop as default branch:
```bash
gh repo edit --default-branch develop
```

---

## Step 8 — Report to user

```
✅ Proyecto [project-name] bootstrapped exitosamente.

📦 Stack instalado: [detected stack]
🤖 Agentes activos: TL/Orchestrator, [others from stack-selector]
🔧 Hooks configurados: format, lint, notify, teardown
📂 Rama default: develop

Artefactos de discovery:
  ✅ REQUIREMENTS.md
  ✅ ARCHITECTURE.md
  ✅ PLAN.md
  ✅ OPEN_QUESTIONS.md (si hay decisiones nivel-3)
  ✅ CLAUDE.md

Primer paso según PLAN.md: [first item from Phase 1]

Para empezar:
  /new-feature [first-feature-name]
```
