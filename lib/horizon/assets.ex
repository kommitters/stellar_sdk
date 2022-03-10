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
  @type options :: Keyword.t()
  @type resource :: Asset.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "assets"

  @doc """
  Lists all assets or by one of these filters: `asset_code` or `asset_issuer`.

  ## Options

    * `asset_code`: The code of the asset you would like to filter by.
    * `asset_issuer`: The issuer's Account ID for the asset you would like to filter by.
    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Assets.all(limit: 20, order: :desc)
      {:ok, %Collection{records: [%Asset{}, ...]}}

      # list by asset_code
      iex> Assets.all(asset_code: "TEST")
      {:ok, %Collection{records: [%Asset{}, ...]}}

      # list by asset_issuer
      iex> Assets.all(asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%Asset{}, ...]}}
  """
  @spec all(options :: options()) :: response()
  def all(options \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(options, extra_params: [:asset_code, :asset_issuer])
    |> Request.perform()
    |> Request.results(&Collection.new({Asset, &1}))
  end

  @doc """
  Lists assets matching the given asset code.

  ## Parameters:

    * `asset_code`: The code of the asset you would like to filter by.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Assets.list_by_asset_code("TEST")
      {:ok, %Collection{records: [%Asset{asset_code: "TEST"}, ...]}}
  """
  @spec list_by_asset_code(asset_code :: asset_code(), options :: options()) :: response()
  def list_by_asset_code(asset_code, options \\ []) do
    options
    |> Keyword.put(:asset_code, asset_code)
    |> all()
  end

  @doc """
  Lists assets matching the given asset issuer.

  ## Parameters:

    * `asset_issuer`: The issuer's Account ID for the asset you would like to filter by.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Assets.list_by_asset_issuer("GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD")
      {:ok, %Collection{records: [%Asset{asset_issuer: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"}, ...]}}
  """
  @spec list_by_asset_issuer(asset_issuer :: asset_issuer(), options :: options()) :: response()
  def list_by_asset_issuer(asset_issuer, options \\ []) do
    options
    |> Keyword.put(:asset_issuer, asset_issuer)
    |> all()
  end
end
