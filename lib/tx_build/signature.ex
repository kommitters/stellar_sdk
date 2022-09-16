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
  @type key :: String.t()
  @type signer :: {type(), key()}
  @type validation :: {:ok, any()} | {:error, atom()}

  # @type t :: %__MODULE__{
  #         public_key: String.t(),
  #         secret: String.t(),
  #         raw_public_key: binary(),
  #         raw_secret: binary(),
  #         hint: binary()
  #       }

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

  # preimage: random 32 bytes (256 bits) in binary
  # NOTE: preimage is received, instead of hash(preimage).
  # TODO: preimage should be in string, not in raw binary
  def new([preimage: preimage], _opts) do
    with :ok <- validate_preimage(preimage),
         do: build_signature(preimage: preimage)
  end

  def new([pre_auth_tx: pre_auth_tx], _opts) do
    with :ok <- KeyPair.validate_pre_auth_tx(pre_auth_tx),
         do: build_signature(pre_auth_tx: pre_auth_tx)
  end

  @spec to_xdr(signature :: t(), base_signature :: binary()) :: DecoratedSignature.t()
  def to_xdr(%__MODULE__{type: :ed25519, key: secret, hint: hint}, base_signature) do
    base_signature
    |> KeyPair.sign(secret)
    |> decorated_signature(hint)
  end

  # works for ed25519, sha256_hash, tx_pre_auth
  # TODO: replace raw_secret with raw_key (DONE)
  @impl true
  def to_xdr(%__MODULE__{hint: hint, raw_key: raw_key}),
    do: decorated_signature(raw_key, hint)

  @spec decorated_signature(raw_signature :: binary(), hint :: binary()) :: DecoratedSignature.t()
  defp decorated_signature(raw_signature, hint) do
    signature = Signature.new(raw_signature)

    hint
    |> SignatureHint.new()
    |> DecoratedSignature.new(signature)
  end

  # @spec build_signature(public_key :: String.t(), secret :: String.t()) :: t()
  defp build_signature(ed25519: secret) do
    raw_secret = KeyPair.raw_secret_seed(secret)
    signature_hint = signature_hint(ed25519: secret)

    %__MODULE__{
      type: :ed25519,
      key: secret,
      raw_key: raw_secret,
      hint: signature_hint
    }
  end

  defp build_signature(preimage: preimage) do
    sha256_hash = :crypto.hash(:sha256, preimage)
    signature_hint = signature_hint(sha256_hash: sha256_hash)
    # raw_sha256_hash = KeyPair.raw_sha256_hash(sha256_hash)
    # TODO: preimage should be in string, not in raw binary

    %__MODULE__{
      type: :sha256_hash,
      key: preimage,
      raw_key: preimage,
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

  defp signature_hint(ed25519: secret) do
    key_type = PublicKeyType.new(:PUBLIC_KEY_TYPE_ED25519)
    {public_key, _secret} = KeyPair.from_secret_seed(secret)

    public_key
    |> KeyPair.raw_public_key()
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

  defp validate_preimage(preimage) do
    case byte_size(preimage) do
      32 -> :ok
      _byte_size -> {:error, :invalid_preimage}
    end
  end
end
