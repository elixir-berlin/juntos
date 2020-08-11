defmodule JuntosWeb.GroupLive.New do
  @moduledoc """
  Save a new group
  """
  use JuntosWeb, :live_view

  alias Juntos.Meetups
  alias Juntos.Meetups.Group

  @impl true
  def mount(_params, session, socket) do
    user =
      session["user_token"] && Juntos.Accounts.get_user_by_session_token(session["user_token"])

    group = %Group{}
    changeset = Meetups.change_group(group)

    {:ok,
     socket
     |> assign(:page_title, "New Group")
     |> assign(:changeset, changeset)
     |> assign(:current_user, user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group")
    |> assign(:current_user, socket.assigns[:current_user])
    |> assign(:group, %Group{})
  end

  @impl true
  def handle_event("validate", %{"group" => group_params}, socket) do
    changeset =
      socket.assigns.group
      |> Meetups.change_group(group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"group" => group_params}, socket) do
    save_group(socket, :new, group_params)
  end

  defp save_group(socket, :new, group_params) do
    group_params = Map.put(group_params, "creator_id", socket.assigns[:current_user].id)

    case Meetups.create_group(group_params) do
      {:ok, _group} ->
        {:noreply,
         socket
         |> put_flash(:info, "Group created successfully")
         |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
