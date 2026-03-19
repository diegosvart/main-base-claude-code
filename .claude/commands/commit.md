---
name: commit
description: Run lint, format, and tests, then create a conventional commit message. Use before every commit.
---

Run the full quality gate before committing:

1. Run `make lint` — if it fails, stop and report the errors
2. Run `make test` — if tests fail, stop and report which ones
3. If both pass, look at `git diff --staged` to understand what changed
4. Generate a conventional commit message:
   - Format: `type(scope): description`
   - Types: feat, fix, refactor, test, chore, docs
   - Keep description under 72 characters
   - Use imperative mood ("add" not "added")
5. Show the message to the user and ask for confirmation
6. On confirmation: `git commit -m "[message]"`

If no files are staged: run `git status` and ask the user which files to stage.
