defmodule Stellar.Horizon.Transaction.LedgerBounds do
  @moduledoc """
  Represents a `LedgerBounds` for a Transaction.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping

  @type t :: %__MODULE__{min_ledger: non_neg_integer(), max_ledger: non_neg_integer()}

  defstruct [:min_ledger, :max_ledger]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse([])
  end
end
