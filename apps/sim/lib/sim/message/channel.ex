defmodule Sim.Channel do
  use Agent

  @doc """
  start a Channel with a list of listeners
  """
  def start_link(opts) do
    Agent.start_link(fn -> [] end, opts)
  end

  def join(agent, listener) do
    Agent.update(agent, fn listeners -> [listener | listeners] end)
  end

  def leave(agent, listener) do
    Agent.update(agent, fn listeners -> List.delete(listeners, listener) end)
  end

  def listeners(agent) do
    Agent.get(agent, fn listeners -> listeners end)
  end
end
