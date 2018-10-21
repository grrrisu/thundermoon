defmodule Sim.FireWorkerTest do
  use ExUnit.Case

  setup do
    # pid = start_supervised!(Sim.Event.List)
    Sim.Event.List.clear()
    %{}
  end

  test "fire event successfully" do
    event = Sim.Event.List.to_event({Example.Handler, :reverse, fn -> String.reverse("hello") end})
    assert Sim.FireWorker.fire_event(event) == {:ok, "olleh"}
  end

  test "fire event that fails" do
    event = Sim.Event.List.to_event({Example.Handler, :reverse, fn -> raise("upps") end})
    assert Sim.FireWorker.fire_event(event) == {:error, %RuntimeError{message: "upps"}}
  end

  test "process events" do
    Sim.Event.List.add({Example.Handler, :reverse, fn -> String.reverse("hello") end})
    Sim.Event.List.add({Example.Handler, :crash, fn -> raise("upps") end})
    Sim.Event.List.add({Example.Handler, :reverse, fn -> String.reverse("world") end})
    assert Sim.FireWorker.process() == :ok
    assert Sim.Event.List.empty?()
  end

  test "process empty list" do
    assert Sim.FireWorker.process() == :ok
  end
end
