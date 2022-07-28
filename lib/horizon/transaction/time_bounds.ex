defmodule Stellar.Horizon.Transaction.TimeBounds do
  @moduledoc """
  Represents a `TimeBounds` for a Transaction.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{min_time: non_neg_integer(), max_time: non_neg_integer()}

  defstruct [:min_time, :max_time]

  @mapping [
    {:min_time, :integer},
    {:max_time, :integer}
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
