#!/bin/bash

# Maximum number of attempts before giving up
MAX_ATTEMPTS=12
attempt=0

# Verify if WordPress is ready
until $(curl --output /dev/null --silent --head --fail http://wordpress); do
	attempt=$((attempt+1))
	if [ $attempt -ge $MAX_ATTEMPTS ]; then
		echo "WordPress did not become ready in time, exiting..."
		exit 1
	fi
	echo "Waiting for WordPress to be ready..."
	sleep 5
done

echo "WordPress is ready!"

# Lancer Nginx
exec nginx -g "daemon off;"
