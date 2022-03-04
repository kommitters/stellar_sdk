defmodule Stellar.Horizon.Trades do
  @moduledoc """
  Exposes functions to interact with Trades in Horizon.

  You can:
  * List all trades.

  Horizon API reference: https://developers.stellar.org/api/resources/trades/
  """

  alias Stellar.Horizon.{Collection, Error, Request, Trade}

  @type params :: Keyword.t()
  @type resource :: Trade.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "trades"

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params, extra_params: allowed_query_params())
    |> Request.perform()
    |> Request.results(&Collection.new({Trade, &1}))
  end

  @spec allowed_query_params() :: list()
  defp allowed_query_params do
    [
      :offer_id,
      :base_asset_type,
      :base_asset_issuer,
      :base_asset_code,
      :counter_asset_type,
      :counter_asset_issuer,
      :counter_asset_code,
      :trade_type
    ]
  end
end
