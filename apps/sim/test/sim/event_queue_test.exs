defmodule Sim.EventQueueTest do
  use ExUnit.Case

  setup do
    Sim.EventList.clear()
    %{}
  end

  test "add an event" do
    assert Sim.EventList.empty?()
    Sim.EventQueue.add({Example.Handler, :upcase, fn -> String.upcase("some calculation") end})
    assert Sim.EventList.empty?()
  end
end
