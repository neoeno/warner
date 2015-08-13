defmodule Warner.Router do
  use Warner.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Warner do
    pipe_through :browser # Use the default browser stack

    get "/", LinkController, :new
    resources "/links", LinkController
    get "/v/:hash", LinkController, :visit
  end

  # Other scopes may use custom stacks.
  # scope "/api", Warner do
  #   pipe_through :api
  # end
end
