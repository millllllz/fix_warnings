defmodule Mix.Tasks.FixWarnings do
  use Mix.Task

  @shortdoc "Patches warning (and overwrites) your files"

  @moduledoc """
  Automatically fixes compiler warnings in your Elixir project.

      $ mix clean
      # clear
      # mix
      # # Copy output to path/to/output.log
      $ mix fix_warnings -f path/to/output.log

  - The `-f` option indicates the path where you have copied the log output
  - The `-q` or --quiet flag to surpress the [Yn] confirm prompt

  See [https://github.com/hasclass/fix_warnings](hasclass/fix_warnings) for details on how to run.
  """

  @doc false
  def run(args) do
    {args, _, _} =
      OptionParser.parse(args,
        aliases: [f: :file, q: :quiet],
        strict: [file: :string, quiet: :boolean]
      )

    args = Map.new(args)

    answer =
      if args[:quiet] do
        "y"
      else
        IO.puts("\n\n")
        IO.puts("Warning: This will **overwrite** your source code.\n")
        IO.puts("Are you sure? [Yn]:")

        IO.read(:stdio, :line)
        |> String.trim()
        |> String.downcase()
      end

    if answer == "y" do
      FixWarnings.run(args)
    else
      IO.puts("Cancelled")
    end
  end
end
