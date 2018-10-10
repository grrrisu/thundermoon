defmodule Example.Handler do
  require Logger

  def incoming(:reverse, [text]) do
    String.reverse(text)
  end

  def incoming(:crash, []) do
    raise "oh snap, function crashed!!!"
  end

  @doc """
  notify everyone about any results
  """
  def outgoing(sessions, action, result) do
    case Sim.Broadcaster.get_listeners(sessions, __MODULE__) do
      {:error, :not_found} ->
        Logger.warn("ERROR: no session #{__MODULE__} found!")

      {:ok, listeners} ->
        Sim.Broadcaster.send_message(listeners, {__MODULE__, action, result})
    end
  end
end
