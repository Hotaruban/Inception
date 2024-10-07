#!/bin/bash
set -e

MAX_TRIES=30
COUNTER=0

while ! mysqladmin ping -h"localhost" --silent; do
	sleep 1
	COUNTER=$((COUNTER+1))
	if [ $COUNTER -ge $MAX_TRIES ]; then
		echo "Impossible to connect to MySQL, after $MAX_TRIES tries."
		exit 1
	fi
done

echo "MariaDB is ready. Proceeding with initialization..."

# Secure the installation
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

# Create the database and the user
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;
EOSQL

echo "Database initialization completed."

# Debug
#echo "SHOW DATABASES"
#mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"
#echo "SHOW USERS"
#mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT User FROM mysql.user;"
#echo "SHOW GRANTS"
#mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW GRANTS FOR '$MYSQL_USER'@'%';"
