defmodule Sim.Simulation.Service do
  use GenServer

  require Logger

  # --- client API ---

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def start_sim(opts \\ {}) do
    GenServer.call(__MODULE__, {:start_sim, opts})
  end

  def stop_sim do
    GenServer.call(__MODULE__, {:stop_sim})
  end

  def running?() do
    GenServer.call(__MODULE__, {:running?})
  end

  def build(realm_module, opts \\ {}) do
    GenServer.call(__MODULE__, {:build, {realm_module, opts}})
  end

  def built?() do
    GenServer.call(__MODULE__, {:built?})
  end

  def load do
  end

  def save do
  end

  def clear do
    GenServer.cast(__MODULE__, {:clear})
  end

  # --- server API ---

  def init(:ok) do
    # IO.puts("starting Sim.Simulation.Service")
    {:ok, %{loop_pid: nil, loop_ref: nil, realm_module: nil}}
  end

  def handle_call({:start_sim, _opts}, _from, %{loop_pid: nil} = state) do
    {:ok, pid} = DynamicSupervisor.start_child(Sim.LoopSupervisor, Sim.Simulation.Loop)
    ref = Process.monitor(pid)
    new_state = %{state | loop_pid: pid, loop_ref: ref}
    {:reply, :ok, new_state}
  end

  def handle_call({:start_sim, _opts}, _from, %{loop_pid: _pid} = state) do
    {:reply, {:error, :already_started}, state}
  end

  def handle_call({:stop_sim}, _from, %{loop_pid: nil} = state) do
    {:reply, {:error, :already_stopped}, state}
  end

  def handle_call({:stop_sim}, _from, %{loop_pid: pid} = state) do
    :ok = DynamicSupervisor.terminate_child(Sim.LoopSupervisor, pid)
    new_state = %{state | loop_pid: nil, loop_ref: nil}
    {:reply, :ok, new_state}
  end

  def handle_call({:running?}, _from, %{loop_pid: loop_pid} = state) do
    {:reply, loop_pid != nil, state}
  end

  def handle_call({:build, {realm_module, _opts}}, _from, %{realm_module: nil} = state) do
    {:ok, _pid} =
      Supervisor.start_child(Sim.Simulation.Supervisor, {realm_module, name: realm_module})

    new_state = %{state | realm_module: realm_module}
    {:reply, :ok, new_state}
  end

  def handle_call({:build, {_realm_module, _opts}}, _from, %{realm_module: _module} = state) do
    {:reply, :ok, state}
  end

  def handle_call({:built?}, _from, %{realm_module: realm_module} = state) do
    {:reply, realm_module != nil, state}
  end

  def handle_cast({:clear}, %{loop_pid: loop_pid, realm_module: realm_module} = state) do
    DynamicSupervisor.terminate_child(Sim.LoopSupervisor, loop_pid)
    Supervisor.terminate_child(Sim.Simulation.Supervisor, realm_module)
    Sim.Simulation.List.clear()
    {:noreply, %{state | loop_pid: nil, loop_ref: nil, realm_module: nil}}
  end

  def handle_info({:DOWN, ref, :process, _pid, error}, %{loop_ref: loop_ref} = state) do
    if loop_ref == ref do
      # TODO broadcast {:error, reason}
      # TODO broadcast sim_stop
      IO.inspect(error)
      {:noreply, %{state | loop_pid: nil, loop_ref: nil}}
    else
      {:noreply, state}
    end
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
