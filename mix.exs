defmodule Relx.MixProject do
  use Mix.Project

  def project do
    [
      app: :relx,
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
      mod: {Relx.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_smtp, "~> 1.2.0"},
      {:ecto, "~> 3.9"},
      {:ecto_sqlite3, "~> 0.9.1"}
    ]
  end
end
