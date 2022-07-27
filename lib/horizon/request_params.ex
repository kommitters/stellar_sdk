defmodule Stellar.Horizon.RequestParams do
  @moduledoc """
  Returns a Keyword list of formatted params
  """

  @type args :: Keyword.t()
  @type type :: atom()

  @spec build_assets_params(args :: args(), type :: type()) :: Keyword.t()
  def build_assets_params(args, type) when type in ~w(selling_asset buying_asset)a do
    args
    |> Keyword.get(type)
    |> resolve_asset_params(type)
  end

  def build_assets_params(_args, _type), do: []

  @spec resolve_asset_params(args :: args(), type :: type()) :: Keyword.t()
  defp resolve_asset_params([code: code, issuer: issuer], type) do
    [
      "#{type}_type": resolve_asset_type(code),
      "#{type}_code": code,
      "#{type}_issuer": issuer
    ]
  end

  defp resolve_asset_params(:native, type), do: ["#{type}_type": :native]
  defp resolve_asset_params(_args, _type), do: []

  @spec resolve_asset_type(code :: String.t()) :: atom()
  defp resolve_asset_type(code) when byte_size(code) < 5, do: :credit_alphanum4
  defp resolve_asset_type(_code), do: :credit_alphanum12
end
