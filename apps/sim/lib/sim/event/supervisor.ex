defmodule Sim.Event.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Sim.Event.List, name: Sim.Event.List},
      {Sim.Event.Queue, name: Sim.Event.Queue},
      {DynamicSupervisor, name: Sim.FireWorkerSupervisor, strategy: :one_for_one}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
