use Mix.Config

# Configure your database
config :api, JuntoApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, JuntoApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "1",
  client_secret: "123"

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  client_id: "2",
  client_secret: "321"
