defmodule Stellar.TxBuild.TransactionEnvelope do
  @moduledoc """
  `TransactionEnvelope` struct definition.
  """
  alias Stellar.TxBuild.{Signature, Transaction, TransactionSignature}

  alias StellarBase.XDR.{
    EnvelopeType,
    TransactionV1Envelope,
    TransactionEnvelope
  }

  @behaviour Stellar.TxBuild.XDR

  @type tx_base64 :: String.t()
  @type signatures :: list(Signature.t())

  @type t :: %__MODULE__{tx: Transaction.t(), signatures: signatures()}

  defstruct [:tx, :signatures]

  @impl true
  def new(%Transaction{} = tx, signatures) when is_list(signatures) do
    %__MODULE__{tx: tx, signatures: signatures}
  end

  @impl true
  def to_xdr(%__MODULE__{tx: tx, signatures: signatures}) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_TX)
    decorated_signatures = TransactionSignature.sign(tx, signatures)

    tx
    |> Transaction.to_xdr()
    |> TransactionV1Envelope.new(decorated_signatures)
    |> TransactionEnvelope.new(envelope_type)
  end

  @spec add_signature(tx_base64 :: tx_base64, signature :: Signature.t()) ::
          TransactionEnvelope.t()
  def add_signature(tx_base64, %Signature{} = signature) do
    with %TransactionEnvelope{envelope: envelope} = tx_envelope_xdr <- from_base64(tx_base64),
         signatures <- TransactionSignature.sign_xdr(tx_envelope_xdr, signature) do
      %{tx_envelope_xdr | envelope: %{envelope | signatures: signatures}}
    end
  end

  @spec to_base64(tx_envelope_xdr :: TransactionEnvelope.t()) :: String.t()
  def to_base64(%TransactionEnvelope{} = tx_envelope_xdr) do
    tx_envelope_xdr
    |> TransactionEnvelope.encode_xdr!()
    |> Base.encode64()
  end

  @spec from_base64(tx_base64 :: tx_base64()) :: TransactionEnvelope.t()
  def from_base64(tx_base64) do
    tx_base64
    |> Base.decode64!()
    |> TransactionEnvelope.decode_xdr!()
    |> elem(0)
  end
end
