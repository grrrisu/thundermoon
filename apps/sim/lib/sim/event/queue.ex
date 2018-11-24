defmodule Sim.Event.Queue do
  use GenServer

  require Logger

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
    Logger.debug("starting Sim.Event.Queue...")
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

  def ensure_fire_worker_is_running(%{fire_worker: %{pid: nil}} = state) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        Sim.FireWorkerSupervisor,
        {Sim.FireWorker, name: Sim.FireWorker}
      )

    ref = Process.monitor(pid)
    %{state | fire_worker: %{pid: pid, ref: ref}}
  end

  def ensure_fire_worker_is_running(%{fire_worker: %{pid: _pid}} = state) do
    state
  end

  def handle_info({:DOWN, ref, :process, _pid, :normal}, state) do
    remove_fire_worker(ref, state)
    {:noreply, remove_fire_worker(ref, state)}
  end

  def handle_info({:DOWN, ref, :process, _pid, _error}, state) do
    # TODO broadcast {:error, reason}
    {:noreply, remove_fire_worker(ref, state)}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp remove_fire_worker(ref, state) do
    current_ref = state.fire_worker.ref

    case ref do
      ref when ref == current_ref -> %{state | fire_worker: %{pid: nil, ref: nil}}
      _ref -> state
    end
  end
end
