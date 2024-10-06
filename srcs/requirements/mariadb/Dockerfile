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

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install MariaDB
RUN apt-get install mariadb-server -y

# Copy the configuration file and the script to the container
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
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

# Clean the system and remove the cache
#RUN apt-get clean
#RUN rm -rf /var/lib/apt/lists/*

# Expose the port 3306 for information
EXPOSE 3306

# Set the user to mysql to run the service for security reasons
USER mysql

# Start the service
ENTRYPOINT ["mysqld"]
