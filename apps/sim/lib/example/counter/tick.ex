defmodule Counter.Tick do
  def sim(realm) do
    case realm.counter_1 |> Counter.Object.inc() do
      n when n > 0 ->
        :ok

      n when n == 0 ->
        case realm.counter_10 |> Counter.Object.inc() do
          nn when nn > 0 ->
            :ok

          nn when nn == 0 ->
            realm.counter_100 |> Counter.Object.inc()
            :ok
        end
    end
  end
end
