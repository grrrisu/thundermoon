defmodule Counter.Realm do
  use Agent

  require Logger

  def start_link(opts) do
    Agent.start_link(fn -> Counter.Realm.build() end, opts)
  end

  def build do
    Logger.debug("Counter.Realm building counters...")
    add_to_object_list()

    keys = [:digit_1, :digit_10, :digit_100]
    Enum.each(keys, &build_counter(&1))

    keys
  end

  def inc(digit_key) do
    Agent.get_and_update(__MODULE__, fn state ->
      result = inc_counter(state, digit_key)
      {result, state}
    end)
  end

  defp inc_counter(state, digit_key) do
    new_counter = Counter.Digit.inc(digit_key)

    case new_counter do
      n when n > 0 ->
        %{digit_key => n}

      n when n == 0 and digit_key != :digit_100 ->
        next_key = next_digit_key(digit_key)
        Map.merge(%{digit_key => 0}, inc_counter(state, next_key))

      n when n == 0 and digit_key == :digit_100 ->
        raise "counter overrun"
    end
  end

  defp next_digit_key(current_key) do
    case current_key do
      :digit_1 -> :digit_10
      :digit_10 -> :digit_100
      :digit_100 -> raise "no next counter key"
    end
  end

  defp add_to_object_list do
    Sim.Simulation.List.add({
      Counter.Handler,
      :change,
      Counter.Realm,
      fn delay ->
        Counter.Tick.sim(Counter.Realm, delay)
      end
    })
  end

  defp build_counter(name) do
    {:ok, _pid} =
      DynamicSupervisor.start_child(
        Counter.DigitSupervisor,
        {Counter.Digit, name: name}
      )
  end
end
