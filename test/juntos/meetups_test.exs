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

  defp create_group(%{user: user}) do
    group = Juntos.MeetupsFixtures.group_fixture(%{creator_id: user.id})
    %{group: group}
  end

  defp create_event(%{group: group}) do
    event = Juntos.MeetupsFixtures.event_fixture(%{group: group})
    %{event: event}
  end

  describe "events" do
    alias Juntos.Meetups.Event

    test "create_event/1 with valid data creates a event" do
      user = Juntos.AccountsFixtures.user_fixture()
      group = Juntos.MeetupsFixtures.group_fixture(%{creator_id: user.id})

      valid_attrs = %{
        ends_at: "2010-04-17T14:00:00Z",
        starts_at: ~N[2010-04-17 14:00:00],
        title: "some title",
        group: group
      }

      assert {:ok, %Event{} = event} = Meetups.create_event(valid_attrs)
      assert event.ends_at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert event.slug_id == 1
      assert event.starts_at == ~N[2010-04-17 14:00:00]
      assert event.title == "some title"
    end

    test "create_event/1 stores slug_id with different values" do
      user = Juntos.AccountsFixtures.user_fixture()
      group = Juntos.MeetupsFixtures.group_fixture(%{creator_id: user.id})

      valid_attrs = %{
        ends_at: "2010-04-17T14:00:00Z",
        starts_at: ~N[2010-04-17 14:00:00],
        title: "some title",
        group: group
      }

      1..10 |> Task.async_stream(fn _ -> assert {:ok, _} = Meetups.create_event(valid_attrs) end)
    end

    test "create_event/1 with invalid data shouldn't increase the group counter" do
      user = Juntos.AccountsFixtures.user_fixture()
      group = Juntos.MeetupsFixtures.group_fixture(%{creator_id: user.id})

      valid_attrs = %{
        title: "some title",
        group: group
      }

      assert {:error, _} = Meetups.create_event(valid_attrs)
      assert Juntos.Repo.reload!(group).event_slug_counter == group.event_slug_counter
    end
  end

  describe "atendees" do
    alias Juntos.Meetups.Attendee

    setup [:create_user, :create_group, :create_event]

    test "attend_event/2 with valid params", %{user: user, event: event} do
      assert {:ok, %Attendee{} = attendee} = Meetups.attend_event(event, user)
      assert attendee.user_id == user.id
      assert attendee.event_id == event.id
    end

    test "attend_event/2 with invalid params" do
      assert {:error, _} = Meetups.attend_event(nil, nil)
    end

    test "attend_event/2 twice", %{user: user, event: event} do
      assert {:ok, %Attendee{} = attendee} = Meetups.attend_event(event, user)
      assert {:error, _} = Meetups.attend_event(event, user)
    end
  end
end
