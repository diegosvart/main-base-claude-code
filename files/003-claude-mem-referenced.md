# ADR-003: claude-mem Referenced as Plugin, Not Included

**Status**: Accepted
**Date**: 2026-03-18

## Context

`claude-mem` (github.com/thedotmack/claude-mem) solves a critical pain point:
sessions interrupted with no way to recover context. It captures tool usage,
compresses it with AI, and injects it back into future sessions.

The question was whether to include its code in this template or reference it
as an external plugin.

## Decision

**Reference claude-mem as a recommended plugin, never include its code.**

Installation remains:
```bash
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem
```

## Reasons

**License incompatibility**: claude-mem is AGPL-3.0. This template is MIT.
Including AGPL code in an MIT-licensed repo would require the entire template
to become AGPL-3.0, which contradicts the goal of a freely usable template.

**Separation of concerns**: claude-mem is a session memory tool, not a project
scaffolding tool. Keeping them separate means each can evolve independently.

**Plugin model is the right abstraction**: Claude Code's plugin system is exactly
designed for this use case — extend without forking.

## Consequences

**Benefits:**
- Template stays MIT-licensed
- claude-mem updates automatically via its own release cycle
- Users who don't want the memory overhead can skip installation
- No AGPL obligations for template users

**Costs:**
- One extra install step for full functionality
- `/inception --resume` has degraded behavior without claude-mem
  (falls back to disk artifact detection — still functional, less rich)

## Fallback without claude-mem

The resume protocol uses Strategy B: scans for existing artifacts on disk,
maps them to a phase state, and asks the user for a brief recap of where
they were. This is less precise than mem-search but fully functional.
