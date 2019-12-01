defmodule JuntoApiWeb.Router do
  use JuntoApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", JuntoApiWeb do
    pipe_through :api
  end
end
