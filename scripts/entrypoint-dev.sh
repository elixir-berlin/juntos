#!/bin/bash -x
# Docker entrypoint script.

# Get the dependencies
su juntos -c "mix deps.get"
su juntos -c "cd assets && npm i"

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  su juntos -c "mix ecto.migrate"
  su juntos -c "mix run priv/repo/seeds.exs"
  echo "Database $PGDATABASE created."
fi

su juntos -c"mix phx.server"
