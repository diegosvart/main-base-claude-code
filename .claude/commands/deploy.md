---
name: deploy
description: Deploy the application. PLACEHOLDER — configure per project before using. Intentionally requires manual invocation.
disable-model-invocation: true
---

⚠️ This command is a placeholder. Configure it for your project before use.

Deploy target: $ARGUMENTS

**This command is intentionally out of scope in the base template.**
Each project has different deploy targets (Railway, Docker, Lambda, VPS, etc.).

To configure this command:
1. Edit `.claude/commands/deploy.md`
2. Define the deploy steps for your specific target
3. Keep `disable-model-invocation: true` — deploy should always be user-triggered

Common patterns to add here:
- `railway up` for Railway
- `docker build && docker push` for container registries
- `fly deploy` for Fly.io
- Custom CI/CD trigger via `gh workflow run`

Until configured, this command will only show this message.
