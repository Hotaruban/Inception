#!/bin/bash

# Start the MySQL service in the foreground
mysqld --skip-networking &

# Wait for MariaDB to be fully up and running
until mariadb -u root -e "SELECT 1;" >/dev/null 2>&1; do
	echo "Waiting for MariaDB to be ready..."
	sleep 5
done

echo "MariaDB is ready."

# Run the database initialization script
/usr/local/bin/database.sh

# Restart MariaDB with networking enabled to allow external connections
killall mysqld
mysqld
