defmodule Juntos.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :starts_at, :naive_datetime
      add :ends_at, :utc_datetime
      add :slug_id, :integer
      add :group_id, references(:meetup_groups, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:events, [:group_id])
    create unique_index(:events, [:slug_id, :group_id])
  end
end
