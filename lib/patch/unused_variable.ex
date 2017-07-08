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
    String.replace(line, patch.element, "_" <> patch.element)
  end

  defp element_name(line) do
    case Regex.scan(@matcher, line) do
      [[_, name]] -> name
      _ -> nil
    end
  end
end

# defmodule FixWarning.FixDefintion do
#   defstruct [:type, :path, :data]
# end

# defmodule FixWarnings.UnusedAlias do
#   @matcher ~r/warning: variable "(.+)\"/

#   def match?(line) do
#     is_nil(variable_name(line))
#   end

#   def variable_name(line) do
#     case Regex.scan(@matcher, line) do
#       [[_, variable_name]] -> variable_name
#       _ -> nil
#     end
#   end

#   def build(curr_line, tail) do
#     var_name = variable_namea
#     %FixWarning.FixDefintion{type: FixWarnings.UnusedAlias, }

#     {:ok, nil, tail}
#   end
# end