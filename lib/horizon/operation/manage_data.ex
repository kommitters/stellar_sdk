defmodule Stellar.Horizon.Operation.ManageData do
  @moduledoc """
  Represents a `ManageData` operation from Horizon API.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{name: String.t(), value: String.t()}

  defstruct [:name, :value]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    Mapping.build(%__MODULE__{}, attrs)
  end
end
