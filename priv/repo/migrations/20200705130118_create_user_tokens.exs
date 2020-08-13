defmodule Juntos.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:account_user_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      timestamps(updated_at: false)
    end

    create index(:account_user_tokens, [:user_id])
    create unique_index(:account_user_tokens, [:context, :token])
  end
end
