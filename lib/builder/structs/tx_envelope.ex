defmodule Stellar.Builder.Structs.TxEnvelope do
  @moduledoc """
  `TxEnvelope` struct definition.
  """
  alias Stellar.Builder.Structs.Transaction

  alias StellarBase.XDR.{
    DecoratedSignature,
    DecoratedSignatures,
    EnvelopeType,
    TransactionV1Envelope,
    TransactionEnvelope
  }

  @type signatures :: list(DecoratedSignature.t())
  @type xdr_value :: TransactionEnvelope.t()

  @type t :: %__MODULE__{tx: Transaction.t(), signatures: signatures()}

  defstruct [:tx, :signatures]

  @spec new(tx :: Transaction.t(), signatures :: signatures()) :: t()
  def new(%Transaction{} = tx, signatures) do
    %__MODULE__{
      tx: Transaction.to_xdr(tx),
      signatures: DecoratedSignatures.new(signatures)
    }
  end

  @spec to_xdr(envelope :: t()) :: xdr_value()
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
