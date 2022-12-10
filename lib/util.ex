defmodule FixWarnings.Util do
  @source_matcher ~r/  (.*):(\d*)(?::|\z)/m

  def parse_source(line) do
    case Regex.scan(@source_matcher, line) do
      [[_, path, line_number]] ->
        case Integer.parse(line_number) do
          {line_number, _} ->
            {path, line_number}

          e ->
            # TODO: check why it doesnt match
            nil
        end

      _ ->
        nil
    end
  end

  def prefix_with_underscore(line, var_name) do
    ~r/([\s\(])(#{var_name}\W)/
    |> Regex.replace(line, "\\g{1}_\\g{2}")
  end
end
