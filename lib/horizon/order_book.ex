defmodule Stellar.Horizon.OrderBook do
  @moduledoc """
  Represents an `OrderBook` resource from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping
  alias Stellar.Horizon.OrderBook.Price

  @type t :: %__MODULE__{
          bids: list(Price.t()),
          asks: list(Price.t()),
          base: map(),
          counter: map()
        }

  defstruct [
    :bids,
    :asks,
    :base,
    :counter
  ]

  @mapping [
    bids: {:list, :struct, Price},
    asks: {:list, :struct, Price}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
