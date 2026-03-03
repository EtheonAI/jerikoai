# Jeriko — Technical Architecture

> Version 2.0.0-alpha.0 · Bun runtime · Single compiled binary

## Overview

Jeriko is a Unix-first AI agent platform. Every capability is a CLI command — no proprietary tool abstractions. Any AI model with shell access (Claude, GPT, Llama, DeepSeek, local models) can control the machine through the same command interface.

**Design principles:**
- **Model-agnostic** — LLM drivers for Anthropic, OpenAI, Ollama, Claude Code, and any OpenAI-compatible provider
- **Single binary** — compiled to a ~66MB self-contained executable with zero runtime dependencies
- **Three layers** — CLI → Daemon → Shared, with zero circular dependencies
- **Unix-first** — commands pipe via JSON stdout, exit codes are semantic, stdin is supported everywhere

```
┌──────────────────────────────────────────────────────────────────┐
│                         CLI Layer                                │
│  Dispatcher → 51 commands across 10 categories                   │
│  Interactive REPL → Ink-based terminal UI                        │
│  Backend → daemon (socket IPC) or in-process (direct agent)      │
└──────────────┬───────────────────────────────────────────────────┘
               │ Unix socket or direct import
┌──────────────▼───────────────────────────────────────────────────┐
│                        Daemon Layer                              │
│  Kernel → 15-step boot sequence                                  │
│  Agent → runAgent loop, 5 LLM drivers, 15 tools, orchestrator   │
│  API → Hono HTTP server + Unix socket IPC                        │
│  Services → channels, connectors, triggers                       │
│  Storage → SQLite + Drizzle ORM + KV store                       │
│  Workers → parallel execution pool                               │
│  Plugins → plugin loader                                         │
└──────────────┬───────────────────────────────────────────────────┘
               │
┌──────────────▼───────────────────────────────────────────────────┐
│                        Shared Layer                              │
│  Config, argument parsing, output formatting, logging            │
│  Skills, connectors, environment refs, secrets, tokens           │
│  Zero internal dependencies — pure functions + types             │
└──────────────────────────────────────────────────────────────────┘
```

---

## CLI Layer

The CLI layer is the primary user interface. It handles command dispatching, interactive chat, and communication with the daemon.

### Dispatcher

The dispatcher resolves commands in two phases: core commands first, then plugin registry. When invoked with no arguments, it launches the interactive chat REPL.

- **51 commands** across 10 categories (system, files, browser, communication, automation, development, connectors, channels, admin, agent)
- **Global flags**: `--format` (json/text/logfmt), `--quiet`, `--version`
- **Help**: `--help` passed through to individual commands for per-command documentation

### Interactive Chat (REPL)

A rich terminal UI built with React and Ink:
- Markdown rendering with syntax highlighting (6 languages)
- Multi-line input with history navigation
- Arrow-key autocomplete for slash commands
- Streaming responses with phase-specific spinners
- Sub-agent live monitoring
- Model-aware cost tracking
- 21 slash commands for in-session control

### Backend Modes

The CLI operates in two modes:
- **Daemon mode** — communicates with the background daemon via Unix socket IPC (streaming)
- **In-process mode** — runs the agent directly within the CLI process (no daemon required)

---

## Daemon Layer

The daemon is a persistent background process that manages all long-running services.

### Kernel Boot Sequence

The kernel follows a 15-step boot sequence:
1. Configuration loading (layered: defaults → user → project → env)
2. Logging initialization
3. Database setup (SQLite migrations)
4. Security configuration
5. License validation
6. Tool registration (15 agent tools)
7. Plugin loading
8. Trigger engine initialization
9. System prompt assembly
10. Skill injection
11. Connector initialization
12. Channel setup (Telegram, WhatsApp, Slack, Discord)
13. HTTP API server start
14. Socket IPC server start
15. Health check

### Agent System

The agent runs a tool-use loop with support for multiple LLM providers:

**Drivers:**
| Driver | Provider | Protocol |
|--------|----------|----------|
| Anthropic | Claude (Haiku, Sonnet, Opus) | Anthropic Messages API |
| OpenAI | GPT-4o, GPT-4 Turbo | OpenAI Chat Completions |
| Local | Ollama, LM Studio, vLLM, llama.cpp | OpenAI-compatible |
| Claude Code | Claude Code CLI | Subprocess |
| Custom | OpenRouter, DeepInfra, Together, Groq | OpenAI-compatible |

