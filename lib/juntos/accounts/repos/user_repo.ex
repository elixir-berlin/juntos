defmodule Juntos.Accounts.UserRepo do
  @moduledoc """
  Collection of queries for `Juntos.Accounts.User` schema
  """
  import Ecto.Query
  alias Juntos.Accounts.User
  alias Juntos.Repo

  @doc """
  Gets a single authorization.

  ## Example

      iex> get_by(uid: "uid", provider: :github)
      %Authorization{...}
  """
  def get_by(opts \\ []) do
    User
    |> TokenOperator.maybe(opts, :email, &by_email/2)
    |> Repo.one()
  end

  defp by_email(query, %{email: email}) do
    from(u in query, where: u.email == ^email)
  end
end
