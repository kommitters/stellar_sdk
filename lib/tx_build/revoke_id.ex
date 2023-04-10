defmodule Stellar.TxBuild.RevokeID do
  @moduledoc """
  `RevokeID` struct definition.
  """

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

  def new(
        [
          %AccountID{} = source_account,
          %SequenceNumber{} = sequence_number,
          op_num,
          %PoolID{} = liquidity_pool_id,
          %Asset{} = asset
        ],
        _opts
      )
      when is_integer(op_num) and op_num >= 0 do
    %__MODULE__{
      source_account: source_account,
      sequence_number: sequence_number,
      op_num: op_num,
      liquidity_pool_id: liquidity_pool_id,
      asset: asset
    }
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
