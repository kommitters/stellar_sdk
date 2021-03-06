defmodule Stellar.TxBuild.SequenceNumber do
  @moduledoc """
  `SequenceNumber` struct definition.
  """
  alias StellarBase.XDR.SequenceNumber

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{sequence_number: non_neg_integer()}

  defstruct [:sequence_number]

  @impl true
  def new(sequence_number \\ 0, opts \\ [])

  def new(sequence_number, _opts) when is_integer(sequence_number) and sequence_number >= 0 do
    %__MODULE__{sequence_number: sequence_number}
  end

  def new(_sequence_number, _opts), do: {:error, :sequence_number}

  @impl true
  def to_xdr(%__MODULE__{sequence_number: sequence_number}) do
    SequenceNumber.new(sequence_number)
  end
end
