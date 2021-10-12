#!/bin/bash

# entrypoint.sh

# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -d $DATABASE_URL
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

exec make run_dev