defmodule Sim.Simulation.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    IO.puts("starting SimulationSupervisor")

    children = [
      {Sim.Simulation.Service, name: Sim.Simulation.Service},
      {Sim.Simulation.List, name: Sim.Simulation.List}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
