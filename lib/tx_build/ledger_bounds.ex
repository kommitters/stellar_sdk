defmodule Stellar.TxBuild.LedgerBounds do
  @moduledoc """
  `LedgerBounds` struct definition.
  """
  alias StellarBase.XDR.{UInt32, LedgerBounds, OptionalLedgerBounds}

  @behaviour Stellar.TxBuild.XDR

  @type validation :: {:ok, non_neg_integer()} | {:error, :atom}
  @type t :: %__MODULE__{min_ledger: non_neg_integer(), max_ledger: non_neg_integer()}

  defstruct [:min_ledger, :max_ledger]

  @impl true
  def new(ledger_bounds \\ [min_ledger: 0, max_ledger: 0], opts \\ [])

  def new(:none, _opts), do: new(min_ledger: 0, max_ledger: 0)

  def new([min_ledger: min_ledger, max_ledger: max_ledger], _opts) do
    with {:ok, min_ledger} <- validate_ledger_bounds(min_ledger),
         {:ok, max_ledger} <- validate_ledger_bounds(max_ledger) do
      %__MODULE__{min_ledger: min_ledger, max_ledger: max_ledger}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{min_ledger: 0, max_ledger: 0}) do
    OptionalLedgerBounds.new()
  end

  def to_xdr(%__MODULE__{min_ledger: min_ledger, max_ledger: max_ledger}) do
    min_ledger = UInt32.new(min_ledger)
    max_ledger = UInt32.new(max_ledger)

    min_ledger
    |> LedgerBounds.new(max_ledger)
    |> OptionalLedgerBounds.new()
  end

  @spec validate_ledger_bounds(ledger_bound :: non_neg_integer()) :: validation()
  defp validate_ledger_bounds(ledger_bound) when is_integer(ledger_bound) and ledger_bound >= 0 do
    {:ok, ledger_bound}
  end

  defp validate_ledger_bounds(_ledger_bounds), do: {:error, :invalid_ledger_bounds}
end
