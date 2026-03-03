#!/usr/bin/env bash
# Example Jeriko hook: pre-command
#
# This script runs before every Jeriko command execution.
# Place hooks in ~/.config/jeriko/hooks/ and make them executable.
#
# Available environment variables:
#   JERIKO_COMMAND  — the command being executed (e.g., "chat", "status")
#   JERIKO_ARGS     — the full argument string
#   JERIKO_FORMAT   — output format (json, text, logfmt)
#
# Exit 0 to allow the command to proceed.
# Exit non-zero to block the command.

set -euo pipefail

LOGFILE="${HOME}/.jeriko/data/logs/hooks.log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Ensure log directory exists
mkdir -p "$(dirname "$LOGFILE")"

# Log the command execution
echo "${TIMESTAMP} pre-command: ${JERIKO_COMMAND:-unknown} ${JERIKO_ARGS:-}" >> "$LOGFILE"

# Example: block destructive commands in production
# if [[ "${JERIKO_COMMAND:-}" == "reset" ]]; then
#   echo "Blocked: reset command disabled by pre-command hook" >&2
#   exit 1
# fi

exit 0
