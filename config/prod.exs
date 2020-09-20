use Mix.Config

config :juntos, JuntosWeb.Endpoint,
  url: [host: System.get_env("HOSTNAME") || "localhost", port: 80],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info
