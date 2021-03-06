defmodule Juntos.Meetups do
  @moduledoc """
  The Meetups context.
  """

  import Ecto.Query, warn: false
  alias Juntos.Repo

  alias Juntos.Meetups.{Group, GroupRepo}

  @doc """
  Gets a single group

  ## Example

      iex> get_group_by(slug: "slug")
      %Group{...}
  """
  def get_group_by(opts) do
    GroupRepo.get_by(opts)
  end

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  alias Juntos.Meetups.{Event, EventRepo}

  @doc """
  Creates a event.

  This function also increases the related groups event slug counter in a transaction

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    Repo.transaction(fn ->
      slug_id = GroupRepo.increase_event_slug_counter(attrs.group)
      attrs = Map.put(attrs, :slug_id, slug_id)

      event_ch = Event.changeset(%Event{}, attrs)

      case Repo.insert(event_ch) do
        {:ok, event} -> event
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  @doc """
  Gets a single event

  ## Example

      iex> get_event_by(slug_id: "id", group_id: "....")
      %Event{...}
  """
  def get_event_by(opts) do
    EventRepo.get_by(opts)
  end

  alias Juntos.Meetups.Attendee

  def attend_event(event, user) do
    %Attendee{}
    |> Attendee.changeset(event, user)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Attendee changes.

  ## Examples

      iex> change_attendee()
      %Ecto.Changeset{data: %Attendee{}}

  """
  def change_attendee(%Attendee{} = attendee) do
    Attendee.changeset(attendee, nil, nil)
  end
end
