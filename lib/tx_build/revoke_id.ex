defmodule Stellar.TxBuild.RevokeID do
  @moduledoc """
  `RevokeID` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1,
      validate_account_id: 1,
      validate_sequence_number: 1,
      validate_pool_id: 1,
      validate_asset: 1
    ]

  alias StellarBase.XDR.{RevokeID, UInt32}
  alias Stellar.TxBuild.{AccountID, Asset, PoolID, SequenceNumber}

  @type t :: %__MODULE__{
          source_account: AccountID.t(),
          sequence_number: SequenceNumber.t(),
          op_num: non_neg_integer(),
          liquidity_pool_id: PoolID.t(),
          asset: Asset.t()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:source_account, :sequence_number, :op_num, :liquidity_pool_id, :asset]

  @impl true
  def new(args, opts \\ nil)

  def new(args, _opts) when is_list(args) do
    source_account = Keyword.get(args, :source_account)
    sequence_number = Keyword.get(args, :sequence_number)
    op_num = Keyword.get(args, :op_num)
    liquidity_pool_id = Keyword.get(args, :liquidity_pool_id)
    asset = Keyword.get(args, :asset)

    with {:ok, source_account} <- validate_account_id({:source_account, source_account}),
         {:ok, sequence_number} <- validate_sequence_number({:sequence_number, sequence_number}),
         {:ok, op_num} <- validate_pos_integer({:op_num, op_num}),
         {:ok, liquidity_pool_id} <- validate_pool_id({:liquidity_pool_id, liquidity_pool_id}),
         {:ok, asset} <- validate_asset({:asset, asset}) do
      %__MODULE__{
        source_account: source_account,
        sequence_number: sequence_number,
        op_num: op_num,
        liquidity_pool_id: liquidity_pool_id,
        asset: asset
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_revoke_id}

  @impl true
  def to_xdr(%__MODULE__{
        source_account: source_account,
        sequence_number: sequence_number,
        op_num: op_num,
        liquidity_pool_id: liquidity_pool_id,
        asset: asset
      }) do
    source_account = AccountID.to_xdr(source_account)
    sequence_number = SequenceNumber.to_xdr(sequence_number)
    op_num = UInt32.new(op_num)
    liquidity_pool_id = PoolID.to_xdr(liquidity_pool_id)
    asset = Asset.to_xdr(asset)

    RevokeID.new(source_account, sequence_number, op_num, liquidity_pool_id, asset)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_revoke_id}
end
