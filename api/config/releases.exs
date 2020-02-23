import Config

database_url = System.get_env("DATABASE_URL")

config :api, JuntoApi.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  client_id: System.get_env("TWITTER_CONSUMER_KEY"),
  client_secret: System.get_env("TWITTER_CONSUMER_SECRET")
