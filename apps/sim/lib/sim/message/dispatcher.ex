defmodule Sim.Dispatcher do
  use GenServer

  require Logger

  # --- client API ---

  @doc """
  start the dispatcher to listen to incoming messages
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def process(message) do
    GenServer.call(__MODULE__, {:process, message})
  end

  # --- server API ---

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:process, {handler, action, args}}, _from, state) do
    Logger.info("Sim.Dispatcher: incoming message #{handler}.#{action}(#{args})")
    Task.start(fn -> enqueue(handler, action, args) end)
    {:reply, :ok, state}
  end

  def enqueue(handler, action, args) do
    Sim.Event.Queue.add(
      {handler, action,
       fn ->
         handler.incoming(action, args)
       end}
    )
  end
end
