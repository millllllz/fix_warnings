defmodule FixWarnings.LogReader do
  def read_from_file!(nil) do
    raise "Error: Please provide path. Example\n. mix fix_warnings -f path/to/output.log"
  end

  def read_from_file!(path) do
    if File.exists?(path) do
      File.read!(path)
    else
      raise "Error: file #{path} does not exists. "
    end
  end

  def read_from_output! do
    System.cmd("mix", ~w/clean/)

    {output, _exit_status} = System.cmd("mix", ~w/compile --force/, stderr_to_stdout: true)

    output
  end
end
