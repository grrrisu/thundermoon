defmodule Counter.Handler do
  @doc """
  notify everyone about changes
  """
  def outgoing(sessions, :change, result) do
    case Sim.Broadcaster.get_listeners(sessions, __MODULE__) do
      {:error, :not_found} -> IO.puts("******* ERROR")
      {:ok, listeners} -> Sim.Broadcaster.send_message(listeners, {__MODULE__, :change, result})
    end
  end
end
