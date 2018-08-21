defmodule Sim.Monitor do
  use Agent

  def start_link(args) do
    Agent.start_link(fn -> [] end)
  end

  def track(error) do
  end
end
