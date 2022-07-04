defmodule Stellar.Horizon.FeeStat do
  @moduledoc """
  Represents a `FeeStat` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          last_ledger: non_neg_integer(),
          last_ledger_base_fee: non_neg_integer(),
          ledger_capacity_usage: float(),
          fee_charged: map(),
          max_fee: map()
        }

  defstruct [
    :last_ledger,
    :last_ledger_base_fee,
    :ledger_capacity_usage,
    :fee_charged,
    :max_fee
  ]

  @mapping [
    last_ledger: :integer,
    last_ledger_base_fee: :integer,
    ledger_capacity_usage: :float
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
