
defmodule Examples.Bar do
end

defmodule Examples.Foo do
  alias Examples.Bar
  alias String

  def foo(unused_param) do
    String.length("hello")
  end

  def foo(unused_param1, unused_param2) do
  end
end