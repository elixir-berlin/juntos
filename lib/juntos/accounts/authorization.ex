defmodule Juntos.Accounts.Authorization do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Juntos.Accounts.{AuthorizationProviderEnum, User}

  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_authorizations" do
    field :provider, AuthorizationProviderEnum
    field :uid, :string
    field :altenative_emails, {:array, :string}
    field :avatar_url, :string
    field :name, :string
    field :email, :string
    field :username, :string
    field :expires_at, :naive_datetime_usec
    field :refresh_token, :string
    field :token, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(authorization, attrs) do
    authorization
    |> cast(attrs, [
      :uid,
      :provider,
      :email,
      :token,
      :expires_at,
      :refresh_token,
      :altenative_emails,
      :avatar_url,
      :username,
      :name
    ])
    |> validate_required([:uid, :provider, :token])
    |> unique_constraint(:provider_uid, name: :account_authorizations_provider_uid_index)
  end

  @doc false
  def assign_user_changeset(%Authorization{} = authorization, %User{} = user) do
    authorization
    |> cast(%{user_id: user.id}, [:user_id])
    |> validate_required(:user_id)
  end
end
