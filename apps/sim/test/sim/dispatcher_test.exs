defmodule Sim.DispatcherTest do
  use ExUnit.Case, async: true

  setup do
    dispatcher = start_supervised!(Sim.Dispatcher)
    %{dispatcher: dispatcher}
  end

  test "start dispatcher", %{dispatcher: dispatcher} do
    assert Sim.Dispatcher.join(dispatcher) == :ok
  end
end
