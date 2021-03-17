defmodule ClusterUserWeb.Router do
  use ClusterUserWeb, :router

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

  scope "/", ClusterUserWeb do
    pipe_through :browser

    get "/:id", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ClusterUserWeb do
  #   pipe_through :api
  # end
end
