defmodule Sim.Event.QueueTest do
  use ExUnit.Case

  setup do
    Sim.Event.List.clear()
    %{}
  end

  test "add an event" do
    assert Sim.Event.List.empty?()
    Sim.Event.Queue.add({Example.Handler, :upcase, fn -> String.upcase("some calculation") end})
    assert Sim.Event.List.empty?()
  end
end
