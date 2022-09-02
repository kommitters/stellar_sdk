defmodule Stellar.TxBuild.Signer do
  @moduledoc """
  `Signer` struct definition.
  """
  alias Stellar.TxBuild.{Weight, SignerKey}
  alias StellarBase.XDR.Signer

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{signer_key: SignerKey.t(), weight: Weight.t()}

  defstruct [:signer_key, :weight]

  @impl true
  def new(args, opts \\ [])

  def new([{_key_type, signer_key}, {:weight, weight}], _opts), do: new({signer_key, weight})

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

  @spec validate_signer_key(signer_key :: String.t()) :: validation()
  defp validate_signer_key(signer_key) do
    case SignerKey.new(signer_key) do
      %SignerKey{} = signer_key -> {:ok, signer_key}
      _error -> {:error, :invalid_signer_key}
    end
  end
end
