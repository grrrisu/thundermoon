defmodule Sim.EventSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Sim.EventList, name: Sim.EventList},
      {Sim.EventQueue, name: Sim.EventQueue},
      {DynamicSupervisor, name: Sim.FireWorkerSupervisor, strategy: :one_for_one}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
