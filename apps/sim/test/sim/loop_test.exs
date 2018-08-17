defmodule Sim.LoopTest do
  use ExUnit.Case

  setup do
    on_exit({}, fn -> Sim.ObjectList.clear() end)
    %{}
  end

  test "get timeout for first step" do
    Sim.ObjectList.add(:a, fn -> :one end)
    Sim.ObjectList.add(:b, fn -> :one end)
    Sim.ObjectList.add(:c, fn -> :one end)
    Sim.ObjectList.add(:d, fn -> :one end)
    %{delay: delay, counter: counter} = Sim.Loop.item_timeout(%{delay: 500, counter: 0})
    assert delay == 125
    assert counter == 4
  end

  test "get timeout for second step" do
    Sim.ObjectList.add(:a, fn -> :one end)
    Sim.ObjectList.add(:b, fn -> :one end)
    %{delay: delay, counter: counter} = Sim.Loop.item_timeout(%{delay: 125, counter: 4})
    # not recalculated
    assert delay == 125
    assert counter == 3
  end

  test "get timeout for the last step" do
    Sim.ObjectList.add(:a, fn -> :one end)
    Sim.ObjectList.add(:b, fn -> :one end)
    %{delay: delay, counter: counter} = Sim.Loop.item_timeout(%{delay: 125, counter: 0})
    # recalculated
    assert delay == 250
    assert counter == 2
  end

  test "get timeout for an empty list" do
    %{delay: delay, counter: counter} = Sim.Loop.item_timeout(%{delay: 125, counter: 0})
    assert delay == 500
    assert counter == 0
  end

  test "process item" do
    pid = self()
    Sim.ObjectList.add(:b, fn delay -> send(pid, {:b, delay}) end)
    {:ok, _pid} = Sim.Loop.process_next_item(200)
    assert_receive {:b, 200}
  end

  test "process empty list" do
    assert Sim.Loop.process_next_item(200) == :empty
  end
end
