defmodule Juntos.Repo.Migrations.AddEventSlugCounterToGroups do
  use Ecto.Migration

  def change do
    alter table(:meetup_groups) do
      add :event_slug_counter, :integer, default: 0
    end
  end
end
