defmodule Sim.DispatcherTest do
  use ExUnit.Case, async: true

  setup do
    dispatcher = start_supervised!(Sim.Dispatcher)
    %{dispatcher: dispatcher}
  end

  test "start dispatcher", %{dispatcher: dispatcher} do
    assert Sim.Dispatcher.join(dispatcher) == :ok
  end

  test "send reverse message", %{dispatcher: dispatcher} do
    msg = {Example.Handler, :reverse, ["hello world"]}
    assert Sim.Dispatcher.message(dispatcher, msg) == :ok
  end

  test "receive answer to reverse message", %{dispatcher: dispatcher} do
    Sim.Dispatcher.join(dispatcher)

    msg = {Example.Handler, :reverse, ["hello world"]}
    Sim.Dispatcher.message(dispatcher, msg)

    assert_receive {Example.Handler, :reverse, {:ok, "dlrow olleh"}}
  end
end
