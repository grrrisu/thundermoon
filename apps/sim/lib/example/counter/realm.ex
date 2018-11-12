defmodule Counter.Realm do
  use Agent

  require Logger

  def start_link(opts) do
    Agent.start_link(fn -> Counter.Realm.build() end, opts)
  end

  def build do
    Logger.debug("Counter.Realm building counters...")
    add_to_object_list()

    keys = [:counter_1, :counter_10, :counter_100]
    Enum.each(keys, &build_counter(&1))

    keys
  end

  def inc(counter_key) do
    Agent.get_and_update(__MODULE__, fn state ->
      result = inc_counter(state, counter_key)
      {result, state}
    end)
  end

  defp inc_counter(state, counter_key) do
    new_counter = Counter.Object.inc(counter_key)

    case new_counter do
      n when n > 0 ->
        %{counter_key => n}

      n when n == 0 and counter_key != :counter_100 ->
        next_key = next_counter_key(counter_key)
        Map.merge(%{counter_key => 0}, inc_counter(state, next_key))

      n when n == 0 and counter_key == :counter_100 ->
        raise "exceeded counter"
    end
  end

  defp next_counter_key(current_key) do
    case current_key do
      :counter_1 -> :counter_10
      :counter_10 -> :counter_100
      :counter_100 -> raise "no next counter key"
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
        Sim.RealmSupervisor,
        {Counter.Object, name: name}
      )
  end
end
