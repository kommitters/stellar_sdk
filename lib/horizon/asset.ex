defmodule Stellar.Horizon.Asset do
  @moduledoc """
  Represents a `Asset` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          paging_token: String.t(),
          asset_type: String.t(),
          asset_code: String.t(),
          asset_issuer: String.t(),
          accounts: map(),
          num_claimable_balances: non_neg_integer(),
          balances: map(),
          claimable_balances_amount: String.t(),
          amount: String.t(),
          num_accounts: non_neg_integer(),
          flags: map()
        }

  defstruct [
    :paging_token,
    :asset_type,
    :asset_code,
    :asset_issuer,
    :accounts,
    :num_claimable_balances,
    :balances,
    :claimable_balances_amount,
    :amount,
    :num_accounts,
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
