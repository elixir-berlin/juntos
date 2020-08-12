defmodule Juntos.Meetups.EventRepo do
  @moduledoc """
  Collection of queries for `Juntos.Meetups.Event` schema
  """
  import Ecto.Query
  alias Juntos.Meetups.Event
  alias Juntos.Repo

  @doc """
  Gets a single event

  ## Example

      iex> get_by(slug_id: 1993, group_id: "...")
      %Event{...}
  """
  def get_by(opts \\ []) do
    Event
    |> TokenOperator.maybe(opts, :slug_id, &by_slug_id/2)
    |> TokenOperator.maybe(opts, :group_id, &by_group_id/2)
    |> Repo.one()
  end

  defp by_slug_id(query, %{slug_id: slug_id}) do
    from(event in query, where: event.slug_id == ^slug_id)
  end

  defp by_group_id(query, %{group_id: group_id}) do
    from(event in query, where: event.group_id == ^group_id)
  end
end
