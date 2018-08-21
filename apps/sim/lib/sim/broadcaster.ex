defmodule Sim.Broadcaster do
  use GenServer

  # --- client API ---

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  join a realm to get notfied about its events
  """
  def join(realm) do
    GenServer.call(__MODULE__, {:join, realm})
  end

  @doc """
  leave a realm
  """
  def leave(realm) do
    GenServer.call(__MODULE__, {:leave, realm})
  end

  def listeners(realm) do
    GenServer.call(__MODULE__, {:listeners, realm})
  end

  def sessions() do
    GenServer.call(__MODULE__, {:sessions})
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

  def handle_call({:join, realm}, {pid, _ref}, state) do
    new_state = join_session(state, realm, pid)
    {:reply, {:ok, realm}, new_state}
  end

  def handle_call({:leave, realm}, {pid, _ref}, state) do
    new_state = leave_session(state, realm, pid)
    {:reply, {:ok, realm}, new_state}
  end

  def handle_call({:listeners, realm}, _from, state) do
    {:reply, get_listeners(state, realm), state}
  end

  def handle_call({:sessions}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:receive_result, handler, action, result}, state) do
    broadcast(state, handler, action, result)
    {:noreply, state}
  end

  def handle_cast({:clear}, state) do
    {:noreply, delete_sessions(state)}
  end

  # --- server internal ---

  def join_session(sessions, key, listener) do
    {sessions, session} = find_or_create_session(sessions, key)
    Sim.Session.join(session, listener)
    sessions
  end

  def leave_session(sessions, key, listener) do
    case find_session(sessions, key) do
      {:ok, pid} -> Sim.Session.leave(pid, listener)
      {:error, :not_found} -> nil
    end

    sessions
  end

  def get_listeners(sessions, key) do
    case find_session(sessions, key) do
      {:ok, pid} -> {:ok, Sim.Session.listeners(pid)}
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  def find_session(sessions, key) do
    case Map.fetch(sessions, key) do
      {:ok, session} -> {:ok, session.pid}
      :error -> {:error, :not_found}
    end
  end

  def find_or_create_session(sessions, key) do
    case sessions[key] do
      nil ->
        {:ok, pid} = Sim.Session.start_link([])
        ref = Process.monitor(pid)
        {Map.put(sessions, key, %{ref: ref, pid: pid}), pid}

      session ->
        {sessions, session.pid}
    end
  end

  def delete_sessions(sessions) do
    sessions
    |> Map.values()
    |> Enum.map(& &1.pid)
    |> Enum.filter(&Process.alive?(&1))
    |> Enum.each(&Agent.stop(&1))

    %{}
  end

  def broadcast(state, handler, action, result) do
    case result do
      {:ok, res} ->
        handler.outgoing(state, action, {:ok, res})

      {:error, error} ->
        :error
        # Sim.Monitor.track(error)
    end
  end

  def send_message(listeners, message) do
    listeners
    |> Enum.each(&send_to_one(&1, message))
  end

  defp send_to_one(listener, message) do
    Task.start_link(fn -> send(listener, message) end)
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
end
