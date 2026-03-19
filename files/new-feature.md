---
name: new-feature
description: Start a new feature with branch, spec, test structure, and task plan. Use when starting any new feature or task.
---

Start a new feature for: $ARGUMENTS

1. Validate the name — normalize to lowercase-hyphens
2. Create the branch:
   ```bash
   git checkout develop && git pull origin develop
   git checkout -b feature/$ARGUMENTS
   ```
3. Read PLAN.md to understand what phase this feature belongs to
4. Create a brief task spec (3-5 lines) — what it does, what it needs, what done looks like
5. Create the test file skeleton:
   - `tests/unit/test_[feature].py` with empty test functions named after the main behaviors
   - `tests/integration/test_[feature]_api.py` if it has endpoints
6. Show the user the plan and test skeleton
7. Ask: "¿Arrancamos con los tests o querés ajustar algo primero?"

TDD rule: tests are written before implementation. Red before green.
