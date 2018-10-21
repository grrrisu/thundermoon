defmodule Sim.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Sim.MessageSupervisor, name: Sim.MessageSupervisor},
      {Sim.EventSupervisor, name: Sim.EventSupervisor},
      {Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
