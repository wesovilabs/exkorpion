defmodule Exkorpion.Mixfile do
  use Mix.Project

  def project do
    [app: :exkorpion,
     version: "0.0.3",
     elixir: "~> 1.3",
     name: "Exkorpion",
     description: description,
     source_url: "https://github.com/wesovilabs/exkorpion",
     preferred_cli_env: ["exkorpion": :test],
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end


  defp description do
    """
        Test framework to help developers to write tests in a  BDD form.
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md"],
     maintainers: ["Ivan Corrales Solera <developer@wesovilabs.com>"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/wesovilabs/exkorpion",
              "Docs" => "http://hexdocs.pm/exkorpion/"}
     ]
  end

  defp deps do
    [
       {:ex_doc, "~> 0.11", only: :dev},
       {:earmark, "~> 0.1", only: :dev},
       {:credo, "~> 0.4", only: [:dev, :test]},
       {:dialyxir, "~> 0.3", only: [:dev]}

    ]
  end
end
