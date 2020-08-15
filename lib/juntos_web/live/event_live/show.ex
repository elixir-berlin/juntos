defmodule JuntosWeb.EventLive.Show do
  @moduledoc false
  use JuntosWeb, :live_view

  alias Juntos.Meetups

  @impl true
  def mount(_params, session, socket) do
    user =
      session["user_token"] && Juntos.Accounts.get_user_by_session_token(session["user_token"])

    {:ok, assign(socket, :current_user, user)}
  end

  @impl true
  def handle_params(%{"group_slug" => group_slug, "slug_id" => slug_id}, _, socket) do
    group = Meetups.get_group_by(slug: group_slug)

    event = Meetups.get_event_by(group_id: group.id, slug_id: slug_id, include: [:attendees])

    changeset = Meetups.change_attendee(%Meetups.Attendee{})

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:changeset, changeset)
     |> assign(:attending, is_attending?(event, socket.assigns.current_user))
     |> assign(:event, event)}
  end

  @impl true
  def handle_event("attend", _params, socket) do
    case Meetups.attend_event(socket.assigns.event, socket.assigns.current_user) do
      {:ok, _} ->
        {:noreply, assign(socket, :attending, true)}

      _ ->
        {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Event"

  defp is_attending?(event, user) do
    user && Enum.any?(event.attendees, &(&1.user_id == user.id))
  end
end
