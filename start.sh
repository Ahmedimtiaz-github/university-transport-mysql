#!/bin/bash
set -e

# Use the PORT provided by Render; default to 8080 if not set
PORT="${PORT:-8080}"

# Start a lightweight HTTP server (background). This gives Render an open HTTP port to verify.
# Output logs to /var/log/http_server.log
python3 -m http.server "$PORT" --bind 0.0.0.0 >/var/log/http_server.log 2>&1 &

# Exec mysqld as the main process (docker-entrypoint has already run initialization)
# Exec ensures PID 1 is mysqld so signals are handled correctly.
exec mysqld