defmodule Sim.SimulationSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    IO.puts("starting SimulationSupervisor")

    children = [
      {Sim.Simulator, name: Sim.Simulator},
      {Sim.ObjectList, name: Sim.ObjectList}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
