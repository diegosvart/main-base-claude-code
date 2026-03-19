---
name: review
description: Code review focused on security, type hints, architecture rules, and test coverage. Use before creating a PR or when asking for feedback on the current branch.
---

Review the current branch diff: $ARGUMENTS (aspects: security | types | architecture | tests | all — default: all)

1. Get the diff: `git diff develop..HEAD`
2. Analyze based on requested aspect (or all):

**Security**
- Hardcoded secrets or tokens
- SQL injection risks (raw queries without parameterization)
- Missing input validation
- Exposed internal errors in HTTP responses
- CORS or auth misconfiguration

**Types**
- Public functions without type hints
- Use of `Any` without justification
- Missing return type annotations
- `dict()` instead of `.model_dump()` (Pydantic v2)

**Architecture**
- `service.py` importing directly from `infra/` (ports rule violation)
- Business logic inside routers
- Files over 400 lines — flag and suggest split point
- Missing `ports.py` when module has >1 external dependency
- Circular imports

**Tests**
- Functions in `services/` or `repositories/` without tests
- Tests without assertions
- Tests that depend on execution order
- Missing edge cases (empty input, not found, permission denied)

3. Report format:
   ```
   [HIGH] Security: hardcoded token in config.py:34
   [MED]  Architecture: service.py imports SQLAlchemy directly — use ports.py
   [LOW]  Types: get_user() missing return type annotation
   [INFO] Coverage looks good on services/ — missing edge case for empty list
   ```

4. End with: total issues by severity and one recommended next step.
