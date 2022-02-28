defmodule Stellar.Horizon.Operation.CreateClaimableBalance do
  @moduledoc """
  Represents a `CreateClaimableBalance` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset: String.t(),
          amount: float(),
          claimants: list(map())
        }

  defstruct [:asset, :amount, :claimants]

  @mapping [amount: :float]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
