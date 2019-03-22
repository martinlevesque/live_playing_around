defmodule LivePlayingAroundWeb.CmdLive do
  use Phoenix.LiveView
  alias LivePlayingAroundWeb.CmdView

  def render(assigns) do
    CmdView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    { :ok, assign(socket, cmd: "", result: "", last_cmd: nil, suggestions: nil) }
  end

  defp run_cmd(query) do
    query
      |> String.to_char_list
      |> :os.cmd
  end

  def handle_event("suggest", %{"q" => query}, socket) when byte_size(query) <= 100 do
    cmd_todo = "cat ~/.bash_history | grep \"^#{query}\""
    
    suggestions_s = run_cmd(cmd_todo)
      |> List.to_string
      |> String.split("\n")
      |> Enum.take(-10)
      |> Enum.join("\n")

    {
      :noreply,
      update(socket, :suggestions, fn _ -> suggestions_s end)
    }
  end

  def handle_event("exec_cmd", %{"q" => query}, socket) do
    result = run_cmd(query)

    {
      :noreply,
      socket
        |> update(:result, fn _ -> result end)
        |> update(:cmd, fn _ -> "" end)
        |> update(:last_cmd, fn _ -> query end)
    }
  end

end
