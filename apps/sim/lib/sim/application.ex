defmodule Sim.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts("starting sim container ...")
    Sim.Supervisor.start_link(name: Sim.Supervisor)
  end

  def stop(state) do
    IO.puts("sim container stopped with #{state}")
  end
end
