defmodule Stellar.MixProject do
  use Mix.Project

  @github_url "https://github.com/kommitters/stellar_sdk"
  @version "0.9.2"

  def project do
    [
      app: :stellar_sdk,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Elixir Stellar SDK",
      description: description(),
      source_url: @github_url,
      package: package(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:hackney, :jason, :logger],
      mod: {Stellar.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:stellar_base, "~> 0.8.1"},
      {:ed25519, "~> 1.3"},
      {:hackney, "~> 1.17"},
      {:jason, "~> 1.0"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.14", only: :test},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Elixir SDK for the Stellar network.
    """
  end

  defp package do
    [
      description: description(),
      files: ["lib", "config", "mix.exs", "README*", "LICENSE"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "#{@github_url}/blob/master/CHANGELOG.md",
        "GitHub" => @github_url,
        "Sponsor" => "https://github.com/sponsors/kommitters"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "Elixir Stellar SDK",
      source_ref: "v#{@version}",
      source_url: @github_url,
      canonical: "http://hexdocs.pm/stellar_sdk",
      extras: extras(),
      groups_for_modules: groups_for_modules(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp groups_for_modules do
    [
      "Building a Transaction": [
        Stellar.TxBuild,
        Stellar.TxBuild.Spec,
        Stellar.TxBuild.Default,
        Stellar.TxBuild.AccountMerge,
        Stellar.TxBuild.BumpSequence,
        Stellar.TxBuild.BeginSponsoringFutureReserves,
        Stellar.TxBuild.ChangeTrust,
        Stellar.TxBuild.Clawback,
        Stellar.TxBuild.ClawbackClaimableBalance,
        Stellar.TxBuild.CreateAccount,
        Stellar.TxBuild.CreatePassiveSellOffer,
        Stellar.TxBuild.EndSponsoringFutureReserves,
        Stellar.TxBuild.ManageData,
        Stellar.TxBuild.ManageSellOffer,
        Stellar.TxBuild.ManageBuyOffer,
        Stellar.TxBuild.Payment,
        Stellar.TxBuild.PathPaymentStrictSend,
        Stellar.TxBuild.PathPaymentStrictReceive,
        Stellar.TxBuild.SetOptions
      ],
      "Querying Horizon": [
        Stellar.Horizon.Ledgers,
        Stellar.Horizon.Transactions,
        Stellar.Horizon.Operations,
        Stellar.Horizon.Effects,
        Stellar.Horizon.Accounts,
        Stellar.Horizon.Offers,
        Stellar.Horizon.Trades,
        Stellar.Horizon.Assets,
        Stellar.Horizon.ClaimableBalances,
        Stellar.Horizon.LiquidityPools,
        Stellar.Horizon.Accounts
      ],
      KeyPairs: [
        Stellar.KeyPair,
        Stellar.KeyPair.Spec,
        Stellar.KeyPair.Default
      ],
      "Horizon Resources": ~r/^Stellar\.Horizon\./,
      "TxBuild Resources": ~r/^Stellar\.TxBuild\./,
      Utils: Stellar.Network
    ]
  end

  defp extras() do
    [
      "README.md",
      "CHANGELOG.md",
      "CONTRIBUTING.md",
      "docs/examples.md",
      "docs/examples/create_account.md",
      "docs/examples/payments.md"
    ]
  end

  defp groups_for_extras do
    [
      Examples: ~r/docs\/examples\/.?/
    ]
  end
end
