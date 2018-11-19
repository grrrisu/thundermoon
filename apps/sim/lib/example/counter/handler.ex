defmodule Counter.Handler do
  def incoming(:inc, [digit, step]) do
    Counter.Realm.inc(digit, step)
  end

  def join(_listener) do
    if Sim.built?() do
      Counter.Realm.current_state()
    else
      %{}
    end
  end

  @doc """
  notify everyone about changes
  """
  def outgoing(sessions, _action, result) do
    case Sim.Broadcaster.get_listeners(sessions, __MODULE__) do
      {:error, :not_found} -> IO.puts("******* ERROR")
      {:ok, listeners} -> Sim.Broadcaster.send_message(listeners, {__MODULE__, :change, result})
    end
  end
end
