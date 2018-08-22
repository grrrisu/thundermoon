defmodule ThunderPhoenixWeb.SimBasicChannel do
  use Phoenix.Channel

  def join("sim:basic", _message, socket) do
    join_realm(Example.Handler)
    {:ok, socket}
  end

  def handle_in("reverse", %{"text" => text}, socket) do
    handle_in_msg(socket, {Example.Handler, :reverse, [text]})
  end

  def handle_in("crash", %{}, socket) do
    handle_in_msg(socket, {Example.Handler, :crash, []})
  end

  defp handle_in_msg(socket, msg) do
    Task.start_link(fn -> Sim.process(msg) end)
    {:noreply, socket}
  end

  def join_realm(realm) do
    Task.start_link(fn ->
      Sim.join(realm)
      listen()
    end)
  end

  defp listen do
    receive do
      {Example.Handler, :reverse, {:ok, result}} ->
        push(socket, "reverse", %{"answer" => result})

      {_handler, action, {:error, message}} ->
        push(socket, Atom.to_string(action), %{"error" => message})
    end

    listen()
  end
end
