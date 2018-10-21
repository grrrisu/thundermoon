defmodule Sim.Simulation.List do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> :queue.new() end, opts)
  end

  def clear() do
    Agent.update(__MODULE__, fn _state -> :queue.new() end)
  end

  def size() do
    Agent.get(__MODULE__, &:queue.len(&1))
  end

  def is_empty() do
    Agent.get(__MODULE__, &:queue.is_empty(&1))
  end

  def to_list() do
    Agent.get(__MODULE__, &:queue.to_list(&1))
  end

  def objects() do
    Agent.get(__MODULE__, fn queue ->
      queue |> :queue.to_list() |> Enum.map(& &1.object)
    end)
  end

  def add(object) do
    Agent.update(__MODULE__, &:queue.in(decorate(object), &1))
  end

  def next() do
    Agent.get_and_update(__MODULE__, fn queue ->
      case :queue.out(queue) do
        {{:value, item}, new_queue} ->
          {item, :queue.in(item, new_queue)}

        {:empty, queue} ->
          {:empty, queue}
      end
    end)
  end

  def remove(object) do
    Agent.update(__MODULE__, fn queue ->
      queue
      |> :queue.to_list()
      |> Enum.reject(&(object == &1.object))
      |> :queue.from_list()
    end)
  end

  defp decorate({handler, action, object, function}) do
    %Sim.Simulation.Transducer{
      handler: handler,
      action: action,
      object: object,
      function: function
    }
  end
end
