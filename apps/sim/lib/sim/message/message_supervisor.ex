defmodule Sim.MessageSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Sim.Dispatcher, name: Sim.Dispatcher},
      {Sim.Broadcaster, name: Sim.Broadcaster},
      {Sim.Monitor, name: Sim.Monitor}
      # {DynamicSupervisor, name: Sim.SessionSupervisor, strategy: :one_for_one},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end