#!/bin/bash
set -e

if [ "$1" = 'mysqld' ]; then
	# If the database is empty, initialize it
	if [ ! -d "/var/lib/mysql/mysql" ]; then
		echo "Initializing database..."
		mysql_install_db --user=mysql --datadir=/var/lib/mysql

		# Start MySQL in the background
		/usr/sbin/mysqld --user=mysql &
		pid="$!"

		# Execute the init script
		/docker-entrypoint-initdb.d/database.sh

		# Stop MySQL
		if ! kill -s TERM "$pid" || ! wait "$pid"; then
			echo >&2 'MySQL init process failed.'
			exit 1
		fi
	fi

	# Start MySQL in the foreground
	exec /usr/sbin/mysqld --user=mysql
fi

exec "$@"
