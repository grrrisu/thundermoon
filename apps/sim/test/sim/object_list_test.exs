defmodule Sim.ObjectListTest do
  use ExUnit.Case, async: true

  setup do
    # object_list = start_supervised!(Sim.ObjectList)
    Sim.ObjectList.clear()
    %{function: fn -> :foo end}
  end

  test "add some objects", %{function: f} do
    assert Sim.ObjectList.objects() == []
    Sim.ObjectList.add(:a, f)
    Sim.ObjectList.add(:b, f)
    Sim.ObjectList.add(:c, f)
    assert Sim.ObjectList.objects() == [:a, :b, :c]
  end

  test "remove an object", %{function: f} do
    Sim.ObjectList.add(:a, f)
    Sim.ObjectList.add(:b, fn -> :one end)
    Sim.ObjectList.add(:c, f)
    Sim.ObjectList.add(:b, fn -> :two end)
    Sim.ObjectList.remove(:b)
    assert Sim.ObjectList.objects() == [:a, :c]
  end

  test "remove inexisting object" do
    Sim.ObjectList.remove(:b)
    assert Sim.ObjectList.objects() == []
  end

  test "get next objects", %{function: f} do
    Sim.ObjectList.add(:a, f)
    Sim.ObjectList.add(:b, f)
    Sim.ObjectList.add(:c, f)
    assert Sim.ObjectList.next().object == :a
    assert Sim.ObjectList.next().object == :b
    assert Sim.ObjectList.next().object == :c
    assert Sim.ObjectList.next().object == :a
  end

  test "get next object on a empty list" do
    assert Sim.ObjectList.next() == :empty
  end
end
