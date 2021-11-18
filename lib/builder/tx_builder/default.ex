defmodule Stellar.TxBuilder.Default do
  @moduledoc """
  Default TxBuilder implementation.
  """
  alias Stellar.Builder.Structs.{Account, Memo, Transaction, TxBuild, TxEnvelope}

  @spec new(account :: Account.t(), opts :: Keyword.t()) :: TxBuild.t()
  def new(%Account{} = account, opts \\ []) do
    account
    |> Transaction.new(opts)
    |> TxBuild.new()
  end

  @spec add_memo(builder :: TxBuild.t(), memo :: Memo.t()) :: TxBuild.t()
  def add_memo(%TxBuild{} = builder, %Memo{} = memo) do
    TxBuild.add_memo(builder, memo)
  end

  @spec set_timeout(builder :: TxBuild.t(), timeout :: non_neg_integer()) :: TxBuild.t()
  def set_timeout(%TxBuild{} = builder, timeout) do
    TxBuild.set_timeout(builder, timeout)
  end

  @spec add_operation(builder :: TxBuild.t(), operation :: any()) :: TxBuild.t()
  def add_operation(%TxBuild{} = builder, operation) do
    TxBuild.add_operation(builder, operation)
  end

  # to be implemented in #22
  @spec sign(builder :: TxBuild.t(), keypair :: tuple()) :: TxBuild.t()
  def sign(%TxBuild{} = builder, _keypair) do
    builder
  end

  @spec build(builder :: TxBuild.t()) :: TxEnvelope.t()
  def build(%TxBuild{tx: tx, signatures: signatures}) do
    tx
    |> TxEnvelope.new(signatures)
    |> TxEnvelope.to_xdr()
  end

  @spec to_base64(envelope_xdr :: struct()) :: String.t()
  def to_base64(envelope_xdr) do
    TxEnvelope.to_base64(envelope_xdr)
  end
end
