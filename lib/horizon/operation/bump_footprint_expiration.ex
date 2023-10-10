defmodule Stellar.Horizon.Operation.BumpFootprintExpiration do
  @moduledoc """
  Represents a `BumpFootprintExpiration` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          ledgers_to_expire: String.t()
        }

  defstruct [:ledgers_to_expire]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts), do: Mapping.build(%__MODULE__{}, attrs)
end
