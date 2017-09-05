defmodule LifxProtocol.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lifx_protocol,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env == :prod,
      deps: deps(),
      dialyzer: [flags: [:error_handling,
                         :race_conditions,
                         :underspecs]],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:dialyxir, "~> 0.5", only: [:dev], runtime: false}]
  end

  defp aliases do
    []
  end

end
