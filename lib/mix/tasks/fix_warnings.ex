defmodule Mix.Tasks.FixWarnings do
  use Mix.Task

  @shortdoc "Patches warning (and overwrites) your files"

  @moduledoc """
  Patches warnings and overwrites the files
  """

  @doc false
  def run(args) do
    IO.puts ""
    IO.puts ""
    IO.puts ""
    IO.puts "Warning: This will **overwrite** your source code."
    IO.puts ""
    IO.puts "Are you sure? [Yn]:"

    answer = IO.read(:stdio, :line)
    |> String.trim
    |> String.downcase

    if answer == "y" do
      FixWarnings.run("test/test.log")
    else
      IO.puts "Cancelled"
    end
  end
end