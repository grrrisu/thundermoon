defmodule Sim.Dispatcher do
  use GenServer

  # --- client API ---

  @doc """
  start the dispatcher to listen to incoming messages
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  join a realm to get notfied about its events
  """
  def join() do
    GenServer.call(__MODULE__, {:join})
  end

  def message(message) do
    GenServer.call(__MODULE__, {:message, message})
  end

  # --- server API ---

  def init(:ok) do
    children = [
      {Sim.Session, id: Sim.Session, name: Sim.Session}
    ]

    session_supervisor =
      Supervisor.start_link(children, strategy: :one_for_one, name: Sim.SessionSupervisor)

    {:ok, %{session_supervisor: session_supervisor}}
  end

  def handle_call({:join}, from, state) do
    Sim.Session.join(Sim.Session, from)
    {:reply, :ok, state}
  end

  def handle_call({:message, {module, action, args}}, {pid, _ref}, state) do
    result = module.process(action, args)
    send(pid, result)
    {:reply, :ok, state}
  end
end
