#!/bin/bash

# Path to the .env file
ENV_FILE="../.env"

# Creation of the .env file
if [ -f "$ENV_FILE" ]; then
	echo "The .env file already exists."
	exit 0
fi
{
    echo "# Environment variables for the project"
    echo ""
    echo "# mysql"
    echo "MYSQL_USER=user"
    echo "MYSQL_DATABASE=wordpress"
    echo "MYSQL_HOSTNAME=mariadb"
    echo ""
    echo "# wordpress"
    echo "WORDPRESS_URL=jhurpy.42.fr"
    echo "WORDPRESS_TITLE=Inception"
    echo "WORDPRESS_ADMIN_USER=hotaru"
    echo "WORDPRESS_ADMIN_EMAIL=hotaru@42bkk.fr"
    echo "WORDPRESS_USER=userone"
    echo "WORDPRESS_USER_EMAIL=userone@pass.fr"
    echo ""
    echo "# password"
} > "$ENV_FILE"

echo ".env file created successfully."
