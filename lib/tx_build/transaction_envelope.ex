defmodule Stellar.TxBuild.TransactionEnvelope do
  @moduledoc """
  `Envelope` struct definition.
  """
  alias Stellar.TxBuild.Transaction

  alias StellarBase.XDR.{
    DecoratedSignature,
    DecoratedSignatures,
    EnvelopeType,
    TransactionV1Envelope,
    TransactionEnvelope
  }

  @behaviour Stellar.TxBuild.Resource

  @type signatures :: list(DecoratedSignature.t())

  @type t :: %__MODULE__{tx: Transaction.t(), signatures: signatures()}

  defstruct [:tx, :signatures]

  @impl true
  def new(%Transaction{} = tx, signatures) do
    %__MODULE__{
      tx: Transaction.to_xdr(tx),
      signatures: DecoratedSignatures.new(signatures)
    }
  end

  @impl true
  def to_xdr(%__MODULE__{tx: tx, signatures: signatures}) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_TX)

    tx
    |> TransactionV1Envelope.new(signatures)
    |> TransactionEnvelope.new(envelope_type)
  end

  @spec to_base64(envelope_xdr :: TransactionEnvelope.t()) :: String.t()
  def to_base64(%TransactionEnvelope{} = envelope_xdr) do
    envelope_xdr
    |> TransactionEnvelope.encode_xdr!()
    |> Base.encode64()
  end
end
