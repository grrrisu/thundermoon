defmodule Sim.SimulatorTest do
  use ExUnit.Case, async: true

  setup do
    # simulator = start_supervised!({Sim.Simulator, name: Sim.Simulator})
    on_exit(%{}, fn -> Sim.Simulator.clear() end)
    %{}
  end

  test "simulator build" do
    Sim.Simulator.build(Counter.Realm, {})
    Sim.Simulator.clear()
  end

  test "simulator start" do
    Sim.Simulator.start_sim({})
    Sim.Simulator.clear()
  end

  test "simulator stop" do
  end
end
