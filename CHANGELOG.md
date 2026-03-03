# Changelog

All notable changes to Jeriko will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0-alpha.0] - 2026-03-03

### Added

- **Daemon architecture** — persistent background process with SQLite state, session management, and streaming responses
- **Interactive CLI** — React/Ink terminal UI with markdown rendering, syntax highlighting, autocomplete, and multi-line input
- **Multi-provider AI** — Claude, GPT-4, Ollama, and any OpenAI-compatible API via custom providers
- **Channels** — Telegram, WhatsApp, Slack, and Discord integration for remote agent interaction
- **Connectors** — OAuth and API key connectors for GitHub, Stripe, PayPal, Twilio, Google Drive, OneDrive, Gmail, Outlook, Vercel, and X
- **Triggers** — cron schedules, webhook receivers, file watchers, and HTTP polling with auto-disable on failure
- **Skills system** — extensible YAML-based skills with progressive loading and community sharing
- **Web development** — pre-built React/Vite/Tailwind templates with instant scaffolding, live preview, and screenshot verification
- **Single binary distribution** — compiled ~66MB binary with zero runtime dependencies
- **Layered configuration** — built-in defaults → user config → project config → environment overrides
- **Security model** — path allowlists, command blocklists, sensitive key redaction, and plugin sandboxing
- **Install scripts** — one-liner install for macOS, Linux, and Windows

[2.0.0-alpha.0]: https://github.com/etheonai/jerikoai/releases/tag/v2.0.0-alpha.0
