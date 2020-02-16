defmodule JuntoApiWeb.Schema do
  use Absinthe.Schema
  alias Api.AuthProvider

  object :auth_provider do
    field(:auth_type, :auth_type)
    field(:client_id, :string)
    field(:scope, :string)
    field(:auth_url, :string)
  end

  enum :auth_type do
    value(:github, as: :github, description: "Github")
    value(:twitter, as: :twitter, description: "Twitter")
  end

  query do
    @desc "Get a list of all :auth_providers"
    field :auth_providers, list_of(:auth_provider) do
      resolve(fn _parent, _args, _resolution ->
        {:ok, AuthProvider.list(Application.get_env(:ueberauth, Ueberauth))}
      end)
    end
  end
end
