defmodule Stellar.TxBuild.TransactionSignature do
  @moduledoc """
  A module for tagging and signing transactions.
  """
  alias Stellar.Network
  alias Stellar.TxBuild.{Transaction, Signature}

  alias StellarBase.XDR.{
    DecoratedSignatures,
    EnvelopeType,
    TransactionEnvelope,
    TransactionSignaturePayload
  }

  alias StellarBase.XDR.Transaction, as: TransactionXDR
  alias StellarBase.XDR.TransactionSignaturePayloadTaggedTransaction, as: TaggedTransaction

  @type signatures :: list(Signature.t())
  @type network_passphrase :: String.t()

  @spec sign(
          tx :: Transaction.t(),
          signatures :: signatures(),
          network_passphrase :: network_passphrase()
        ) :: DecoratedSignatures.t()
  def sign(%Transaction{} = tx, signatures, network_passphrase) do
    base_signature =
      tx
      |> Transaction.to_xdr()
      |> base_signature(network_passphrase)

    signatures
    |> Enum.map(&Signature.to_xdr(&1, base_signature))
    |> DecoratedSignatures.new()
  end

  @spec sign_xdr(
          tx_envelope :: TransactionEnvelope.t(),
          signature :: Signature.t(),
          network_passphrase :: network_passphrase()
        ) :: DecoratedSignatures.t()
  def sign_xdr(
        %TransactionEnvelope{
          envelope: %{
            tx: tx_xdr,
            signatures: %DecoratedSignatures{signatures: current_signatures}
          }
        },
        %Signature{} = signature,
        network_passphrase
      ) do
    base_signature = base_signature(tx_xdr, network_passphrase)

    signature
    |> Signature.to_xdr(base_signature)
    |> (&DecoratedSignatures.new(current_signatures ++ [&1])).()
  end

  @spec base_signature(tx_xdr :: TransactionXDR.t(), network_passphrase :: network_passphrase()) ::
          binary()
  def base_signature(%TransactionXDR{} = tx_xdr, network_passphrase) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_TX)

    tx_xdr
    |> TaggedTransaction.new(envelope_type)
    |> signature_payload(network_passphrase)
  end

  @spec signature_payload(tagged_tx :: struct(), network_passphrase :: network_passphrase()) ::
          binary()
  defp signature_payload(tagged_tx, network_passphrase) do
    network_passphrase
    |> Network.network_id_xdr()
    |> TransactionSignaturePayload.new(tagged_tx)
    |> TransactionSignaturePayload.encode_xdr!()
    |> hash()
  end

  @spec hash(data :: binary()) :: binary()
  defp hash(data), do: :crypto.hash(:sha256, data)
end
