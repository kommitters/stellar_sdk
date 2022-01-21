defmodule Stellar.Horizon.Account.Balance do
  @moduledoc """
  Represents a `Balance` for an account.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          balance: non_neg_integer(),
          asset_type: String.t(),
          buying_liabilities: float(),
          selling_liabilities: float(),
          limit: float() | nil,
          last_modified_ledger: non_neg_integer() | nil,
          is_authorized: boolean() | nil,
          is_authorized_to_maintain_liabilities: boolean() | nil,
          asset_code: String.t() | nil,
          asset_issuer: String.t() | nil
        }

  defstruct [
    :balance,
    :asset_type,
    :buying_liabilities,
    :selling_liabilities,
    :limit,
    :last_modified_ledger,
    :is_authorized,
    :is_authorized_to_maintain_liabilities,
    :asset_code,
    :asset_issuer
  ]

  @mapping [
    {:balance, :float},
    {:limit, :float},
    {:buying_liabilities, :float},
    {:selling_liabilities, :float}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
