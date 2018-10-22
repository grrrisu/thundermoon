defmodule Counter.HandlerTest do
  use ExUnit.Case, async: true

  setup do
    pid = start_supervised!({Counter.Realm, name: Counter.Realm})
    %{realm: pid}
  end

  test "inc" do
    result = Counter.Handler.incoming(:inc, [10])
    assert result == %{counter_10: 1}
  end
end
