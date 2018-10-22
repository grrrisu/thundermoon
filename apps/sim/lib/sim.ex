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
  process a message, consisting of tuple {handler_module, action, args}

  ## Parameters

    - msg: tuple {handler <Module>, action <Atom> , args <Array>}

  ## Examples

    Sim.Dispatcher.process({Example.Handler, :reverse, ["hello world"]})

    Sim.Dispatcher.process({Example.Handler, :crash, []})

  """
  def process(msg) do
    Sim.Dispatcher.process(msg)
  end
end
