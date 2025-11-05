#!/bin/bash
set -e

echo "$(date) - Ensuring /data/mysql exists and is owned by mysql:mysql"
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql

# Initialize DB if empty
if [ ! -d "/data/mysql/mysql" ]; then
  echo "$(date) - No existing DB found; initializing insecurely (you can change later)"
  mysqld --initialize-insecure --datadir=/data/mysql
  echo "$(date) - Initialization complete"
fi

# Start MySQL using custom data directory as the mysql user
exec mysqld --datadir=/data/mysql --user=mysql