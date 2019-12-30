FROM elixir:1.9.4

# Install pg client for db setup
RUN apt-get update && \
  apt-get install -y postgresql-client

# Create app directory and copy the Elixir project into it
RUN mkdir /app
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

CMD ["/app/entrypoint-dev.sh"]
