defmodule JuntosWeb.UserLive.Registeration do
  use JuntosWeb, :live_view

  alias Juntos.Accounts.User
  alias Juntos.Accounts

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :authorizaion, get_authorization(params["authorization_id"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
    |> assign(:authorizaion, socket.assigns.authorizaion)
  end

  defp get_authorization(authorization_id) when not is_nil(authorization_id) do
    Accounts.get_authorization_by(id: authorization_id)
  end
end
