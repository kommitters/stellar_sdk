defmodule Stellar.Horizon.Operation.LiquidityPoolWithdraw do
  @moduledoc """
  Represents a `LiquidityPoolWithdraw` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          liquidity_pool_id: String.t(),
          reserves_min: list(),
          shares: integer(),
          reserves_received: list()
        }

  defstruct [:liquidity_pool_id, :reserves_min, :shares, :reserves_received]

  @mapping [shares: :integer]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
