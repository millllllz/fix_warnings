defmodule FixWarnings do
  @moduledoc """
  FixWarnings automatically fixes the most common Elixir warnings in your source code.

  Currently supported fixes:

  ## warning: variable "foo" is unused

  Prefix variable `foo` with a `_`: `_foo`

  ## warning: unused alias Baz

  Automatically deletes the line with an unused alias.

  Edge Cases:
  - TODO: alias Foo.{Bar, Baz}

  """

  alias FixWarnings.LogParser
  alias FixWarnings.Patch.UnusedAlias
  alias FixWarnings.Patch.UnusedVariable

  def enabled_patches do
    [
      UnusedAlias,
      UnusedVariable
    ]
  end

  def run(path, mode \\ :preview) do
    # IO.puts("parsing log: #{path}")

    changes(path)
    |> Enum.filter(fn {path, content} -> File.exists?(path) end)
    |> Enum.each(fn {path, content} ->
      # IO.puts("- writing #{path}")
      File.write(path, content)
    end)
  end

  def changes(path) do
    patches_per_file(path)
    |> Enum.map(fn {path, patches} -> {path, patch(path, patches)} end)
    |> Map.new()
  end

  def patch(path, patches) do
    # IO.puts("patching source: #{path}")

    # group by line number. There can be multiple patches per line.
    # e.g. def foo(unused_param1, unused_param2) do
    patches = Enum.group_by(patches, fn p -> p.line - 1 end)

    case File.read(path) do
      {:ok, data} ->
        data
        |> String.split("\n")
        |> Enum.with_index()
        |> Enum.map(fn {line, no} -> patch_line(line, patches[no]) end)
        |> Enum.reject(&is_nil/1)
        |> Enum.join("\n")

      _ ->
        nil
    end
  end

  def patch_line(line, nil), do: line

  def patch_line(line, patches) do
    Enum.reduce(patches, line, fn patch, line ->
      # IO.puts("patching line: #{line}")
      # edge-case: line can be nil, e.g. when it was removed previously
      if line, do: patch.__struct__.patch(line, patch)
    end)
  end

  defp patches_per_file(path) do
    File.read!(path)
    |> LogParser.parse()
    |> Enum.group_by(fn x -> x.path end)
  end
end
