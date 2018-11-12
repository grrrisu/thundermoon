defmodule Sim.Simulation.ListTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.List, name: Sim.Simulation.List})
    %{function: fn -> :do_something end}
  end

  def add_to_object_list(object, function) do
    Sim.Simulation.List.add({Example.Handler, :reverse, object, function})
  end

  test "add some objects", %{function: f} do
    assert Sim.Simulation.List.objects() == []
    add_to_object_list(:a, f)
    add_to_object_list(:b, f)
    add_to_object_list(:c, f)
    assert Sim.Simulation.List.objects() == [:a, :b, :c]
  end

  test "list size", %{function: f} do
    assert Sim.Simulation.List.size() == 0
    add_to_object_list(:a, f)
    add_to_object_list(:b, f)
    add_to_object_list(:c, f)
    assert Sim.Simulation.List.size() == 3
  end

  test "remove an object", %{function: f} do
    add_to_object_list(:a, f)
    add_to_object_list(:b, fn -> :one end)
    add_to_object_list(:c, f)
    add_to_object_list(:b, fn -> :two end)
    Sim.Simulation.List.remove(:b)
    assert Sim.Simulation.List.objects() == [:a, :c]
  end

  test "remove inexisting object" do
    Sim.Simulation.List.remove(:b)
    assert Sim.Simulation.List.objects() == []
  end

  test "get next objects", %{function: f} do
    add_to_object_list(:a, f)
    add_to_object_list(:b, f)
    add_to_object_list(:c, f)
    assert Sim.Simulation.List.next().object == :a
    assert Sim.Simulation.List.next().object == :b
    assert Sim.Simulation.List.next().object == :c
    assert Sim.Simulation.List.next().object == :a
  end

  test "get next object on a empty list" do
    assert Sim.Simulation.List.next() == :empty
  end
end
