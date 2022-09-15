defmodule Stellar.Horizon.LiquidityPool do
  @moduledoc """
  Represents a `LiquidityPool` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          fee_bp: non_neg_integer(),
          type: String.t(),
          total_trustlines: non_neg_integer(),
          total_shares: String.t(),
          reserves: list(map()),
          last_modified_ledger: non_neg_integer(),
          last_modified_time: DateTime.t()
        }

  defstruct [
    :id,
    :paging_token,
    :fee_bp,
    :type,
    :total_trustlines,
    :total_shares,
    :reserves,
    :last_modified_ledger,
    :last_modified_time
  ]

  @mapping [
    fee_bp: :integer,
    total_trustlines: :integer,
    last_modified_ledger: :integer,
    last_modified_time: :date_time
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
