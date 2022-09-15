defmodule Stellar.Horizon.Operation.CreateClaimableBalance do
  @moduledoc """
  Represents a `CreateClaimableBalance` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          asset: String.t(),
          amount: String.t(),
          claimants: list(map())
        }

  defstruct [:asset, :amount, :claimants]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
