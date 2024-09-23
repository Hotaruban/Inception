FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get install vim -y

RUN apt-get install curl -y

RUN apt-get install nginx -y

RUN apt-get install openssl -y

RUN mkdir -p /etc/nginx/ssl

# the option -nodes is used to create a private key without a passphrase
# the option -x509 is used to create a self-signed certificate
# the option -out is used to specify the output file for the certificate
# the option -keyout is used to specify the output file for the private key
# the option -subj is used to specify the subject of the certificate
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/jhurpy.42.fr.crt -keyout /etc/nginx/ssl/jhurpy.42.fr.key -days 365 -subj "/C=TH/ST=Bangkok/L=Bangkok/O=42BKK/OU=42/CN=jhurpy.42.fr"

RUN mkdir -p /var/www/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
