defmodule Stellar.TxBuild.SignerKey do
  @moduledoc """
  `SignerKey` struct definition.
  """
  alias Stellar.KeyPair
  alias StellarBase.XDR.{SignerKey, SignerKeyType, UInt256}

  @behaviour Stellar.TxBuild.XDR

  @type type :: :ed25519 | :sha256_hash | :pre_auth_tx
  @type key :: String.t()
  @type signer :: {type(), key()}
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{type: type(), key: key()}

  defstruct [:type, :key]

  @impl true
  def new(args, opts \\ [])

  def new({type, key}, _opts) do
    with {:ok, type} <- validate_signer_type(type),
         {:ok, key} <- validate_signer_key({type, key}) do
      %__MODULE__{type: type, key: key}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_signer_key}

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
    |> (&:crypto.hash(:sha256, &1)).()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
  end

  def to_xdr(%__MODULE__{type: :pre_auth_tx, key: key}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_PRE_AUTH_TX)

    key
    |> (&:crypto.hash(:sha256, &1)).()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
  end

  @spec validate_signer_type(type :: type()) :: validation()
  defp validate_signer_type(type) when type in ~w(ed25519 sha256_hash pre_auth_tx)a,
    do: {:ok, type}

  defp validate_signer_type(_type), do: {:error, :invalid_signer_type}

  @spec validate_signer_key(signer :: signer()) :: validation()
  defp validate_signer_key({:ed25519, key}) do
    case KeyPair.validate_public_key(key) do
      :ok -> {:ok, key}
      _error -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key({type, key})
       when type in [:sha256_hash, :pre_auth_tx] and byte_size(key) == 64,
       do: {:ok, key}

  defp validate_signer_key(_type), do: {:error, :invalid_signer_key}
end
