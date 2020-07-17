defmodule Juntos.Repo.Migrations.CreateAccountAuthorizations do
  use Ecto.Migration

  alias Juntos.Accounts.AuthorizationProviderEnum

  def change do
    AuthorizationProviderEnum.create_type()

    create table(:account_authorizations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :provider, AuthorizationProviderEnum.type(), null: false
      add :uid, :string, null: false
      add :username, :string
      add :name, :string
      add :email, :string
      add :token, :string, null: false
      add :expires_at, :naive_datetime_usec
      add :refresh_token, :string
      add :altenative_emails, {:array, :string}
      add :avatar_url, :string
      timestamps()
    end

    create unique_index(:account_authorizations, [:provider, :uid])
  end
end
