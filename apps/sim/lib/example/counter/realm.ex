defmodule Counter.Realm do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> Counter.Realm.build() end, opts)
  end

  def counter_1 do
    Agent.get(__MODULE__, fn state -> state.counter_1 end)
  end

  def counter_10 do
    Agent.get(__MODULE__, fn state -> state.counter_10 end)
  end

  def counter_100 do
    Agent.get(__MODULE__, fn state -> state.counter_100 end)
  end

  def build do
    add_to_object_list()

    %{
      counter_1: build_counter(1),
      counter_10: build_counter(10),
      counter_100: build_counter(100)
    }
  end

  def inc(counter_key) do
    Agent.get_and_update(__MODULE__, fn state ->
      result =
        case counter_key do
          :counter_1 -> inc_counter_1(state)
          :counter_10 -> inc_counter_10(state)
          :counter_100 -> inc_counter_100(state)
        end

      {result, state}
    end)
  end

  defp inc_counter_1(state) do
    case state.counter_1 |> Counter.Object.inc() do
      n when n > 0 -> %{counter_1: n}
      n when n == 0 -> Map.merge(%{counter_1: 0}, inc_counter_10(state))
    end
  end

  defp inc_counter_10(state) do
    case state.counter_10 |> Counter.Object.inc() do
      n when n > 0 -> %{counter_10: n}
      n when n == 0 -> Map.merge(%{counter_10: 0}, inc_counter_100(state))
    end
  end

  defp inc_counter_100(state) do
    case state.counter_100 |> Counter.Object.inc() do
      n when n > 0 -> %{counter_100: n}
      n when n == 0 -> raise "exceeded counter"
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

  defp build_counter(n) do
    {:ok, pid} = Counter.Object.start_link(name: String.to_atom("counter_#{n}"))
    pid
  end
end
