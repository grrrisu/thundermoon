defmodule Counter.HandlerTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor})
    :ok = Sim.build(Counter.Realm)
    :ok
  end

  test "inc" do
    result = Counter.Handler.incoming(:inc, [10])
    assert result == %{counter_10: 1}
  end
end
