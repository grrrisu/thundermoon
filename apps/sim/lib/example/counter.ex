defmodule Counter do
  def build do
    Sim.build(Counter.Supervisor)
  end

  def join do
    Sim.join(Counter.Handler)
  end
end
