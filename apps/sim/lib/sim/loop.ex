defmodule Sim.Loop do
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
    {delay, new_counter} = item_timeout(counter_params)
    process_next_item(delay)
    Process.sleep(delay)
    process({delay, new_counter})
  end

  def item_timeout(%{delay: delay, counter: counter}) do
    case counter do
      0 -> %{delay: recalculate_timeout(), counter: Sim.ObjectList.size()}
      n -> %{delay: delay, counter: counter - 1}
    end
  end

  defp recalculate_timeout() do
    case Sim.ObjectList.size() do
      0 -> @timeout
      n -> (@timeout / n) |> round
    end
  end

  def process_next_item(delay) do
    case Sim.ObjectList.next() do
      :empty -> :empty
      item -> add_event(item, delay)
    end
  end

  defp add_event(item, delay) do
    Task.start(fn ->
      Sim.EventQueue.add_and_process(self(), fn -> item.function.(delay) end)

      receive do
        {:ok, result} ->
          Logger.debug("Sim.Worker: sim #{item.object}-> #{result}")

        {:error, error} ->
          Logger.warn("Sim.Worker: error #{item.object} -> #{error.message}}")
      end
    end)
  end
end
