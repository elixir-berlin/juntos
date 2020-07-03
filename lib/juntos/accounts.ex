defmodule Juntos.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Juntos.Repo
  alias Juntos.Accounts.{AuthorizationRepo, Authorization}

  def get_authorization_by(opts) do
    AuthorizationRepo.get_by(opts)
  end

  @spec create_authorization(%Ueberauth.Auth{}) ::
          {:ok, Authorization} | {:error, Ecto.Changeset.t()}
  def create_authorization(ueberauth) do
    ueberauth
    |> export_authorization_struct()
    |> AuthorizationRepo.create()
  end

  defp export_authorization_struct(%{provider: :github} = ueberauth) do
    altenative_emails =
      (ueberauth.extra.raw_info.user["emails"] || [])
      |> Enum.filter(&(&1["verified"] == true))
      |> Enum.map(& &1["email"])

    %{
      uid: "#{ueberauth.uid}",
      provider: ueberauth.provider,
      email: ueberauth.info.email,
      token: ueberauth.credentials.token,
      expires_at: nil,
      refresh_token: nil,
      altenative_emails: altenative_emails,
      avatar_url: ueberauth.info.image,
      username: ueberauth.info.nickname,
      name: ueberauth.info.name
    }
  end

  alias Juntos.Accounts.User

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
