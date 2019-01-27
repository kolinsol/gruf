defmodule Gruf.MixProject do
  use Mix.Project

  def project do
    [
      app: :gruf,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:logger, :ulid],
      mod: {Gruf.Application, []}
    ]
  end

  defp deps do
    [
      {:ulid, "~> 0.2.0"}
    ]
  end
end
