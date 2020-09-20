defmodule Juntos.Repo.Migrations.CreateAttendees do
  use Ecto.Migration

  def change do
    create table(:attendees, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :event_id, references(:events, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create index(:attendees, [:user_id])
    create index(:attendees, [:event_id])
    create unique_index(:attendees, [:user_id, :event_id])
  end
end
