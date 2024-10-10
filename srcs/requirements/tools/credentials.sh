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
ask_password "mysql root" "./secrets/mysql-root-password.txt"
ask_password "mysql user" "./secrets/mysql-user-password.txt"

ask_password "wordpress admin" "./secrets/wordpress-admin-password.txt"
ask_password "wordpress user" "./secrets/wordpress-user-password.txt"

echo "Passwords saved in the secrets folder."

# create ssl certificate and key via openssl

echo "Creating SSL certificate and key...";

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout ./secrets/ssl/nginx-selfsigned.key \
	-out ./secrets/ssl/nginx-selfsigned.crt \
	-subj "/C=TH/ST=Bangkok/L=Bangkok/O=42BKK/OU=42/CN=jhurpy.42.fr"

echo "SSL certificate and key created in the secrets folder."
