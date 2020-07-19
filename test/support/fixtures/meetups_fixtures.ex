defmodule Juntos.MeetupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Juntos.Meetups` context.
  """

  def unique_slug, do: "slug-#{System.unique_integer()}"

  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "Museter Group",
        slug: unique_slug()
      })
      |> Juntos.Meetups.create_group()

    group
  end
end
