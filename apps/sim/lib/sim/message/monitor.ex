defmodule Sim.Monitor do
  use Agent

  require Logger

  def start_link(args) do
    Agent.start_link(fn -> [] end, args)
  end

  def track(error) do
    # Logger.warn(error)
    IO.inspect(error)
  end
end
