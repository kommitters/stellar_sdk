defmodule Stellar.Horizon.Resource.Transaction do
  @moduledoc """
  Represents a `Transaction` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource.Spec

  alias Stellar.Horizon.Resource.Mapping

  @type t :: %__MODULE__{
          id: String.t(),
          paging_token: String.t(),
          successful: boolean(),
          hash: String.t(),
          ledger: non_neg_integer(),
          created_at: DateTime.t(),
          source_account: String.t(),
          source_account_sequence: non_neg_integer(),
          fee_charged: String.t(),
          max_fee: non_neg_integer(),
          operation_count: non_neg_integer(),
          envelope_xdr: String.t(),
          result_xdr: String.t(),
          result_meta_xdr: String.t(),
          fee_meta_xdr: String.t(),
          memo: String.t(),
          memo_type: String.t(),
          signatures: list(),
          valid_after: DateTime.t(),
          valid_before: DateTime.t()
        }

  defstruct [
    :id,
    :paging_token,
    :successful,
    :hash,
    :ledger,
    :created_at,
    :source_account,
    :source_account_sequence,
    :fee_charged,
    :max_fee,
    :operation_count,
    :envelope_xdr,
    :result_xdr,
    :result_meta_xdr,
    :fee_meta_xdr,
    :memo,
    :memo_type,
    :signatures,
    :valid_after,
    :valid_before
  ]

  @mapping [
    {:max_fee, :integer},
    {:source_account_sequence, :integer},
    {:fee_charged, :integer},
    {:created_at, :date_time},
    {:valid_after, :date_time},
    {:valid_before, :date_time}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
