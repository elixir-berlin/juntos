defmodule Juntos.Meetups.Attendee do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "attendees" do
    belongs_to :user, Juntos.Accounts.User
    belongs_to :event, Juntos.Meetups.Event

    timestamps()
  end

  @doc false
  def changeset(attendee, event, user) do
    attendee
    |> cast(%{}, [])
    |> put_assoc(:event, event)
    |> put_assoc(:user, user)
    |> validate_required([:user, :event])
    |> unique_constraint([:user_id, :event_id])
  end
end
