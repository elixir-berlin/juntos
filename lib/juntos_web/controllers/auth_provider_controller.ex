defmodule JuntosWeb.AuthProviderController do
  use JuntosWeb, :controller
  plug Ueberauth

  alias Juntos.Accounts

  def store_redirect_to(conn, _params) do
    conn
    |> put_session(:user_return_to, conn.params["user_return_to"])
    |> redirect(to: Routes.auth_provider_path(conn, :request, conn.params["provider"]))
  end

  def callback(%{assigns: %{ueberauth_auth: ueberauth_auth}} = conn, _params) do
    internal_callback(conn, ueberauth_auth)
  end

  def internal_callback(conn, ueberauth_auth) do
    case Accounts.create_authorization(ueberauth_auth) do
      {:ok, authorization} ->
        redirect_new_user(conn, authorization)

      {:error,
       %{
         errors: [
           provider_uid:
             {_,
              [constraint: :unique, constraint_name: "account_authorizations_provider_uid_index"]}
         ]
       } = changeset} ->
        authorization =
          Accounts.get_authorization_by(
            uid: changeset.data.uid,
            provider: changeset.data.provider,
            include: :user
          )

        if authorization.user_id do
          JuntosWeb.UserAuth.login_user(conn, authorization.user)
        else
          redirect_new_user(conn, authorization)
        end

      {:error, _changeset} ->
        throw(:some_data_are_missing)
    end
  end

  defp redirect_new_user(conn, authorization) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> put_session(:authorization_id, authorization.id)
    |> redirect(to: "/users/new")
  end
end
