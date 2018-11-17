defmodule Counter.RealmTest do
  use ExUnit.Case

  setup do
    start_supervised!({Sim.Simulation.Supervisor, name: Sim.Simulation.Supervisor})
    :ok = Counter.build()
    :ok
  end

  test "build counters" do
    assert Counter.Digit.get(:digit_1) == 0
    assert Counter.Digit.get(:digit_10) == 0
    assert Counter.Digit.get(:digit_100) == 0
  end

  test "add tick to object list" do
    assert !Sim.Simulation.List.is_empty()
  end

  test "inc digit_1" do
    assert Counter.Digit.get(:digit_1) == 0
    assert Counter.Realm.inc(:digit_1) == %{digit_1: 1}
    assert Counter.Digit.get(:digit_1) == 1
  end

  test "inc digit_10" do
    assert Counter.Digit.get(:digit_10) == 0
    assert Counter.Realm.inc(:digit_10) == %{digit_10: 1}
    assert Counter.Digit.get(:digit_10) == 1
  end

  test "inc digit_100" do
    assert Counter.Digit.get(:digit_100) == 0
    assert Counter.Realm.inc(:digit_100) == %{digit_100: 1}
    assert Counter.Digit.get(:digit_100) == 1
  end

  test "inc 9 should become 10" do
    Enum.each(1..9, fn _n -> Counter.Realm.inc(:digit_1) end)
    assert Counter.Digit.get(:digit_1) == 9
    assert Counter.Realm.inc(:digit_1) == %{digit_1: 0, digit_10: 1}
    assert Counter.Digit.get(:digit_1) == 0
    assert Counter.Digit.get(:digit_10) == 1
  end

  test "raise if 1000 is reached" do
    Enum.each(1..9, fn _n ->
      Counter.Realm.inc(:digit_1)
      Counter.Realm.inc(:digit_10)
      Counter.Realm.inc(:digit_100)
    end)

    catch_exit(Counter.Realm.inc(:digit_1))
  end

  test "get current state" do
    Enum.each(1..2, fn _n -> Counter.Realm.inc(:digit_1) end)
    Enum.each(1..3, fn _n -> Counter.Realm.inc(:digit_10) end)
    Enum.each(1..4, fn _n -> Counter.Realm.inc(:digit_100) end)

    assert Counter.Realm.current_state() == %{
             digits: %{
               digit_1: 2,
               digit_10: 3,
               digit_100: 4
             }
           }
  end
end
