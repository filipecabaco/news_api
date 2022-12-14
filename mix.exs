defmodule NewsApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :news_api,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NewsApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.16.0"},
      {:jason, "~> 1.0"},
      {:req, "~> 0.3.0"}
    ]
  end
end
