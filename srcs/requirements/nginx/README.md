
# Dockerfile Overview

This Dockerfile is used to build a container that runs an NGINX server with SSL (HTTPS) enabled using a self-signed certificate. Below is an explanation of each step within the Dockerfile.

## 1. Base Image

The Dockerfile starts by specifying the base image. Here, we're using **Debian:bookworm**, which is the latest stable version of Debian as of October 2024.

```Dockerfile
FROM debian:bookworm
```

## 2. Metadata

We use the `LABEL` instruction to specify metadata for the image, such as the author of the image.

```Dockerfile
LABEL org.opencontainers.image.authors="Hotaruban"
```

## 3. System Update and Package Installation

To ensure the system is up-to-date and to install the necessary packages (NGINX and OpenSSL), we use the following `RUN` commands:

```Dockerfile
RUN apt-get update && apt-get upgrade -y
RUN apt-get install nginx -y
RUN apt-get install openssl -y
```

- `apt-get update`: Updates the list of available packages.
- `apt-get upgrade -y`: Upgrades the system packages without prompting for confirmation.
- `apt-get install nginx -y`: Installs NGINX, the web server.
- `apt-get install openssl -y`: Installs OpenSSL, used for creating SSL certificates.

### Cleaning the System

After installing the necessary packages, we clean up unnecessary files to reduce the size of the Docker image:

```Dockerfile
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
```

## 4. SSL Directory Setup

We create a directory to store the SSL certificate and private key. This will be used later when we generate the SSL files.

```Dockerfile
RUN mkdir -p /etc/nginx/ssl
```

## 5. SSL Certificate Generation

Next, we generate a self-signed SSL certificate using OpenSSL. The options used in the command are as follows:

```Dockerfile
RUN openssl req -x509 -nodes -days 365 \
    -out /etc/nginx/ssl/jhurpy.42.fr.crt \
    -keyout /etc/nginx/ssl/jhurpy.42.fr.key \
    -subj "/C=TH/ST=Bangkok/L=Bangkok/O=42BKK/OU=42/CN=jhurpy.42.fr"
```

- `-x509`: Creates a self-signed certificate.
- `-nodes`: Creates a private key without a passphrase.
- `-days 365`: Sets the certificate to be valid for 365 days.
- `-out`: Specifies the output file for the certificate.
- `-keyout`: Specifies the output file for the private key.
- `-subj`: Defines the subject for the certificate, containing:
    - `/C=TH`: Country (Thailand)
    - `/ST=Bangkok`: State (Bangkok)
    - `/L=Bangkok`: Locality (Bangkok)
    - `/O=42BKK`: Organization (42 Bangkok)
    - `/OU=42`: Organizational Unit (42)
    - `/CN=jhurpy.42.fr`: Common Name (domain name)

This certificate is self-signed, meaning it is suitable for development environments but should not be used in production.

## 6. NGINX Configuration

We copy a custom NGINX configuration file from the `conf` directory on the host system to the container’s configuration directory:

```Dockerfile
COPY conf/nginx.conf /etc/nginx/nginx.conf
```

This custom configuration file should define the behavior of NGINX, including SSL setup, server blocks, and more.

## 7. Port Exposure

The container will expose port **443**, which is the default port for HTTPS:

```Dockerfile
EXPOSE 443
```

## 8. Starting NGINX

Finally, we use the `ENTRYPOINT` instruction to start the NGINX service and keep the container running. The `daemon off;` option ensures that NGINX runs in the foreground, allowing the container to stay active:

```Dockerfile
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
```

## Summary

This Dockerfile builds an NGINX web server container with SSL enabled using a self-signed certificate. It performs the following key steps:
1. Uses Debian as the base image.
2. Installs NGINX and OpenSSL.
3. Cleans up unnecessary system files to reduce image size.
4. Generates a self-signed SSL certificate.
5. Configures NGINX with a custom configuration.
6. Exposes port 443 for HTTPS.
7. Starts the NGINX server with the necessary parameters.

This setup is ideal for local development or internal projects requiring SSL but should be adjusted for production environments with a proper SSL certificate from a Certificate Authority.
