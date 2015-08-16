defmodule Warner.PreferenceControllerTest do
  use Warner.ConnCase

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "when asked, disables warnings", %{conn: conn} do
    conn = post conn, preference_path(conn, :update), preference: %{disable_all: true}
    assert response(conn, 200)
    assert Plug.Conn.get_session(conn, :disable_all) == true
  end

  test "when asked, enables warnings", %{conn: conn} do
    conn = post conn, preference_path(conn, :update), preference: %{disable_all: false}
    assert response(conn, 200)
    assert Plug.Conn.get_session(conn, :disable_all) == false
  end

  test "when asked, does not enable random rubbish", %{conn: conn} do
    conn = post conn, preference_path(conn, :update), preference: %{evil: true}
    assert response(conn, 200)
    assert Plug.Conn.get_session(conn, :evil) != true
  end
end
