defmodule Sim.BroadcasterTest do
  use ExUnit.Case, async: true

  setup do
    # _pid = start_supervised!({Sim.Broadcaster, name: Sim.Broadcaster})
    Sim.Broadcaster.clear()
    :ok
  end

  test "client joins a session" do
    assert Sim.Broadcaster.listeners(:foo) == {:error, :not_found}
    {:ok, :foo} = Sim.Broadcaster.join(:foo)
    {:ok, [pid]} = Sim.Broadcaster.listeners(:foo)
    assert self() == pid
  end

  test "client joins a dead session" do
    {:ok, :foo} = Sim.Broadcaster.join(:foo)
    {:ok, %{foo: %{pid: pid, ref: _ref}}} = Sim.Broadcaster.sessions()
    Agent.stop(pid)
    assert Sim.Broadcaster.listeners(:foo) == {:error, :not_found}
  end

  test "client leaves a session" do
    {:ok, :foo} = Sim.Broadcaster.join(:foo)
    {:ok, [_listener]} = Sim.Broadcaster.listeners(:foo)
    assert Sim.Broadcaster.leave(:foo) == {:ok, :foo}
    assert Sim.Broadcaster.listeners(:foo) == {:ok, []}
  end

  test "client leaves a dead session" do
    {:ok, :foo} = Sim.Broadcaster.join(:foo)
    {:ok, %{foo: %{pid: pid, ref: _ref}}} = Sim.Broadcaster.sessions()
    Agent.stop(pid)
    assert Sim.Broadcaster.leave(:foo) == {:ok, :foo}
  end

  test "client get listeners from a dead session" do
    {:ok, :foo} = Sim.Broadcaster.join(:foo)
    {:ok, %{foo: %{pid: pid, ref: _ref}}} = Sim.Broadcaster.sessions()
    Agent.stop(pid)
    assert Sim.Broadcaster.listeners(:foo) == {:error, :not_found}
  end

  test "fireworker sends back a result" do
    Sim.Broadcaster.join(Example.Handler)
    Sim.Broadcaster.receive_result(Example.Handler, :reverse, {:ok, "olleh"})
    assert_receive {Example.Handler, :reverse, {:ok, "olleh"}}
  end

  test "fireworker sends back an error" do
    Sim.Broadcaster.join(Example.Handler)
    Sim.Broadcaster.receive_result(Example.Handler, :reverse, {:error, "SomeError"})
    # TODO check monitor
  end

  test "join a session" do
    sessions = Sim.Broadcaster.join_session(%{}, :foo, {:pid, :ref})
    assert Map.has_key?(sessions, :foo)
    assert Sim.Broadcaster.get_listeners(sessions, :foo) == {:ok, [{:pid, :ref}]}
  end

  test "create a session" do
    {sessions, pid} = Sim.Broadcaster.find_or_create_session(%{}, :foo)
    assert Map.has_key?(sessions, :foo)
    assert is_pid(pid)
  end

  test "find an existing session" do
    {:error, :not_found} = Sim.Broadcaster.find_session(%{}, :foo)
    {sessions, pid_1} = Sim.Broadcaster.find_or_create_session(%{}, :foo)
    {:ok, pid_2} = Sim.Broadcaster.find_session(sessions, :foo)
    assert pid_1 == pid_2
  end

  test "send message to listeners" do
    dead = spawn(fn -> :finished end)
    Sim.Broadcaster.send_message([dead, self(), dead], :message)
    assert_receive :message
  end
end
