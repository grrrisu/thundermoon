defmodule Counter.RealmTest do
  use ExUnit.Case

  setup do
    realm = start_supervised!({Counter.Realm, name: Counter.Realm})
    on_exit(%{}, fn -> Sim.Simulation.List.clear() end)
    %{realm: realm}
  end

  test "build counters" do
    assert is_pid(Counter.Realm.counter_1())
    assert is_pid(Counter.Realm.counter_10())
    assert is_pid(Counter.Realm.counter_100())
  end

  test "add tick to object list" do
    assert !Sim.Simulation.List.is_empty()
  end

  test "inc counter_1" do
    assert Counter.Realm.counter_1() |> Counter.Object.get() == 0
    assert Counter.Realm.inc(:counter_1) == %{counter_1: 1}
    assert Counter.Realm.counter_1() |> Counter.Object.get() == 1
  end

  test "inc counter_10" do
    assert Counter.Realm.counter_10() |> Counter.Object.get() == 0
    assert Counter.Realm.inc(:counter_10) == %{counter_10: 1}
    assert Counter.Realm.counter_10() |> Counter.Object.get() == 1
  end

  test "inc counter_100" do
    assert Counter.Realm.counter_100() |> Counter.Object.get() == 0
    assert Counter.Realm.inc(:counter_100) == %{counter_100: 1}
    assert Counter.Realm.counter_100() |> Counter.Object.get() == 1
  end

  test "inc 9 should become 10" do
    Enum.each(1..9, fn _n -> Counter.Realm.inc(:counter_1) end)
    assert Counter.Realm.counter_1() |> Counter.Object.get() == 9
    assert Counter.Realm.inc(:counter_1) == %{counter_1: 0, counter_10: 1}
    assert Counter.Realm.counter_1() |> Counter.Object.get() == 0
    assert Counter.Realm.counter_10() |> Counter.Object.get() == 1
  end

  test "raise if 1000 is reached" do
    Enum.each(1..9, fn _n ->
      Counter.Realm.inc(:counter_1)
      Counter.Realm.inc(:counter_10)
      Counter.Realm.inc(:counter_100)
    end)

    catch_exit(Counter.Realm.inc(:counter_1))
  end
end
