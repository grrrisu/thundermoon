defmodule Counter.Tick do
  def sim(_realm, _delay) do
    Counter.Realm.inc(:counter_1)
  end
end
