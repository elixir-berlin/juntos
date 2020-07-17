defmodule JuntosWeb.PageControllerTest do
  use JuntosWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "to Phoenix!"
  end
end
