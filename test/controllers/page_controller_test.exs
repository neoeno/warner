defmodule Warner.PageControllerTest do
  use Warner.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "TwCw"
  end
end
