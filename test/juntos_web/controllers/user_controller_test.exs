defmodule JuntosWeb.UserControllerTest do
  use JuntosWeb.ConnCase

  alias Juntos.Accounts

  @create_attrs %{
    avatar_url: "some avatar_url",
    email: "some@email",
    name: "some name",
    username: "some username"
  }
  @invalid_attrs %{avatar_url: nil, email: nil, name: nil, username: nil}

  defp fixture(:authorization) do
    ueberauth_params = %{
      uid: 1001,
      provider: :github,
      info: %{
        email: "foo@example.com",
        image: "https://avatar.url",
        nickname: "foobar",
        name: "Foo Bar"
      },
      credentials: %{token: "---token---"},
      extra: %{raw_info: %{user: %{}}}
    }

    {:ok, auth} = Accounts.create_authorization(ueberauth_params)
    auth
  end

  defp create_authorization(_) do
    auth = fixture(:authorization)
    %{authorization: auth}
  end

  describe "new user" do
    setup [:create_authorization]

    test "renders sign up form for new user", %{conn: conn, authorization: authorization} do
      conn =
        conn
        |> put_auth_session(authorization)
        |> get(Routes.user_path(conn, :new))

      assert html_response(conn, 200) =~ "value=\"#{authorization.username}"
      assert html_response(conn, 200) =~ "value=\"#{authorization.email}"
      assert html_response(conn, 200) =~ "value=\"#{authorization.name}"
      assert html_response(conn, 200) =~ "value=\"#{authorization.avatar_url}"
    end

    test "renders sign up for a username which is taken", %{
      conn: conn,
      authorization: authorization
    } do
      {:ok, _} =
        Accounts.create_user(%{
          email: "email@example.com",
          avatar_url: "https://avatar.url",
          username: "foobar",
          name: "Foo"
        })

      conn =
        conn
        |> put_auth_session(authorization)
        |> get(Routes.user_path(conn, :new))

      assert html_response(conn, 200) =~ "value=\"#{authorization.username}"
      assert html_response(conn, 200) =~ "has already been taken"
      assert html_response(conn, 200) =~ "value=\"#{authorization.email}"
      assert html_response(conn, 200) =~ "value=\"#{authorization.name}"
      assert html_response(conn, 200) =~ "value=\"#{authorization.avatar_url}"
    end

    test "redirects to /auth/error when authorization session is not set", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert redirected_to(conn) =~ "/auth/error"
    end
  end

  describe "create user" do
    setup [:create_authorization]

    test "redirects to home page when data is valid", %{conn: conn, authorization: authorization} do
      conn =
        conn
        |> put_auth_session(authorization)
        |> post(Routes.user_path(conn, :create), user: @create_attrs)

      assert html_response(conn, 302)

      assert Accounts.UserRepo.get_by(email: @create_attrs[:email])
    end

    test "redirects to /auth/error when authorization session is not set", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{})
      assert redirected_to(conn) =~ "/auth/error"
    end

    test "renders errors when data is invalid", %{conn: conn, authorization: authorization} do
      conn =
        conn
        |> put_auth_session(authorization)
        |> post(Routes.user_path(conn, :create), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "New User"
    end
  end

  defp put_auth_session(conn, authorization) do
    session =
      Plug.Session.init(
        store: :cookie,
        key: "_app",
        encryption_salt: "-------- salty ------",
        signing_salt: "--------- signing salty ------"
      )

    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(session)
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.put_session(:authorization_id, authorization.id)
  end
end
