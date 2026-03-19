# ADR-002: Screaming Architecture + Explicit Ports

**Status**: Accepted
**Date**: 2026-03-18
**Deciders**: Diego, Architecture Agent, Stack Builder

## Context

Two architectural patterns were evaluated:
- **Pure Hexagonal Architecture**: application/domain/infrastructure as root folders
- **Screaming Architecture**: domain name as root folder (e.g., `users/`, `audit/`)
- **Pure Screaming**: domain folders with direct infra imports

The project needs to support both reusable library-grade modules (auth, audit)
and project-specific domains with varying complexity.

## Decision

**Screaming Architecture with explicit ports**, not pure Hexagonal.

Rules:
1. Folder name = domain name (`users/`, `audit/`, `billing/`)
2. `service.py` only imports from `ports.py` — never from `infra/` directly
3. `ports.py` is mandatory when a module has >1 external dependency
4. `ports.py` is optional (but recommended) when the module has only 1 dependency (DB)
5. Lib-grade modules (portable across projects) get full ports + separated infra structure

## Consequences

**Benefits:**
- Folder names communicate intent immediately (Screaming)
- `service.py` is testable without infrastructure (ports enable mocking)
- Lib-grade modules are extractable without rewriting
- Simpler than full Hexagonal for small/medium projects
- The `service.py → ports.py` rule is verifiable by a grep-based hook

**Costs:**
- Requires discipline to not import infra directly
- Adding ports.py has upfront cost on small modules
- Team needs to understand when ports are required vs optional

## The portability question

The inception agent asks at Gate 2: *"Do any modules need to be reusable across projects?"*
This determines which modules get lib-grade structure from day one — avoiding costly rewrites later.

---
