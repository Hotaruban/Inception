FROM debian:buster

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install MariaDB
RUN apt-get install mariadb-server -y

# Copy the configuration file
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
