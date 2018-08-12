defmodule Sim.Event do
  @enforce_keys [:function, :caller]
  defstruct [:function, :caller]
end
