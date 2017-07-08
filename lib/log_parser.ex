defmodule FixWarnings.LogParser do
  @moduledoc """
  Parses a file containing log output into a list of patches.

  ## Exammple

      log_data = "warning: unused alias Bar\n  examples/foo.ex:13"
      FixWarnings.LogParser.parse(log_data)
      > [%FixWarnings.Patch.UnusedAlias{path: "examples/foo.ex", line: 13, element: "Bar"}]

  """

  def parse(str) do
    lines = String.split(str, "\n")
    parse_lines([], lines)
  end

  defp parse_lines(fixes, []), do: fixes
  defp parse_lines(fixes, [curr_line | tail]) do
    definition = Enum.find(FixWarnings.enabled_patches, fn(d) ->
      d.match?(curr_line)
    end)

    fixes = if definition do
      case definition.build(curr_line, tail) do
        {:ok, fix, tail} ->
          parse_lines([fix | fixes], tail)
        _ ->
          # log: warning
          parse_lines(fixes, tail)
      end
    else
      parse_lines(fixes, tail)
    end
  end

end