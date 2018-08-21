defmodule Sim.Event do
  @enforce_keys [:function, :handler, :action]
  defstruct [:function, :handler, :action]
end
