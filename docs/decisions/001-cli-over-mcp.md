# ADR-001: CLI over MCP

**Status**: Accepted
**Date**: 2026-03-18
**Deciders**: Diego (project owner), Stack Builder agent

## Context

Claude Code supports two ways to interact with external services like GitHub:
via MCP servers (Model Context Protocol) and via CLI tools like `gh`.

Both can create branches, PRs, and manage repos. The question was which to
prefer as the default in the template.

## Decision

**Always prefer CLI tools over MCP servers.** Use `gh` CLI for all git
operations. Use bash for filesystem operations. Reserve MCP for cases
where no CLI alternative exists.

## Consequences

**Benefits:**
- Significantly lower token consumption — MCP servers consume context
  on every tool call; CLI commands are compact bash
- No authentication complexity in `.mcp.json` for git operations
- Works offline for local git operations
- No MCP server startup time or connection failures

**Costs:**
- `gh` CLI must be installed and authenticated on the developer's machine
- Some MCP features (like reading issue comments or PR review threads) are
  harder via CLI — use MCP for those specific cases

## When to use MCP instead

- Reading structured data from external APIs with no CLI equivalent
- Integrations with services that have no official CLI (Jira, Slack, etc.)
- When the MCP server provides significantly richer data than the CLI

---
