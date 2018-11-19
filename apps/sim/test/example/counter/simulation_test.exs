defmodule Counter.SimulationTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor})
    :ok = Counter.build()
    :ok
  end

  test "inc 1" do
    Counter.Simulation.inc(:digit_1, 1)
    assert Counter.Digit.get(:digit_1) == 1
    assert Counter.Digit.get(:digit_10) == 0
    assert Counter.Digit.get(:digit_100) == 0
  end

  test "inc 123" do
    Enum.each(1..123, fn _n -> Counter.Simulation.inc(:digit_1, 1) end)
    assert Counter.Digit.get(:digit_1) == 3
    assert Counter.Digit.get(:digit_10) == 2
    assert Counter.Digit.get(:digit_100) == 1
  end
end
