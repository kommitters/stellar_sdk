defmodule Stellar.TxBuild.Transaction do
  @moduledoc """
  `Transaction` struct definition.
  """

  alias Stellar.TxBuild.{
    Account,
    BaseFee,
    Operations,
    SequenceNumber,
    Memo,
    TimeBounds
  }

  alias StellarBase.XDR.{Ext, Transaction}

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, struct()} | {:error, atom()}

  @type t :: %__MODULE__{
          source_account: Account.t(),
          sequence_number: SequenceNumber.t(),
          base_fee: BaseFee.t(),
          memo: Memo.t(),
          time_bounds: TimeBounds.t(),
          operations: Operations.t()
        }

  defstruct [:source_account, :sequence_number, :base_fee, :memo, :time_bounds, :operations]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) do
    source_account = Keyword.get(args, :source_account)
    sequence_number = Keyword.get(args, :sequence_number)
    base_fee = Keyword.get(args, :base_fee)
    time_bounds = Keyword.get(args, :time_bounds)
    memo = Keyword.get(args, :memo)
    operations = Keyword.get(args, :operations)

    with {:ok, source_account} <- validate_source_account(source_account),
         {:ok, sequence_number} <- validate_sequence_number(sequence_number),
         {:ok, base_fee} <- validate_base_fee(base_fee),
         {:ok, time_bounds} <- validate_time_bounds(time_bounds),
         {:ok, memo} <- validate_memo(memo),
         {:ok, operations} <- validate_operations(operations) do
      %__MODULE__{
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        time_bounds: time_bounds,
        memo: memo,
        operations: operations
      }
    end
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

  @spec validate_source_account(source_account :: Account.t()) :: validation()
  defp validate_source_account(%Account{} = source_account), do: {:ok, source_account}
  defp validate_source_account(_source_account), do: {:error, :invalid_source_account}

  @spec validate_sequence_number(sequence_number :: SequenceNumber.t()) :: validation()
  defp validate_sequence_number(%SequenceNumber{} = sequence_number), do: {:ok, sequence_number}
  defp validate_sequence_number(_sequence_number), do: {:error, :invalid_sequence_number}

  @spec validate_base_fee(base_fee :: BaseFee.t()) :: validation()
  defp validate_base_fee(%BaseFee{} = base_fee), do: {:ok, base_fee}
  defp validate_base_fee(_base_fee), do: {:error, :invalid_base_fee}

  @spec validate_time_bounds(time_bounds :: TimeBounds.t()) :: validation()
  defp validate_time_bounds(%TimeBounds{} = time_bounds), do: {:ok, time_bounds}
  defp validate_time_bounds(_time_bounds), do: {:error, :invalid_time_bounds}

  @spec validate_memo(memo :: Memo.t()) :: validation()
  defp validate_memo(%Memo{} = memo), do: {:ok, memo}
  defp validate_memo(_memo), do: {:error, :invalid_memo}

  @spec validate_operations(operations :: Operations.t()) :: validation()
  defp validate_operations(%Operations{} = operations), do: {:ok, operations}
  defp validate_operations(_operations), do: {:error, :invalid_operations}
end
