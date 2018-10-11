defmodule ThunderPhoenixWeb.Router do
  use ThunderPhoenixWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ThunderPhoenixWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/counter", PageController, :counter)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ThunderPhoenixWeb do
  #   pipe_through :api
  # end
end
