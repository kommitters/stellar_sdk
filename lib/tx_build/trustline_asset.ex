defmodule Stellar.TxBuild.TrustlineAsset do
  @moduledoc """
  `TrustlineAsset` struct definition.
  """
  alias Stellar.TxBuild.{AccountID, PoolID}

  alias StellarBase.XDR.{
    AlphaNum4,
    AlphaNum12,
    AssetCode4,
    AssetCode12,
    TrustLineAsset,
    AssetType,
    Void
  }

  @behaviour Stellar.TxBuild.XDR

  @type asset :: atom() | Keyword.t()
  @type type :: :native | :alpha_num4 | :alpha_num12 | :pool_share
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{asset: asset(), type: type()}

  defstruct [:type, :asset]

  @impl true
  def new(args, opts \\ [])

  def new(:native, _opts) do
    %__MODULE__{asset: [code: "XLM", issuer: nil], type: :native}
  end

  def new([pool_id: pool_id], _opts) do
    case PoolID.new(pool_id) do
      %PoolID{} = pool_id -> %__MODULE__{asset: [pool_id: pool_id], type: :pool_share}
      error -> error
    end
  end

  def new([code: code, issuer: issuer], _opts) do
    code = code |> to_string() |> String.trim()

    with {:ok, code} <- validate_asset_code(code),
         {:ok, issuer} <- validate_asset_issuer(issuer) do
      %__MODULE__{asset: [code: code, issuer: issuer], type: asset_type(code)}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_trustline_asset}

  @impl true
  def to_xdr(%__MODULE__{type: :native}) do
    TrustLineAsset.new(Void.new(), AssetType.new(:ASSET_TYPE_NATIVE))
  end

  def to_xdr(%__MODULE__{asset: [pool_id: pool_id], type: :pool_share}) do
    pool_id
    |> PoolID.to_xdr()
    |> TrustLineAsset.new(AssetType.new(:ASSET_TYPE_POOL_SHARE))
  end

  def to_xdr(%__MODULE__{asset: [code: code, issuer: issuer], type: :alpha_num4}) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM4)
    issuer = AccountID.to_xdr(issuer)

    code
    |> AssetCode4.new()
    |> AlphaNum4.new(issuer)
    |> TrustLineAsset.new(asset_type)
  end

  def to_xdr(%__MODULE__{asset: [code: code, issuer: issuer], type: :alpha_num12}) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM12)
    issuer = AccountID.to_xdr(issuer)

    code
    |> AssetCode12.new()
    |> AlphaNum12.new(issuer)
    |> TrustLineAsset.new(asset_type)
  end

  @spec validate_asset_code(code :: String.t()) :: validation()
  defp validate_asset_code(code) when is_bitstring(code) and byte_size(code) < 13, do: {:ok, code}
  defp validate_asset_code(_code), do: {:error, :invalid_asset_code}

  @spec validate_asset_issuer(issuer :: String.t()) :: validation()
  defp validate_asset_issuer(issuer) do
    case AccountID.new(issuer) do
      %AccountID{} = issuer -> {:ok, issuer}
      _error -> {:error, :invalid_asset_issuer}
    end
  end

  @spec asset_type(code :: String.t()) :: atom()
  defp asset_type(code) when byte_size(code) < 5, do: :alpha_num4
  defp asset_type(_code), do: :alpha_num12
end
