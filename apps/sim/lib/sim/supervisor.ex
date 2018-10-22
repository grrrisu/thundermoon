defmodule Sim.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Sim.Message.Supervisor, name: Sim.Message.Supervisor},
      {Sim.Event.Supervisor, name: Sim.Event.Supervisor},
      {Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
