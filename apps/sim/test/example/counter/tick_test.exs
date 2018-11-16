defmodule Counter.TickTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor})
    :ok = Counter.build()
    :ok
  end

  test "inc 1" do
    Counter.Tick.sim(Counter.Realm, 10)
    assert Counter.Object.get(:counter_1) == 1
    assert Counter.Object.get(:counter_10) == 0
    assert Counter.Object.get(:counter_100) == 0
  end

  test "inc 123" do
    Enum.each(1..123, fn _n -> Counter.Tick.sim(Counter.Realm, 10) end)
    assert Counter.Object.get(:counter_1) == 3
    assert Counter.Object.get(:counter_10) == 2
    assert Counter.Object.get(:counter_100) == 1
  end
end
