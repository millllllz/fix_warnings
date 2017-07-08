defmodule FixWarnings.Mixfile do
  use Mix.Project

  def project do
    [app: :fix_warnings,
     version: "0.1.1",
     elixir: "~> 1.4",
     description: "A mix task that automatically fixes compiler warnings in your Elixir project",
     package: [
      licenses: "MIT",
      maintainers: ["hasclass"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/hasclass/fix_warnings"},
      files: ~w(lib) ++
        ~w(LICENSE.md mix.exs README.md)
     ],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :docs},
    ]
  end
end
