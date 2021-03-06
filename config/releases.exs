import Config

database_url = System.fetch_env!("DATABASE_URL")
secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

config :juntos, Juntos.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :juntos, JuntosWeb.Endpoint,
  url: [scheme: "https", host: System.get_env("HOSTNAME"), port: 443],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :juntos, JuntosWeb.Endpoint, server: true

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")
