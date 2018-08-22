defmodule Sim.EventListTest do
  use ExUnit.Case

  setup do
    # pid = start_supervised!(Sim.EventList)
    Sim.EventList.clear()
    %{}
  end

  test "add an event" do
    event = Sim.EventList.add({Example.Handler, :reverse, fn -> String.reverse("hello") end})
    %Sim.Event{handler: Example.Handler, action: :reverse, function: func} = event
    assert func.() == "olleh"
  end

  test "next event" do
    event1 = Sim.EventList.add({Example.Handler, :reverse, fn -> String.reverse("hello") end})
    event2 = Sim.EventList.add({Example.Handler, :reverse, fn -> String.reverse("world") end})
    {:ok, next1} = Sim.EventList.next()
    {:ok, next2} = Sim.EventList.next()
    assert event1 == next1
    assert event2 == next2
    assert Sim.EventList.empty?()
  end

  test "next on empty list" do
    assert Sim.EventList.next() == :empty
  end
end
