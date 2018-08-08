defmodule Sim.SessionTest do
  use ExUnit.Case, async: true

  setup do
    session = start_supervised!(Sim.Session)
    %{session: session}
  end

  test "start session", %{session: session} do
    assert Sim.Session.join(session, 123) == :ok
  end
end
