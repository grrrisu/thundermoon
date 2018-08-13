defmodule Sim.EventQueue do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> :queue.new() end, opts)
  end

  def clear do
    Agent.update(__MODULE__, fn _queue -> :queue.new() end)
  end

  def is_empty do
    Agent.get(__MODULE__, &:queue.is_empty(&1))
  end

  def add(caller, function) do
    event = %Sim.Event{caller: caller, function: function}
    Agent.update(__MODULE__, &:queue.in(event, &1))
  end

  def add_and_process(caller, function) do
    add(caller, function)
    process()
  end

  def next() do
    res = Agent.get_and_update(__MODULE__, &:queue.out(&1))

    case res do
      {:value, event} -> {:ok, event}
      :empty -> :empty
    end
  end

  def fire_next_event() do
    case next() do
      {:ok, event} -> process_event(event)
      :empty -> :empty
    end
  end

  def process do
    case fire_next_event() do
      {:ok, _result} -> process()
      {:error, _error} -> process()
      :empty -> :ok
    end
  end

  defp process_event(event) do
    send(
      event.caller,
      Task.async(fn -> execute_event_function(event) end)
      |> Task.await()
    )
  end

  defp execute_event_function(event) do
    {:ok, event.function.()}
  rescue
    error -> {:error, error}
  end
end
