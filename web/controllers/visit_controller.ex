defmodule Warner.VisitController do
  use Warner.Web, :controller

  alias Warner.Link

  def show(conn, %{"hash" => hash}) do
    link = Repo.get_by!(Link, hash: hash)

    case get_session(conn, :disable_all) do
      true ->
        redirect(conn, external: link.url)
      _ ->
        render(conn, "show.html", link: link)
    end
  end
end
