defmodule Stellar.TxBuild do
  @moduledoc """
  Transaction build implementation.
  """
  alias Stellar.TxBuild.{
    Account,
    Memo,
    Operation,
    Operations,
    Signature,
    TimeBounds,
    Transaction,
    TransactionEnvelope
  }

  @type signature :: Signature.t()

  @type signatures :: signature() | list(signature())

  @type operation :: Operation.t()

  @type operations :: operation() | list(operation())

  @type t :: %__MODULE__{
          tx: Transaction.t(),
          signatures: signatures(),
          tx_envelope: TransactionEnvelope.t() | nil
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

  @spec set_timeout(tx_build :: t(), timeout :: TimeBounds.t()) :: t()
  def set_timeout(%__MODULE__{tx: tx} = tx_build, %TimeBounds{} = timeout) do
    transaction = %{tx | time_bounds: timeout}
    %{tx_build | tx: transaction}
  end

  @spec add_operation(tx_build :: t(), operations :: operations()) :: t()
  def add_operation(%__MODULE__{} = tx_build, []), do: tx_build

  def add_operation(%__MODULE__{} = tx_build, [operation | operations]) do
    tx_build
    |> add_operation(operation)
    |> add_operation(operations)
  end

  def add_operation(%__MODULE__{tx: tx} = tx_build, operation) do
    operation = Operation.new(operation)
    transaction = %{tx | operations: Operations.add(tx.operations, operation)}
    %{tx_build | tx: transaction}
  end

  @spec sign(tx_build :: t(), signatures :: signatures()) :: t()
  def sign(%__MODULE__{} = tx_build, []), do: tx_build

  def sign(%__MODULE__{} = tx_build, [%Signature{} = signature | signatures]) do
    tx_build
    |> sign(signature)
    |> sign(signatures)
  end

  def sign(%__MODULE__{signatures: signatures} = tx_build, %Signature{} = signature) do
    %{tx_build | signatures: signatures ++ [signature]}
  end

  @spec build(tx_build :: t()) :: t()
  def build(%__MODULE__{tx: tx, signatures: signatures} = tx_build) do
    %{tx_build | tx_envelope: TransactionEnvelope.new(tx, signatures)}
  end

  @spec envelope(tx_build :: t()) :: String.t()
  def envelope(%__MODULE__{tx: tx, signatures: signatures}) do
    tx
    |> TransactionEnvelope.new(signatures)
    |> TransactionEnvelope.to_xdr()
    |> TransactionEnvelope.to_base64()
  end
end
