defmodule Stellar.TxBuild.Default do
  @moduledoc """
  Default TxBuild implementation.
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

  @behaviour Stellar.TxBuild.Spec

  @type tx :: Transaction.t()
  @type signatures :: Signature.t() | list(Signature.t())
  @type tx_envelope :: TransactionEnvelope.t() | nil

  @type t :: %__MODULE__{
          tx: tx(),
          signatures: signatures(),
          tx_envelope: tx_envelope()
        }

  defstruct [:tx, :signatures, :tx_envelope]

  @impl true
  def new(%Account{} = account, opts \\ []) do
    %__MODULE__{
      tx: Transaction.new(account, opts),
      signatures: [],
      tx_envelope: nil
    }
  end

  @impl true
  def add_memo(%__MODULE__{tx: tx} = tx_build, %Memo{} = memo) do
    transaction = %{tx | memo: memo}
    %{tx_build | tx: transaction}
  end

  @impl true
  def set_timeout(%__MODULE__{tx: tx} = tx_build, %TimeBounds{} = timeout) do
    transaction = %{tx | time_bounds: timeout}
    %{tx_build | tx: transaction}
  end

  @impl true
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

  @impl true
  def sign(%__MODULE__{} = tx_build, []), do: tx_build

  def sign(%__MODULE__{} = tx_build, [%Signature{} = signature | signatures]) do
    tx_build
    |> sign(signature)
    |> sign(signatures)
  end

  def sign(%__MODULE__{signatures: signatures} = tx_build, %Signature{} = signature) do
    %{tx_build | signatures: signatures ++ [signature]}
  end

  @impl true
  def build(%__MODULE__{tx: tx, signatures: signatures} = tx_build) do
    %{tx_build | tx_envelope: TransactionEnvelope.new(tx, signatures)}
  end

  @impl true
  def envelope(%__MODULE__{tx: tx, signatures: signatures}) do
    tx
    |> TransactionEnvelope.new(signatures)
    |> TransactionEnvelope.to_xdr()
    |> TransactionEnvelope.to_base64()
  end
end
