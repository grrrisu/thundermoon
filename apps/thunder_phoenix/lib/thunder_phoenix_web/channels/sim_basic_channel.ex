defmodule ThunderPhoenixWeb.SimBasicChannel do
  use Phoenix.Channel

  def join("sim:basic", _message, socket) do
    {:ok, socket}
  end

  def handle_in("reverse", %{"text" => text}, socket) do
    msg = {Example.Handler, :reverse, [text]}
    Sim.Dispatcher.message(msg)

    receive do
      {Example.Handler, :reverse, {:ok, result}} ->
        broadcast!(socket, "reverse", %{"answer" => result})

      {Example.Handler, :reverse, {:error, message}} ->
        broadcast!(socket, "reverse", %{"error" => message})
    end

    {:noreply, socket}
  end
end
