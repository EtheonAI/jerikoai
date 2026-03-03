# Security

## Reporting Vulnerabilities

If you discover a security vulnerability in Jeriko, please report it responsibly.

**Email:** security@etheon.ai

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Your suggested fix (if any)

We will acknowledge receipt within 48 hours and aim to provide a fix or mitigation within 7 days for critical issues.

**Do not** open a public GitHub issue for security vulnerabilities.

---

## Security Model

Jeriko's security operates at the application level with defense-in-depth principles.

### Authentication

| Layer | Mechanism |
|-------|-----------|
| HTTP API | Bearer token authentication with timing-safe comparison |
| WebSocket | HMAC-SHA256 token validation, timing-safe comparison |
| Telegram | Admin ID allowlist — deny-all when empty |
| Webhooks | Signature verification (GitHub, Stripe, HMAC) — fail-closed |
| Daemon | Auth secret required — refuses to start without it |

### Agent Execution

- **Sensitive key stripping** — API keys and tokens are filtered from agent subprocess environments
- **Output size limits** — agent tool output is capped to prevent resource exhaustion
- **Execution timeouts** — all agent-spawned processes have configurable timeouts
- **Turn limits** — agent loops are bounded to prevent runaway execution

### Plugin Sandboxing

- **Untrusted by default** — new plugins cannot receive webhooks or inject prompts until explicitly trusted
- **Environment isolation** — plugins only see declared environment variables plus safe system vars
- **Integrity verification** — SHA-512 manifest hashes detect post-install tampering
- **Namespace reservation** — core command names are blocked from plugin registration
- **Conflict detection** — duplicate commands are rejected at install time
- **Audit logging** — all plugin operations are logged with automatic rotation

### Webhook Security

- **Fail-closed** — if a webhook has a secret configured but the request lacks a valid signature, it is rejected
- **Multiple formats** — supports GitHub (`x-hub-signature-256`), Stripe (`stripe-signature`), and generic HMAC verification
- **Timing-safe** — all signature comparisons use constant-time algorithms

### Configuration Security

- Config files should have restricted permissions (`chmod 600`)
- Sensitive values can reference environment variables using `{env:VAR_NAME}` syntax instead of storing secrets in config files
- Sensitive keys are automatically redacted in log output

---

## Security Boundaries

Jeriko operates with the permissions of the user running it. The AI agent can execute commands within the scope granted by the user's configuration.

### Recommended Practices

1. **Restrict allowed paths** — configure `security.allowedPaths` to limit filesystem access
2. **Block dangerous commands** — configure `security.blockedCommands` to prevent destructive operations
3. **Review trigger actions** — audit autonomous trigger configurations, especially those processing external input
4. **Use admin allowlists** — always set admin IDs for channel integrations (Telegram, Slack, Discord)
5. **Rotate secrets** — periodically rotate auth secrets and API keys
6. **Monitor audit logs** — review plugin and trigger activity in the audit log

### Known Limitations

- No kernel-level sandboxing — agent execution relies on application-level controls
- Prompt injection is a risk when processing untrusted external content (web pages, emails, webhooks)
- The user is the security perimeter — Jeriko trusts the user's configuration and access decisions

---

## Hardening Roadmap

We are actively working on deeper isolation capabilities:

- **Application-level controls** — command allowlisting, path validation, network restrictions
- **OS-level isolation** — namespace-based sandboxing for agent execution on Linux
- **Fine-grained permissions** — per-context execution manifests with scoped capabilities

---

## License

Proprietary — © 2024-2026 Etheon AI. All rights reserved.
