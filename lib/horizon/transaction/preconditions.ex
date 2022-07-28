defmodule Stellar.Horizon.Transaction.Preconditions do
  @moduledoc """
  Represents a `Preconditions` for a Transaction.
  """

  @behaviour Stellar.Horizon.Resource

  alias Stellar.Horizon.Mapping
  alias Stellar.Horizon.Transaction.{LedgerBounds, TimeBounds}

  @type t :: %__MODULE__{
          time_bounds: TimeBounds.t(),
          ledger_bounds: LedgerBounds.t(),
          min_account_sequence: non_neg_integer(),
          min_account_sequence_age: non_neg_integer(),
          min_account_sequence_ledger_gap: non_neg_integer(),
          extra_signers: list(String.t())
        }

  defstruct [
    :time_bounds,
    :ledger_bounds,
    :min_account_sequence,
    :min_account_sequence_age,
    :min_account_sequence_ledger_gap,
    :extra_signers
  ]

  @mapping [
    time_bounds: {:struct, TimeBounds},
    ledger_bounds: {:struct, LedgerBounds},
    min_account_sequence: :integer
  ]

  @impl true
  def new(attrs, opts \\ [])

  def new(attrs, _opts) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
