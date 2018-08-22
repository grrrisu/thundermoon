defmodule Example.HandlerTest do
  use ExUnit.Case, async: true

  test "reverse text" do
    res = Example.Handler.incoming(:reverse, ["hello world"])
    assert res, "dlrow olleh"
  end

  test "crash" do
    assert_raise RuntimeError, fn ->
      Example.Handler.incoming(:crash, [])
    end
  end
end
