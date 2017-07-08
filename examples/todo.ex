
defmodule Examples.Bar do
end
defmodule Examples.Baz do
end

defmodule Examples.AliasWithCurlyBrackets do
  alias Examples.{Bar,Baz}

  Baz

  def parse_headers(headers, headers1) do
    headers1
  end
end