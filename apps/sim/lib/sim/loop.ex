defmodule Sim.Loop do
  use Task, restart: :transient

  require Logger

  @timeout 500

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_args) do
    IO.puts("starting sim loop...")
  end

  def process() do
    case Sim.ObjectList.next() do
      :empty ->
        Process.sleep(@timeout)

      sim_function ->
        add_event(sim_function)
        Process.sleep(5)
    end

    process()
  end

  def add_event(sim_function) do
    Task.start(fn ->
      Sim.EventQueue.add_and_process(self(), sim_function)

      receive do
        {:ok, result} ->
          Logger.debug("Sim.Worker: sim #{sim_function} -> #{result}")

        {:error, error} ->
          Logger.warn("Sim.Worker: error #{sim_function} -> #{error.message}}")
      end
    end)
  end
end
