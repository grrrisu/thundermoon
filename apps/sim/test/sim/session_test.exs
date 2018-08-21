defmodule Sim.SessionTest do
  use ExUnit.Case, async: true

  setup do
    session = start_supervised!(Sim.Session)
    %{session: session}
  end

  test "join session", %{session: session} do
    assert Sim.Session.join(session, 123)
    assert Sim.Session.join(session, 456)
    assert Sim.Session.join(session, 789)
    assert Sim.Session.listeners(session) == [789, 456, 123]
  end

  test "leave session", %{session: session} do
    Sim.Session.join(session, 123)
    Sim.Session.join(session, 456)
    Sim.Session.join(session, 789)
    Sim.Session.leave(session, 456)
    assert Sim.Session.listeners(session) == [789, 123]
  end
end
