defmodule Juntos.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_users" do
    field :avatar_url, :string
    field :email, :string
    field :name, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :email, :avatar_url])
    |> validate_required([:username, :name, :email])
    |> validate_length(:username, min: 5)
    |> validate_format(:email, ~r/@/)
    |> lazy_unsafe_validate_unique(:username, Juntos.Repo)
    |> lazy_unsafe_validate_unique(:email, Juntos.Repo)
    |> unique_constraint(:email, name: :account_users_email_index)
    |> unique_constraint(:username, name: :account_users_username_index)

  end

  defp lazy_unsafe_validate_unique(changeset, field, repo, opts \\ []) do
    case Enum.find(changeset.errors, &(elem(&1, 0) == field)) do
      nil -> unsafe_validate_unique(changeset, field, repo, opts)
      _ -> changeset
    end
  end
end
