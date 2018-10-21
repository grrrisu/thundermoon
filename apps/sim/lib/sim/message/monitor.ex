defmodule Sim.Monitor do
  use Agent

  def start_link(args) do
    Agent.start_link(fn -> [] end, args)
  end

  def track(_error) do
  end
end
