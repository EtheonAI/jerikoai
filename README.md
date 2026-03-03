<p align="center">
  <img src="https://jeriko.ai/logo.svg" alt="Jeriko" width="120" />
</p>

<h1 align="center">Jeriko</h1>

<p align="center">
  <strong>Unix-first CLI toolkit for AI agents</strong><br/>
  Commands replace proprietary tool abstractions. Model-agnostic: any AI with exec capability can control the machine.
</p>

<p align="center">
  <a href="https://github.com/etheonai/jerikoai/releases"><img src="https://img.shields.io/github/v/release/etheonai/jerikoai?label=version&style=flat-square" alt="Version"></a>
  <a href="#install"><img src="https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-blue?style=flat-square" alt="Platform"></a>
  <a href="LICENSE.md"><img src="https://img.shields.io/badge/license-proprietary-lightgrey?style=flat-square" alt="License"></a>
</p>

---

## Install

**macOS / Linux:**

```bash
curl -fsSL https://jeriko.ai/install | bash
```

**Windows (PowerShell):**

```powershell
irm https://jeriko.ai/install.ps1 | iex
```

**Windows (CMD):**

```cmd
curl -fsSL https://jeriko.ai/install.cmd -o install.cmd && install.cmd
```

The installer downloads a pre-compiled binary — no runtime dependencies required.

## Features

- **Daemon architecture** — persistent background process with SQLite state, session management, and multi-model routing
- **Interactive CLI** — rich terminal UI with markdown rendering, syntax highlighting, autocomplete, and streaming responses
- **Channels** — Telegram, WhatsApp, Slack, Discord — chat with your agent from anywhere
- **Connectors** — GitHub, Stripe, PayPal, Twilio, Google Drive, OneDrive, Gmail, Outlook, Vercel, X
- **Triggers** — cron schedules, webhooks, file watchers, HTTP polling — automate anything
- **Skills** — extensible skill system with YAML frontmatter, progressive loading, and community sharing
- **Multi-provider** — Claude, GPT-4, Ollama, OpenRouter, DeepInfra, Together, Groq, and any OpenAI-compatible API
- **Web development** — pre-built React/Vite/Tailwind templates with instant scaffolding and live preview

## Quick Start

```bash
# Initialize configuration
jeriko init

# Start a conversation
jeriko chat

# Start the daemon (enables channels, triggers, connectors)
jeriko start

# Check system status
jeriko status
```

## Documentation

| Document | Description |
|----------|-------------|
| [Commands](docs/COMMANDS.md) | Full CLI reference — every command and flag |
| [Architecture](docs/ARCHITECTURE.md) | System design and data flow |
| [Install Guide](docs/INSTALL.md) | Detailed installation instructions |
| [Plugins](docs/PLUGINS.md) | Plugin system, trust model, env isolation |
| [Triggers](docs/TRIGGERS.md) | Cron, webhook, file, and HTTP triggers |
| [API Reference](docs/API.md) | HTTP and WebSocket API |
| [Security](SECURITY.md) | Security model and vulnerability reporting |

## Agent System Prompt

The [`AGENT.md`](AGENT.md) file is the system prompt sent to all AI models. It contains every command, flag, workflow, and integration. If you're building tools or skills that interact with Jeriko, start here.

## Configuration

Jeriko uses a layered configuration system:

1. **Built-in defaults** — sensible out-of-the-box settings
2. **User config** — `~/.config/jeriko/config.json`
3. **Project config** — `./jeriko.json` in your project root
4. **Environment variables** — `JERIKO_*` prefixed overrides

See [`examples/settings/`](examples/settings/) for annotated configuration examples.

## Community

- [Issues](https://github.com/etheonai/jerikoai/issues) — bug reports and feature requests
- [Discussions](https://github.com/etheonai/jerikoai/discussions) — questions, ideas, and show & tell
- [Website](https://jeriko.ai) — documentation and downloads
- [Changelog](CHANGELOG.md) — release history

## Security

Found a vulnerability? See [SECURITY.md](SECURITY.md) for responsible disclosure instructions.

## License

Proprietary — © 2024-2026 Etheon AI. All rights reserved. See [LICENSE.md](LICENSE.md).
