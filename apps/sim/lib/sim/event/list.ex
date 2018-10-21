defmodule Sim.Event.List do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> :queue.new() end, opts)
  end

  def clear() do
    Agent.update(__MODULE__, fn _state -> :queue.new() end)
  end

  def empty? do
    Agent.get(__MODULE__, &:queue.is_empty(&1))
  end

  def add(message) do
    Agent.get_and_update(__MODULE__, fn queue ->
      event = to_event(message)
      {event, :queue.in(event, queue)}
    end)
  end

  def to_event({handler, action, function}) do
    %Sim.Event{handler: handler, action: action, function: function}
  end

  def next() do
    Agent.get_and_update(__MODULE__, fn queue ->
      case :queue.out(queue) do
        {{:value, item}, new_queue} -> {{:ok, item}, new_queue}
        {:empty, queue} -> {:empty, queue}
      end
    end)
  end
end
