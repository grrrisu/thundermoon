defmodule Sim.Session do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> MapSet.new() end, opts)
  end

  def join(session, client) do
    Agent.update(session, &MapSet.put(&1, client))
  end
end
