defmodule Sim.Event.ListTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Event.List, name: Sim.Event.List})
    :ok
  end

  test "add an event" do
    event = Sim.Event.List.add({Example.Handler, :reverse, fn -> String.reverse("hello") end})
    %Sim.Event{handler: Example.Handler, action: :reverse, function: func} = event
    assert func.() == "olleh"
  end

  test "next event" do
    event1 = Sim.Event.List.add({Example.Handler, :reverse, fn -> String.reverse("hello") end})
    event2 = Sim.Event.List.add({Example.Handler, :reverse, fn -> String.reverse("world") end})
    {:ok, next1} = Sim.Event.List.next()
    {:ok, next2} = Sim.Event.List.next()
    assert event1 == next1
    assert event2 == next2
    assert Sim.Event.List.empty?()
  end

  test "next on empty list" do
    assert Sim.Event.List.next() == :empty
  end
end
