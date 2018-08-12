defmodule Example.HandlerTest do
  use ExUnit.Case, async: true

  test "reverse text" do
    res = Example.Handler.process(:reverse, ["hello world"])
    assert res, "dlrow olleh"
  end

  test "crash" do
    assert_raise RuntimeError, fn ->
      Example.Handler.process(:crash, [])
    end
  end
end
