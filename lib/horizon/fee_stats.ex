defmodule Stellar.Horizon.FeeStats do
  @moduledoc """
  Exposes functions to interact with FeeStats in Horizon.

  You can:
  * Retrieve the fee stats.

  Horizon API reference: https://developers.stellar.org/api/aggregations/fee-stats/
  """

  alias Stellar.Horizon.{Error, FeeStat, Request}

  @type resource :: FeeStat.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "fee_stats"

  @doc """
  Retrieves information of the fee stats.

  ## Examples

      iex> FeeStats.retrieve()
      {:ok, %FeeStat{}}
  """

  @spec retrieve :: response()
  def retrieve do
    :get
    |> Request.new(@endpoint)
    |> Request.perform()
    |> Request.results(as: FeeStat)
  end
end
