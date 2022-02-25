defmodule Stellar.Horizon.Operation.LiquidityPoolWithdraw do
  @moduledoc """
  Represents a `LiquidityPoolWithdraw` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          liquidity_pool_id: String.t(),
          reserves_min: list(map()),
          shares: integer(),
          reserves_received: list(map())
        }

  defstruct [:liquidity_pool_id, :reserves_min, :shares, :reserves_received]

  @mapping [
    shares: :integer,
    reserves_received: {:list, :map, [amount: :float]},
    reserves_min: {:list, :map, [amount: :float]}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
