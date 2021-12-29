defmodule Stellar.TxBuild.Signer do
  @moduledoc """
  `Signer` struct definition.
  """
  alias Stellar.KeyPair
  alias Stellar.TxBuild.Weight
  alias StellarBase.XDR.{Signer, SignerKey, SignerKeyType, UInt256}

  @behaviour Stellar.TxBuild.XDR

  @type signer_type :: :ed25519 | :sha256_hash | :pre_auth_tx
  @type signer_key :: String.t()
  @type signer :: {signer_type(), signer_key()}
  @type weight :: Weight.t()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{type: signer_type(), key: signer_key(), weight: weight()}

  defstruct [:type, :key, :weight]

  @signer_types [:ed25519, :sha256_hash, :pre_auth_tx]

  @impl true
  def new(args, opts \\ [])

  def new([{type, key}, {:weight, weight}], _opts) do
    with {:ok, type} <- validate_signer_type(type),
         {:ok, key} <- validate_signer_key({type, key}),
         {:ok, weight} <- validate_signer_weight(weight) do
      %__MODULE__{type: type, key: key, weight: weight}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_signer}

  @impl true
  def to_xdr(%__MODULE__{type: :ed25519, key: key, weight: weight}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_ED25519)
    weight = Weight.to_xdr(weight)

    key
    |> KeyPair.raw_ed25519_public_key()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
    |> Signer.new(weight)
  end

  def to_xdr(%__MODULE__{type: :sha256_hash, key: key, weight: weight}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_HASH_X)
    weight = Weight.to_xdr(weight)

    key
    |> (&:crypto.hash(:sha256, &1)).()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
    |> Signer.new(weight)
  end

  def to_xdr(%__MODULE__{type: :pre_auth_tx, key: key, weight: weight}) do
    signer_type = SignerKeyType.new(:SIGNER_KEY_TYPE_PRE_AUTH_TX)
    weight = Weight.to_xdr(weight)

    key
    |> (&:crypto.hash(:sha256, &1)).()
    |> UInt256.new()
    |> SignerKey.new(signer_type)
    |> Signer.new(weight)
  end

  @spec validate_signer_type(type :: signer_type()) :: validation()
  defp validate_signer_type(type) when type in @signer_types, do: {:ok, type}
  defp validate_signer_type(_type), do: {:error, :invalid_signer_type}

  @spec validate_signer_weight(weight :: non_neg_integer()) :: validation()
  defp validate_signer_weight(weight) do
    case Weight.new(weight) do
      %Weight{} = weight -> {:ok, weight}
      {:error, _reason} -> {:error, :invalid_signer_weight}
    end
  end

  @spec validate_signer_key(signer :: signer()) :: validation()
  defp validate_signer_key({:ed25519, key}) do
    case KeyPair.validate_ed25519_public_key(key) do
      :ok -> {:ok, key}
      _error -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key({type, key})
       when type in [:sha256_hash, :pre_auth_tx] and byte_size(key) == 64,
       do: {:ok, key}

  defp validate_signer_key(_type), do: {:error, :invalid_signer_key}
end
