defmodule JuntosWeb.EventLive.Show do
  @moduledoc false
  use JuntosWeb, :live_view

  alias Juntos.Meetups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"group_slug" => group_slug, "slug_id" => slug_id}, _, socket) do
    group = Meetups.get_group_by(slug: group_slug)

    event = Meetups.get_event_by(group_id: group.id, slug_id: slug_id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:event, event)}
  end

  defp page_title(:show), do: "Show Event"
  defp page_title(:edit), do: "Edit Event"
end
