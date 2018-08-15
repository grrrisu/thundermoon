defmodule Counter.ObjectTest do
  use ExUnit.Case, async: true

  setup do
    object = start_supervised!(Counter.Object)
    %{object: object}
  end

  test "increment counter", %{object: object} do
    assert Counter.Object.inc(object) == 1
    assert Counter.Object.inc(object) == 2
    assert Counter.Object.inc(object) == 3
    assert Counter.Object.inc(object) == 4
    assert Counter.Object.inc(object) == 5
    assert Counter.Object.inc(object) == 6
    assert Counter.Object.inc(object) == 7
    assert Counter.Object.inc(object) == 8
    assert Counter.Object.inc(object) == 9
    assert Counter.Object.inc(object) == 0
    assert Counter.Object.inc(object) == 1
  end
end
