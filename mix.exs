defmodule Fido.MixProject do
  use Mix.Project

  def project do
    [
      app: :fido,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Fido.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.6"},
      {:plug_cowboy, "~> 2.0"},
      {:cowboy, "~> 2.6"},
      {:httpoison, "~> 1.4"},
      {:sweet_xml, "~> 0.6.5"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:distillery, "~> 2.0"}
    ]
  end
end
