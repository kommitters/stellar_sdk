defmodule Stellar.TxBuild.SequenceNumber do
  @moduledoc """
  `SequenceNumber` struct definition.
  """
  alias StellarBase.XDR.SequenceNumber

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{sequence_number: non_neg_integer()}

  defstruct [:sequence_number]

  @impl true
  def new(account, opts \\ [])

  def new(%Account{account_id: account_id}, _opts) do
    %__MODULE__{sequence_number: fetch_secuence_number(account_id)}
  end

  @impl true
  def to_xdr(%__MODULE__{sequence_number: sequence_number}) do
    SequenceNumber.new(sequence_number)
  end

  # A fixed sequence number is set while the full feature is implemented in #27.
  @spec fetch_secuence_number(account_id :: String.t()) :: non_neg_integer()
  defp fetch_secuence_number(_account_id) do
    4_130_487_228_432_385
  end
end
