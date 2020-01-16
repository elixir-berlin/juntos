defmodule JuntoApiWeb.Schema do
  use Absinthe.Schema

  object :auth_provider do
    field(:auth_type, :string)
    field(:client_id, :string)
    field(:scope, :string)
    field(:auth_url, :string)
  end

  query do
    @desc "Get a list of all :auth_providers"
    field :auth_providers, list_of(:auth_provider) do
      resolve(fn _parent, _args, _resolution ->
        {:ok, []}
      end)
    end
  end
end
