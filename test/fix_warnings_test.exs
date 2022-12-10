defmodule FixWarningsTest do
  use ExUnit.Case
  doctest FixWarnings

  test "basic test" do
    %{file: "test/test.log"}
    |> FixWarnings.changes()
    |> assert_changes
  end

  test "basic test for deprecated logs style (without function references)'" do
    %{file: "test/test_deprecated.log"}
    |> FixWarnings.changes()
    |> assert_changes
  end

  defp assert_changes(changes) do
    assert String.trim(changes["examples/foo.ex"]) ==
             String.trim("""
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

  test "edge-cases" do
    changes = FixWarnings.changes(%{file: "test/todo.log"})

    assert String.trim(changes["examples/todo.ex"]) ==
             String.trim("""
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

               def parse_params(%{"title" => _title}), do: nil
               def parse_params(%{title: _title}), do: nil
             end
             """)
  end

  test "safely prefix with _" do
    assert "(_bar)" == FixWarnings.Util.prefix_with_underscore("(bar)", "bar")
  end

  test "prefix ignores map string keys" do
    assert "%{\"bar\" => _bar}" ==
             FixWarnings.Util.prefix_with_underscore("%{\"bar\" => _bar}", "bar")
  end

  test "prefix ignores map atom keys" do
    assert "%{bar: _bar}" == FixWarnings.Util.prefix_with_underscore("%{bar: _bar}", "bar")
  end

  test "safely prefix with my_bar" do
    assert "my_bar" == FixWarnings.Util.prefix_with_underscore("my_bar", "bar")
  end

  test "safely prefix with mybar" do
    assert "mybar" == FixWarnings.Util.prefix_with_underscore("mybar", "bar")
  end
end
