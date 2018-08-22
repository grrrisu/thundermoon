defmodule Sim.DispatcherTest do
  use ExUnit.Case

  setup do
    # dispatcher = start_supervised!(Sim.Dispatcher)
    :ok
  end

  test "client process message" do
    msg = {Example.Handler, :reverse, ["hello world"]}
    assert Sim.Dispatcher.process(msg) == :ok
  end

  test "add event to sim queue" do
    {:ok, event} = Sim.Dispatcher.enqueue(Example.Handler, :reverse, ["hello world"])
    %Sim.Event{handler: Example.Handler, action: :reverse, function: function} = event
    assert function.() == "dlrow olleh"
  end
end
