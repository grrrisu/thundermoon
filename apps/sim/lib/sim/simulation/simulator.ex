defmodule Sim.Simulator do
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

  def build(realm_module, opts \\ {}) do
    GenServer.call(__MODULE__, {:build, {realm_module, opts}})
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
    IO.puts("starting Simulator")
    {:ok, %{running: false, realm_module: nil}}
  end

  def handle_call({:start_sim, _opts}, _from, state) do
    new_state =
      case start_child(Sim.Loop) do
        :ok -> %{state | running: true}
        :error -> state
      end

    {:reply, :ok, new_state}
  end

  def handle_call({:build, {realm_module, _opts}}, _from, state) do
    new_state =
      case start_child(realm_module) do
        :ok -> %{state | realm_module: realm_module}
        :error -> state
      end

    {:reply, :ok, new_state}
  end

  defp start_child(child_module) do
    case Supervisor.start_child(Sim.SimulationSupervisor, {child_module, name: child_module}) do
      {:ok, _pid} ->
        :ok

      {:error, reason} ->
        Logger.warn(reason.message)
        :error
    end
  end

  def handle_cast({:clear}, %{realm_module: realm_module} = state) do
    Supervisor.terminate_child(Sim.SimulationSupervisor, Sim.Loop)
    Supervisor.terminate_child(Sim.SimulationSupervisor, realm_module)
    Sim.Simulation.List.clear()
    {:noreply, %{state | running: false, realm_module: nil}}
  end
end
