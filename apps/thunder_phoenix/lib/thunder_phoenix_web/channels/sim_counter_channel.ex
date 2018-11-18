defmodule ThunderPhoenixWeb.SimCounterChannel do
  use Phoenix.Channel

  require Logger

  def join("sim:counter", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("inc", %{"digit" => digit, "step" => step}, socket) do
    if Enum.member?(["1", "10", "100"], digit) do
      msg = {Counter.Handler, :inc, [digit]}
      Task.start_link(fn -> Sim.process(msg) end)
    end

    {:noreply, socket}
  end

  def handle_in("start", message, socket) do
    Sim.start()
    broadcast!(socket, "started", %{})
    {:noreply, socket}
  end

  def handle_in("stop", message, socket) do
    Sim.stop()
    broadcast!(socket, "stopped", %{})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    join_realm(socket)
    build_counter()
    {:noreply, socket}
  end

  def join_realm(socket) do
    Task.start_link(fn ->
      {:ok, initial_state} = Counter.join()
      push(socket, "joined", %{"answer" => initial_state})
      listen(socket)
    end)
  end

  defp build_counter() do
    Task.start_link(fn -> Counter.build() end)
  end

  defp listen(socket) do
    receive do
      {Counter.Handler, :change, {:ok, result}} ->
        push(socket, "change", %{"answer" => result})

      {_handler, action, {:error, message}} ->
        push(socket, Atom.to_string(action), %{"error" => message})

      other ->
        IO.puts("**** reveived something else ****")
        IO.inspect(other)
    end

    listen(socket)
  end
end
