defmodule LivePlayingAroundWeb.Router do
  use LivePlayingAroundWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :put_layout, {LivePlayingAroundWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LivePlayingAroundWeb do
    pipe_through :browser

    #get "/", PageController, :index

    live("/", CounterLive)
    live("/cmd", CmdLive)
    live("/monitor", MonitorLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivePlayingAroundWeb do
  #   pipe_through :api
  # end
end
