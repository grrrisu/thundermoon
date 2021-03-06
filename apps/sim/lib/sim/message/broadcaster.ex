defmodule Sim.Broadcaster do
  use GenServer

  require Logger

  # --- client API ---

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  join a handler to get notfied about its events
  """
  def join(handler) do
    GenServer.call(__MODULE__, {:join, handler})
  end

  @doc """
  leave a handler
  """
  def leave(handler) do
    GenServer.call(__MODULE__, {:leave, handler})
  end

  def listeners(handler) do
    GenServer.call(__MODULE__, {:listeners, handler})
  end

  def channels() do
    GenServer.call(__MODULE__, {:channels})
  end

  def clear() do
    GenServer.cast(__MODULE__, {:clear})
  end

  def receive_result(handler, action, result) do
    GenServer.cast(__MODULE__, {:receive_result, handler, action, result})
  end

  # --- server API ---

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:join, handler}, {pid, _ref}, state) do
    new_state = join_channel(state, handler, pid)
    {:reply, {:ok, handler.join(pid)}, new_state}
  end

  def handle_call({:leave, handler}, {pid, _ref}, state) do
    new_state = leave_channel(state, handler, pid)
    {:reply, {:ok, handler}, new_state}
  end

  def handle_call({:listeners, handler}, _from, state) do
    {:reply, get_listeners(state, handler), state}
  end

  def handle_call({:channels}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:receive_result, handler, action, result}, state) do
    Logger.debug("Sim.Broadcaster: receiving result #{elem(result, 0)} for #{handler} #{action}")
    broadcast(state, handler, action, result)
    {:noreply, state}
  end

  def handle_cast({:clear}, state) do
    {:noreply, delete_channels(state)}
  end

  def handle_info({:DOWN, ref, :process, _pid, :normal}, state) do
    case Enum.find(state, &(elem(&1, 1).ref == ref)) do
      nil -> {:noreply, state}
      {key, _listener} -> {:noreply, Map.delete(state, key)}
    end
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # --- server internal ---

  def join_channel(channels, key, listener) do
    {channels, channel} = find_or_create_channel(channels, key)
    Sim.Channel.join(channel, listener)
    channels
  end

  def leave_channel(channels, key, listener) do
    case find_channel(channels, key) do
      {:ok, pid} -> Sim.Channel.leave(pid, listener)
      {:error, :not_found} -> nil
    end

    channels
  end

  def get_listeners(channels, key) do
    case find_channel(channels, key) do
      {:ok, pid} -> {:ok, Sim.Channel.listeners(pid)}
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  def find_channel(channels, key) do
    case Map.fetch(channels, key) do
      {:ok, channel} -> {:ok, channel.pid}
      :error -> {:error, :not_found}
    end
  end

  def find_or_create_channel(channels, key) do
    case channels[key] do
      nil ->
        {:ok, pid} = DynamicSupervisor.start_child(Sim.ChannelSupervisor, Sim.Channel)
        ref = Process.monitor(pid)
        new_channels = Map.put(channels, key, %{ref: ref, pid: pid})
        {new_channels, pid}

      channel ->
        {channels, channel.pid}
    end
  end

  def delete_channels(channels) do
    channels
    |> Map.values()
    |> Enum.map(& &1.pid)
    |> Enum.filter(&Process.alive?(&1))
    |> Enum.each(&Agent.stop(&1))

    %{}
  end

  def broadcast(state, handler, action, {:ok, result}) do
    handler.outgoing(state, action, {:ok, result})
  end

  def broadcast(_state, _handler, _action, {:error, error}) do
    Sim.Monitor.track(error)
  end

  def send_message(listeners, message) do
    listeners
    |> Enum.each(&send_to_one(&1, message))
  end

  defp send_to_one(listener, message) do
    Task.start_link(fn -> send(listener, message) end)
  end
end
