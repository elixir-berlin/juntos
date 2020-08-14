defmodule JuntosWeb.EventLiveTest do
  use JuntosWeb.ConnCase

  import Phoenix.LiveViewTest
  import Juntos.AccountsFixtures
  import Juntos.MeetupsFixtures

  defp create_event(_) do
    user = user_fixture()
    group = group_fixture(%{creator_id: user.id})
    event = event_fixture(%{group: group})
    %{event: event, group: group}
  end

  describe "Show" do
    setup [:create_event]

    test "displays event", %{conn: conn, event: event, group: group} do
      {:ok, _show_live, html} =
        live(conn, Routes.event_show_path(conn, :show, group.slug, event.slug_id))

      assert html =~ event.title
    end

    test "attends event", %{conn: conn, event: event, group: group} do
      attendee = user_fixture()

      conn = login_user(conn, attendee)

      {:ok, show_live, _html} =
        live(conn, Routes.event_show_path(conn, :show, group.slug, event.slug_id))

      html =
        show_live
        |> form("#rsvp-form")
        |> render_submit()

      assert html =~ "You are attending"
    end

    test "attemps to attend an already attending event", %{conn: conn, event: event, group: group} do
      attendee = user_fixture()

      Juntos.Meetups.attend_event(event, attendee)

      conn = login_user(conn, attendee)

      {:ok, _show_live, html} =
        live(conn, Routes.event_show_path(conn, :show, group.slug, event.slug_id))

      refute html =~ "rsvp-form"

      assert html =~ "You are attending"
    end
  end
end
