#!/bin/bash

echo "Start: $(date)"
echo "Revoking connections..."
docker exec postgis psql -U postgres -d template1 -w -c 'REVOKE CONNECT ON DATABASE postgres FROM public;'
echo "Terminating backends..."
docker exec postgis psql -U postgres -d template1 -w -c "SELECT pid, pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'postgres' AND pid <> pg_backend_pid();"
echo "Dropping postgis extension..."
docker exec postgis psql -U postgres -d template1 -w -c 'DROP EXTENSION postgis;'
echo "Dropping hstore extension..."
docker exec postgis psql -U postgres -d template1 -w -c 'DROP EXTENSION hstore;'
echo "Dropping postgres database..."
docker exec postgis dropdb -U postgres  postgres
echo "Creating postgis extension..."
docker exec postgis psql -U postgres -d template1 -w -c 'CREATE EXTENSION postgis;'
echo "Creating hstore extennsion..."
docker exec postgis psql -U postgres -d template1 -w -c 'CREATE EXTENSION hstore;'
echo "Creating postgres database..."
docker exec postgis createdb -U postgres postgres --encoding UNICODE --template=template1
echo "Setting message level..."
docker exec postgis psql -U postgres -d postgres -w -c 'SET client_min_messages TO WARNING;'
echo "Loading database. It is normal to see an error that the postgres role already exists..."
docker exec postgis psql -U postgres -d postgres -q -f /var/scratch/pg.deploy.sql
echo "End: $(date)"
