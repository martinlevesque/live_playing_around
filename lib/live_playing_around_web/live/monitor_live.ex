defmodule LivePlayingAroundWeb.MonitorLive do
  use Phoenix.LiveView
  alias LivePlayingAroundWeb.MonitorView

  def render(assigns) do
    MonitorView.render("index.html", assigns)
  end

  defp run_cmd(query) do
    query
      |> String.to_char_list
      |> :os.cmd
  end

  def handle_info(:refresh_results, socket) do
    results =
      socket.assigns.cmds
        |> Enum.map(fn cmd ->
            Task.async(fn ->
              %{
                cmd: cmd,
                result: run_cmd(cmd)
              }
            end)
          end)
        |> Enum.map(&Task.await/1)

    {
      :noreply,
      socket
        |> update(:results, fn _ -> results end)
    }
  end

  def mount(_session, socket) do
    :timer.send_interval(1000, self(), :refresh_results)

    { :ok, assign(socket, cmds: [], results: []) }
  end

  def handle_event("add_cmd", %{"q" => query}, socket) do
    {
      :noreply,
      socket
        |> update(:cmds, fn _ -> socket.assigns.cmds ++ [query] end)
    }
  end

end
