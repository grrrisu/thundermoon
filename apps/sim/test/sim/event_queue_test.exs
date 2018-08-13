defmodule Sim.EventQueueTest do
  use ExUnit.Case, async: true

  setup do
    event_queue = start_supervised!(Sim.EventQueue)
    Sim.EventQueue.clear()
    %{event_queue: event_queue}
  end

  test "add an event" do
    assert Sim.EventQueue.is_empty()
    Sim.EventQueue.add(self(), fn -> String.upcase("some calculation") end)
    assert !Sim.EventQueue.is_empty()
  end

  test "get next event" do
    func = fn -> String.upcase("some calculation") end
    Sim.EventQueue.add(self(), func)
    event = Sim.EventQueue.next()
    assert event == {:ok, %Sim.Event{caller: self(), function: func}}
    assert Sim.EventQueue.is_empty()
  end

  test "next is :empty if queue is empty" do
    assert Sim.EventQueue.is_empty()
    assert Sim.EventQueue.next() == :empty
  end

  test "fire next event" do
    func = fn -> String.upcase("some calculation") end
    Sim.EventQueue.add(self(), func)
    res = Sim.EventQueue.fire_next_event()
    assert res == {:ok, "SOME CALCULATION"}
  end

  test "fire on empty queue" do
    assert Sim.EventQueue.is_empty()
    assert Sim.EventQueue.fire_next_event() == :empty
  end

  test "fire event that will crash" do
    func = fn -> raise "upps" end
    Sim.EventQueue.add(self(), func)
    {:error, error} = Sim.EventQueue.fire_next_event()
    assert Exception.message(error) == "upps"
  end

  test "process some events" do
    Sim.EventQueue.add(self(), fn -> :a end)
    Sim.EventQueue.add(self(), fn -> :b end)
    Sim.EventQueue.add(self(), fn -> :c end)
    assert Sim.EventQueue.process() == :ok
    assert Sim.EventQueue.is_empty()
  end

  test "process some events with errors" do
    Sim.EventQueue.add(self(), fn -> :a end)
    Sim.EventQueue.add(self(), fn -> raise "b" end)
    Sim.EventQueue.add(self(), fn -> :c end)
    assert Sim.EventQueue.process() == :ok
    assert Sim.EventQueue.is_empty()
  end

  test "process empty queue" do
    assert Sim.EventQueue.is_empty()
    assert Sim.EventQueue.process() == :ok
  end
end
