#!/bin/bash
set -e

# Use Render's port or default to 8080
PORT="${PORT:-8080}"

# Start lightweight HTTP server (background)
python3 -m http.server "$PORT" --bind 0.0.0.0 >/var/log/http_server.log 2>&1 &

# Ensure MySQL data directory exists and owned properly
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql

# Start MySQL with correct data directory
exec mysqld --datadir=/data/mysql
