defmodule Warner.LinkController do
  use Warner.Web, :controller

  alias Warner.Link

  plug :scrub_params, "link" when action in [:create, :update]

  def index(conn, _params) do
    links = Repo.all(Link)
    render(conn, "index.html", links: links)
  end

  def new(conn, _params) do
    changeset = Link.changeset(%Link{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"link" => %{"url" => url, "warnings_string" => warnings_string}}) do
    warnings = warnings_string |> String.split(",", trim: true)
    changeset = Link.changeset(%Link{},
                               %{"url" => url, "hash" => Link.generate_hash(url), "warnings" => warnings})

    case Repo.insert(changeset) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: link_path(conn, :show, link))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"link" => link_params}) do
    changeset = Link.changeset(%Link{}, link_params)
    Repo.insert(changeset)
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)
    render(conn, "show.html", link: link)
  end

  def visit(conn, %{"hash" => hash}) do
    link = Repo.get_by!(Link, hash: hash)
    conn
    |> redirect(external: link.url)
  end

  def edit(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)
    changeset = Link.changeset(link)
    render(conn, "edit.html", link: link, changeset: changeset)
  end

  def update(conn, %{"id" => id, "link" => %{"url" => url, "warnings_string" => warnings_string}}) do
    warnings = warnings_string |> String.split(",", trim: true)
    link = Repo.get!(Link, id)
    changeset = Link.changeset(link, %{"url" => url, "hash" => Link.generate_hash(url), "warnings" => warnings})

    case Repo.update(changeset) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link updated successfully.")
        |> redirect(to: link_path(conn, :show, link))
      {:error, changeset} ->
        render(conn, "edit.html", link: link, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Repo.get!(Link, id)
    changeset = Link.changeset(link, link_params)
    Repo.update(changeset)

    render(conn, "edit.html", link: link, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: link_path(conn, :index))
  end
end
