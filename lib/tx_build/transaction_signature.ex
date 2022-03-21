defmodule Stellar.TxBuild.TransactionSignature do
  @moduledoc """
  A module for tagging and signing transactions.
  """
  alias Stellar.Network
  alias Stellar.TxBuild.{Transaction, Signature}

  alias StellarBase.XDR.{
    DecoratedSignatures,
    EnvelopeType,
    Hash,
    TransactionEnvelope,
    TransactionSignaturePayload
  }

  alias StellarBase.XDR.Transaction, as: TransactionXDR
  alias StellarBase.XDR.TransactionSignaturePayloadTaggedTransaction, as: TaggedTransaction

  @type signatures :: list(Signature.t())

  @spec sign(tx :: Transaction.t(), signatures :: signatures()) :: DecoratedSignatures.t()
  def sign(%Transaction{} = tx, signatures) do
    base_signature =
      tx
      |> Transaction.to_xdr()
      |> base_signature()

    signatures
    |> Enum.map(&Signature.to_xdr(&1, base_signature))
    |> DecoratedSignatures.new()
  end

  @spec sign_xdr(tx_envelope :: TransactionEnvelope.t(), signature :: Signature.t()) ::
          DecoratedSignatures.t()
  def sign_xdr(
        %TransactionEnvelope{
          envelope: %{
            tx: tx_xdr,
            signatures: %DecoratedSignatures{signatures: current_signatures}
          }
        },
        %Signature{} = signature
      ) do
    base_signature = base_signature(tx_xdr)

    signature
    |> Signature.to_xdr(base_signature)
    |> (&DecoratedSignatures.new(current_signatures ++ [&1])).()
  end

  @spec base_signature(tx_xdr :: TransactionXDR.t()) :: binary()
  defp base_signature(%TransactionXDR{} = tx_xdr) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_TX)

    tx_xdr
    |> TaggedTransaction.new(envelope_type)
    |> signature_payload()
  end

  @spec signature_payload(tagged_tx :: struct()) :: binary()
  defp signature_payload(tagged_tx) do
    network_id_xdr()
    |> TransactionSignaturePayload.new(tagged_tx)
    |> TransactionSignaturePayload.encode_xdr!()
    |> hash()
  end

  @spec network_id_xdr :: Hash.t()
  defp network_id_xdr do
    Network.passphrase()
    |> hash()
    |> Hash.new()
  end

  @spec hash(data :: binary()) :: binary()
  defp hash(data), do: :crypto.hash(:sha256, data)
end
