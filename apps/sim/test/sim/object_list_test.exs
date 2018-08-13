defmodule Sim.ObjectListTest do
  use ExUnit.Case, async: true

  setup do
    object_list = start_supervised!(Sim.ObjectList)
    Sim.ObjectList.clear()
    %{object_list: object_list}
  end

  test "add some objects", %{object_list: _object_list} do
    assert Sim.ObjectList.to_list() == []
    Sim.ObjectList.add(:a)
    Sim.ObjectList.add(:b)
    Sim.ObjectList.add(:c)
    assert Sim.ObjectList.to_list() == [:a, :b, :c]
  end

  test "remove an object", %{object_list: _object_list} do
    Sim.ObjectList.add(:a)
    Sim.ObjectList.add(:b)
    Sim.ObjectList.add(:c)
    Sim.ObjectList.remove(:b)
    assert Sim.ObjectList.to_list() == [:a, :c]
  end

  test "remove inexisting object" do
    Sim.ObjectList.remove(:b)
    assert Sim.ObjectList.to_list() == []
  end

  test "get next objects", %{object_list: _object_list} do
    Sim.ObjectList.add(:a)
    Sim.ObjectList.add(:b)
    Sim.ObjectList.add(:c)
    assert Sim.ObjectList.next() == :a
    assert Sim.ObjectList.next() == :b
    assert Sim.ObjectList.next() == :c
    assert Sim.ObjectList.next() == :a
  end

  test "get next object on a empty list" do
    assert Sim.ObjectList.next() == :empty
  end
end
