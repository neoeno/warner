defmodule Warner.VisitControllerTest do
  use Warner.ConnCase

  alias Warner.Link
  @valid_link %Link{hash: "hash", url: "http://cat.com/", warnings: ["cats"]}

  setup do
    conn = conn()
    link = Repo.insert! @valid_link
    {:ok, conn: conn, link: link}
  end

  test "redirects to the right link", %{link: link, conn: conn} do
    conn = get conn, "/v/#{link.hash}"
    assert html_response(conn, 200) =~ List.first(link.warnings)
    assert html_response(conn, 200) =~ link.url
  end

  test "when warnings are disabled, redirects to the right link", %{link: link, conn: conn} do
    conn = conn
    |> set_preference(%{disable_all: true})
    |> get "/v/#{link.hash}"
    assert redirected_to(conn) == link.url
  end

  defp set_preference(conn, preferences) do
    post conn, preference_path(conn, :update), preference: preferences
  end
end
