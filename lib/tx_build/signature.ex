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

  @type type :: :ed25519 | :sha256_hash | :pre_auth_tx | :ed25519_signed_payload

  @type t :: %__MODULE__{
          type: type(),
          key: String.t(),
          raw_key: binary(),
          hint: binary()
        }

  defstruct [:type, :key, :raw_key, :hint]

  @impl true
  def new(keypair, opts \\ [])

  def new({_public_key, secret}, _opts), do: new(ed25519: secret)

  def new([ed25519: secret], _opts) do
    with :ok <- KeyPair.validate_secret_seed(secret),
         do: build_signature(ed25519: secret)
  end

  def new([preimage: preimage], _opts) do
    with :ok <- validate_preimage(preimage),
         do: build_signature(preimage: preimage)
  end

  def new([pre_auth_tx: pre_auth_tx], _opts) do
    with :ok <- KeyPair.validate_pre_auth_tx(pre_auth_tx),
         do: build_signature(pre_auth_tx: pre_auth_tx)
  end

  @spec to_xdr(signature :: t(), base_signature :: binary()) :: DecoratedSignature.t()
  def to_xdr(%__MODULE__{type: :ed25519, key: key, hint: hint}, base_signature) do
    base_signature
    |> KeyPair.sign(key)
    |> decorated_signature(hint)
  end

  @impl true
  def to_xdr(%__MODULE__{raw_key: raw_key, hint: hint}),
    do: decorated_signature(raw_key, hint)

  @spec decorated_signature(raw_signature :: binary(), hint :: binary()) :: DecoratedSignature.t()
  defp decorated_signature(raw_signature, hint) do
    signature = Signature.new(raw_signature)

    hint
    |> SignatureHint.new()
    |> DecoratedSignature.new(signature)
  end

  @spec build_signature([
          {:ed25519 | :preimage | :pre_auth_tx | :ed25519_signed_payload, String.t()}
        ]) :: t()
  defp build_signature(ed25519: secret) do
    raw_secret = KeyPair.raw_secret_seed(secret)
    {public_key, _secret} = KeyPair.from_secret_seed(secret)

    signature_hint =
      public_key
      |> KeyPair.raw_public_key()
      |> (&signature_hint(ed25519: &1)).()

    %__MODULE__{
      type: :ed25519,
      key: secret,
      raw_key: raw_secret,
      hint: signature_hint
    }
  end

  defp build_signature(preimage: preimage) do
    raw_preimage = Base.decode16!(preimage, case: :lower)

    signature_hint =
      :sha256
      |> :crypto.hash(raw_preimage)
      |> (&signature_hint(sha256_hash: &1)).()

    %__MODULE__{
      type: :sha256_hash,
      key: preimage,
      raw_key: raw_preimage,
      hint: signature_hint
    }
  end

  defp build_signature(pre_auth_tx: pre_auth_tx) do
    raw_pre_auth_tx = KeyPair.raw_pre_auth_tx(pre_auth_tx)
    signature_hint = signature_hint(pre_auth_tx: raw_pre_auth_tx)

    %__MODULE__{
      type: :pre_auth_tx,
      key: pre_auth_tx,
      raw_key: raw_pre_auth_tx,
      hint: signature_hint
    }
  end

  @spec signature_hint([{type(), binary()}]) :: binary()
  defp signature_hint(ed25519: raw_public_key) do
    key_type = PublicKeyType.new(:PUBLIC_KEY_TYPE_ED25519)

    raw_public_key
    |> UInt256.new()
    |> PublicKey.new(key_type)
    |> PublicKey.encode_xdr!()
    |> extract_hint()
  end

  defp signature_hint([{_key_type, raw_key}]), do: extract_hint(raw_key)

  @spec extract_hint(raw_key :: binary()) :: binary()
  defp extract_hint(raw_key) do
    bytes_size = byte_size(raw_key)
    binary_part(raw_key, bytes_size - 4, 4)
  end

  @spec validate_preimage(preimage :: String.t()) :: :ok | {:error, :invalid_preimage}
  defp validate_preimage(preimage) do
    with {:ok, raw_preimage} <- Base.decode16(preimage),
         32 <- byte_size(raw_preimage) do
      :ok
    else
      _ -> {:error, :invalid_preimage}
    end
  end
end
