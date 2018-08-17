defmodule Counter.TickTest do
  use ExUnit.Case

  setup do
    realm = start_supervised!({Counter.Realm, name: Counter.Realm})
    on_exit(%{}, fn -> Sim.ObjectList.clear() end)
    %{realm: realm}
  end

  test "inc 1" do
    Counter.Tick.sim(Counter.Realm, 10)
    assert Counter.Realm.counter_1() |> Counter.Object.get() == 1
    assert Counter.Realm.counter_10() |> Counter.Object.get() == 0
    assert Counter.Realm.counter_100() |> Counter.Object.get() == 0
  end

  test "inc 123" do
    Enum.each(1..123, fn _n -> Counter.Tick.sim(Counter.Realm, 10) end)
    assert Counter.Realm.counter_1() |> Counter.Object.get() == 3
    assert Counter.Realm.counter_10() |> Counter.Object.get() == 2
    assert Counter.Realm.counter_100() |> Counter.Object.get() == 1
  end
end
