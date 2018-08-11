defmodule Sim.DispatcherTest do
  use ExUnit.Case, async: true

  setup do
    dispatcher = start_supervised!(Sim.Dispatcher)
    %{dispatcher: dispatcher}
  end

  test "start dispatcher", %{dispatcher: _dispatcher} do
    assert Sim.Dispatcher.join() == :ok
  end

  test "send reverse message", %{dispatcher: _dispatcher} do
    msg = {Example.Handler, :reverse, ["hello world"]}
    assert Sim.Dispatcher.message(msg) == :ok
  end

  test "receive answer to reverse message", %{dispatcher: _dispatcher} do
    Sim.Dispatcher.join()

    msg = {Example.Handler, :reverse, ["hello world"]}
    Sim.Dispatcher.message(msg)

    assert_receive {Example.Handler, :reverse, {:ok, "dlrow olleh"}}
  end
end
