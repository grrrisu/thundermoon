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
    children = [
      {Sim.ObjectList, name: Sim.ObjectList}
    ]

    {:ok, supervisor} =
      Supervisor.start_link(children, strategy: :one_for_one, name: Sim.SimulatorSupervisor)

    {:ok, %{supervisor: supervisor, loop: nil, realm: nil}}
  end

  def handle_call({:start_sim, _opts}, _from, %{supervisor: supervisor} = state) do
    new_state =
      case start_child(supervisor, Sim.Loop) do
        :ok -> %{state | loop: Sim.Loop}
        :error -> state
      end

    {:reply, :ok, new_state}
  end

  def handle_call({:build, {realm_module, _opts}}, _from, %{supervisor: supervisor} = state) do
    new_state =
      case start_child(supervisor, realm_module) do
        :ok -> %{state | realm: realm_module}
        :error -> state
      end

    {:reply, :ok, new_state}
  end

  defp start_child(supervisor, child_module) do
    case Supervisor.start_child(supervisor, {child_module, name: child_module}) do
      {:ok, _pid} ->
        :ok

      {:error, reason} ->
        Logger.warn(reason)
        :error
    end
  end

  def handle_cast({:clear}, %{supervisor: supervisor, loop: loop, realm: realm} = state) do
    Supervisor.terminate_child(supervisor, loop)
    Supervisor.terminate_child(supervisor, realm)
    Sim.ObjectList.clear()
    {:noreply, %{state | loop: nil, realm: nil}}
  end
end
