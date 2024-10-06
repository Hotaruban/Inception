## Dockerfile Creation

Each Dockerfile must start with the **`FROM`** command, which specifies the base image for the container. This represents the infrastructure or OS used by the service(s) that will run inside the container.

For this project, we use **`debian:bookworm`** ← currently the latest stable version as of October 5, 2024.

> `FROM debian:bookworm`

Next, we update the system inside the container with the apt-get update and apt-get upgrade -y commands (the -y option automatically confirms all prompts) using the Docker RUN command. After the update, we remove the package list files to reduce the size of the Docker image.

> `RUN apt-get update && apt-get upgrade -y`<br>
> `RUN rm -rf /var/lib/apt/lists/*`

We then install nginx, which will make our NGINX server available.

> `RUN apt-get install nginx -y`

Next, we proceed with the installation of OpenSSL, which will allow us to create an SSL certificate to secure the server. We will also create a folder to store the SSL certificates with the following command:

> `RUN apt-get install openssl -y`<br>
> `RUN mkdir -p /etc/nginx/ssl`

We then generate the SSL certificates with the command:

> `RUN openssl req -x509 -nodes -out /etc/nginx/ssl/certificate.crt -keyout /etc/nginx/certificate.key -days 365 -subj “/C=TH/ST=Bangkok/L=Bangkok/O=42BKK/OU=42/CN=login.42.fr”`

- x509: Used to create a self-signed certificate.
- nodes: Creates a private key without a passphrase.
- out: Specifies the output file for the certificate.
- keyout: Specifies the output file for the private key.
- days 365: Sets the certificate's validity period (365 days).
- subj: Specifies the subject for the certificate, which includes:
	- /C=TH: Country
	- /ST=Bangkok: State
	- /L=Bangkok: Locality
	- /O=42BKK: Organization
	- /OU=42: Organizational Unit
	- /CN=login.42.fr: Common Name (domain name)

The SSL certificate created is a self-signed certificate, which is acceptable for local development purposes but is not recommended for a production environment. In production, the certificate should be validated by a certificate authority.

We will also copy the configuration file that we need to create in the conf folder into the container to give it the specific configurations for our NGINX server.

> `COPY conf/nginx.conf /etc/nginx/nginx.conf`

We are almost done. Now, we need to tell the container which port to listen to:

> `EXPOSE 443`

Finally, we run our NGINX server using the CMD or ENTRYPOINT instruction (the final line should be added here).

> `ENTRYPOINT [”nginx”, “-g”, “daemon off;”]`
