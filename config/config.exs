# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :juntos,
  ecto_repos: [Juntos.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :juntos, JuntosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YayRK14gPg162dniln7N3t9cq/roDTDiyNnfKsp73SIjd7BeEq8H2fhpr/Thsk/E",
  render_errors: [view: JuntosWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Juntos.PubSub,
  live_view: [signing_salt: "/z+FZ3js"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ueberauth providers
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
