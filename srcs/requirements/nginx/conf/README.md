## Creation du config file

Maintenant que nous avons le Dockerfile, il nous faut faire le config file pour pouvoir demarrer le serveur nginx avec les configuration demande par le sujet. Celui-ci permet de definir au serveur, les configurations d’ecoute des requetes qui lui sont envoyer, mais aussi je configurer les regles de securite.

Nous commencons avec le bloc events qui contiens les options generales du serveur, il ne peut y avoir qu'un seul bloc `events`. Pour notre projets, il n’est pas necessaire de lui donner des options.

```docker
events {

}
```

Ensuite nous ajoutons le bloc http qui va lui nous interresser beaucoup plus, il permet de configurer les spécificités d’un serveur `http` dans `Nginx`. ([voir le lien](https://www.notion.so/Details-of-Nginx-server-11300086bfc88067ad5bd673e3219294?pvs=21))

```docker
events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

}
```

“include” permet d’ajouter les mime.types, ce qui permet de plus facilement identifier le type des fichier. ([voir le lien](https://www.notion.so/Set-up-Ngnix-Server-10a00086bfc88065abe2f509116d6394?pvs=21))

“default_type” defini le type du fichier en octet-stream qui est un type general pour telecharger les fichiers, s’il n’est pas trouve dans mime.type. ([voir le lien](https://www.notion.so/Set-up-Ngnix-Server-10a00086bfc88065abe2f509116d6394?pvs=21))

Dans ce bloc nous allons ajouter le bloc `server` , il peut y avoir plusieurs bloc server ce qui permet a `Nginx` de gerer plusieurs sites en meme temps, il va indiquer les spécificités sur comment le server doit reagir selon les different domaine ou groupe de domaine.

```docker
events {

}

http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	server {

	}
}
```

Dans le bloc `server` nous ajouter les differents parametrages comme souhaiter par le sujet.

D’abord nous allons faire les configuration SSL

```docker
events {

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
}
```

“listen 443 ssl;” va indiquer a notre server d’etre accessible uniquement sur le port 443.

“ssl_protocols TLSv1.2 TLSv1.3;” permet au server d’echanger avec le client de maniere privee, nous gardons uniquement TLSv1.2 et TLSv1.3 comme demander par le sujet. ([voir le lien](https://www.ibm.com/docs/en/ibm-http-server/9.0.5?topic=communications-secure-sockets-layer-ssl-protocol))

“ssl_certificate” et “ssl_certificate_key” sont les routes d’acces au certificat ssl de notre serveur.

Ensuite, nous allons ajouter les configuration root et server_name du server.

```docker
events {

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
}
```

“root” indique l’emplacement de depart de notre serveur pour l’acces au fichier.

“server_name” va indiquer le nom des servers name par lequel on peut acceder a notre server.

“index” va indiquer la page a ouvrir par default si aucune autre page n’est demande.

Nous maintenant ajouter un bloc `location`  afin d’ajouter une regle d’affichage de la page d’erreur 404 si la requete demande est inconnu

```docker
events {

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
}
```

“/” va determiner le point de depart du chemin a suivre qui sera pour le coup “/var/www/html” le point de depart indiquer dans les configurations du serveur.

“try_files” va d’abord essayer les fichiers static avant de retourner la page `error404`

Nous allons ajouter un autre bloc `location` afin d’acceder a notre site `Wordpress`

```docker
events {

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
}
```

“~ \.php$” Le symbole `~` indique que cette location utilise une expression régulière. Cette ligne signifie que cette configuration s'applique à toutes les requêtes dont l'URL se termine par `.php`

“fastcgi_split_path_info” Cette directive divise le chemin de la requête pour obtenir le script PHP et les informations de chemin. Elle permet à NGINX de gérer les requêtes qui contiennent à la fois un fichier PHP et un chemin d'accès supplémentaire.

“fastcgi_pass” Cela indique à NGINX de passer la requête au serveur FastCGI, qui est ici le conteneur WordPress à l'adresse `wordpress:9000`. Cela permet d'exécuter le script PHP à l'intérieur du conteneur WordPress.

“fastcgi_index” Cette directive définit le fichier par défaut à exécuter lorsque le chemin demandé est un répertoire. Dans ce cas, si quelqu'un accède à `/`, NGINX essaiera d'exécuter `index.php`.

“include” Cela inclut les paramètres FastCGI prédéfinis. Ces paramètres sont nécessaires pour passer des informations au serveur FastCGI (comme le chemin du script à exécuter).

“fastcgi_param” Définit le paramètre `SCRIPT_FILENAME`, qui est le chemin complet vers le script PHP à exécuter. `$document_root` correspond à la racine définie dans le bloc `server`, et `$fastcgi_script_name` correspond au nom du script demandé.

“fastcgi_param” Définit le paramètre `PATH_INFO`, qui contient le chemin supplémentaire après le script PHP. Cela est utile pour les frameworks qui utilisent des routes.

Nous allons pour finir ajouter les directive suivante dans le serveur.

```docker
events {

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
}
```

“access_log” Cette directive configure le fichier de **journal des accès**. Elle enregistre chaque requête traitée par NGINX, y compris l'heure de la requête, l'adresse IP de l'utilisateur, l'URL demandée, le statut de la réponse, etc.

“error_log” Cette directive configure le fichier de **journal des erreurs**. Il enregistre les erreurs générées par NGINX, ce qui est crucial pour le débogage et la maintenance du serveur.
