#!/bin/bash

until mysqladmin ping -h mariadb --silent; do
  echo "Waiting for MariaDB to be available..."
  sleep 5
done

echo "MariaDB is up and running!"

# Auto config for wordpress
#wp download --allow-root
wp config create --allow-root \
	--dbname=$MYSQL_DATABASE \
	--dbuser=$MYSQL_USER \
	--dbpass=$MYSQL_PASSWORD \
	--dbhost=mariadb:3306 --path='/var/www/html/wordpress'

wp core install --allow-root \
	--url=$WORDPRESS_URL \
	--title=$WORDPRESS_TITLE \
	--admin_user=$WORDPRESS_ADMIN_USER \
	--admin_password=$WORDPRESS_ADMIN_PASSWORD \
	--admin_email=$WORDPRESS_ADMIN_EMAIL \
	--path='/var/www/html/wordpress'

wp user create --allow-root \
	$WORDPRESS_USER $WORDPRESS_USER_EMAIL \
	--role=author \
	--user_pass=$WORDPRESS_USER_PASSWORD \
	--path='/var/www/html/wordpress'

wp plugin update --all --allow-root --path='/var/www/html/wordpress'

chown -R www-data:www-data /var/www/html/wordpress

/usr/sbin/php-fpm8.3 -F
