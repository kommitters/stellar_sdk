defmodule Stellar.Horizon.Ledger do
  @moduledoc """
  Represents a `Ledger` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          hash: String.t(),
          prev_hash: String.t(),
          sequence: non_neg_integer(),
          successful_transaction_count: non_neg_integer(),
          failed_transaction_count: non_neg_integer(),
          operation_count: non_neg_integer(),
          tx_set_operation_count: non_neg_integer(),
          closed_at: DateTime.t(),
          total_coins: String.t(),
          fee_pool: String.t(),
          base_fee_in_stroops: non_neg_integer(),
          base_reserve_in_stroops: non_neg_integer(),
          max_tx_set_size: non_neg_integer(),
          protocol_version: non_neg_integer(),
          header_xdr: String.t()
        }

  defstruct [
    :id,
    :paging_token,
    :hash,
    :prev_hash,
    :sequence,
    :successful_transaction_count,
    :failed_transaction_count,
    :operation_count,
    :tx_set_operation_count,
    :closed_at,
    :total_coins,
    :fee_pool,
    :base_fee_in_stroops,
    :base_reserve_in_stroops,
    :max_tx_set_size,
    :protocol_version,
    :header_xdr
  ]

  @mapping [
    closed_at: :date_time,
    sequence: :integer,
    successful_transaction_count: :integer,
    failed_transaction_count: :integer,
    tx_set_operation_count: :integer,
    operation_count: :integer,
    base_fee_in_stroops: :integer,
    base_reserve_in_stroops: :integer,
    max_tx_set_size: :integer
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
