defmodule Juntos.Meetups.GroupRepo do
  @moduledoc """
  Collection of queries for `Juntos.Meetups.Group` schema
  """
  import Ecto.Query
  alias Juntos.Meetups.Group
  alias Juntos.Repo

  @doc """
  Gets list of groups.

  """
  def all(opts \\ []) do
    Group
    |> TokenOperator.maybe(opts, :include, creator: &join_user/1)
    |> Repo.all()
  end

  @doc """
  Gets a single group

  ## Example

      iex> get_by(uid: "uid", provider: :github)
      %Group{...}
  """
  def get_by(opts \\ []) do
    Group
    |> TokenOperator.maybe(opts, :slug, &by_slug/2)
    |> Repo.one()
  end

  def increase_event_slug_counter(group) do
    from(group in Group,
      select: group.event_slug_counter,
      update: [inc: [event_slug_counter: 1]],
      where: [id: ^group.id]
    )
    |> Repo.update_all([])
    |> elem(1)
    |> List.first()
  end

  defp join_user(query) do
    from(group in query, left_join: creator in assoc(group, :creator), preload: [creator: creator])
  end

  defp by_slug(query, %{slug: slug}) do
    from(group in query, where: group.slug == ^slug)
  end
end
