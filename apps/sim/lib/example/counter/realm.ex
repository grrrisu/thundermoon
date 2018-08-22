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

  defp add_to_object_list do
    Sim.ObjectList.add({
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