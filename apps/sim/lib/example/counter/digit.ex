defmodule Counter.Digit do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> init_digit(opts[:name]) end, opts)
  end

  def init_digit(name) do
    Sim.Broadcaster.receive_result(Counter.Handler, :inc, {:ok, %{name => 0}})
    0
  end

  def get(digit) do
    Agent.get(digit, fn counter -> counter end)
  end

  def inc(digit) do
    Agent.get_and_update(digit, fn
      counter when counter == 9 ->
        {0, 0}

      counter ->
        new_counter = counter + 1
        {new_counter, new_counter}
    end)
  end
end
