#!/bin/bash

if mysqladmin ping -h mariadb --silent; then
	echo "MariaDB is up and running!"

	MYSQL_PASSWORD=$(cat /run/secrets/mysql_user_password)
	WORDPRESS_ADMIN_PASSWORD=$(cat /run/secrets/wordpress_admin_password)
	WORDPRESS_USER_PASSWORD=$(cat /run/secrets/wordpress_user_password)

	#wp core download --allow-root
	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php


	# Verify if the database exists
	if ! sudo -u www-data -- wp core is-installed --path=/var/www/html; then
		# Install WordPress
		sudo -u www-data -- wp core install \
			--url=$WORDPRESS_URL \
			--title=$WORDPRESS_TITLE \
			--admin_user=$WORDPRESS_ADMIN_USER \
			--admin_password=$WORDPRESS_ADMIN_PASSWORD \
			--admin_email=$WORDPRESS_ADMIN_EMAIL \
			--path=/var/www/html
	else
		echo "WordPress is already installed."
	fi

	#wp core install --allow-root \
	#	--url=$WORDPRESS_URL \
	#	--title=$WORDPRESS_TITLE \
	#	--admin_user=$WORDPRESS_ADMIN_USER \
	#	--admin_password=$WORDPRESS_ADMIN_PASSWORD \
	#	--admin_email=$WORDPRESS_ADMIN_EMAIL \
	#	--path=/var/www/html


	# Verify if the user exists
    if sudo -u www-data -- wp user list --field=user_login | grep -q "^$WORDPRESS_USER$"; then
		echo "User '$WORDPRESS_USER' already exists."
	else
		# Create the user
		wp user create --allow-root \
			$WORDPRESS_USER $WORDPRESS_USER_EMAIL \
			--role=author \
			--user_pass=$WORDPRESS_USER_PASSWORD \
			--path=/var/www/html

		echo "User '$WORDPRESS_USER' created."
	fi

	#wp user create --allow-root \
	#	$WORDPRESS_USER $WORDPRESS_USER_EMAIL \
	#	--role=author \
	#	--user_pass=$WORDPRESS_USER_PASSWORD \
	#	--path=/var/www/html

	#wp plugin update --all --allow-root --path=/var/www/html
	sudo -u www-data -- wp plugin update --all --path=/var/www/html

	chown -R www-data:www-data /var/www/html

	/usr/sbin/php-fpm8.2 -F

else
	echo "MariaDB is not available. Exiting."
	sleep 5
	exit 1
fi
