defmodule Stellar.Horizon.OrderBook.Price do
  @moduledoc """
  Represents a `Price` for an order book.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          price_r: map(),
          price: String.t(),
          amount: String.t()
        }

  defstruct [
    :price_r,
    :price,
    :amount
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
