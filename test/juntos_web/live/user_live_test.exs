defmodule JuntosWeb.UserLiveTest do
  use JuntosWeb.ConnCase

  import Phoenix.LiveViewTest

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


  describe "Registeration" do
    setup [:create_authorization]
    test "saves new user", %{conn: conn, authorization: authorization} do
      {:ok, new_live, _html} = live(conn, Routes.user_registeration_path(conn, :new, %{authorization_id: authorization.id}))

      assert new_live
             |> form("#user-form", user: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        new_live
        |> form("#user-form", user: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.page_path(conn, :index))

      assert html =~ "User created successfully"
    end
  end
end
