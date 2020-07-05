defmodule JuntosWeb.UserController do
  use JuntosWeb, :controller

  alias Juntos.Accounts
  alias Juntos.Accounts.User

  plug :fetch_authorization

  def new(conn, _params) do
    changeset =
      Accounts.change_user(%User{}, %{
        name: conn.assigns.authorization.name,
        email: conn.assigns.authorization.email,
        avatar_url: conn.assigns.authorization.avatar_url,
        username: conn.assigns.authorization.username
      })
      |> Map.put(:action, :validate)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Accounts.assign_authorization_to_user(conn.assigns.authorization, user)

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp get_authorization(authorization_id) when not is_nil(authorization_id) do
    Accounts.get_authorization_by(id: authorization_id)
  end

  defp fetch_authorization(conn, _opt) do
    with auth_id when not is_nil(auth_id) <- get_session(conn, :authorization_id),
         authorization when not is_nil(authorization) <- get_authorization(auth_id),
         {:is_used, nil} <- {:is_used, authorization.user_id} do
      assign(conn, :authorization, authorization)
    else
      {:is_used, _} ->
        conn
        |> redirect(to: "/auth/error?error=authorization_already_used")
        |> halt

      _ ->
        conn
        |> redirect(to: "/auth/error")
        |> halt
    end
  end
end
