#!/bin/bash
set -e

# Ensure /data/mysql exists and is owned by mysql:mysql
echo "$(date) - Ensuring /data/mysql exists and is owned by mysql:mysql"
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql

# Initialize DB if empty
if [ ! -d "/data/mysql/mysql" ]; then
  echo "$(date) - No existing DB found; initializing insecurely (you can change later)"
  mysqld --initialize-insecure --datadir=/data/mysql
  echo "$(date) - Initialization complete"
fi

# Start MySQL in the background
echo "$(date) - Starting MySQL..."
mysqld --datadir=/data/mysql --user=mysql &

# Start lightweight HTTP server on port 8080 for health check
echo "$(date) - Starting HTTP server for health check on port 8080..."
python3 -m http.server 8080 --bind 0.0.0.0 &

# Wait for MySQL to be ready and continue running the process
wait $!