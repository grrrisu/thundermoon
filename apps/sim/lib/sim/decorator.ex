defmodule Sim.Decorator do
  @enforce_keys [:function, :object]
  defstruct [:function, :object, :last_touched]
end
