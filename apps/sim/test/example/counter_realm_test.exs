defmodule Counter.RealmTest do
  use ExUnit.Case

  setup do
    realm = start_supervised!({Counter.Realm, name: Counter.Realm})
    on_exit(%{}, fn -> Sim.ObjectList.clear() end)
    %{realm: realm}
  end

  test "build counters" do
    assert is_pid(Counter.Realm.counter_1())
    assert is_pid(Counter.Realm.counter_10())
    assert is_pid(Counter.Realm.counter_100())
  end

  test "add tick to object list" do
    assert !Sim.ObjectList.is_empty()
  end
end
