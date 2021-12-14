defmodule Stellar.TxBuild.Asset do
  @moduledoc """
  `Asset` struct definition.
  """
  alias Stellar.TxBuild.AccountID
  alias StellarBase.XDR.{AlphaNum4, AlphaNum12, AssetCode4, AssetCode12, Asset, AssetType, Void}

  @behaviour Stellar.TxBuild.XDR

  @type issuer :: AccountID.t() | nil
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{code: String.t(), issuer: issuer(), type: atom()}

  defstruct [:code, :issuer, :type]

  @impl true
  def new(args, opts \\ [])

  def new(:native, _opts) do
    %__MODULE__{code: "XLM", issuer: nil, type: :native}
  end

  def new({code, issuer}, _opts), do: new(code: code, issuer: issuer)

  def new(args, _opts) when is_list(args) do
    code = Keyword.get(args, :code, "") |> String.trim()
    issuer = Keyword.get(args, :issuer)

    with {:ok, code} <- validate_asset_code(code),
         {:ok, issuer} <- validate_asset_issuer(issuer) do
      %__MODULE__{type: asset_type(code), code: code, issuer: issuer}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_asset}

  @impl true
  def to_xdr(%__MODULE__{type: :native}) do
    Asset.new(Void.new(), AssetType.new(:ASSET_TYPE_NATIVE))
  end

  def to_xdr(%__MODULE__{code: code, issuer: issuer, type: :alpha_num4}) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM4)
    issuer = AccountID.to_xdr(issuer)

    code
    |> AssetCode4.new()
    |> AlphaNum4.new(issuer)
    |> Asset.new(asset_type)
  end

  def to_xdr(%__MODULE__{code: code, issuer: issuer, type: :alpha_num12}) do
    asset_type = AssetType.new(:ASSET_TYPE_CREDIT_ALPHANUM12)
    issuer = AccountID.to_xdr(issuer)

    code
    |> AssetCode12.new()
    |> AlphaNum12.new(issuer)
    |> Asset.new(asset_type)
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
