# ADR-006: Provider Switching for Alternative LLM Models

**Date**: 2026-03-19
**Status**: Proposed
**Context**: Claude Code is built around Claude models and Anthropic APIs. However, token limits or budget constraints may require using alternative LLM providers (OpenRouter, LiteLLM, Azure OpenAI, etc.). Currently, no documented mechanism exists to switch providers.

---

## Decision

The template will support **provider switching via environment variables**, allowing users to seamlessly use alternative LLM providers without code changes.

### Mechanism

Claude Code respects two environment variables:

```bash
ANTHROPIC_BASE_URL      # Override the API endpoint (default: https://api.anthropic.com)
ANTHROPIC_API_KEY       # Override the API key
```

These variables allow pointing to proxy servers (OpenRouter, LiteLLM) that expose a compatible API.

## Supported Providers

| Provider | Mechanism | URL | Notes |
|---|---|---|---|
| **Anthropic** (default) | Direct API | `https://api.anthropic.com` | No changes needed |
| **OpenRouter** | Compatible proxy | `https://openrouter.ai/api/v1` | Supports 200+ models; Kimi K2 available |
| **LiteLLM** | Local proxy | `http://localhost:4000` | Run locally: `litellm --model moonshot/kimi-k2 --port 4000` |
| **Azure OpenAI** | Compatible proxy | `https://{resource}.openai.azure.com/v1` | Requires Azure-specific key format |

## Configuration

### Location: `.claude/settings.local.json`

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api/v1",
    "ANTHROPIC_API_KEY": "sk-or-v1-..."
  }
}
```

**Critical Rule**: This file is **gitignored**. Keys NEVER go in `settings.json`.

### How It Works

1. Claude Code reads `.claude/settings.local.json` at startup
2. Sets `ANTHROPIC_BASE_URL` and `ANTHROPIC_API_KEY` in the environment
3. API calls use the overridden endpoint and key
4. All Claude API interactions (agent calls, tool use, etc.) route through the provider

## Example: Setting up Kimi K2 via OpenRouter

### Step 1: Get OpenRouter API Key
Visit https://openrouter.ai/keys → create/copy your key

### Step 2: Create `.claude/settings.local.json`
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api/v1",
    "ANTHROPIC_API_KEY": "sk-or-v1-YOUR_KEY_HERE"
  }
}
```

### Step 3: Verify Configuration
Start Claude Code. SessionStart hook will display:
```
⚡ PROVIDER CHECK:
  Base URL: https://openrouter.ai/api/v1
  Model: claude-opus-4-6 (via OpenRouter)
```

### Step 4: Use Normally
All subsequent commands use Kimi K2 (or whichever provider/model is configured).

## Alternative: LiteLLM Local Proxy

If Kimi K2 is not available on OpenRouter or you prefer a local setup:

### Step 1: Install LiteLLM
```bash
pip install litellm
```

### Step 2: Start Local Proxy
```bash
litellm --model moonshot/kimi-k2 --port 4000
```

### Step 3: Configure Claude Code
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4000",
    "ANTHROPIC_API_KEY": "anything"  # LiteLLM ignores this locally
  }
}
```

## Trade-offs

### Benefits
- **No code changes**: Works with entire template ecosystem (agents, skills, hooks)
- **Isolation**: Credentials never committed; `settings.local.json` is gitignored
- **Flexibility**: Switch providers between sessions without restart
- **Cost management**: Use cheaper providers for large tasks (analysis, summaries)

### Costs
- **Provider compatibility**: Not all providers expose 100% of Anthropic API features
  - Some agents may perform worse on non-Claude models
  - Extended thinking, tool_choice, budget tokens may differ
- **Rate limiting**: Different rate limits per provider
- **Authentication**: Each provider has different key formats

## When to Use Provider Switching

**Use alternative provider when:**
- Anthropic token budget is exhausted for current month
- Context is very high (>50k tokens) → use cheaper model for summarization phase
- Exploring cost optimization before scaling

**Stick with Claude when:**
- Primary development (agents need full feature set)
- Security-sensitive work (Claude has better safety properties)
- Complex reasoning required (Claude 4.x outperforms alternatives)

## Related Artifacts

- ADR-007: Session-Start Provider Check (how to detect & suggest provider switches)
- `.claude/settings.json` → SessionStart hook (displays provider on every session)
- `.claude/settings.local.json` → template file (reference)

## Consequences

1. **Power users** can reduce costs by strategically switching providers
2. **Teams** can define per-environment provider configs (dev vs. prod-like)
3. **Experiments** can run on alternative models without forking the template
4. **Backup plan** exists if Anthropic has outages or quota issues

---

**Implementation Note**: This ADR does NOT mandate using alternative providers. It documents that they are possible and how to configure them safely. Default behavior uses Anthropic APIs unless environment is overridden.

