FROM debian:bookworm

# Set the metadata for the image an author
LABEL org.opencontainers.image.authors="Hotaruban"

# update, upgrade and install nginx and openssl
RUN apt-get update && apt-get upgrade -y
RUN apt-get install nginx -y
RUN apt-get install openssl -y

# Clean the system and remove the cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*


# Create a directory for storing the ssl certificate and the private key
	# the option -nodes is used to create a private key without a passphrase
	# the option -x509 is used to create a self-signed certificate
	# the option -out is used to specify the output file for the certificate
	# the option -keyout is used to specify the output file for the private key
	# the option -subj is used to specify the subject of the certificate
		#/C=TH : Country
		#/ST=Bangkok : State
		#/L=Bangkok : Locality
		#/O=MyCompany : Organisation (Company)
		#/OU=IT : Organisation unit (IT department)
		#/CN=mycompany.com : Common Name (domain name)
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365\
	-out /etc/nginx/ssl/jhurpy.42.fr.crt\
	-keyout /etc/nginx/ssl/jhurpy.42.fr.key\
	-subj "/C=TH/ST=Bangkok/L=Bangkok/O=42BKK/OU=42/CN=jhurpy.42.fr"

# copy our configuration file of nginx to the container
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose the port 443 for information
EXPOSE 443

# execute the command to start nginx
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
