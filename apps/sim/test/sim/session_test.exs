defmodule Sim.ChannelTest do
  use ExUnit.Case, async: true

  setup do
    session = start_supervised!(Sim.Channel)
    %{session: session}
  end

  test "join session", %{session: session} do
    assert Sim.Channel.join(session, 123)
    assert Sim.Channel.join(session, 456)
    assert Sim.Channel.join(session, 789)
    assert Sim.Channel.listeners(session) == [789, 456, 123]
  end

  test "leave session", %{session: session} do
    Sim.Channel.join(session, 123)
    Sim.Channel.join(session, 456)
    Sim.Channel.join(session, 789)
    Sim.Channel.leave(session, 456)
    assert Sim.Channel.listeners(session) == [789, 123]
  end
end
