defmodule Sim.Simulation.Loop do
  use Task, restart: :transient

  require Logger

  @timeout 500

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_args) do
    IO.puts("starting sim loop...")
    process(%{delay: @timeout, counter: 0})
  end

  def process(counter_params) do
    %{delay: delay, counter: new_counter} = item_timeout(counter_params)
    process_next_item(delay)
    Process.sleep(delay)
    process(%{delay: delay, counter: new_counter})
  end

  def item_timeout(%{delay: delay, counter: counter}) do
    case counter do
      0 -> %{delay: recalculate_timeout(), counter: Sim.Simulation.List.size()}
      _n -> %{delay: delay, counter: counter - 1}
    end
  end

  defp recalculate_timeout() do
    case Sim.Simulation.List.size() do
      0 -> @timeout
      n -> div(@timeout, n)
    end
  end

  def process_next_item(delay) do
    case Sim.Simulation.List.next() do
      :empty -> :empty
      item -> enqueue(item, delay)
    end
  end

  def enqueue(item, delay) do
    Sim.EventQueue.add(
      {item.handler, item.action,
       fn ->
         item.function.(delay)
       end}
    )
  end
end
