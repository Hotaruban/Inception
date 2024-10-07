##!/bin/bash
#set -e

#MAX_TRIES=30
#COUNTER=0

#while ! mysqladmin ping -h"localhost" --silent; do
#	sleep 1
#	COUNTER=$((COUNTER+1))
#	if [ $COUNTER -ge $MAX_TRIES ]; then
#		echo "Impossible to connect to MySQL, after $MAX_TRIES tries."
#		exit 1
#	fi
#done

echo "MySQL is ready."

## script to create the database and the user
#sleep 10

##MYSQL_ROOT_PASSWORD="42root"
##MYSQL_DATABASE=wordpress
##MYSQL_PASSWORD=42userjdg
##MYSQL_USER=userjdg

# secure the installation
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

# delete the anonymous user
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='';"

# delete the remote root user
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# delete the test database
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS test;"
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

# reload the privileges
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

mariadb -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF



#!/bin/bash

# Secure the installation
#mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
#mariadb -e "DELETE FROM mysql.user WHERE User='';"
#mariadb -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
#mariadb -e "DROP DATABASE IF EXISTS test;"
#mariadb -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
#mariadb -e "FLUSH PRIVILEGES;"

# Create the database and the user
#mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
#mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
#mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
#mariadb -e "FLUSH PRIVILEGES;"

echo "Database initialization completed."
#echo "SHOW DATABASES"
#mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"
#echo "SHOW USERS"
#mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT User FROM mysql.user;"
#echo "SHOW GRANTS"
#mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW GRANTS FOR '$MYSQL_USER'@'%';"

