defmodule ThunderPhoenixWeb.PageController do
  use ThunderPhoenixWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def counter(conn, _params) do
    render(conn, "counter.html")
  end
end
