defmodule Stellar.Horizon.OrderBook.Price do
  @moduledoc """
  Represents a `Price` for an order book.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          price_r: map(),
          price: float(),
          amount: float()
        }

  defstruct [
    :price_r,
    :price,
    :amount
  ]

  @mapping [
    price: :float,
    amount: :float
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
