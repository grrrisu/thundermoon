defmodule Counter.HandlerTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor})
    :ok = Counter.build()
    :ok
  end

  test "inc" do
    result = Counter.Handler.incoming(:inc, [:digit_10, 1])
    assert result == %{digit_10: 1}
  end

  test "dec" do
    Enum.each(1..3, fn _n -> Counter.Realm.inc(:digit_10) end)
    result = Counter.Handler.incoming(:inc, [:digit_10, -1])
    assert result == %{digit_10: 2}
  end

  test "join" do
    result = Counter.Handler.join(:pid)
    assert result == %{running: false, digits: %{digit_1: 0, digit_10: 0, digit_100: 0}}
  end
end
