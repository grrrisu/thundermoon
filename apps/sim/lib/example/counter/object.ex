defmodule Counter.Object do
  use Agent

  def start_link(opts) do
    Agent.start_link(fn -> 0 end, opts)
  end

  def get(object) do
    Agent.get(object, fn counter -> counter end)
  end

  def inc(object) do
    Agent.get_and_update(object, fn
      counter when counter == 9 ->
        {0, 0}

      counter ->
        new_counter = counter + 1
        {new_counter, new_counter}
    end)
  end
end
