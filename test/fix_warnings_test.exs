
require IEx


defmodule FixWarningsTest do
  use ExUnit.Case
  doctest FixWarnings

  test "basic test" do
    changes = FixWarnings.changes("test/test.log")

    assert String.trim(changes["examples/foo.ex"]) == String.trim("""
defmodule Examples.Bar do
end

defmodule Examples.Foo do
  alias String

  def foo(_unused_param) do
    String.length("hello")
  end

  def foo(_unused_param1, _unused_param2) do
  end
end
""")
  end

  test "todo" do
    changes = FixWarnings.changes("test/todo.log")

    assert String.trim(changes["examples/todo.ex"]) == String.trim("""
defmodule Examples.Bar do
end
defmodule Examples.Baz do
end

defmodule Examples.AliasWithCurlyBrackets do
  alias Examples.{Baz}

  Baz

  def parse_headers(_headers, headers1) do
    headers1
  end
end
""")
  end

end
