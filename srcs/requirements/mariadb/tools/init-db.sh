#!/bin/bash

# Start the MySQL service in the foreground
mysqld --skip-networking &

# Maximum number of attempts before giving up
MAX_ATTEMPTS=12
attempt=0

# Wait for MariaDB to be ready (retry up to MAX_ATTEMPTS times)
until mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; do
	attempt=$((attempt+1))
	if [ $attempt -ge $MAX_ATTEMPTS ]; then
		echo "MariaDB did not become ready in time, exiting..."
		exit 1
	fi
	echo "Waiting for MariaDB to be ready... Attempt $attempt/$MAX_ATTEMPTS"
	sleep 5
done

echo "MariaDB is ready."

# Run the database initialization script
/usr/local/bin/database.sh

# Restart MariaDB with networking enabled to allow external connections
killall mysqld
mysqld
