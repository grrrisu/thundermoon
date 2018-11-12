defmodule Sim.Simulation.ServiceTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor})
    :ok
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
