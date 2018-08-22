defmodule Sim.Monitor do
  use Agent

  def start_link(_args) do
    Agent.start_link(fn -> [] end)
  end

  def track(_error) do
  end
end
