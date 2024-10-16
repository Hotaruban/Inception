#!/bin/bash

# Start the MySQL service in the foreground
mysqld --skip-networking &

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)

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

check_mariadb_database_with_password() {
	mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE $MYSQL_DATABASE;" >/dev/null 2>&1
}

check_mariadb_database_without_password() {
	mariadb -u root -e "USE $MYSQL_DATABASE;" >/dev/null 2>&1
}

# Wait for MariaDB to be ready (retry up to MAX_ATTEMPTS times)
until check_mariadb_without_password || check_mariadb_with_password; do
	attempt=$((attempt+1))
	if [ $attempt -ge $MAX_ATTEMPTS ]; then
		echo "MariaDB did not become ready in time, exiting..."
		exit 1
	fi
	echo "Waiting for MariaDB to be ready... Attempt [$attempt/$MAX_ATTEMPTS]"
	sleep 5
done

echo "MariaDB is ready for initialization."

# Check if the database already exists
if check_mariadb_database_with_password || check_mariadb_database_without_password; then
	echo "Database $MYSQL_DATABASE already exists. Skipping initialization."
else
	echo "Database $MYSQL_DATABASE does not exist. Running initialization script."
	# Run the database initialization script
	/usr/local/bin/database.sh
fi

# Restart MariaDB with networking enabled to allow external connections
echo "MariaDB initialization complete. Restarting MariaDB with networking enabled."
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
echo "MariaDB is ready for connections."
mysqld
