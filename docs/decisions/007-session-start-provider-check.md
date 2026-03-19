# ADR-007: Session-Start Provider Check and Smart Switching Suggestions

**Date**: 2026-03-19
**Status**: Proposed
**Context**: Sessions can end abruptly due to token exhaustion. Users arrive at the next session unaware that their previous session was cut short or that they're near quota. ADR-006 enables provider switching, but users need guidance on *when* to switch.

---

## Decision

Extend the SessionStart hook to:
1. Display the active LLM provider and model
2. Show token budget warnings if available
3. Suggest provider switching based on context height and task type

## Implementation

### SessionStart Hook (Updated)

```bash
#!/bin/bash
echo "=== SESSION START ==="
git branch --show-current 2>/dev/null || echo "(not a git repo)"
echo ""
echo "--- Recent Commits (last 5) ---"
git log --oneline -5 2>/dev/null || echo "(no git history)"
echo ""
echo "⚡ PROVIDER CHECK:"
echo "  Model: ${CLAUDE_MODEL:-claude-opus-4-6 (default)}"
echo "  Base URL: ${ANTHROPIC_BASE_URL:-https://api.anthropic.com (default)}"
echo ""

# Check for high context warning
if [ -f ".claude/session.context.log" ]; then
  CONTEXT_PCT=$(tail -1 ".claude/session.context.log" | awk '{print $1}' 2>/dev/null)
  if [ ! -z "$CONTEXT_PCT" ] && [ "$CONTEXT_PCT" -gt 70 ]; then
    echo "⚠️  CONTEXT ALERT: Last session reached ${CONTEXT_PCT}% context"
    echo "   → Consider /clear or provider switch for next task"
  fi
fi

echo ""
echo "💡 PROVIDER SWITCHING GUIDE:"
if [ -f "PLAN.md" ]; then
  echo "   Plan detected → if this is a NEW task, consider switching to:"
  echo "   - OpenRouter (cheaper, 200+ models available)"
  echo "   - LiteLLM (local proxy, cost control)"
  echo "   Docs: docs/decisions/006-provider-switching.md"
fi
```

### Triggers for Provider Switch Suggestion

The TL Orchestrator agent observes:

| Signal | Trigger | Suggestion |
|--------|---------|------------|
| **New feature starts** | `/new-feature` command detected | Switch to cost-optimized provider for planning phase |
| **High context** | Session context > 70% | Use `/clear` or switch provider for context reset |
| **PLAN.md exists** | File present on SessionStart | New session with multi-phase work → alternate provider for analysis |
| **Rate limit warning** | Provider returns 429 or similar | Switch to backup provider immediately |
| **Token depletion** | Previous session summary shows incomplete work | Suggest switching before resuming |

## Context Height Alerts

Add a post-hook to track context:

```bash
# Hook: Stop (or OnSessionEnd)
CONTEXT_HEIGHT=$(curl -s https://api.anthropic.com/v1/messages \
  -H "Authorization: Bearer $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -X POST \
  -d '{"model":"claude-opus-4-6","max_tokens":1,"messages":[{"role":"user","content":"test"}]}' \
  2>/dev/null | jq '.usage.input_tokens // 0')

PCT=$((CONTEXT_HEIGHT * 100 / 200000))  # Assuming 200k token limit
echo "$PCT $(date)" >> .claude/session.context.log
```

## Rule: TL Orchestrator Provider Suggestion

When the TL Orchestrator loads PLAN.md:

```
If PLAN.md found AND new SessionStart:
  IF context_height_last_session > 60%:
    SUGGEST: "Your previous session reached high context.
              Switch provider for cost-optimized analysis?"

  IF no completion marker in last phase:
    SUGGEST: "Last session's work was incomplete.
              Use alternative provider to continue without context penalty."
```

## When NOT to Switch

⚠️ **Do NOT switch providers:**
- During critical development (agents may behave differently)
- When using extended thinking (some providers don't support it)
- For security-sensitive operations
- During final polish and review phases

✅ **Good times to switch:**
- Discovery and analysis phases (reading existing code)
- Planning phases (outlining architecture)
- Documentation phases (writing, not executing)
- Cost-sensitive tasks (bulk analysis, summarization)

## Machine-Readable Output

Add to `machine-readable/session-log.jsonl`:

```jsonl
{"event": "session_start", "date": "2026-03-19T10:00:00Z", "provider": "anthropic", "context_pct": 25}
{"event": "provider_alert", "date": "2026-03-19T10:15:00Z", "trigger": "context_high", "previous_pct": 72}
{"event": "provider_switch", "date": "2026-03-19T10:16:00Z", "from": "anthropic", "to": "openrouter"}
```

This log feeds into:
- `/metrics` dashboard (provider usage, cost breakdown)
- Session continuity recovery (where was the last switch?)
- Cost analytics (which providers used for which tasks)

## Consequences

1. **User awareness**: Provider status is visible on every session start
2. **Cost optimization**: Users can strategically switch for high-context tasks
3. **Reliability**: Backup provider available if Anthropic has issues
4. **Metrics**: Cost and performance trends become trackable
5. **Recovery**: Incomplete sessions can resume with fresh context via provider switch

## Related

- ADR-006: Provider Switching (mechanism for switching)
- ADR-005: Living Documentation via Artifacts (session-log.jsonl integration)
- `.claude/settings.json` → SessionStart hook (implementation location)
- TL Orchestrator (`skill/orchestrator.md`) → provider suggestion logic

---

**Note**: This is a *soft* suggestion system. Users are not forced to switch providers; they are informed and given tools to decide. The decision remains with the developer.

