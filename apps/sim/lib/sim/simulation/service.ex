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
    {:ok, %{running: false, realm_module: nil}}
  end

  def handle_call({:start_sim, _opts}, _from, state) do
    new_state =
      case start_child(Sim.Simulation.Loop) do
        {:ok, _pid} -> %{state | running: true}
        {:error, _reason} -> state
      end

    {:reply, :ok, new_state}
  end

  def handle_call({:build, {realm_module, _opts}}, _from, state) do
    new_state =
      case start_child(realm_module) do
        {:ok, _pid} -> %{state | realm_module: realm_module}
        {:error, _reason} -> state
      end

    {:reply, :ok, new_state}
  end

  def handle_call({:built?}, _from, %{realm_module: realm_module} = state) do
    {:reply, realm_module != nil, state}
  end

  defp start_child(child_module) do
    Supervisor.start_child(Sim.Simulation.Supervisor, {child_module, name: child_module})
  end

  def handle_cast({:clear}, %{realm_module: realm_module} = state) do
    Supervisor.terminate_child(Sim.Simulation.Supervisor, Sim.Simulation.Loop)
    Supervisor.terminate_child(Sim.Simulation.Supervisor, realm_module)
    Sim.Simulation.List.clear()
    {:noreply, %{state | running: false, realm_module: nil}}
  end
end
