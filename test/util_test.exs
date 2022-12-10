defmodule UtilTest do
  use ExUnit.Case
  doctest FixWarnings.Util

  alias FixWarnings.Util

  describe "parse_source/1" do
    test "parses path and line_number from source line" do
      assert {"examples/foo.ex", 13} == Util.parse_source("  examples/foo.ex:13: M.f/2")
    end

    test "parses path and line_number from deprecated-style source line" do
      assert {"examples/foo.ex", 13} == Util.parse_source("  examples/foo.ex:13")
    end
  end

  describe "prefix_with_underscore/2" do
    test "safely prefixes with _" do
      assert "(_bar)" == Util.prefix_with_underscore("(bar)", "bar")
    end

    test "ignores map string keys" do
      assert "%{\"bar\" => _bar}" ==
               Util.prefix_with_underscore("%{\"bar\" => _bar}", "bar")
    end

    test "ignores map atom keys" do
      assert "%{bar: _bar}" == Util.prefix_with_underscore("%{bar: _bar}", "bar")
    end

    test "safely prefixs with my_bar" do
      assert "my_bar" == Util.prefix_with_underscore("my_bar", "bar")
    end

    test "safely prefixs with mybar" do
      assert "mybar" == Util.prefix_with_underscore("mybar", "bar")
    end
  end
end
