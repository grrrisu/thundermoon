defmodule Counter.Simulation do
  @moduledoc """
  use this functions only inside the realm agent.
  If it crashes it will reset the digits.
  """

  def inc(digit_key, 1) do
    inc_counter(digit_key)
  end

  def inc(digit_key, -1) do
    dec_counter(digit_key)
  end

  defp inc_counter(digit_key) do
    new_counter = Counter.Digit.inc(digit_key)

    case new_counter do
      n when n > 0 ->
        %{digit_key => n}

      n when n == 0 and digit_key != :digit_100 ->
        next_key = next_digit_key(digit_key)
        Map.merge(%{digit_key => 0}, inc_counter(next_key))

      n when n == 0 and digit_key == :digit_100 ->
        raise "counter overrun"
    end
  end

  defp dec_counter(digit_key) do
    new_counter = Counter.Digit.dec(digit_key)

    case new_counter do
      n when n < 9 ->
        %{digit_key => n}

      n when n == 9 and digit_key != :digit_100 ->
        next_key = next_digit_key(digit_key)
        Map.merge(%{digit_key => 9}, dec_counter(next_key))

      n when n == 9 and digit_key == :digit_100 ->
        raise "counter overrun"
    end
  end

  defp next_digit_key(current_key) do
    case current_key do
      :digit_1 -> :digit_10
      :digit_10 -> :digit_100
      :digit_100 -> raise "no next counter key"
    end
  end
end
