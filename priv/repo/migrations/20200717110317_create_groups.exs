defmodule Juntos.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:meetup_groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :slug, :citext, null: false

      add :creator_id, references(:account_users, on_delete: :nothing, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:meetup_groups, [:creator_id])
    create unique_index(:meetup_groups, [:slug])
  end
end
