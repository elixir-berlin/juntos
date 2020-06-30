defmodule JuntosWeb.AuthProviderController do
  use JuntosWeb, :controller
  plug Ueberauth

  alias Juntos.Accounts

  def callback(%{assigns: %{ueberauth_auth: ueberauth_auth}} = conn, _params) do
    internal_callback(conn, ueberauth_auth)
  end

  def internal_callback(conn, ueberauth_auth) do
    case Accounts.create_authorization(ueberauth_auth) do
      {:ok, authorization} ->
        conn
        |> put_session(:authorization_id, authorization.id)
        |> redirect(to: "/users/new")

      {:error, _changeset} ->
        throw(:what_to_do_next?)
    end
  end
end
