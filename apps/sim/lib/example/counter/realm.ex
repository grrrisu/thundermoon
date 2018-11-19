defmodule Counter.Realm do
  use Agent

  require Logger

  def start_link(opts) do
    Agent.start_link(fn -> Counter.Realm.build() end, opts)
  end

  def build do
    Logger.debug("Counter.Realm building digits...")
    add_to_object_list()

    keys = [:digit_1, :digit_10, :digit_100]
    Enum.each(keys, &build_digit(&1))

    keys
  end

  defp add_to_object_list do
    Sim.Simulation.List.add({
      Counter.Handler,
      :change,
      Counter.Realm,
      fn delay ->
        tick(delay)
      end
    })
  end

  def tick(_delay) do
    inc(:digit_1, 1)
  end

  defp build_digit(name) do
    {:ok, _pid} =
      DynamicSupervisor.start_child(
        Counter.DigitSupervisor,
        {Counter.Digit, name: name}
      )
  end

  def current_state() do
    Agent.get(__MODULE__, fn _state ->
      %{
        running: Sim.running?(),
        digits: %{
          digit_1: Counter.Digit.get(:digit_1),
          digit_10: Counter.Digit.get(:digit_10),
          digit_100: Counter.Digit.get(:digit_100)
        }
      }
    end)
  end

  def inc(digit, step) do
    # run inc inside realm agent, so if it crashes it will reset the digits
    Agent.get(__MODULE__, fn _state ->
      Counter.Simulation.inc(digit, step)
    end)
  end
end
