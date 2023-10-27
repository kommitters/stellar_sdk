defmodule Stellar.Horizon.Operation.ExtendFootprintTTL do
  @moduledoc """
  Represents a `ExtendFootprintTTL` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{extend_to: non_neg_integer()}

  defstruct [:extend_to]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
