defmodule Stellar.TxBuild.Price do
  @moduledoc """
  `Price` struct definition.
  """
  import Stellar.TxBuild.Utils, only: [number_to_fraction: 1]

  alias StellarBase.XDR.{Int32, Price}

  @behaviour Stellar.TxBuild.XDR

  @type price :: non_neg_integer() | float()

  @type t :: %__MODULE__{
          price: price(),
          numerator: non_neg_integer(),
          denominator: non_neg_integer()
        }

  defstruct [:price, :numerator, :denominator]

  @impl true
  def new(price, opts \\ [])

  def new(price, _opts) when is_number(price) and price > 0 do
    {numerator, denominator} = number_to_fraction(price)
    %__MODULE__{price: price, numerator: numerator, denominator: denominator}
  end

  def new(_amount, _opts), do: {:error, :invalid_price}

  @impl true
  def to_xdr(%__MODULE__{numerator: numerator, denominator: denominator}) do
    denominator = Int32.new(denominator)

    numerator
    |> Int32.new()
    |> Price.new(denominator)
  end
end
