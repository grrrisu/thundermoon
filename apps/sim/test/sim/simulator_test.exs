defmodule Sim.SimulatorTest do
  use ExUnit.Case

  setup do
    # simulator = start_supervised!({Sim.Simulator, name: Sim.Simulator})
    on_exit(%{}, fn -> Sim.Simulator.clear() end)
    %{}
  end

  test "simulator build" do
    Sim.Simulator.build(Counter.Realm)
  end

  test "simulator start" do
    Sim.Simulator.start_sim()
  end

  test "simulator stop" do
  end
end
