defmodule Stellar.TxBuild.SignerKey do
  @moduledoc """
  `SignerKey` struct definition.
  """
  alias Stellar.KeyPair
  alias StellarBase.StrKey

  alias StellarBase.XDR.{
    SignerKey,
    SignerKeyType,
    UInt256,
    SignerKeyEd25519SignedPayload,
    VariableOpaque64
  }

  @behaviour Stellar.TxBuild.XDR

  @type type :: :ed25519 | :sha256_hash | :pre_auth_tx | :ed25519_signed_payload
  @type key :: String.t()
  @type signer :: {type(), key()}
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{type: type(), key: key()}

  defstruct [:type, :key]

  @impl true
  def new(args, opts \\ [])

  def new(key, _opts) do
    with {:ok, type} <- get_signer_type(key),
         {:ok, key} <- validate_signer_key({type, key}) do
      %__MODULE__{type: type, key: key}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{type: :ed25519, key: key}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_ED25519)

    key
    |> KeyPair.raw_public_key()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
  end

  def to_xdr(%__MODULE__{type: :sha256_hash, key: key}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_HASH_X)

    key
    |> KeyPair.raw_sha256_hash()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
  end

  def to_xdr(%__MODULE__{type: :pre_auth_tx, key: key}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_PRE_AUTH_TX)

    key
    |> KeyPair.raw_pre_auth_tx()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
  end

  def to_xdr(%__MODULE__{type: :ed25519_signed_payload, key: key}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_ED25519_SIGNED_PAYLOAD)

    <<key::binary-size(32), _payload_size::binary-size(4), payload::binary>> =
      StrKey.decode!(key, :signed_payload)

    payload = VariableOpaque64.new(payload)

    key
    |> UInt256.new()
    |> SignerKeyEd25519SignedPayload.new(payload)
    |> SignerKey.new(signer_type)
  end

  @spec get_signer_type(key :: key()) :: validation()
  defp get_signer_type(key) do
    case String.first(key) do
      "G" -> {:ok, :ed25519}
      "T" -> {:ok, :pre_auth_tx}
      "X" -> {:ok, :sha256_hash}
      "P" -> {:ok, :ed25519_signed_payload}
      _error -> {:error, :invalid_signer_type}
    end
  end

  @spec validate_signer_key(signer :: signer()) :: validation()
  defp validate_signer_key({:ed25519, key}) do
    case KeyPair.validate_public_key(key) do
      :ok -> {:ok, key}
      _error -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key({:pre_auth_tx, key}) do
    case KeyPair.validate_pre_auth_tx(key) do
      :ok -> {:ok, key}
      _error -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key({:sha256_hash, key}) do
    case KeyPair.validate_sha256_hash(key) do
      :ok -> {:ok, key}
      _error -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key({:ed25519_signed_payload, key}) do
    case KeyPair.validate_signed_payload(key) do
      :ok -> {:ok, key}
      _error -> {:error, :invalid_signer_key}
    end
  end
end
