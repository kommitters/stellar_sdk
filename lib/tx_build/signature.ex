defmodule Stellar.TxBuild.Signature do
  @moduledoc """
  `Signature` struct definition.
  """
  alias Stellar.KeyPair

  alias StellarBase.XDR.{
    DecoratedSignature,
    Signature,
    SignatureHint,
    PublicKey,
    PublicKeyType,
    UInt256
  }

  @behaviour Stellar.TxBuild.Resource

  @type t :: %__MODULE__{
          public_key: String.t(),
          secret: String.t(),
          raw_public_key: binary(),
          raw_secret: binary(),
          hint: binary()
        }

  defstruct [:public_key, :secret, :raw_public_key, :raw_secret, :hint]

  @impl true
  def new(public_key, secret) do
    raw_public_key = KeyPair.raw_ed25519_public_key(public_key)
    raw_secret = KeyPair.raw_ed25519_secret(secret)
    signature_hint = signature_hint(raw_public_key)

    %__MODULE__{
      public_key: public_key,
      raw_public_key: raw_public_key,
      secret: secret,
      raw_secret: raw_secret,
      hint: signature_hint
    }
  end

  @spec to_xdr(signature :: t(), base_signature :: binary()) :: DecoratedSignature.t()
  def to_xdr(%__MODULE__{hint: hint, secret: secret}, base_signature) do
    base_signature
    |> KeyPair.sign(secret)
    |> decorated_signature(hint)
  end

  @impl true
  def to_xdr(%__MODULE__{hint: hint, raw_secret: raw_secret}),
    do: decorated_signature(raw_secret, hint)

  @spec decorated_signature(raw_signature :: binary(), hint :: binary()) :: DecoratedSignature.t()
  defp decorated_signature(raw_signature, hint) do
    signature = Signature.new(raw_signature)

    hint
    |> SignatureHint.new()
    |> DecoratedSignature.new(signature)
  end

  @spec signature_hint(raw_public_key :: binary()) :: binary()
  defp signature_hint(raw_public_key) do
    key_type = PublicKeyType.new(:PUBLIC_KEY_TYPE_ED25519)

    raw_public_key
    |> UInt256.new()
    |> PublicKey.new(key_type)
    |> PublicKey.encode_xdr!()
    |> public_key_hint()
  end

  @spec public_key_hint(encoded_public_key :: binary()) :: binary()
  defp public_key_hint(encoded_public_key) do
    bytes_size = byte_size(encoded_public_key)
    binary_part(encoded_public_key, bytes_size - 4, 4)
  end
end