**15 Agent Tools:**
| Tool | Capability |
|------|-----------|
| bash | Shell command execution |
| read_file | File reading |
| write_file | File creation |
| edit_file | Targeted file editing |
| list_files | Directory listing |
| search_files | Content search (grep) |
| browser | Chrome automation (Playwright) |
| web_search | DuckDuckGo search |
| use_skill | Skill system access |
| web_dev | Web development project management |
| delegate | Sub-agent orchestration |
| notify | User notification |
| share | Response sharing |
| doc_reader | PDF/Excel/Word/CSV reading |
| memory | Session memory management |

### Services

**Channels** — bidirectional messaging integrations:
- Telegram (long-polling via bot API)
- WhatsApp (via Baileys)
- Slack (Socket Mode)
- Discord (Gateway)

**Connectors** — OAuth and API key integrations:
- OAuth: GitHub, X, Google Drive, OneDrive, Gmail, Outlook, Vercel
- API Key: Stripe, PayPal, Twilio

**Triggers** — event-driven automation:
- Cron schedules (standard 5/6-field expressions)
- Webhook receivers (with signature verification)
- File watchers (recursive, with pattern filtering)
- HTTP monitors (status/latency checking)

### Storage

SQLite database managed via Drizzle ORM:
- **Sessions** — conversation history with parent/child relationships
- **Messages** — per-session message storage
- **Triggers** — trigger configuration with run counts and error tracking
- **KV Store** — general-purpose key-value persistence
- **Billing** — subscription and license state

Automatic migrations ensure schema evolution across versions.

---

## API Layer

### HTTP API (Hono)

| Endpoint | Auth | Description |
|----------|------|-------------|
| `GET /health` | None | Health check and system status |
| `GET /api/nodes` | Bearer | List connected WebSocket nodes |
| `GET /api/token/:name` | Bearer | Generate auth token for a node |
| `GET /api/triggers` | Bearer | List all triggers |
| `POST /hooks/:id` | Signature | Receive webhook for a trigger |
| `POST /hooks/plugin/:ns/:name` | Signature | Receive webhook for a plugin |
| `GET /api/billing/plan` | Bearer | Current billing plan |
| `POST /api/billing/checkout` | Bearer | Create checkout session |
| `POST /api/billing/webhook` | Stripe sig | Billing webhook receiver |

### Unix Socket IPC

The daemon exposes a Unix socket for local CLI communication:
- Streaming responses via Server-Sent Events (SSE)
- Session management (create, resume, list)
- Model switching
- Status and health queries

### WebSocket

Remote node orchestration via WebSocket:
- HMAC-SHA256 authentication
- Task assignment and streaming results
- 30-second heartbeat with liveness tracking
- 5-minute task timeout with partial result recovery

---

## Configuration

Layered configuration with increasing priority:

1. **Built-in defaults** — sensible zero-configuration settings
2. **User config** — `~/.config/jeriko/config.json`
3. **Project config** — `./jeriko.json` in the working directory
4. **Environment variables** — `JERIKO_*` prefixed overrides

Key configuration sections:
- `agent` — model, temperature, max tokens, extended thinking
- `channels` — Telegram, WhatsApp, Slack, Discord credentials
- `connectors` — webhook secrets and API credentials
- `security` — allowed paths, blocked commands, sensitive keys
- `storage` — database and memory paths
- `logging` — level, rotation size, file count
- `providers` — custom LLM provider definitions
- `billing` — Stripe billing configuration

---

## Build & Distribution

Compiled to a single binary using Bun's `--compile` flag. The binary bundles all application code, dependencies, and the Bun runtime into a self-contained executable.

**Supported platforms:**
| Platform | Architecture |
|----------|-------------|
| macOS | Apple Silicon (arm64) |
| macOS | Intel (x86_64) |
| Linux | x86_64 |
| Linux | ARM64 |
| Linux | x86_64 (musl) |
| Windows | x86_64 |

Install scripts handle platform detection, binary download, checksum verification, and PATH setup automatically.
