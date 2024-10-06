## Creating the Configuration File

Now that we have the Dockerfile, we need to create the configuration file to start the Nginx server with the required settings. This file defines the server's behavior for handling incoming requests and sets security rules.

We'll begin with the events block, which contains general server options. There can only be one events block. For our project, there is no need to specify any options here.

```events {

}```

Next, we add the http block, which is more important for configuring the specifics of an http server in Nginx.

```events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

}```

The include directive adds the mime types, making it easier to identify file types.

The default_type specifies the default file type as octet-stream, a general type used for file downloads if the file type isn't found in mime.types.

Within this block, we add the server block. Multiple server blocks can exist, allowing Nginx to manage several sites simultaneously, defining how the server reacts based on different domains.

```events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	server {

	}
}```

In the server block, we add the necessary configurations as required by the project.

Let's start with the SSL settings:

```events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	server {
		listen 443 ssl;
		ssl_protocols TLSv1.2 TLSv1.3;
		ssl_certificate /etc/nginx/ssl/jhurpy.42.fr.crt;
		ssl_certificate_key /etc/nginx/ssl/jhurpy.42.fr.key;

	}
}```

listen 443 ssl; tells the server to be accessible only on port 443.
ssl_protocols TLSv1.2 TLSv1.3; specifies the supported SSL protocols, keeping only TLSv1.2 and TLSv1.3 as required.
ssl_certificate and ssl_certificate_key define the paths to the server's SSL certificate.
Next, let's configure the server's root and server_name.

```events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	server {
		listen 443 ssl;
		ssl_protocols TLSv1.2 TLSv1.3;
		ssl_certificate /etc/nginx/ssl/jhurpy.42.fr.crt;
		ssl_certificate_key /etc/nginx/ssl/jhurpy.42.fr.key;

		root /var/www/html;
		server_name jhurpy.42.fr www.jhurpy.42.fr;
		index index.php index.html index.htm;
	}
}```

root specifies the root directory for file access.
server_name lists the domain names through which the server can be accessed.
index sets the default page to open if no specific page is requested.
We now add a location block to display a custom 404 error page for unknown requests.

```events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	server {
		listen 443 ssl;
		ssl_protocols TLSv1.2 TLSv1.3;
		ssl_certificate /etc/nginx/ssl/jhurpy.42.fr.crt;
		ssl_certificate_key /etc/nginx/ssl/jhurpy.42.fr.key;

		root /var/www/html;
		server_name jhurpy.42.fr www.jhurpy.42.fr;
		index index.php index.html index.htm;

		location / {
			try_files $uri $uri/ =404;

		}
	}
}```

/ defines the root path, set to /var/www/html as per the server's configuration.
try_files first tries static files before returning the 404 error page.
Let's now add another location block to access our WordPress site.

```events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	server {
		listen 443 ssl;
		ssl_protocols TLSv1.2 TLSv1.3;
		ssl_certificate /etc/nginx/ssl/jhurpy.42.fr.crt;
		ssl_certificate_key /etc/nginx/ssl/jhurpy.42.fr.key;

		root /var/www/html;
		server_name jhurpy.42.fr www.jhurpy.42.fr;
		index index.php index.html index.htm;

		location / {
			try_files $uri $uri/ =404;

		}

		location ~ \.php$ {
			fastcgi_split_path_info ^(.+\.php)(/.+)$;
			fastcgi_pass wordpress:9000;
			fastcgi_index index.php;
			include fastcgi_params;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			fastcgi_param PATH_INFO $fastcgi_path_info;
			try_files $uri =404;

		}
	}
}```

~ \.php$ specifies that this location applies to all requests ending with .php.
fastcgi_split_path_info divides the request path to get the PHP script and additional path info.
fastcgi_pass forwards the request to the FastCGI server (in this case, the WordPress container).
fastcgi_index sets the default PHP file to execute, such as index.php.
include adds predefined FastCGI parameters.
fastcgi_param SCRIPT_FILENAME defines the full path to the PHP script.
fastcgi_param PATH_INFO includes any additional path information after the PHP script.
Finally, let's add the following directives to the server:


```events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	server {
		listen 443 ssl;
		ssl_protocols TLSv1.2 TLSv1.3;
		ssl_certificate /etc/nginx/ssl/jhurpy.42.fr.crt;
		ssl_certificate_key /etc/nginx/ssl/jhurpy.42.fr.key;

		root /var/www/html;
		server_name jhurpy.42.fr www.jhurpy.42.fr;
		index index.php index.html index.htm;

		location / {
			try_files $uri $uri/ =404;

		}

		location ~ \.php$ {
			fastcgi_split_path_info ^(.+\.php)(/.+)$;
			fastcgi_pass wordpress:9000;
			fastcgi_index index.php;
			include fastcgi_params;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			fastcgi_param PATH_INFO $fastcgi_path_info;
			try_files $uri =404;

		}

		access_log /var/log/nginx/access.log;
		error_log /var/log/nginx/error.log;
	}
}```

access_log configures the access log file, which records every request processed by Nginx.
error_log configures the error log file, which logs errors generated by Nginx, essential for debugging and server maintenance.
