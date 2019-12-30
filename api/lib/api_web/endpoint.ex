defmodule JuntoApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :api

  plug Plug.Static,
    at: "/",
    from: :api,
    gzip: false,
    only: ~w(favicon.ico robots.txt)

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Absinthe.Plug,
    schema: JuntoApiWeb.Schema
end
