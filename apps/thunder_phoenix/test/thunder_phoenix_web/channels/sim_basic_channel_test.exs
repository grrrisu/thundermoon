defmodule ThunderPhoenixWeb.SimBasicChannelTest do
  use ThunderPhoenixWeb.ChannelCase

  alias ThunderPhoenixWeb.SimBasicChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(SimBasicChannel, "sim:basic")

    {:ok, socket: socket}
  end

  test "reverse text in sim handler", %{socket: socket} do
    push(socket, "reverse", %{text: "hello world"})
    assert_push("reverse", %{"answer" => "dlrow olleh"}, 500)
  end

  test "crash event", %{socket: socket} do
    push(socket, "crash", %{})

    refute_push(
      "crash",
      %{"error" => %RuntimeError{message: "oh snap, function crashed!!!"}},
      500
    )
  end
end
