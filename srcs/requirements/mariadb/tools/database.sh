#!/bin/bash

# script to create the database and the user

#mysql_install_db

/etc/init.d/mysql start

# secure the installation
#mysql_secure_installation<<EOF
#y
#$MYSQL_ROOT_PASSWORD
#$MYSQL_ROOT_PASSWORD
#y
#y
#y
#y
#EOF

# create the database and the user
#mariadb -u root -p$MYSQL_ROOT_PASSWORD<<EOF
#GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
#FLUSH PRIVILEGES;

mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

#mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /tmp/wordpress.sql

# stop the service
/etc/init.d/mysql stop
