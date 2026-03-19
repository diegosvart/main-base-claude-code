# Changelog

All notable changes to this template are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.0.0] — 2026-03-18

### Added

**Inception Agent** (`skill/`)
- 3 modes: fresh discovery, `--resume`, `--analyze`
- 5-phase discovery protocol with explicit gates
- Graduated challenge system (Level 1 nota / Level 2 trade-off / Level 3 bloqueo soft)
- Portability question in Phase 2 (Screaming vs lib-grade decision)
- Progressive artifact generation: REQUIREMENTS → ARCHITECTURE → PLAN → CLAUDE.md
- claude-mem integration in resume protocol (Strategy A with fallback to Strategy B)
- Bootstrap via `gh` CLI — clones template, configures stack, generates CLAUDE.md

**6-Layer Template** (`main-base-claude-code/`)
- CLAUDE.md synthesis template (English, generated from discovery artifacts)
- Base hooks: SessionStart log, PostToolUse ruff format, Stop notification, Bash audit
- 6 slash commands: commit, new-feature, create-pr, review, close-phase, deploy (placeholder)
- Context teardown hook: detects merges, lists mounted tools, prompts user for cleanup

**5 Specialized Agents** (`.claude/agents/`)
- TL/Orchestrator — always active, coordinates and delegates
- Architecture Agent — Screaming+ports pattern, ADRs, automation tools knowledge
- Backend Agent — FastAPI/SQLAlchemy, TDD-first, file size enforcement
- DBA Agent — schema, migrations, N+1 detection, indexing strategy
- Frontend Agent — TypeScript, accessibility, component structure

**Documentation**
- README with onboarding-prompt (fetchable via claude command)
- `llms.txt` — standard LLM entry point
- `machine-readable/index.yaml` — parseable index for agents (~300 tokens)
- `SKILLS_CATALOG.md` — base minimum per agent + full catalog
- 3 ADRs: CLI-over-MCP, Screaming+Ports, claude-mem-as-plugin

**Architecture Principles**
- Screaming Architecture + Explicit Ports (not pure Hexagonal)
- File size limit: warn at 300 lines, hard limit at 400 lines
- TDD enforced: tests before implementation
- service.py → ports.py only (never direct infra imports)
- CLI over MCP as non-negotiable principle

### References

- Inspired by [claude-mem](https://github.com/thedotmack/claude-mem) session continuity patterns
- Documentation structure inspired by [Claude Code Ultimate Guide](https://github.com/FlorianBruniaux/claude-code-ultimate-guide)
