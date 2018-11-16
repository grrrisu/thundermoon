defmodule Counter.RealmTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor})
    :ok = Counter.build()
    :ok
  end

  test "build counters" do
    assert Counter.Object.get(:counter_1) == 0
    assert Counter.Object.get(:counter_10) == 0
    assert Counter.Object.get(:counter_100) == 0
  end

  test "add tick to object list" do
    assert !Sim.Simulation.List.is_empty()
  end

  test "inc counter_1" do
    assert Counter.Object.get(:counter_1) == 0
    assert Counter.Realm.inc(:counter_1) == %{counter_1: 1}
    assert Counter.Object.get(:counter_1) == 1
  end

  test "inc counter_10" do
    assert Counter.Object.get(:counter_10) == 0
    assert Counter.Realm.inc(:counter_10) == %{counter_10: 1}
    assert Counter.Object.get(:counter_10) == 1
  end

  test "inc counter_100" do
    assert Counter.Object.get(:counter_100) == 0
    assert Counter.Realm.inc(:counter_100) == %{counter_100: 1}
    assert Counter.Object.get(:counter_100) == 1
  end

  test "inc 9 should become 10" do
    Enum.each(1..9, fn _n -> Counter.Realm.inc(:counter_1) end)
    assert Counter.Object.get(:counter_1) == 9
    assert Counter.Realm.inc(:counter_1) == %{counter_1: 0, counter_10: 1}
    assert Counter.Object.get(:counter_1) == 0
    assert Counter.Object.get(:counter_10) == 1
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
