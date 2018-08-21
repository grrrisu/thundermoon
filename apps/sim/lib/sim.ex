defmodule Sim do
  @moduledoc """
  Facade for Sim.
  """

  @doc """
  join a realm, get notfied about changes
  """
  def join(realm) do
    Sim.Broadcaster.join(realm)
  end

  @doc """
  leave a realm, unsubscribe to any changes
  """
  def leave(realm) do
    Sim.Broadcaster.leave(realm)
  end

  @doc """
  process a message, consiting of tuple {handler_module, action, args}
  """
  def process(msg) do
    Sim.Dispatcher.process(msg)
  end
end
