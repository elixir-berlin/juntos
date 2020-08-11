defmodule Juntos.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Juntos.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def unique_username, do: "username#{System.unique_integer()}"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        username: unique_username(),
        name: "Muster"
      })
      |> Juntos.Accounts.create_user()

    user
  end
end
