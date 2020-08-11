defmodule Juntos.MeetupsTest do
  use Juntos.DataCase

  alias Juntos.Meetups
  import Juntos.AccountsFixtures
  import Juntos.MeetupsFixtures

  describe "groups" do
    alias Juntos.Meetups.Group

    @valid_attrs %{name: "some name", slug: "some-slug", creator_id: "xxxx"}
    @invalid_attrs %{name: nil, slug: nil}

    setup [:create_user]

    test "list_groups/0 returns all groups", %{user: user} do
      group = group_fixture(%{creator_id: user.id})
      assert Meetups.list_groups() == [group]
    end

    test "create_group/1 with valid data creates a group", %{user: user} do
      assert {:ok, %Group{} = group} =
               Meetups.create_group(Map.put(@valid_attrs, :creator_id, user.id))

      assert group.name == "some name"
      assert group.slug == "some-slug"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meetups.create_group(@invalid_attrs)
    end

    test "create_group/1 with invalid short slug returns error changeset" do
      assert {:error, changeset} = Meetups.create_group(Map.put(@valid_attrs, :slug, "sh"))
      assert errors_on(changeset) == %{slug: ["should be at least 5 character(s)"]}
    end

    test "create_group/1 with invalid slug returns error changeset" do
      assert {:error, changeset} =
               Meetups.create_group(Map.put(@valid_attrs, :slug, "slug with spaces"))

      assert errors_on(changeset) == %{slug: ["has invalid format"]}
    end

    test "change_group/1 returns a group changeset", %{user: user} do
      group = group_fixture(%{creator_id: user.id})
      assert %Ecto.Changeset{} = Meetups.change_group(group)
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
