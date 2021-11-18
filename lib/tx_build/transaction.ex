defmodule Stellar.TxBuild.Transaction do
  @moduledoc """
  `Transaction` struct definition.
  """
  alias Stellar.TxBuild.{Account, BaseFee, Operations, SequenceNumber, Memo, TimeBounds}
  alias StellarBase.XDR.{Ext, Transaction}

  @behaviour Stellar.TxBuild.Spec

  @type t :: %__MODULE__{
          source_account: Account.t(),
          sequence_number: SequenceNumber.t(),
          base_fee: BaseFee.t(),
          memo: Memo.t(),
          time_bounds: TimeBounds.t(),
          operations: list(Operation.t())
        }

  defstruct [:source_account, :sequence_number, :base_fee, :memo, :time_bounds, :operations]

  @impl true
  def new(%Account{} = account, opts \\ []) do
    memo = Keyword.get(opts, :memo, Memo.new(:none))
    base_fee = Keyword.get(opts, :base_fee, BaseFee.new())
    seq_number = Keyword.get(opts, :sequence_number, SequenceNumber.new(account))
    time_bounds = Keyword.get(opts, :time_bounds, TimeBounds.new())
    operations = Keyword.get(opts, :operations, Operations.new())

    %__MODULE__{
      source_account: account,
      sequence_number: seq_number,
      operations: operations,
      base_fee: base_fee,
      memo: memo,
      time_bounds: time_bounds
    }
  end

  @impl true
  def to_xdr(%__MODULE__{
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        time_bounds: time_bounds,
        memo: memo,
        operations: operations
      }) do
    Transaction.new(
      Account.to_xdr(source_account),
      BaseFee.to_xdr(base_fee),
      SequenceNumber.to_xdr(sequence_number),
      TimeBounds.to_xdr(time_bounds),
      Memo.to_xdr(memo),
      Operations.to_xdr(operations),
      Ext.new()
    )
  end
end
