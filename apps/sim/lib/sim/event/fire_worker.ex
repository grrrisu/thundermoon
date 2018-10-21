defmodule Sim.FireWorker do
  use Task, restart: :transient

  def start_link(args \\ []) do
    Task.start_link(__MODULE__, :run, args)
  end

  def run(_args) do
    process()
  end

  def process() do
    case fire_next_event() do
      :ok -> process()
      :empty -> :ok
    end
  end

  def fire_next_event() do
    case Sim.Event.List.next() do
      {:ok, event} -> process_event(event)
      :empty -> :empty
    end
  end

  def process_event(event) do
    Sim.Broadcaster.receive_result(event.handler, event.action, fire_event(event))
  end

  def fire_event(event) do
    {:ok, event.function.()}
  rescue
    error -> {:error, error}
  end
end
