defmodule Stellar.Horizon.Operation.BeginSponsoringFutureReserves do
  @moduledoc """
  Represents a `BeginSponsoringFutureReserves` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{sponsored_id: String.t()}

  defstruct [:sponsored_id]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
