#!/bin/bash

sleep 10

if mysqladmin ping -h mariadb --silent; then
	echo "MariaDB is up and running!"

	# Auto config for wordpress
	#wp core download --allow-root
	wp language core install en_EN --allow-root
	wp config create --allow-root \
		--dbname=$MYSQL_DATABASE \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbhost=mariadb:3306 \
		--path=/var/www/html

	wp site switch-language en_EN --allow-root --path=/var/www/html

	wp core install --allow-root \
		--url=$WORDPRESS_URL \
		--title=$WORDPRESS_TITLE \
		--admin_user=$WORDPRESS_ADMIN_USER \
		--admin_password=$WORDPRESS_ADMIN_PASSWORD \
		--admin_email=$WORDPRESS_ADMIN_EMAIL \
		--path=/var/www/html

	wp user create --allow-root \
		$WORDPRESS_USER $WORDPRESS_USER_EMAIL \
		--role=author \
		--user_pass=$WORDPRESS_USER_PASSWORD \
		--path=/var/www/html

	wp plugin update --all --allow-root --path=/var/www/html

	chown -R www-data:www-data /var/www/html

	/usr/sbin/php-fpm8.2 -F

else
	echo "MariaDB is not available. Exiting."
	exit 1
fi
