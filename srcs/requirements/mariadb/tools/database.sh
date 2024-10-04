#!/bin/bash

# script to create the database and the user

/etc/init.d/mariadb start

# secure the installation
mysql_secure_installation<<EOF
y
MYSQL_ROOT_PASSWORD
MYSQL_ROOT_PASSWORD
y
y
y
y
EOF

# create the database and the user
mariadb -u root -p$MYSQL_ROOT_PASSWORD<<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

# stop the service
/etc/init.d/mariadb stop
