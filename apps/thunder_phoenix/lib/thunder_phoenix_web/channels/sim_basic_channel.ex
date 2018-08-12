defmodule ThunderPhoenixWeb.SimBasicChannel do
  use Phoenix.Channel

  def join("sim:basic", _message, socket) do
    {:ok, socket}
  end

  def handle_in("reverse", %{"text" => text}, socket) do
    msg = {Example.Handler, :reverse, [text]}
    Task.start_link(fn -> send_sim_message(msg, socket) end)
    {:noreply, socket}
  end

  def send_sim_message(msg, socket) do
    Sim.Dispatcher.message(msg)

    receive do
      {Example.Handler, :reverse, {:ok, result}} ->
        push(socket, "reverse", %{"answer" => result})

      {_handler, :reverse, {:error, message}} ->
        push(socket, "reverse", %{"error" => message})
    end
  end
end
