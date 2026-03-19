---
name: close-phase
description: Close a development phase after a merge. Updates PLAN.md, generates a phase summary, lists mounted context tools, and prompts for teardown. Use after a PR is merged to develop.
---

Close phase: $ARGUMENTS

Load and execute `~/.claude/skills/inception/close-phase.md` with phase name: $ARGUMENTS

If no argument provided: read PLAN.md, show in-progress phases, and ask which one to close.
