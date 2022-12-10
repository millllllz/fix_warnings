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
end
