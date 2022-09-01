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
    Preconditions,
    TimeBounds,
    Transaction,
    TransactionEnvelope
  }

  @behaviour Stellar.TxBuild.Spec

  @preconditions_keys [
    :time_bounds,
    :ledger_bounds,
    :min_seq_num,
    :min_seq_age,
    :min_seq_ledger_gap,
    :extra_signers
  ]

  @impl true
  def new(%Account{} = source_account, opts) do
    sequence_number = Keyword.get(opts, :sequence_number, SequenceNumber.new())
    base_fee = Keyword.get(opts, :base_fee, BaseFee.new())
    memo = Keyword.get(opts, :memo, Memo.new())
    operations = Keyword.get(opts, :operations, Operations.new())

    preconditions =
      opts
      |> Keyword.take(@preconditions_keys)
      |> Preconditions.new()

    case Transaction.new(
           source_account: source_account,
           sequence_number: sequence_number,
           base_fee: base_fee,
           preconditions: preconditions,
           memo: memo,
           operations: operations
         ) do
      %Transaction{} = transaction ->
        {:ok, %TxBuild{tx: transaction, signatures: [], tx_envelope: nil}}

      error ->
        error
    end
  end

  def new(_source_account, _opts), do: {:error, :invalid_source_account}

  @impl true
  def add_memo({:ok, %TxBuild{tx: tx} = tx_build}, %Memo{} = memo) do
    transaction = %{tx | memo: memo}
    {:ok, %{tx_build | tx: transaction}}
  end

  def add_memo({:ok, %TxBuild{}}, _memo), do: {:error, :invalid_memo}
  def add_memo(error, _memo), do: error

  @impl true
  def set_time_bounds(
        {:ok, %TxBuild{tx: %{preconditions: %{type: :none} = preconditions} = tx} = tx_build},
        %TimeBounds{} = time_bounds
      ) do
    preconditions = %{preconditions | type: :precond_time, preconditions: time_bounds}
    transaction = %{tx | preconditions: preconditions}
    {:ok, %{tx_build | tx: transaction}}
  end

  def set_time_bounds(
        {:ok,
         %TxBuild{tx: %{preconditions: %{type: :precond_time} = preconditions} = tx} = tx_build},
        %TimeBounds{} = time_bounds
      ) do
    preconditions = %{preconditions | preconditions: time_bounds}
    transaction = %{tx | preconditions: preconditions}
    {:ok, %{tx_build | tx: transaction}}
  end

  def set_time_bounds(
        {:ok,
         %TxBuild{
           tx:
             %{
               preconditions:
                 %{type: :precond_v2, preconditions: inner_preconditions} = preconditions
             } = tx
         } = tx_build},
        %TimeBounds{} = time_bounds
      ) do
    inner_preconditions = Keyword.put(inner_preconditions, :time_bounds, time_bounds)
    preconditions = %{preconditions | preconditions: inner_preconditions}
    transaction = %{tx | preconditions: preconditions}
    {:ok, %{tx_build | tx: transaction}}
  end

  def set_time_bounds({:ok, %TxBuild{}}, _time_bounds), do: {:error, :invalid_time_bounds}
  def set_time_bounds(error, _time_bounds), do: error

  @impl true
  def set_preconditions({:ok, %TxBuild{tx: tx} = tx_build}, %Preconditions{} = preconditions) do
    transaction = %{tx | preconditions: preconditions}
    {:ok, %{tx_build | tx: transaction}}
  end

  def set_preconditions({:ok, %TxBuild{}}, _preconditions), do: {:error, :invalid_preconditions}
  def set_preconditions(error, _preconditions), do: error

  @impl true
  def set_base_fee({:ok, %TxBuild{tx: tx} = tx_build}, %BaseFee{} = base_fee) do
    %Transaction{operations: %Operations{count: ops_count}} = tx
    transaction = %{tx | base_fee: BaseFee.increment(base_fee, ops_count)}

    {:ok, %{tx_build | tx: transaction}}
  end

  def set_base_fee({:ok, %TxBuild{}}, _base_fee), do: {:error, :invalid_base_fee}
  def set_base_fee(error, _base_fee), do: error

  @impl true
  def set_sequence_number({:ok, %TxBuild{tx: tx} = tx_build}, %SequenceNumber{} = seq_num) do
    transaction = %{tx | sequence_number: seq_num}
    {:ok, %{tx_build | tx: transaction}}
  end

  def set_sequence_number({:ok, %TxBuild{}}, _seq_num), do: {:error, :invalid_sequence_number}
  def set_sequence_number(error, _seq_num), do: error

  @impl true
  def add_operations({:ok, %TxBuild{}} = tx_build, []), do: tx_build

  def add_operations({:ok, %TxBuild{}} = tx_build, [operation | operations]) do
    tx_build
    |> add_operation(operation)
    |> add_operations(operations)
  end

  def add_operations({:ok, %TxBuild{}}, _operations), do: {:error, :invalid_operation}
  def add_operations(error, _operations), do: error

  @impl true
  def add_operation({:ok, %TxBuild{tx: tx} = tx_build}, operation_body) do
    with %Operation{} = operation <- Operation.new(operation_body),
         %Operations{} = operations <- Operations.add(tx.operations, operation) do
      transaction = %{tx | operations: operations, base_fee: BaseFee.increment(tx.base_fee)}
      {:ok, %{tx_build | tx: transaction}}
    end
  end

  def add_operation(error, _operation), do: error

  @impl true
  def sign({:ok, %TxBuild{}} = tx_build, []), do: tx_build

  def sign({:ok, %TxBuild{}} = tx_build, [%Signature{} = signature | signatures]) do
    tx_build
    |> sign(signature)
    |> sign(signatures)
  end

  def sign({:ok, %TxBuild{signatures: signatures} = tx_build}, %Signature{} = signature) do
    {:ok, %{tx_build | signatures: signatures ++ [signature]}}
  end

  def sign({:ok, %TxBuild{}}, _signature), do: {:error, :invalid_signature}
  def sign(error, _signature), do: error

  @impl true
  def build({:ok, %TxBuild{tx: tx, signatures: signatures} = tx_build}) do
    {:ok, %{tx_build | tx_envelope: TransactionEnvelope.new(tx, signatures)}}
  end

  def build(error), do: error

  @impl true
  def envelope({:ok, %TxBuild{tx: tx, signatures: signatures}}) do
    tx
    |> TransactionEnvelope.new(signatures)
    |> TransactionEnvelope.to_xdr()
    |> TransactionEnvelope.to_base64()
    |> (&{:ok, &1}).()
  end

  def envelope(error), do: error

  @impl true
  def sign_envelope(tx_base64, []), do: tx_base64
  def sign_envelope({:ok, tx_base64}, signatures), do: sign_envelope(tx_base64, signatures)

  def sign_envelope(tx_base64, [%Signature{} = signature | signatures]) do
    tx_base64
    |> sign_envelope(signature)
    |> sign_envelope(signatures)
  end

  def sign_envelope(tx_base64, %Signature{} = signature) do
    tx_base64
    |> TransactionEnvelope.add_signature(signature)
    |> TransactionEnvelope.to_base64()
    |> (&{:ok, &1}).()
  end

  def sign_envelope(_tx_base64, _signature), do: {:error, :invalid_signature}
end
