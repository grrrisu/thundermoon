defmodule Sim.Decorator do
  @enforce_keys [:handler, :action, :function, :object]
  defstruct [:handler, :action, :function, :object, :last_touched]
end
