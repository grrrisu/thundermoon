defmodule Thundermoon.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Thundermoon",
      source_url: "https://github.com/grrrisu/thundermoon",
      homepage_url: "https://github.com/grrrisu/thundermoon",
      docs: [
        # The main page in the docs
        # main: "api-reference.html",
        logo: "thunderbird_moon.jpg"
        # extras: ["README.md"]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
