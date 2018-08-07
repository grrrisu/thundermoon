defmodule Sim.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts("starting sim container ...")
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Sim.Worker.start_link(arg)
      # {Sim.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sim.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(state) do
    IO.puts("stopping sim container with #{state}...")
  end
end
