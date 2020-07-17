defmodule Juntos.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:account_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string, null: false
      add :name, :string
      add :email, :string, null: false
      add :avatar_url, :string

      timestamps()
    end

    create unique_index(:account_users, :username)
    create unique_index(:account_users, :email)
  end
end
