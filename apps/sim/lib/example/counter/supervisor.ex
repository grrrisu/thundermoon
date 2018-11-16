defmodule Counter.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, name: Counter.DigitSupervisor, strategy: :one_for_one},
      {Counter.Realm, name: Counter.Realm}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
