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

      iex> get_by(slug: "slug")
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
end
