defmodule Stellar.Horizon.FeeStats do
  @moduledoc """
  Exposes functions to interact with FeeStats in Horizon.

  You can:
  * Retrieve the fee stats.

  Horizon API reference: https://developers.stellar.org/api/aggregations/fee-stats/
  """

  alias Stellar.Horizon.{Error, FeeStat, Request, Server}

  @type server :: Server.t()
  @type resource :: FeeStat.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "fee_stats"

  @doc """
  Retrieves information of the fee stats.

  ## Parameters
    * `server`: The Horizon server to query.

  ## Examples

      iex> FeeStats.retrieve(Stellar.Horizon.Server.testnet())
      {:ok, %FeeStat{}}
  """

  @spec retrieve(server :: server()) :: response()
  def retrieve(server) do
    server
    |> Request.new(:get, @endpoint)
    |> Request.perform()
    |> Request.results(as: FeeStat)
  end
end
