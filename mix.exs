defmodule Gruf.MixProject do
  use Mix.Project

  def project() do
    [
      app: :gruf,
      name: "gruf",
      version: "0.1.0",
      elixir: "~> 1.8",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      source_url: "https://github.com/verrchu/gruf"
    ]
  end

  def application() do
    [
      applications: [:logger, :ulid],
      mod: {Gruf.Application, []}
    ]
  end

  defp deps() do
    [
      {:ulid, "~> 0.2"},
      {:propcheck, "~> 1.1", only: :test},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp description() do
    """
    GenServer-based graph-like structure
    """
  end

  defp package() do
    [
      name: "gruf",
      maintainers: ["Yauheni Tsiarokhin"],
      files: ~w(lib mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/verrchu/gruf"}
    ]
  end
end
