defmodule Sim.Message.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, name: Sim.ChannelSupervisor, strategy: :one_for_one},
      {Sim.Monitor, name: Sim.Monitor},
      {Sim.Dispatcher, name: Sim.Dispatcher},
      {Sim.Broadcaster, name: Sim.Broadcaster}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
