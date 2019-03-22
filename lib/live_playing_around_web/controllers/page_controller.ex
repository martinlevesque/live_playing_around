defmodule LivePlayingAroundWeb.PageController do
  use LivePlayingAroundWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
