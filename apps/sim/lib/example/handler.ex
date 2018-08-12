defmodule Example.Handler do
  def process(:reverse, [text]) do
    String.reverse(text)
  end

  def process(:crash, []) do
    raise "oh snap, function crashed!!!"
  end
end
