defmodule Example.Handler do
  def process(:reverse, [text]) do
    result = String.reverse(text)
    {Example.Handler, :reverse, {:ok, result}}
  end
end
