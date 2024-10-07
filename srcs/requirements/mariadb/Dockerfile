FROM debian:bookworm

# Set the metadata for the image an author
LABEL org.opencontainers.image.authors="Hotaruban"

# Set the arguments
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_DATABASE

# Set the user to root to install the packages
USER root

# Update and upgrade the system and install the necessary packages
# Clean the system and remove the cache
RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y mariadb-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Copy the configuration file and the script to the container
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Create directory for MySQL socket with correct permissions
RUN mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

# Define the volumes
VOLUME /var/lib/mysql

# Run the script to create the database
RUN chmod +x /usr/local/bin/database.sh

# Expose the port 3306 for information
EXPOSE 3306

# Copy and set up the initialization script
COPY ./tools/database.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/database.sh

# Use an entrypoint script to initialize the database and start MariaDB
COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Execute the script in docker-entrypoint-initdb.d
ENTRYPOINT ["docker-entrypoint.sh"]

# Start the service
CMD ["mysqld"]
