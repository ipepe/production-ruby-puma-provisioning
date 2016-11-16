#!/bin/bash
set -e

if [ "$1" = 'postgres' ]; then
	chown -R postgres "$PGDATA"

	# przy pierwszym starcie inicjujemy baze,
	# dodajemy obsluge HSTORE
	# i tworzymy uzytkownika dla aplikacji WWW
	if [ -z "$(ls -A "$PGDATA")" ]; then
		gosu postgres initdb

		gosu postgres postgres --single template1 -E <<-EOSQL
			CREATE EXTENSION hstore
		EOSQL
		gosu postgres postgres --single -E <<-EOSQL
			CREATE USER webapp WITH PASSWORD 'Password1'
		EOSQL
		gosu postgres postgres --single -E <<-EOSQL
			ALTER USER webapp CREATEDB
		EOSQL

		sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

		{ echo; echo 'host all all 0.0.0.0/0 trust'; } >> "$PGDATA"/pg_hba.conf

		if [ -d /docker-entrypoint-initdb.d ]; then
			for f in /docker-entrypoint-initdb.d/*.sh; do
				[ -f "$f" ] && . "$f"
			done
		fi
	fi

	exec gosu postgres "$@"
fi

exec "$@"