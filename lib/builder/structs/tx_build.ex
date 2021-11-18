defmodule Stellar.Builder.Structs.TxBuild do
  @moduledoc """
  `TxBuild` struct definition.
  """
  alias Stellar.Builder.Structs.{Memo, TimeBounds, Transaction, TxEnvelope}

  @type t :: %__MODULE__{tx: Transaction.t(), signatures: list(), tx_envelope: TxEnvelope.t()}

  defstruct [:tx, :signatures, :tx_envelope]

  @spec new(tx :: Transaction.t()) :: t()
  def new(%Transaction{} = tx) do
    %__MODULE__{tx: tx, signatures: [], tx_envelope: nil}
  end

  @spec add_memo(builder :: t(), memo :: Memo.t()) :: t()
  def add_memo(%__MODULE__{tx: tx} = builder, %Memo{} = memo) do
    transaction = %{tx | memo: memo}
    %{builder | tx: transaction}
  end

  @spec set_timeout(builder :: t(), timeout :: non_neg_integer()) :: t()
  def set_timeout(%__MODULE__{tx: tx} = builder, timeout) do
    transaction = %{tx | time_bounds: TimeBounds.set_max_time(timeout)}
    %{builder | tx: transaction}
  end

  @spec add_operation(builder :: t(), operation :: any()) :: t()
  def add_operation(%__MODULE__{tx: tx} = builder, operation) do
    transaction = %{tx | operations: tx.operations ++ [operation]}
    %{builder | tx: transaction}
  end

  @spec add_signature(builder :: t(), signature :: any()) :: t()
  def add_signature(%__MODULE__{signatures: signatures} = builder, signature) do
    %{builder | signatures: signatures ++ [signature]}
  end
end
