defmodule Sim.ObjectListTest do
  use ExUnit.Case

  setup do
    on_exit({}, fn -> Sim.ObjectList.clear() end)
    %{function: fn -> :foo end}
  end

  def add_to_object_list(object, function) do
    Sim.ObjectList.add({Example.Handler, :reverse, object, function})
  end

  test "add some objects", %{function: f} do
    assert Sim.ObjectList.objects() == []
    add_to_object_list(:a, f)
    add_to_object_list(:b, f)
    add_to_object_list(:c, f)
    assert Sim.ObjectList.objects() == [:a, :b, :c]
  end

  test "list size", %{function: f} do
    assert Sim.ObjectList.size() == 0
    add_to_object_list(:a, f)
    add_to_object_list(:b, f)
    add_to_object_list(:c, f)
    assert Sim.ObjectList.size() == 3
  end

  test "remove an object", %{function: f} do
    add_to_object_list(:a, f)
    add_to_object_list(:b, fn -> :one end)
    add_to_object_list(:c, f)
    add_to_object_list(:b, fn -> :two end)
    Sim.ObjectList.remove(:b)
    assert Sim.ObjectList.objects() == [:a, :c]
  end

  test "remove inexisting object" do
    Sim.ObjectList.remove(:b)
    assert Sim.ObjectList.objects() == []
  end

  test "get next objects", %{function: f} do
    add_to_object_list(:a, f)
    add_to_object_list(:b, f)
    add_to_object_list(:c, f)
    assert Sim.ObjectList.next().object == :a
    assert Sim.ObjectList.next().object == :b
    assert Sim.ObjectList.next().object == :c
    assert Sim.ObjectList.next().object == :a
  end

  test "get next object on a empty list" do
    assert Sim.ObjectList.next() == :empty
  end
end
