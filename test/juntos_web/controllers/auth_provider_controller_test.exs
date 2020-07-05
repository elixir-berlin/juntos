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
  end
end
