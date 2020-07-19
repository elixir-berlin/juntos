defmodule Juntos.Meetups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "meetup_groups" do
    field :name, :string
    field :slug, :string
    belongs_to :creator, Juntos.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :slug, :creator_id])
    |> validate_required([:name, :slug, :creator_id])
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/)
    |> validate_length(:slug, min: 5)
    |> unique_constraint(:slug, name: :meetup_groups_slug_index)
    |> unsafe_validate_unique(:slug, Juntos.Repo)
  end
end
