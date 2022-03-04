defmodule Stellar.Horizon.Effects do
  @moduledoc """
  Exposes functions to interact with Effects in Horizon.

  You can:
  * List all effects.

  Horizon API reference: https://developers.stellar.org/api/resources/effects/
  """

  alias Stellar.Horizon.{Collection, Effect, Error, Request}

  @type params :: Keyword.t()
  @type resource :: Effect.t() | Collection.t()
  @type response :: {:ok, resource()} | {:error, Error.t()}

  @endpoint "effects"

  @spec all(params :: params()) :: response()
  def all(params \\ []) do
    :get
    |> Request.new(@endpoint)
    |> Request.add_query(params)
    |> Request.perform()
    |> Request.results(&Collection.new({Effect, &1}))
  end
end
