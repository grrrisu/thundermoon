defmodule Counter.DigitTest do
  use ExUnit.Case, async: true

  setup do
    object = start_supervised!(Counter.Digit)
    %{object: object}
  end

  test "increment counter", %{object: object} do
    assert Counter.Digit.inc(object) == 1
    assert Counter.Digit.inc(object) == 2
    assert Counter.Digit.inc(object) == 3
    assert Counter.Digit.inc(object) == 4
    assert Counter.Digit.inc(object) == 5
    assert Counter.Digit.inc(object) == 6
    assert Counter.Digit.inc(object) == 7
    assert Counter.Digit.inc(object) == 8
    assert Counter.Digit.inc(object) == 9
    assert Counter.Digit.inc(object) == 0
    assert Counter.Digit.inc(object) == 1
  end
end
