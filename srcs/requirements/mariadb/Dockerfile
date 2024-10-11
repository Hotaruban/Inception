FROM debian:bookworm

# Set the metadata for the image an author
LABEL org.opencontainers.image.authors="Hotaruban"

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

# Copy the script to the container and set the permissions
COPY ./tools/database.sh /usr/local/bin/
COPY ./tools/init-db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/database.sh && \
		chmod +x /usr/local/bin/init-db.sh

# Define the volumes
VOLUME /var/lib/mysql

# Expose the port 3306 for information
EXPOSE 3306

# Set the entrypoint
ENTRYPOINT [ "/usr/local/bin/init-db.sh" ]
