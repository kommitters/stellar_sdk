defmodule Stellar.Horizon.PaymentPaths do
  @moduledoc """
  Exposes functions to interact with Paths in Horizon.

  You can:
  * Lists the paths a payment can take based on the amount of an asset you want the recipient to receive.
  * Lists the paths a payment can take based on the amount of an asset you want to send.

  Horizon API reference: https://developers.stellar.org/api/aggregations/paths/
  """

  alias Stellar.Horizon.{Error, Paths, Request}

  @type args :: Keyword.t()
  @type opt :: atom()
  @type path :: String.t()
  @type resource :: Paths.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "paths"

  @doc """
    List Payment Paths

  ## Parameters
    * `source_account`: The Stellar address of the sender.
    * `destination_asset_type`: The type for the destination asset.
    * `destination_amount`: The amount of the destination asset that should be received.

  ## Options
    * `destination_account`: The Stellar address of the reciever.
    * `destination_asset_issuer`: The Stellar address of the issuer of the destination asset. Required if the `destination_asset_type` is not native
    * `destination_asset_code`: The code for the destination asset. Required if the `destination_asset_type` is not native.

  ## Examples

    iex> PaymentPaths.list_paths(source_account: "GBRSLTT74SKP62KJ7ENTMP5V4R7UGB6E5UQESNIIRWUNRCCUO4ZMFM4C",
                                 destination_asset_type: :native,
                                 destination_amount: 5
                                )
    {:ok, %Paths{records: [%Path{}, ...]}}

    # list with `destination_account`
    iex> PaymentPaths.list_paths(source_account: "GBRSLTT74SKP62KJ7ENTMP5V4R7UGB6E5UQESNIIRWUNRCCUO4ZMFM4C",
                                 destination_asset_type: :native,
                                 destination_amount: 5,
                                 destination_account: "GBRSLTT74SKP62KJ7ENTMP5V4R7UGB6E5UQESNIIRWUNRCCUO4ZMFM4C"
                                )
    {:ok, %Paths{records: [%Path{}, ...]}}

    # list with more options
    iex> PaymentPaths.list_paths(source_account: "GBRSLTT74SKP62KJ7ENTMP5V4R7UGB6E5UQESNIIRWUNRCCUO4ZMFM4C",
                                 destination_asset_type: "credit_alphanum4",
                                 destination_amount: 5,
                                 destination_account: "GBRSLTT74SKP62KJ7ENTMP5V4R7UGB6E5UQESNIIRWUNRCCUO4ZMFM4C",
                                 destination_asset_code: "TEST",
                                 destination_asset_issuer: "GA654JC6QLA3ZH4O5V7X5NPM7KEWHKRG5GJA4PETK4SOFBUJLCCN74KQ"
                                )
    {:ok, %Paths{records: [%Path{}, ...]}}
  """

  @spec list_paths(args :: args()) :: response()
  def list_paths(args \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(args, extra_params: allowed_query_options(:list_paths))
    |> Request.perform()
    |> Request.results(as: Paths)
  end

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

      # list with `source_account`
      iex> PaymentPaths.list_receive_paths(destination_asset_type: :native,
                                           destination_amount: 5,
                                           source_account: "GBTKSXOTFMC5HR25SNL76MOVQW7GA3F6CQEY622ASLUV4VMLITI6TCOO"
                                          )
      {:ok, %Paths{records: [%Path{}, ...]}}


      # list with `source_assets`
      iex> PaymentPaths.list_receive_paths(destination_asset_type: :native,
                                           destination_amount: 5,
                                           source_assets: :native
                                          )
      {:ok, %Paths{records: [%Path{}, ...]}}

      # list with more options
      iex> PaymentPaths.list_receive_paths(destination_asset_type: :credit_alphanum4,
                                           destination_amount: 5,
                                           destination_asset_code: "BB1",
                                           destination_asset_issuer: "GD5J6HLF5666X4AZLTFTXLY46J5SW7EXRKBLEYPJP33S33MXZGV6CWFN",
                                           source_assets: "CNY:GAREELUB43IRHWEASCFBLKHURCGMHE5IF6XSE7EXDLACYHGRHM43RFOX"
                                          )
      {:ok, %Paths{records: [%Path{}, ...]}}
  """

  @spec list_receive_paths(args :: args()) :: response()
  def list_receive_paths(args \\ []) do
    :get
    |> Request.new(@endpoint, path: "strict-receive")
    |> Request.add_query(args, extra_params: allowed_query_options(:list_receive))
    |> Request.perform()
    |> Request.results(as: Paths)
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

      * list with `destination_account`
      iex> PaymentPaths.list_send_paths(source_asset_type: :native,
                                        source_amount: 5,
                                        destination_account: "GBTKSXOTFMC5HR25SNL76MOVQW7GA3F6CQEY622ASLUV4VMLITI6TCOO"
                                      )
      {:ok, %Paths{records: [%Path{}, ...]}}

      * list with `destination_assets`
      iex> PaymentPaths.list_send_paths(source_asset_type: :native,
                                        source_amount: 5,
                                        destination_assets: "TEST:GA654JC6QLA3ZH4O5V7X5NPM7KEWHKRG5GJA4PETK4SOFBUJLCCN74KQ"
                                      )
      {:ok, %Paths{records: [%Path{}, ...]}}

      # list with more options
      iex> PaymentPaths.list_send_paths(source_asset_type: :credit_alphanum4,
                                        source_amount: 400,
                                        destination_account: "GAYOLLLUIZE4DZMBB2ZBKGBUBZLIOYU6XFLW37GBP2VZD3ABNXCW4BVA",
                                        source_asset_issuer: "GDVKY2GU2DRXWTBEYJJWSFXIGBZV6AZNBVVSUHEPZI54LIS6BA7DVVSP",
                                        source_asset_code: "BRL"
                                      )
      {:ok, %Paths{records: [%Path{}, ...]}}
  """

  @spec list_send_paths(args :: args()) :: response()
  def list_send_paths(args \\ []) do
    :get
    |> Request.new(@endpoint, path: "strict-send")
    |> Request.add_query(args, extra_params: allowed_query_options(:list_send))
    |> Request.perform()
    |> Request.results(as: Paths)
  end

  @spec allowed_query_options(opt :: opt()) :: list()
  defp allowed_query_options(:list_paths) do
    [
      :source_account,
      :destination_asset_type,
      :destination_amount,
      :destination_account,
      :destination_asset_issuer,
      :destination_asset_code
    ]
  end

  defp allowed_query_options(:list_receive) do
    [
      :destination_asset_type,
      :destination_amount,
      :source_account,
      :source_assets,
      :destination_asset_issuer,
      :destination_asset_code
    ]
  end

  defp allowed_query_options(:list_send) do
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
