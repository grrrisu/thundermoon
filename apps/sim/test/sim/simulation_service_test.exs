defmodule Sim.Simulation.ServiceTest do
  use ExUnit.Case

  setup do
    # simulator = start_supervised!({Sim.Simulation.Service, name: Sim.Simulation.Service})
    on_exit(%{}, fn -> Sim.Simulation.Service.clear() end)
    %{}
  end

  test "simulator build" do
    Sim.Simulation.Service.build(Counter.Realm)
  end

  test "simulator start" do
    Sim.Simulation.Service.start_sim()
  end

  test "simulator stop" do
  end
end
