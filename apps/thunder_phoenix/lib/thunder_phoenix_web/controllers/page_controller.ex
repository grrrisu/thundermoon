defmodule ThunderPhoenixWeb.PageController do
  use ThunderPhoenixWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
