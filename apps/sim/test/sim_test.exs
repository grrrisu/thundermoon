defmodule SimTest do
  use ExUnit.Case

  test "integration: reverse text" do
    Sim.join(Example.Handler)
    Sim.process({Example.Handler, :reverse, ["hello"]})
    # bigger timeout to make sure request goes trough even with some IO output
    assert_receive {Example.Handler, :reverse, {:ok, "olleh"}}, 500
  end
end
