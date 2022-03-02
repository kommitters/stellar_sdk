defmodule Stellar.Horizon.Assets do
  @moduledoc """
  Exposes functions to interact with Assets in Horizon.

  You can:
  * List all assets.
  * List assets by asset_code.
  * List assets by asset_issuer.

  Horizon API reference: https://developers.stellar.org/api/resources/assets/
  """

  alias Stellar.Horizon.{Asset, Collection, Error, Request}

  @type asset_code :: String.t()
  @type asset_issuer :: String.t()
  @type params :: Keyword.t()
  @type resource :: Asset.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "assets"

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: [:asset_code, :asset_issuer])
    |> Request.perform()
    |> Request.results(&Collection.new({Asset, &1}))
  end

  @spec list_by_asset_code(asset_code :: asset_code(), params :: params()) :: response()
  def list_by_asset_code(asset_code, params \\ []) do
    params
    |> Keyword.put(:asset_code, asset_code)
    |> all()
  end

  @spec list_by_asset_issuer(asset_issuer :: asset_issuer(), params :: params()) :: response()
  def list_by_asset_issuer(asset_issuer, params \\ []) do
    params
    |> Keyword.put(:asset_issuer, asset_issuer)
    |> all()
  end
end
