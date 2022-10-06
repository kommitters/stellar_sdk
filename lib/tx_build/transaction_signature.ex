defmodule Stellar.TxBuild.TransactionSignature do
  @moduledoc """
  A module for tagging and signing transactions.
  """
  alias Stellar.TxBuild.{Transaction, Signature}

  alias StellarBase.XDR.{
    DecoratedSignatures,
    TransactionEnvelope
  }

  @type signatures :: list(Signature.t())

  @spec sign(tx :: Transaction.t(), signatures :: signatures()) :: DecoratedSignatures.t()
  def sign(%Transaction{} = tx, signatures) do
    base_signature = Transaction.base_signature(tx)

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
    base_signature = Transaction.base_signature(tx_xdr)

    signature
    |> Signature.to_xdr(base_signature)
    |> (&DecoratedSignatures.new(current_signatures ++ [&1])).()
  end
end
