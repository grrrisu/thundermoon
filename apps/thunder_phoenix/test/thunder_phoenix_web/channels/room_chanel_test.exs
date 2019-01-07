defmodule ThunderPhoenixWeb.RoomChannelTest do
  use ThunderPhoenixWeb.ChannelCase

  alias ThunderPhoenixWeb.RoomChannel

  setup do
    {:ok, _, socket} =
      socket(ThunderPhoenixWeb.UserSocket, "user_id", %{some: :assign})
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  # test "ping replies with status ok", %{socket: socket} do
  #   ref = push(socket, "new_msg", %{body: "hello"})
  #   assert_reply(ref, "new_msg", %{body: "hello"})
  # end

  test "shout broadcasts to room:lobby", %{socket: socket} do
    push(socket, "new_msg", %{body: "hi everybody"})
    assert_broadcast("new_msg", %{body: "hi everybody"})
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "new_msg", %{body: "from me"})
    assert_push("new_msg", %{body: "from me"})
  end
end
