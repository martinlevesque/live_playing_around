defmodule LivePlayingAroundWeb.CounterLive do
  use Phoenix.LiveView
  alias LivePlayingAroundWeb.CounterView

  def render(assigns) do
    CounterView.render("index.html", assigns)
  end

  # called from the controller
  def mount(_session, socket) do
    { :ok, assign(socket, :val, 0) }
  end

  def handle_event("inc", _, socket) do
    { :noreply, update(socket, :val, &(&1 + 1)) }
  end

  def handle_event("dec", _, socket) do
    { :noreply, update(socket, :val, &(&1 - 1)) }
  end
end
