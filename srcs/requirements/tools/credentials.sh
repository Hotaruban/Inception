#!/bin/bash

function ask_password() {
	local user=$1
	local file=$2
	local try=0
	local pass1=""
	local pass2=""

	while [[ $try -lt 3 ]]; do
	echo -n "Enter the password for $user: "
	read -s pass1
	echo
	echo -n "Confirm the password for $user: "
	read -s pass2
	echo

	if [[ "$pass1" == "$pass2" ]]; then
		echo "Passwords match."
		# Save the password in the file
		echo "$pass1" > "$file"
		echo "Password saved in $file."
		echo "$user=$pass1" >> ./srcs/.env
		break
	else
		echo "Passwords do not match. Try again."
		((try++))
	fi

	if [[ $try -eq 3 ]]; then
		echo "You have reached the maximum number of attempts."
		exit 1
	fi
	done
}

# Ask for the passwords and save them in the secrets folder
if [ -f ./secrets/mysql-root-password.txt ]; then
	echo "The password for mysql root already exists."
else
	ask_password "MYSQL_ROOT_PASSWORD" "./secrets/mysql-root-password.txt"
fi

if [ -f ./secrets/mysql-user-password.txt ]; then
	echo "The password for mysql user already exists."
else
	ask_password "MYSQL_PASSWORD" "./secrets/mysql-user-password.txt"
fi

if [ -f ./secrets/wordpress-admin-password.txt ]; then
	echo "The password for wordpress admin already exists."
else
	ask_password "WORDPRESS_ADMIN_PASSWORD" "./secrets/wordpress-admin-password.txt"
fi

if [ -f ./secrets/wordpress-user-password.txt ]; then
	echo "The password for wordpress user already exists."
else
	ask_password "WORDPRESS_USER_PASSWORD" "./secrets/wordpress-user-password.txt"
fi

echo "Passwords saved in the secrets folder."

# create ssl certificate and key via openssl

if [ -d ./secrets/ssl ]; then
	echo "SSL certificate and key already exist."
	exit 0
else
	echo "Creating SSL certificate and key...";

	mkdir -p ./secrets/ssl
	chmod 777 ./secrets/ssl


	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ./secrets/ssl/nginx-selfsigned.key \
		-out ./secrets/ssl/nginx-selfsigned.crt \
		-subj "/C=TH/ST=Bangkok/L=Bangkok/O=42BKK/OU=42/CN=jhurpy.42.fr"

	echo "SSL certificate and key created in the secrets folder."
fi
