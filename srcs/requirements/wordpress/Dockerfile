FROM debian:bookworm
# Set the metadata for the image an author
LABEL org.opencontainers.image.authors="Hotaruban"

# Set the environment variable for the Wordpress
ARG WORDPRESS_URL
ARG WORDPRESS_TITLE
ARG WORDPRESS_ADMIN_USER
ARG WORDPRESS_ADMIN_PASSWORD
ARG WORDPRESS_ADMIN_EMAIL

# Set the environment variable for first user
ARG WORDPRESS_USER
ARG WORDPRESS_USER_EMAIL
ARG WORDPRESS_USER_PASSWORD

# Use the root user to run the following commands
USER root

# Update and upgrade the system and install the necessary packages
RUN apt-get update && apt-get upgrade -y

# Install Wordpress
RUN apt-get install -y wget
RUN mkdir -p /var/www/html
RUN wget https://wordpress.org/wordpress-6.6.2.tar.gz -P /var/www/html
RUN tar -xvf /var/www/html/wordpress-6.6.2.tar.gz -C /var/www/html
RUN mv /var/www/html/wordpress/* /var/www/html/
RUN rm -rf /var/www/html/wordpress-6.6.2.tar.gz /var/www/html/wordpress
RUN chown -R root:root /var/www/html

# Install PHP
RUN apt-get install -y php \
	php-fpm \
	php-mysql \
	mariadb-client

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp/
RUN chmod +x /tmp/wp-cli.phar
RUN mv /tmp/wp-cli.phar /usr/local/bin/wp
RUN wp cli update

# Copy the configuration file and the script to the container
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/auto_config.sh /tmp/auto_config.sh

# Change the permission of the script
RUN chmod +x /tmp/auto_config.sh
ENTRYPOINT ["/bin/bash", "/tmp/auto_config.sh"]

# Clean the system and remove the cache
#RUN apt-get clean
#RUN rm -rf /var/lib/apt/lists/*

# Expose the port 9000 for information
EXPOSE 9000

# Run the script to configure the Wordpress and start the PHP
CMD ["/usr/sbin/php-fpm7.4", "-F"]
