defmodule Juntos.Accounts do
  @moduledoc """
  The Accounts context.
  """
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
end
