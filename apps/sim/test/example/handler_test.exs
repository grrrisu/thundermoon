defmodule Example.HandlerTest do
  use ExUnit.Case, async: true

  test "reverse text" do
    result = Example.Handler.incoming(:reverse, ["hello world"])
    assert result, "dlrow olleh"
  end

  test "crash" do
    assert_raise RuntimeError, fn ->
      Example.Handler.incoming(:crash, [])
    end
  end
end
