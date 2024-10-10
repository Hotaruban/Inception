FROM debian:bookworm

# Set the metadata for the image
LABEL org.opencontainers.image.authors="Hotaruban"

# Use the root user to run the following commands
USER root

# Update and upgrade the system and install the necessary packages
RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y wget php php-fpm php-mysql mariadb-client && \
	rm -rf /var/lib/apt/lists/*

# Install Wordpress
RUN wget https://wordpress.org/wordpress-6.6.2.tar.gz -P /tmp && \
	tar -xvf /tmp/wordpress-6.6.2.tar.gz -C /var/www/html && \
	mv /var/www/html/wordpress/* /var/www/html/ && \
	rm -rf /tmp/wordpress-6.6.2.tar.gz /var/www/html/wordpress && \
	chown -R www-data:www-data /var/www/html

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp/ && \
	chmod +x /tmp/wp-cli.phar && mv /tmp/wp-cli.phar /usr/local/bin/wp

# Copy the configuration file and the script to the container
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY ./tools/auto_config.sh /usr/local/bin/auto_config.sh

# Give the permission to the script
RUN chmod +x /usr/local/bin/auto_config.sh

# Define the working directory
WORKDIR /var/www/html

# Expose the port 9000 for information
EXPOSE 9000

# Entrypoint and command to run the script and start the PHP
ENTRYPOINT ["/bin/bash", "/usr/local/bin/auto_config.sh"]

CMD ["/usr/sbin/php-fpm8.2", "-F"]
