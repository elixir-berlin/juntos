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
    |> TokenOperator.maybe(opts, :id, &by_id/2)
    |> TokenOperator.maybe(opts, :include, user: &join_user/1)
    |> Repo.one()
  end

  @doc """
  Assign a user to authorization record.
  """
  def assign_user(authorization, user) do
    authorization
    |> Authorization.assign_user_changeset(user)
    |> Repo.update()
  end

  defp by_uid(query, %{uid: uid}) do
    from(a in query, where: a.uid == ^uid)
  end

  defp by_provider(query, %{provider: provider}) do
    from(a in query, where: a.provider == ^provider)
  end

  defp by_id(query, %{id: id}) do
    from(a in query, where: a.id == ^id)
  end

  defp join_user(query) do
    from(auth in query, left_join: user in assoc(auth, :user), preload: [user: user])
  end
end
