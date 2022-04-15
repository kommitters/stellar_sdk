defmodule Stellar.Horizon.Effects do
  @moduledoc """
  Exposes functions to interact with Effects in Horizon.

  You can:
  * List all effects.

  Horizon API reference: https://developers.stellar.org/api/resources/effects/
  """

  alias Stellar.Horizon.{Collection, Effect, Error, Request}

  @type options :: Keyword.t()
  @type resource :: Effect.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "effects"

  @doc """
  Lists all effects.

  ## Options

    * `cursor`: A number that points to a specific location in a collection of responses and is pulled from the `paging_token` value of a record.
    * `order`: A designation of the order in which records should appear. Options include `asc` (ascending) or `desc` (descending).
    * `limit`: The maximum number of records returned. The limit can range from 1 to 200. Defaults to 10.

  ## Examples

      iex> Effects.all(limit: 10, order: :asc)
      {:ok, %Collection{records: [%Effect{}, ...]}}
  """
  @spec all(options :: options()) :: response()
  def all(options \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(options)
    |> Request.perform()
    |> Request.results(collection: {Effect, &all/1})
  end
end
