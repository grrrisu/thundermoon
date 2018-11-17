defmodule Sim.BroadcasterTest do
  use ExUnit.Case

  setup do
    start_supervised!({DynamicSupervisor, name: Sim.ChannelSupervisor, strategy: :one_for_one})
    start_supervised!({Sim.Broadcaster, name: Sim.Broadcaster})
    :ok
  end

  test "client joins a channel" do
    assert Sim.Broadcaster.listeners(Example.Handler) == {:error, :not_found}
    {:ok, %{}} = Sim.Broadcaster.join(Example.Handler)
    {:ok, [pid]} = Sim.Broadcaster.listeners(Example.Handler)
    assert self() == pid
  end

  test "client joins a dead channel" do
    {:ok, %{}} = Sim.Broadcaster.join(Example.Handler)
    {:ok, %{Example.Handler => %{pid: pid, ref: _ref}}} = Sim.Broadcaster.channels()
    Agent.stop(pid)
    assert Sim.Broadcaster.listeners(Example.Handler) == {:error, :not_found}
  end

  test "client leaves a channel" do
    {:ok, %{}} = Sim.Broadcaster.join(Example.Handler)
    {:ok, [_listener]} = Sim.Broadcaster.listeners(Example.Handler)
    assert Sim.Broadcaster.leave(Example.Handler) == {:ok, Example.Handler}
    assert Sim.Broadcaster.listeners(Example.Handler) == {:ok, []}
  end

  test "client leaves a dead channel" do
    {:ok, %{}} = Sim.Broadcaster.join(Example.Handler)
    {:ok, %{Example.Handler => %{pid: pid, ref: _ref}}} = Sim.Broadcaster.channels()
    Agent.stop(pid)
    assert Sim.Broadcaster.leave(Example.Handler) == {:ok, Example.Handler}
  end

  test "client get listeners from a dead channel" do
    {:ok, %{}} = Sim.Broadcaster.join(Example.Handler)
    {:ok, %{Example.Handler => %{pid: pid, ref: _ref}}} = Sim.Broadcaster.channels()
    Agent.stop(pid)
    assert Sim.Broadcaster.listeners(Example.Handler) == {:error, :not_found}
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

  test "join a channel" do
    channels = Sim.Broadcaster.join_channel(%{}, Example.Handler, {:pid, :ref})
    assert Map.has_key?(channels, Example.Handler)
    assert Sim.Broadcaster.get_listeners(channels, Example.Handler) == {:ok, [{:pid, :ref}]}
  end

  test "create a channel" do
    {channels, pid} = Sim.Broadcaster.find_or_create_channel(%{}, Example.Handler)
    assert Map.has_key?(channels, Example.Handler)
    assert is_pid(pid)
  end

  test "find an existing channel" do
    {:error, :not_found} = Sim.Broadcaster.find_channel(%{}, Example.Handler)
    {channels, pid_1} = Sim.Broadcaster.find_or_create_channel(%{}, Example.Handler)
    {:ok, pid_2} = Sim.Broadcaster.find_channel(channels, Example.Handler)
    assert pid_1 == pid_2
  end

  test "send message to listeners" do
    dead = spawn(fn -> :finished end)
    Sim.Broadcaster.send_message([dead, self(), dead], :message)
    assert_receive :message
  end
end
