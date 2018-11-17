defmodule Counter.Tick do
  def sim(_realm, _delay) do
    Counter.Realm.inc(:digit_1)
  end
end
