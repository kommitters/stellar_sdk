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

  @behaviour Stellar.TxBuild.XDR

  @type type :: :ed25519 | :hash_x | :signed_payload
  @type key :: String.t() | {String.t(), String.t()}
  @type raw_key :: binary() | {binary(), binary()}

  @type t :: %__MODULE__{
          type: type(),
          key: key(),
          raw_key: raw_key(),
          hint: binary()
        }

  defstruct [:type, :key, :raw_key, :hint]

  @impl true
  def new(args, opts \\ [])

  def new({_public_key, secret}, _opts), do: new(ed25519: secret)

  def new([ed25519: secret], _opts) do
    case KeyPair.validate_secret_seed(secret) do
      :ok -> build_signature(ed25519: secret)
      error -> error
    end
  end

  def new([hash_x: preimage], _opts) do
    case validate_preimage(preimage) do
      :ok -> build_signature(hash_x: preimage)
      error -> error
    end
  end

  def new([signed_payload: {payload, secret}], _opts) do
    with :ok <- validate_payload(payload),
         :ok <- KeyPair.validate_secret_seed(secret),
         do: build_signature(signed_payload: {payload, secret})
  end

  @spec to_xdr(signature :: t(), base_signature :: binary()) :: DecoratedSignature.t()
  def to_xdr(%__MODULE__{type: :ed25519, key: secret, hint: hint}, base_signature) do
    base_signature
    |> KeyPair.sign(secret)
    |> decorated_signature(hint)
  end

  def to_xdr(%__MODULE__{} = signature, _base_signature), do: to_xdr(signature)

  @impl true
  def to_xdr(%__MODULE__{
        type: :signed_payload,
        key: {_payload, secret},
        raw_key: {raw_payload, _raw_secret},
        hint: hint
      })
      when byte_size(raw_payload) < 4 do
    zeros_needed = 4 - byte_size(raw_payload)

    <<raw_payload::binary, 0::zeros_needed*8>>
    |> KeyPair.sign(secret)
    |> decorated_signature(hint)
  end

  def to_xdr(%__MODULE__{
        type: :signed_payload,
        key: {_payload, secret},
        raw_key: {raw_payload, _raw_secret},
        hint: hint
      }) do
    raw_payload
    |> KeyPair.sign(secret)
    |> decorated_signature(hint)
  end

  def to_xdr(%__MODULE__{raw_key: raw_key, hint: hint}),
    do: decorated_signature(raw_key, hint)

  @spec decorated_signature(raw_signature :: binary(), hint :: binary()) :: DecoratedSignature.t()
  defp decorated_signature(raw_signature, hint) do
    signature = Signature.new(raw_signature)

    hint
    |> SignatureHint.new()
    |> DecoratedSignature.new(signature)
  end

  @spec build_signature([{type(), String.t() | tuple()}]) :: t()
  defp build_signature(ed25519: secret) do
    raw_secret = KeyPair.raw_secret_seed(secret)
    signature_hint = signature_hint(ed25519: raw_secret)

    %__MODULE__{
      type: :ed25519,
      key: secret,
      raw_key: raw_secret,
      hint: signature_hint
    }
  end

  defp build_signature(hash_x: preimage) do
    raw_preimage = Base.decode16!(preimage, case: :lower)
    signature_hint = signature_hint(hash_x: raw_preimage)

    %__MODULE__{
      type: :hash_x,
      key: preimage,
      raw_key: raw_preimage,
      hint: signature_hint
    }
  end

  defp build_signature(signed_payload: {payload, secret}) do
    raw_payload = Base.decode16!(payload, case: :lower)
    raw_secret = KeyPair.raw_secret_seed(secret)

    {public_key, _secret} = KeyPair.from_secret_seed(secret)

    signature_hint =
      public_key
      |> KeyPair.raw_public_key()
      |> KeyPair.signature_hint_for_signed_payload(raw_payload)

    %__MODULE__{
      type: :signed_payload,
      key: {payload, secret},
      raw_key: {raw_payload, raw_secret},
      hint: signature_hint
    }
  end

  @spec signature_hint([{type(), binary()}]) :: binary()
  defp signature_hint(ed25519: raw_secret) do
    key_type = PublicKeyType.new(:PUBLIC_KEY_TYPE_ED25519)

    raw_secret
    |> Ed25519.derive_public_key()
    |> UInt256.new()
    |> PublicKey.new(key_type)
    |> PublicKey.encode_xdr!()
    |> extract_hint()
  end

  defp signature_hint(hash_x: raw_preimage) do
    :sha256
    |> :crypto.hash(raw_preimage)
    |> extract_hint()
  end

  @spec extract_hint(raw_key :: binary()) :: binary()
  defp extract_hint(raw_key) do
    bytes_size = byte_size(raw_key)
    binary_part(raw_key, bytes_size, -4)
  end

  @spec validate_preimage(preimage :: String.t()) :: :ok | {:error, :invalid_preimage}
  defp validate_preimage(preimage) do
    with {:ok, raw_preimage} <- Base.decode16(preimage, case: :lower),
         32 <- byte_size(raw_preimage) do
      :ok
    else
      _ -> {:error, :invalid_preimage}
    end
  end

  @spec validate_payload(payload :: String.t()) :: :ok | {:error, :invalid_payload}
  defp validate_payload(payload) do
    with {:ok, raw_payload} <- Base.decode16(payload, case: :lower),
         size <- byte_size(raw_payload),
         true <- size <= 32 do
      :ok
    else
      _ -> {:error, :invalid_payload}
    end
  end
end
