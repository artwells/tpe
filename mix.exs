defmodule Tpe.MixProject do
  use Mix.Project

  def project do
    [
      app: :tpe,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tpe.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
       {:dep_from_hexpm, "~> 0.3.0"},
       {:ecto_sql, "~> 3.11.1"},
       {:postgrex, ">= 0.0.0"},
       {:csv, "~> 2.3.0"},
       {:ex_doc, ">= 0.0.0", runtime: false, only: [:docs, :dev]},
       {:livebook_helpers, ">= 0.0.0", only: [:docs, :dev]},
    ]
  end






  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]
end
