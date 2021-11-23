defmodule Stellar.TxBuild do
  @moduledoc """
  TxBuild implementation.
  """
  alias Stellar.TxBuild.{Account, Memo, Operations, TimeBounds, Transaction, TransactionEnvelope}

  @type t :: %__MODULE__{
          tx: Transaction.t(),
          signatures: list(),
          tx_envelope: TransactionEnvelope.t()
        }

  defstruct [:tx, :signatures, :tx_envelope]

  @spec new(account :: Account.t(), opts :: Keyword.t()) :: t()
  def new(%Account{} = account, opts \\ []) do
    %__MODULE__{
      tx: Transaction.new(account, opts),
      signatures: [],
      tx_envelope: nil
    }
  end

  @spec add_memo(tx_build :: t(), memo :: Memo.t()) :: t()
  def add_memo(%__MODULE__{tx: tx} = tx_build, %Memo{} = memo) do
    transaction = %{tx | memo: memo}
    %{tx_build | tx: transaction}
  end

  @spec set_timeout(tx_build :: t(), timeout :: non_neg_integer()) :: t()
  def set_timeout(%__MODULE__{tx: tx} = tx_build, timeout) do
    transaction = %{tx | time_bounds: TimeBounds.set_max_time(timeout)}
    %{tx_build | tx: transaction}
  end

  @spec add_operation(tx_build :: t(), operation :: any()) :: t()
  def add_operation(%__MODULE__{tx: tx} = tx_build, operation) do
    transaction = %{tx | operations: Operations.add(tx.operations, operation)}
    %{tx_build | tx: transaction}
  end

  @spec sign(tx_build :: t(), keypair :: tuple()) :: t()
  def sign(%__MODULE__{} = tx_build, _keypair) do
    tx_build
  end

  @spec build(tx_build :: t()) :: TransactionEnvelope.t()
  def build(%__MODULE__{tx: tx, signatures: signatures}) do
    tx
    |> TransactionEnvelope.new(signatures)
    |> TransactionEnvelope.to_xdr()
  end

  @spec to_base64(envelope_xdr :: struct()) :: String.t()
  def to_base64(envelope_xdr) do
    TransactionEnvelope.to_base64(envelope_xdr)
  end
end
