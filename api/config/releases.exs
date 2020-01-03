import Config

database_url = System.get_env("DATABASE_URL")

config :api, JuntoApi.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
