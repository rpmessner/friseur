defmodule Friseur.Mixfile do
  use Mix.Project

  def project do
    [ app: :friseur,
      version: "0.0.1",
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps(_) do
    [{:dynamo, "0.1.0.dev", github: "elixir-lang/dynamo"},
     {:erlv8, %r(.*), github: "rpmessner/erlv8"}]
  end
end
