defmodule Juntos.Repo.Migrations.AddUserIdToAuthorization do
  use Ecto.Migration

  def change do
    alter table(:account_authorizations) do
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: true
    end

    create index(:account_authorizations, [:user_id])
  end
end
