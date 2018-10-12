defmodule ThunderPhoenixWeb.SimCounterChannel do
  use Phoenix.Channel

  require Logger

  def join("sim:counter", _message, socket) do
    # send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("inc", %{"digit" => digit, "step" => step}, socket) do
    # FIXME just a shortcut to test websocket and redux
    broadcast!(socket, "update", %{digit: digit, value: 5})
    {:noreply, socket}
  end

  def handle_in("start", message, socket) do
    # FIXME just a shortcut to test websocket and redux
    broadcast!(socket, "started", %{})
    {:noreply, socket}
  end

  def handle_in("stop", message, socket) do
    # FIXME just a shortcut to test websocket and redux
    broadcast!(socket, "stopped", %{})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    join_realm(Counter.Handler, socket)
    {:noreply, socket}
  end

  def join_realm(realm, socket) do
    Task.start_link(fn ->
      Sim.join(realm)
      listen(socket)
    end)
  end

  defp listen(socket) do
    # receive do
    #   {Example.Handler, :reverse, {:ok, result}} ->
    #     push(socket, "reverse", %{"answer" => result})
    #
    #   {_handler, action, {:error, message}} ->
    #     push(socket, Atom.to_string(action), %{"error" => message})
    #
    #   other ->
    #     IO.puts("**** reveived something else ****")
    #     IO.inspect(other)
    # end

    listen(socket)
  end
end
