defmodule Stellar.TxBuild.FromAsset do
  @moduledoc """
  `FromAsset` struct definition.
  """

  alias StellarBase.XDR.{FromAsset, Hash}
  alias Stellar.TxBuild.Asset

  @type t :: %__MODULE__{
          network_id: binary(),
          asset: Asset.t()
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:network_id, :asset]

  @impl true
  def new(args, opts \\ nil)

  def new(
        [
          network_id,
          %Asset{} = asset
        ],
        _opts
      )
      when is_binary(network_id) do
    %__MODULE__{
      network_id: network_id,
      asset: asset
    }
  end

  def new(_args, _opts), do: {:error, :invalid_from_asset}

  @impl true
  def to_xdr(%__MODULE__{
        network_id: network_id,
        asset: asset
      }) do
    network_id = Hash.new(network_id)
    asset = Asset.to_xdr(asset)

    FromAsset.new(network_id, asset)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_from_asset}
end
