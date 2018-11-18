defmodule Sim.Simulation.Transducer do
  @enforce_keys [:handler, :action, :function, :object, :ref]
  defstruct [:handler, :action, :function, :object, :ref, :last_touched]
end
