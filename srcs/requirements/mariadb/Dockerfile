FROM debian:bookworm
# Set the metadata for the image an author
LABEL org.opencontainers.image.authors="Hotaruban"

# Set the arguments
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE
ARG MYSQL_ROOT_PASSWORD

# Set the user to root to install the packages
USER root

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y
RUN rm -rf /var/lib/apt/lists/*

# Install MariaDB
RUN apt-get install mariadb-server -y

# Copy the configuration file
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the script to create the database
COPY ./tools/ /root/tools/

# Run the script to create the database
RUN chmod +x /root/tools/database.sh
RUN /root/tools/database.sh
RUN rm -rf /root/tools

# Create directory with correct permissions and ownership for socket
#RUN mkdir -p /var/run/mysqld
#RUN chown -R mysql:mysql /var/run/mysqld
#RUN chmod 755 /var/run/mysqld

# Define the volumes
VOLUME /var/lib/mysql

# Expose the port (default port for MariaDB)
EXPOSE 3306

# Start the service
ENTRYPOINT ["mysqld"]
