# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api,
  namespace: JuntoApi,
  ecto_repos: [JuntoApi.Repo]

# Configures the endpoint
config :api, JuntoApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4ZowRpSdf+oIEjy9fVmHvM0EBTuyexSIXlGzxf/FIa/IFtjbTyOo3tfn54cCZXEN",
  render_errors: [view: JuntoApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: JuntoApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user"]},
    twitter: {Ueberauth.Strategy.Twitter, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  client_id: System.get_env("TWITTER_CONSUMER_KEY"),
  client_secret: System.get_env("TWITTER_CONSUMER_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
