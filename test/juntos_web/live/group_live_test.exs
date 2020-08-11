defmodule JuntosWeb.GroupLiveTest do
  use JuntosWeb.ConnCase

  import Phoenix.LiveViewTest
  import Juntos.MeetupsFixtures
  import Juntos.AccountsFixtures

  @create_attrs %{name: "some name", slug: "some-slug"}
  @invalid_attrs %{name: nil, slug: nil}

  describe "New" do
    setup :register_and_login_user

    test "saves new group", %{conn: conn, user: user} do
      {:ok, new_live, _html} = live(conn, Routes.group_new_path(conn, :new))

      assert new_live
             |> form("#group-form", group: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        new_live
        |> form("#group-form", group: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, "/")

      assert group = Juntos.Meetups.get_group_by(slug: @create_attrs[:slug])
      assert group.creator_id == user.id
      assert html =~ "Group created successfully"
    end
  end

  describe "Show" do
    test "show group page", %{conn: conn} do
      user = user_fixture()
      group = group_fixture(%{creator_id: user.id})
      {:ok, _, html} = live(conn, Routes.group_show_path(conn, :show, [group.slug]))
      assert html =~ group.name
    end
  end
end
