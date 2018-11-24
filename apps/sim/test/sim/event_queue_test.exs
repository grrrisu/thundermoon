defmodule Sim.Event.QueueTest do
  use ExUnit.Case

  setup do
    start_supervised!({DynamicSupervisor, name: Sim.FireWorkerSupervisor, strategy: :one_for_one})
    start_supervised!({Sim.Event.List, name: Sim.Event.List})
    start_supervised!({Sim.Event.Queue, name: Sim.Event.Queue})
    :ok
  end

  test "add an event" do
    assert Sim.Event.List.empty?()
    Sim.Event.Queue.add({Example.Handler, :upcase, fn -> String.upcase("some calculation") end})
    assert Sim.Event.List.empty?()
  end

  test "remove fireworker when finished" do
    assert :sys.get_state(Sim.Event.Queue).fire_worker == %{pid: nil, ref: nil}
    Sim.Event.Queue.add({Example.Handler, :upcase, fn -> :done end})
    Process.sleep(5)
    assert :sys.get_state(Sim.Event.Queue).fire_worker == %{pid: nil, ref: nil}
  end

  test "remove fireworker when crashed" do
    assert :sys.get_state(Sim.Event.Queue).fire_worker == %{pid: nil, ref: nil}
    Sim.Event.Queue.add({Example.Handler, :upcase, fn -> spawn_link(fn -> raise "error" end) end})
    Process.sleep(5)
    assert :sys.get_state(Sim.Event.Queue).fire_worker == %{pid: nil, ref: nil}
  end
end
