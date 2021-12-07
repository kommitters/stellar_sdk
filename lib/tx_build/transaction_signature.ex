defmodule Stellar.TxBuild.TransactionSignature do
  @moduledoc """
  A module for tagging and signing transactions.
  """
  alias Stellar.Network
  alias Stellar.TxBuild.{Transaction, Signature}
  alias StellarBase.XDR.{DecoratedSignatures, EnvelopeType, Hash, TransactionSignaturePayload}
  alias StellarBase.XDR.TransactionSignaturePayloadTaggedTransaction, as: TaggedTransaction

  @type signatures :: list(Signature.t())

  @spec sign(tx :: Transaction.t(), signatures :: signatures()) :: struct()
  def sign(%Transaction{} = tx, signatures) do
    base_signature = base_signature(tx)

    signatures
    |> Enum.map(&Signature.to_xdr(&1, base_signature))
    |> DecoratedSignatures.new()
  end

  @spec base_signature(tx :: Transaction.t()) :: binary()
  defp base_signature(%Transaction{} = tx) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_TX)

    tx
    |> Transaction.to_xdr()
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
