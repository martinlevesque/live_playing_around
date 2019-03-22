defmodule LivePlayingAroundWeb.CmdLive do
  use Phoenix.LiveView
  alias LivePlayingAroundWeb.CmdView

  def render(assigns) do
    CmdView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    { :ok, assign(socket, cmd: "", result: "", last_cmd: nil) }
  end

  def handle_event("exec_cmd", %{"q" => query}, socket) do
    result = query
      |> String.to_char_list
      |> :os.cmd

    {
      :noreply,
      socket
        |> update(:result, fn _ -> result end)
        |> update(:cmd, fn _ -> "" end)
        |> update(:last_cmd, fn _ -> query end)
    }
  end

end
