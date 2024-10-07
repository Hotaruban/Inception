#!/bin/bash

# Start the MySQL service in the foreground
mysqld --skip-networking &

# Maximum number of attempts before giving up
MAX_ATTEMPTS=12
attempt=0


# Check if the root password is not set
check_mariadb_without_password() {
	mariadb -u root -e "SELECT 1;" >/dev/null 2>&1
}

# Check if the root password is set
check_mariadb_with_password() {
	mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1
}

# Wait for MariaDB to be ready (retry up to MAX_ATTEMPTS times)
until check_mariadb_without_password || check_mariadb_with_password; do
	attempt=$((attempt+1))
	if [ $attempt -ge $MAX_ATTEMPTS ]; then
		echo "MariaDB did not become ready in time, exiting..."
		exit 1
	fi
	echo "Waiting for MariaDB to be ready... Attempt $attempt/$MAX_ATTEMPTS"
	sleep 5
done

echo "MariaDB is ready."

# Check if the database already exists
if mariadb -u root -e "USE $MYSQL_DATABASE;" >/dev/null 2>&1; then
	echo "Database $MYSQL_DATABASE already exists. Skipping initialization."
else
	echo "Database $MYSQL_DATABASE does not exist. Running initialization script."
	# Run the database initialization script
	/usr/local/bin/database.sh
fi

# Restart MariaDB with networking enabled to allow external connections
killall mysqld
mysqld
