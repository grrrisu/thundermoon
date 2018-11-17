defmodule Counter.Handler do
  def incoming(:inc, [digit]) do
    digit_key = String.to_atom("digit_#{digit}")
    Counter.Realm.inc(digit_key)
  end

  @doc """
  notify everyone about changes
  """
  def outgoing(sessions, :inc, result) do
    case Sim.Broadcaster.get_listeners(sessions, __MODULE__) do
      {:error, :not_found} -> IO.puts("******* ERROR")
      {:ok, listeners} -> Sim.Broadcaster.send_message(listeners, {__MODULE__, :change, result})
    end
  end
end
