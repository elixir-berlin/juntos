defmodule JuntosWeb.GroupLive.Show do
  use JuntosWeb, :live_view

  alias Juntos.Meetups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"path" => [slug]}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:group, Meetups.get_group_by(slug: slug))}
  end

  defp page_title(:show), do: "Show Group"
end
