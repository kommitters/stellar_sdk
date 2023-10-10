defmodule Stellar.Horizon.Asset do
  @moduledoc """
  Represents a `Asset` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset_type: String.t(),
          asset_code: String.t(),
          asset_issuer: String.t(),
          paging_token: String.t(),
          num_accounts: non_neg_integer(),
          num_claimable_balances: non_neg_integer(),
          num_liquidity_pools: non_neg_integer(),
          num_contracts: non_neg_integer(),
          amount: String.t(),
          accounts: map(),
          claimable_balances_amount: String.t(),
          liquidity_pools_amount: String.t(),
          contracts_amount: String.t(),
          balances: map(),
          flags: map()
        }

  defstruct [
    :asset_type,
    :asset_code,
    :asset_issuer,
    :paging_token,
    :num_accounts,
    :num_claimable_balances,
    :num_liquidity_pools,
    :num_contracts,
    :amount,
    :accounts,
    :claimable_balances_amount,
    :liquidity_pools_amount,
    :contracts_amount,
    :balances,
    :flags
  ]

  @mapping [
    num_claimable_balances: :integer,
    num_accounts: :integer
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
