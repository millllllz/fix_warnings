defmodule FixWarnings.Patch.UnusedVariable do
  @moduledoc """
  Automatically prefixes unused variables with a "_". This is the minimal
  invasive patch, as it preserves meaning from variable names.

  ## Example

      warning: variable "my_param" is unused

      # Before
      def foo(my_param) do
        nil
      end

      # After
      def foo(_my_param) do
        nil
      end
  """

  defstruct [:path, :line, :element]

  alias FixWarnings.Util
  alias FixWarnings.Patch.UnusedVariable

  @matcher ~r/warning: variable "(.+)" is unused/

  def match?(line) do
    !is_nil(element_name(line))
  end

  def build(curr_line, []), do: {:error}

  def build(curr_line, tail) do
    [file_loc | tail] = tail

    case Util.parse_source(file_loc) do
      {path, no} ->
        fix = %UnusedVariable{path: path, line: no, element: element_name(curr_line)}
        {:ok, fix, tail}

      _ ->
        {:error}
    end
  end

  def patch(line, patch) do
    Util.prefix_with_underscore(line, patch.element)
  end

  defp element_name(line) do
    case Regex.scan(@matcher, line) do
      [[_, name]] -> name
      _ -> nil
    end
  end
end
