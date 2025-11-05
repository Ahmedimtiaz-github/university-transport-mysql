#!/bin/bash
set -euo pipefail

# Create data dir and ensure mysql owner
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql

# If DB data not present, initialize insecurely (so root has empty password initially)
if [ ! -d "/data/mysql/mysql" ]; then
  echo "$(date) - No DB found; initializing insecurely"
  mysqld --initialize-insecure --datadir=/data/mysql
fi

# Start mysqld in background with data dir
mysqld --datadir=/data/mysql --user=mysql &

# Wait for MySQL to accept connections (60s max)
echo "$(date) - waiting for mysql to be ready..."
for i in $(seq 1 60); do
  if mysql -u root -e "SELECT 1" >/dev/null 2>&1; then
    echo "mysql ready"
    break
  fi
  sleep 1
done

# Import the SQL dump once (idempotent using marker)
MARKER="/data/mysql/.imported_from_gist"
if [ ! -f "$MARKER" ]; then
  echo "$(date) - Downloading SQL dump and importing..."
  # IMPORTANT: change this URL only if your dump URL changes
  DUMP_URL="https://gist.githubusercontent.com/Ahmedimtiaz-github/9f5614c927c7cc28cc8b04b6082c7e01/raw/8085358cefd74a34ccde8d3da500ff6a4674af78/gistfile1.txt"
  curl -sSL "$DUMP_URL" -o /tmp/transport_management.sql

  # Ensure target database exists
  mysql -u root -e "CREATE DATABASE IF NOT EXISTS transport_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" || true

  # Import (ignore errors but try)
  mysql -u root transport_management < /tmp/transport_management.sql || true

  # create marker so we don't re-import on every restart
  touch "$MARKER"
  echo "$(date) - import finished"
fi

# Start a lightweight HTTP server for Render health checks on $PORT (default 8080)
PORT="${PORT:-8080}"
python3 -m http.server "$PORT" --bind 0.0.0.0 >/var/log/http_server.log 2>&1 &

# Wait on mysqld process so container stays alive and signals propagate
wait %1