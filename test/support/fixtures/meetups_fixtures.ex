defmodule Juntos.MeetupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Juntos.Meetups` context.
  """

  alias Juntos.Meetups

  def unique_slug, do: "slug-#{System.unique_integer()}"

  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "Museter Group",
        slug: unique_slug()
      })
      |> Meetups.create_group()

    group
  end

  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        ends_at: "2010-04-17T14:00:00Z",
        slug_id: 42,
        starts_at: ~N[2010-04-17 14:00:00],
        title: "some title"
      })
      |> Meetups.create_event()

    event
  end
end
