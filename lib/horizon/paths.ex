defmodule Stellar.Horizon.Paths do
  @moduledoc """
  Exposes functions to interact with Paths in Horizon.

  You can:
  * Lists the paths a payment can take based on the amount of an asset you want the recipient to receive.
  * Lists the paths a payment can take based on the amount of an asset you want to send.

  Horizon API reference: https://developers.stellar.org/api/aggregations/paths/
  """

  alias Stellar.Horizon.{Error, Path, Request}

  @type destination_asset_type :: String.t()
  @type destination_amount :: String.t()
  @type source_asset_type :: String.t()
  @type source_assets :: String.t()
  @type source_amount :: String.t()
  @type options :: Keyword.t()
  @type resource :: Path.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "paths"

  @doc """
  List Strict Receive Payment Paths

  ## Parameters

    Using either `source_account` or `source_assets` as an argument is required for strict receive path payments.
    * `destination_asset_type`: The type for the destination asset.
    * `destination_amount`: The amount of the destination asset that should be received.

  ## Options

    * `source_account`: The Stellar address of the sender.
    * `source_assets`: A comma-separated list of assets available to the sender.
    * `destination_asset_issuer`: The Stellar address of the issuer of the destination asset. Required if the `destination_asset_type` is not native
    * `destination_asset_code`: The code for the destination asset. Required if the `destination_asset_type` is not native.

  ## Examples

      # list by `source_assets`
      iex> Paths.strict_receive_paths(source_assets: "CNY:GAREELUB43IRHWEASCFBLKHURCGMHE5IF6XSE7EXDLACYHGRHM43RFOX",
                                      destination_asset_type: "credit_alphanum4",
                                      destination_asset_code: "BB1",
                                      destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
                                      destination_amount: 5
                                     )
      {:ok, [%Path{}, ...]}

      # list by `source_account`
      iex> Paths.strict_receive_paths(source_account: "GBTKSXOTFMC5HR25SNL76MOVQW7GA3F6CQEY622ASLUV4VMLITI6TCOO",
                                      destination_asset_type: "native",
                                      destination_amount: 5
                                      )
      {:ok, [%Path{}, ...]}
  """

  @spec strict_receive_paths(options :: options()) :: response()
  def strict_receive_paths(options \\ []) do
    :get
    |> Request.new(@endpoint, path: "strict-receive")
    |> Request.add_query(options, extra_params: allowed_receive_query_options())
    |> Request.perform()
    |> Request.results(collection: {Path})
  end

  @doc """
  List Strict Send Payment Paths

  ## Parameters
      Using either `destination_account` or `destination_assets` as an argument is required for strict send path payments.
      * `source_asset_type`: The type for the source asset
      * `source_amount`: The amount of the source asset that should be sent.

  ## Options
      * `source_asset_issuer`: The Stellar address of the issuer of the source asset. Required if the `source_asset_type` is not native.
      * `source_asset_code`: The code for the source asset. Required if the `source_asset_type` is not native.
      * `destination_account`: The Stellar address of the reciever.
      * `destination_assets`: A comma-separated list of assets that the recipient can receive.

  ## Examples

      * list by `destination_account`
      iex> Paths.strict_send_paths(source_asset_type: "credit_alphanum4",
                                   source_asset_code: "BRL",
                                   source_asset_issuer: "GDVKY2GU2DRXWTBEYJJWSFXIGBZV6AZNBVVSUHEPZI54LIS6BA7DVVSP",
                                   source_amount: 400,
                                   destination_account: "GAYOLLLUIZE4DZMBB2ZBKGBUBZLIOYU6XFLW37GBP2VZD3ABNXCW4BVA"
                                  )
      {:ok, [%Path{}, ...]}

      * list by `destination_assets`
      iex> Paths.strict_send_paths(destination_assets: "TEST:GA654JC6QLA3ZH4O5V7X5NPM7KEWHKRG5GJA4PETK4SOFBUJLCCN74KQ",
                                   source_asset_type: "native",
                                   source_amount: 5
                                  )
      {:ok, [%Path{}, ...]}
  """

  @spec strict_send_paths(options :: options()) :: response()
  def strict_send_paths(options \\ []) do
    :get
    |> Request.new(@endpoint, path: "strict-send")
    |> Request.add_query(options, extra_params: allowed_send_query_options())
    |> Request.perform()
    |> Request.results(collection: {Path})
  end

  @spec allowed_receive_query_options() :: list()
  defp allowed_receive_query_options do
    [
      :source_account,
      :destination_amount,
      :destination_asset_type,
      :source_assets,
      :destination_asset_issuer,
      :destination_asset_code
    ]
  end

  @spec allowed_send_query_options() :: list()
  defp allowed_send_query_options do
    [
      :source_asset_type,
      :source_amount,
      :source_asset_issuer,
      :source_asset_code,
      :destination_account,
      :destination_assets
    ]
  end
end
