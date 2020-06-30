defmodule Juntos.Accounts.AuthorizationRepo do
  @moduledoc """
  Collection of queries for `Juntos.Accounts.Authorization` schema
  """
  import Ecto.Query
  alias Juntos.Accounts.Authorization
  alias Juntos.Repo

  @doc """
  Creates an authorization
  """
  def create(params) do
    %Authorization{}
    |> Authorization.changeset(params)
    |> Juntos.Repo.insert()
  end

  @doc """
  Gets a single authorization.

  ## Example

      iex> get_by(uid: "uid", provider: :github)
      %Authorization{...}
  """
  def get_by(opts \\ []) do
    Authorization
    |> TokenOperator.maybe(opts, :uid, &by_uid/2)
    |> TokenOperator.maybe(opts, :provider, &by_provider/2)
    |> Repo.one()
  end

  defp by_uid(query, %{uid: uid}) do
    from(a in query, where: a.uid == ^uid)
  end

  defp by_provider(query, %{provider: provider}) do
    from(a in query, where: a.provider == ^provider)
  end
end
