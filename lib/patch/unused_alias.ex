defmodule FixWarnings.Patch.UnusedAlias do
  @moduledoc """
  Automatically removes unused aliases from a module.

  ## Example

      warning: unused alias Bar

      # Before:
      defmodule Foo
        alias Bar
      end

      # After the patch
      defmodule Foo
      end

  """

  defstruct [:path, :line, :element]

  alias FixWarnings.Util
  alias FixWarnings.Patch.UnusedAlias

  @matcher ~r/warning: unused alias (.+)/

  def match?(line) do
    !is_nil(alias_name(line))
  end

  def build(curr_line, []), do: {:error}
  def build(curr_line, tail) do
    [file_loc | tail] = tail

    case Util.parse_source(file_loc) do
      {path, no} ->
        fix = %UnusedAlias{path: path, line: no, element: alias_name(curr_line)}
        {:ok, fix, tail}
      _ ->
        {:error}
    end
  end

  def patch(_line, _patch) do
    nil # nil value means the line is removed
  end

  defp alias_name(line) do
    case Regex.scan(@matcher, line) do
      [[_, name]] -> name
      _ -> nil
    end
  end
end