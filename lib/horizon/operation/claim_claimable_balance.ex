defmodule Stellar.Horizon.Operation.ClaimClaimableBalance do
  @moduledoc """
  Represents a `ClaimClaimableBalance` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{balance_id: String.t(), claimant: String.t()}

  defstruct [:balance_id, :claimant]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
