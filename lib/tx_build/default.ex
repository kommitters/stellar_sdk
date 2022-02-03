defmodule Stellar.TxBuild.Default do
  @moduledoc """
  Default TxBuild implementation.
  """
  alias Stellar.TxBuild

  alias Stellar.TxBuild.{
    Account,
    Memo,
    BaseFee,
    Operation,
    Operations,
    SequenceNumber,
    Signature,
    TimeBounds,
    Transaction,
    TransactionEnvelope
  }

  @behaviour Stellar.TxBuild.Spec

  @impl true
  def new(%Account{} = account, opts \\ []) do
    %TxBuild{tx: Transaction.new(account, opts), signatures: [], tx_envelope: nil}
  end

  @impl true
  def add_memo(%TxBuild{tx: tx} = tx_build, %Memo{} = memo) do
    transaction = %{tx | memo: memo}
    %{tx_build | tx: transaction}
  end

  @impl true
  def set_time_bounds(%TxBuild{tx: tx} = tx_build, %TimeBounds{} = timeout) do
    transaction = %{tx | time_bounds: timeout}
    %{tx_build | tx: transaction}
  end

  @impl true
  def set_base_fee(%TxBuild{tx: tx} = tx_build, %BaseFee{} = base_fee) do
    transaction = %{tx | base_fee: base_fee}
    %{tx_build | tx: transaction}
  end

  @impl true
  def set_sequence_number(%TxBuild{tx: tx} = tx_build, %SequenceNumber{} = sequence_number) do
    transaction = %{tx | sequence_number: sequence_number}
    %{tx_build | tx: transaction}
  end

  @impl true
  def add_operations(%TxBuild{} = tx_build, []), do: tx_build

  def add_operations(%TxBuild{} = tx_build, [operation | operations]) do
    tx_build
    |> add_operation(operation)
    |> add_operations(operations)
  end

  @impl true
  def add_operation(%TxBuild{tx: tx} = tx_build, operation_body) do
    operation = Operation.new(operation_body)
    operations = Operations.add(tx.operations, operation)
    base_fee = BaseFee.new(operations.count)

    transaction = %{tx | operations: operations, base_fee: base_fee}
    %{tx_build | tx: transaction}
  end

  @impl true
  def sign(%TxBuild{} = tx_build, []), do: tx_build

  def sign(%TxBuild{} = tx_build, [%Signature{} = signature | signatures]) do
    tx_build
    |> sign(signature)
    |> sign(signatures)
  end

  def sign(%TxBuild{signatures: signatures} = tx_build, %Signature{} = signature) do
    %{tx_build | signatures: signatures ++ [signature]}
  end

  @impl true
  def build(%TxBuild{tx: tx, signatures: signatures} = tx_build) do
    %{tx_build | tx_envelope: TransactionEnvelope.new(tx, signatures)}
  end

  @impl true
  def envelope(%TxBuild{tx: tx, signatures: signatures}) do
    tx
    |> TransactionEnvelope.new(signatures)
    |> TransactionEnvelope.to_xdr()
    |> TransactionEnvelope.to_base64()
  end
end
