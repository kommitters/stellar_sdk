defmodule Stellar.Horizon.Operation.InvokeHostFunction do
  @moduledoc """
  Represents a `InvokeHostFunction` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{
          function: String.t(),
          parameters: list(map()),
          address: String.t(),
          salt: String.t(),
          asset_balance_changes: list()
        }

  defstruct [:function, :parameters, :address, :salt, :asset_balance_changes]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts), do: Mapping.build(%__MODULE__{}, attrs)
end
