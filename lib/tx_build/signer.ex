defmodule Stellar.TxBuild.Signer do
  @moduledoc """
  `Signer` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias Stellar.KeyPair
  alias Stellar.TxBuild.{Weight, SignerKey}
  alias StellarBase.StrKey
  alias StellarBase.XDR.{Signer, VariableOpaque64, UInt256, SignerKeyEd25519SignedPayload}

  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{signer_key: SignerKey.t(), weight: Weight.t()}

  defstruct [:signer_key, :weight]

  @impl true
  def new(args, opts \\ [])

  def new([{_signer_type, _signer_key} = signer_key_tuple, {:weight, weight}], _opts) do
    with {:ok, signer_key} <- validate_signer_key_tuple(signer_key_tuple),
         {:ok, weight} <- validate_signer_weight(weight) do
      %__MODULE__{signer_key: signer_key, weight: weight}
    end
  end

  def new({signer_key, weight}, _opts) do
    with {:ok, signer_key} <- validate_signer_key(signer_key),
         {:ok, weight} <- validate_signer_weight(weight) do
      %__MODULE__{signer_key: signer_key, weight: weight}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_signer}

  @impl true
  def to_xdr(%__MODULE__{signer_key: signer_key, weight: weight}) do
    weight_xdr = Weight.to_xdr(weight)

    signer_key
    |> SignerKey.to_xdr()
    |> Signer.new(weight_xdr)
  end

  @spec validate_signer_weight(weight :: non_neg_integer()) :: validation()
  defp validate_signer_weight(weight) do
    case Weight.new(weight) do
      %Weight{} = weight -> {:ok, weight}
      {:error, _reason} -> {:error, :invalid_signer_weight}
    end
  end

  @spec validate_signer_key_tuple(signer_key :: tuple()) :: validation()
  defp validate_signer_key_tuple({:pre_auth_tx, signer_key}) do
    with {:ok, raw_pre_auth_tx} <- Base.decode16(signer_key, case: :lower),
         32 <- byte_size(raw_pre_auth_tx),
         pre_auth_tx <- StrKey.encode!(raw_pre_auth_tx, :pre_auth_tx) do
      {:ok, SignerKey.new(pre_auth_tx)}
    else
      _ -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key_tuple({:hash_x, signer_key}) do
    with {:ok, raw_hash_x} <- Base.decode16(signer_key, case: :lower),
         32 <- byte_size(raw_hash_x),
         hash_x <- StrKey.encode!(raw_hash_x, :sha256_hash) do
      {:ok, SignerKey.new(hash_x)}
    else
      _ -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key_tuple({:signed_payload, [ed25519: public_key, payload: payload]}) do
    with :ok <- KeyPair.validate_public_key(public_key),
         {:ok, raw_payload} <- Base.decode16(payload, case: :lower),
         size <- byte_size(raw_payload),
         true <- size <= 32 do
      payload_xdr = VariableOpaque64.new(raw_payload)

      signed_payload_signer_key =
        public_key
        |> StrKey.decode!(:ed25519_public_key)
        |> UInt256.new()
        |> SignerKeyEd25519SignedPayload.new(payload_xdr)
        |> SignerKeyEd25519SignedPayload.encode_xdr!()
        |> StrKey.encode!(:signed_payload)
        |> SignerKey.new()

      {:ok, signed_payload_signer_key}
    else
      _ -> {:error, :invalid_signer_key}
    end
  end

  defp validate_signer_key_tuple({:ed25519, public_key}), do: validate_signer_key(public_key)

  defp validate_signer_key(signer_key) do
    case SignerKey.new(signer_key) do
      %SignerKey{} = signer_key -> {:ok, signer_key}
      _error -> {:error, :invalid_signer_key}
    end
  end
end
