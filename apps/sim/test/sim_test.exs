defmodule SimTest do
  use ExUnit.Case

  setup do
    start_supervised!({DynamicSupervisor, name: Sim.ChannelSupervisor, strategy: :one_for_one})
    start_supervised!({Sim.Broadcaster, name: Sim.Broadcaster})
    start_supervised!({DynamicSupervisor, name: Sim.FireWorkerSupervisor, strategy: :one_for_one})
    start_supervised!({Sim.Event.List, name: Sim.Event.List})
    start_supervised!({Sim.Event.Queue, name: Sim.Event.Queue})
    start_supervised!({Sim.Dispatcher, name: Sim.Dispatcher})
    :ok
  end

  test "integration: reverse text" do
    Sim.join(Example.Handler)
    Sim.process({Example.Handler, :reverse, ["hello"]})
    # bigger timeout to make sure request goes trough even with some IO output
    assert_receive {Example.Handler, :reverse, {:ok, "olleh"}}, 500
  end
end
