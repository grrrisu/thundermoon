defmodule Sim.Simulation.LoopTest do
  use ExUnit.Case

  setup do
    start_supervised!({DynamicSupervisor, name: Sim.FireWorkerSupervisor, strategy: :one_for_one})
    start_supervised!({Sim.Event.List, name: Sim.Event.List})
    start_supervised!({Sim.Event.Queue, name: Sim.Event.Queue})
    start_supervised!({Sim.Simulation.List, name: Sim.Simulation.List})
    start_supervised!({Sim.Simulation.Loop, name: Sim.Simulation.Loop})
    :ok
  end

  def add_to_object_list(object, function) do
    Sim.Simulation.List.add({Example.Handler, :reverse, object, function})
  end

  test "get timeout for first step" do
    add_to_object_list("a", fn -> :one end)
    add_to_object_list("b", fn -> :one end)
    add_to_object_list("c", fn -> :one end)
    add_to_object_list("d", fn -> :one end)

    %{delay: delay, counter: counter} =
      Sim.Simulation.Loop.item_timeout(%{delay: 500, counter: 0})

    assert delay == 125
    assert counter == 4
  end

  test "get timeout for second step" do
    add_to_object_list("a", fn -> :one end)
    add_to_object_list("b", fn -> :one end)

    %{delay: delay, counter: counter} =
      Sim.Simulation.Loop.item_timeout(%{delay: 125, counter: 4})

    # not recalculated
    assert delay == 125
    assert counter == 3
  end

  test "get timeout for the last step" do
    add_to_object_list("a", fn -> :one end)
    add_to_object_list("b", fn -> :one end)

    %{delay: delay, counter: counter} =
      Sim.Simulation.Loop.item_timeout(%{delay: 125, counter: 0})

    # recalculated
    assert delay == 250
    assert counter == 2
  end

  test "get timeout for an empty list" do
    %{delay: delay, counter: counter} =
      Sim.Simulation.Loop.item_timeout(%{delay: 125, counter: 0})

    assert delay == 500
    assert counter == 0
  end

  test "process item" do
    pid = self()
    add_to_object_list("b", fn delay -> send(pid, {"b", delay}) end)
    {:ok, _pid} = Sim.Simulation.Loop.process_next_item(200)
    assert_receive {"b", 200}
  end

  test "process empty list" do
    assert Sim.Simulation.Loop.process_next_item(200) == :empty
  end
end
