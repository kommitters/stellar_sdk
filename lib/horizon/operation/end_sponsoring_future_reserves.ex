defmodule Stellar.Horizon.Operation.EndSponsoringFutureReserves do
  @moduledoc """
  Represents a `EndSponsoringFutureReserves` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{begin_sponsor: String.t()}

  defstruct [:begin_sponsor]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
