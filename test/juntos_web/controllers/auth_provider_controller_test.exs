defmodule JuntosWeb.AuthProviderControllerTest do
  use JuntosWeb.ConnCase
  alias Juntos.Accounts

  describe "callback" do
    test "redirects to new user page when it's a new authorization record", %{conn: conn} do
      ueberauth_auth = %{
        uid: 1000,
        provider: :github,
        info: %{
          email: "foo@example.com",
          image: "https://avatar.url",
          nickname: "foobar",
          name: "Foo Bar"
        },
        credentials: %{token: "---token---"},
        extra: %{raw_info: %{user: %{"emails" => []}}}
      }

      conn =
        conn
        |> init_test_session(foo: "bar")
        |> JuntosWeb.AuthProviderController.internal_callback(ueberauth_auth)

      recorded_id = Plug.Conn.get_session(conn, :authorization_id)
      assert Accounts.get_authorization_by(uid: "1000", provider: :github).id == recorded_id
      assert redirected_to(conn) =~ "/users/new"
    end

    test "redirects to new user page if authorization record is not assigned to any user", %{
      conn: conn
    } do
      ueberauth_auth = %{
        uid: 1000,
        provider: :github,
        info: %{
          email: "foo@example.com",
          image: "https://avatar.url",
          nickname: "foobar",
          name: "Foo Bar"
        },
        credentials: %{token: "---token---"},
        extra: %{raw_info: %{user: %{"emails" => []}}}
      }

      _ = Accounts.create_authorization(ueberauth_auth)

      conn =
        conn
        |> init_test_session(foo: "bar")
        |> JuntosWeb.AuthProviderController.internal_callback(ueberauth_auth)

      recorded_id = Plug.Conn.get_session(conn, :authorization_id)
      assert Accounts.get_authorization_by(uid: "1000", provider: :github).id == recorded_id
      assert redirected_to(conn) =~ "/users/new"
    end

    test "redirects to main page when user exists", %{
      conn: conn
    } do
      ueberauth_auth = %{
        uid: 1000,
        provider: :github,
        info: %{
          email: "foo@example.com",
          image: "https://avatar.url",
          nickname: "foobar",
          name: "Foo Bar"
        },
        credentials: %{token: "---token---"},
        extra: %{raw_info: %{user: %{"emails" => []}}}
      }

      {:ok, user} = Accounts.create_user(%{name: "foo", email: "bar@me.com", username: "foobar"})
      {:ok, authorization} = Accounts.create_authorization(ueberauth_auth)

      Accounts.assign_authorization_to_user(authorization, user)

      conn =
        conn
        |> init_test_session(foo: "bar")
        |> JuntosWeb.AuthProviderController.internal_callback(ueberauth_auth)

      assert redirected_to(conn) =~ "/"
      assert token = get_session(conn, :user_token)
      assert get_session(conn, :live_socket_id) == "users_sessions:#{Base.url_encode64(token)}"
      assert Accounts.get_user_by_session_token(token)
    end
  end
end
