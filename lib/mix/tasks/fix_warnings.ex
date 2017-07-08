require IEx
defmodule Mix.Tasks.FixWarnings do
  use Mix.Task

  @shortdoc "Patches warning (and overwrites) your files"

  @moduledoc """
  Patches warnings and overwrites the files
  """

  @doc false
  def run(args) do
    {_,_,args} =  OptionParser.parse(args)
    args = Map.new(args)

    path = args["-f"]
    if is_nil(path) do
      raise "Error: Please provide path. Example\n. mix fix_warnings -f path/to/output.log"
    end
    if !File.exists?(path) do
      raise "Error: file #{args["-f"]} does not exists. "
    end

    answer = if Enum.member?(args, "-q") || Enum.member?(args, "--quiet") do
      "y"
    else
      IO.puts "\n\n"
      IO.puts "Warning: This will **overwrite** your source code.\n"
      IO.puts "Are you sure? [Yn]:"

      IO.read(:stdio, :line)
      |> String.trim
      |> String.downcase
    end

    if answer == "y"  do
      FixWarnings.run(path)
    else
      IO.puts "Cancelled"
    end
  end
end