defmodule Sim.Simulation.List do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def clear() do
    GenServer.call(__MODULE__, {:clear})
  end

  def size() do
    GenServer.call(__MODULE__, {:size})
  end

  def empty? do
    GenServer.call(__MODULE__, {:empty?})
  end

  def to_list do
    GenServer.call(__MODULE__, {:to_list})
  end

  def objects do
    GenServer.call(__MODULE__, {:objects})
  end

  def add(transducer) do
    GenServer.call(__MODULE__, {:add, transducer})
  end

  def next() do
    GenServer.call(__MODULE__, {:next})
  end

  def remove(object) do
    GenServer.call(__MODULE__, {:remove, object})
  end

  # --- server API ---

  def init(:ok) do
    {:ok, :queue.new()}
  end

  def handle_call({:clear}, _from, _state) do
    {:reply, :ok, :queue.new()}
  end

  def handle_call({:size}, _from, state) do
    {:reply, :queue.len(state), state}
  end

  def handle_call({:empty?}, _from, state) do
    {:reply, :queue.is_empty(state), state}
  end

  def handle_call({:to_list}, _from, state) do
    {:reply, :queue.to_list(state), state}
  end

  def handle_call({:objects}, _from, state) do
    objects = state |> :queue.to_list() |> Enum.map(& &1.object)
    {:reply, objects, state}
  end

  def handle_call({:add, transducer}, _from, state) do
    new_state = :queue.in(decorate(transducer), state)
    {:reply, :ok, new_state}
  end

  def handle_call({:next}, _from, state) do
    {item, queue} = handle_next(state)
    {:reply, item, queue}
  end

  def handle_call({:remove, object}, _from, state) do
    new_queue = handle_remove(state, &(object == &1.object))
    {:reply, :ok, new_queue}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    IO.inspect(ref)
    IO.inspect(state)
    new_queue = handle_remove(state, &(ref == &1.ref))
    {:noreply, new_queue}
  end

  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end

  defp handle_next(queue) do
    case :queue.out(queue) do
      {{:value, item}, new_queue} ->
        {item, :queue.in(item, new_queue)}

      {:empty, queue} ->
        {:empty, queue}
    end
  end

  defp handle_remove(queue, function) do
    queue
    |> :queue.to_list()
    |> Enum.reject(function)
    |> :queue.from_list()
  end

  defp decorate({handler, action, object, function}) do
    ref =
      if is_pid(object) do
        Process.monitor(object)
      end

    %Sim.Simulation.Transducer{
      handler: handler,
      action: action,
      object: object,
      ref: ref,
      function: function
    }
  end
end
