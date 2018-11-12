defmodule Sim.Event.Queue do
  use GenServer

  # --- client API ---

  @doc """
  start the event queue
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def add(message) do
    GenServer.call(__MODULE__, {:add, message})
  end

  def clear() do
    GenServer.cast(__MODULE__, {:clear})
  end

  # --- server API ---

  def init(_args) do
    # IO.puts("starting Sim.Event.Queue")
    {:ok, %{fire_worker: %{pid: nil, ref: nil}}}
  end

  def handle_call({:add, message}, _from, state) do
    event = Sim.Event.List.add(message)
    {:reply, {:ok, event}, ensure_fire_worker_is_running(state)}
  end

  def handle_cast({:clear}, state) do
    Sim.Event.List.clear()
    {:noreply, state}
  end

  def ensure_fire_worker_is_running(state) do
    case state do
      %{fire_worker: %{pid: nil}} ->
        {:ok, pid} =
          DynamicSupervisor.start_child(
            Sim.FireWorkerSupervisor,
            {Sim.FireWorker, name: Sim.FireWorker}
          )

        ref = Process.monitor(pid)
        %{state | fire_worker: %{pid: pid, ref: ref}}

      %{fire_worker: %{pid: _pid}} ->
        state
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, :normal}, state) do
    new_state =
      case state do
        %{fire_worker: %{ref: ref}} -> %{state | fire_worker: %{pid: nil, ref: nil}}
        _no_match -> state
      end

    {:noreply, new_state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
