defmodule Juntos.Meetups.Event do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :ends_at, :utc_datetime
    field :slug_id, :integer
    field :starts_at, :naive_datetime
    field :title, :string
    belongs_to :group, Juntos.Meetups.Group
    has_many :attendees, Juntos.Meetups.Attendee

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :starts_at, :ends_at, :slug_id])
    |> put_assoc(:group, attrs.group)
    |> validate_required([:title, :starts_at, :ends_at, :slug_id, :group])
  end
end
