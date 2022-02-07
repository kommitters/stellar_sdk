defmodule Stellar.TxBuild.AssetsPath do
  @moduledoc """
  `AssetsPath` struct definition.
  """
  alias Stellar.TxBuild.Asset
  alias StellarBase.XDR.Assets

  @behaviour Stellar.TxBuild.XDR

  @type assets :: Asset.t() | list(Asset.t())
  @type error :: {:error, atom()}

  @type t :: %__MODULE__{assets: list(Asset.t())}

  defstruct [:assets]

  @impl true
  def new(assets \\ [], opts \\ [])

  def new(assets, _opts) do
    build_path(%__MODULE__{assets: []}, assets)
  end

  @impl true
  def to_xdr(%__MODULE__{assets: assets}) do
    assets
    |> Enum.map(&Asset.to_xdr/1)
    |> Assets.new()
  end

  @spec build_path(path :: t(), assets :: assets()) :: t() | error()
  defp build_path(%__MODULE__{} = path, []), do: path

  defp build_path(%__MODULE__{} = path, [asset | assets]) do
    with %Asset{} = asset <- Asset.new(asset) do
      path
      |> build_path(asset)
      |> build_path(assets)
    end
  end

  defp build_path(%__MODULE__{assets: assets} = path, %Asset{} = asset) do
    %{path | assets: assets ++ [asset]}
  end
end
