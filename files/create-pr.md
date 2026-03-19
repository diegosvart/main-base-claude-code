---
name: create-pr
description: Create a pull request with auto-generated description from commits. Use when a feature is ready for review.
---

Create a PR for the current branch toward: $ARGUMENTS (default: develop)

1. Get current branch: `git branch --show-current`
2. Get commits since branching from develop:
   ```bash
   git log develop..HEAD --oneline
   ```
3. Run the full quality gate: `make lint && make test`
   - If either fails: stop and report. Don't create the PR.
4. Generate PR description:
   - **Title**: conventional format matching the main commit
   - **What changed**: bullet list from commits
   - **How to test**: steps to verify the feature works
   - **Checklist**: type hints ✓ | tests ✓ | no secrets ✓ | lint ✓
5. Show description to user for approval
6. On approval, create PR via gh CLI:
   ```bash
   gh pr create --base ${ARGUMENTS:-develop} --title "[title]" --body "[description]"
   ```
7. Show the PR URL

Never create a PR if tests are failing.
