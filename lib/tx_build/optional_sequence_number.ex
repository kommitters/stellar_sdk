defmodule Stellar.TxBuild.OptionalSequenceNumber do
  @moduledoc """
  `OptionalSequenceNumber` struct definition.
  """
  alias StellarBase.XDR.OptionalSequenceNumber
  alias Stellar.TxBuild.SequenceNumber

  @behaviour Stellar.TxBuild.XDR

  @type sequence_number :: SequenceNumber.t() | nil

  @type t :: %__MODULE__{sequence_number: sequence_number()}

  defstruct [:sequence_number]

  @impl true
  def new(sequence_number \\ nil, opts \\ [])

  def new(%SequenceNumber{} = sequence_number, _opts) do
    %__MODULE__{sequence_number: sequence_number}
  end

  def new(nil, _opts), do: %__MODULE__{sequence_number: nil}

  @impl true
  def to_xdr(%__MODULE__{sequence_number: nil}), do: OptionalSequenceNumber.new()

  def to_xdr(%__MODULE__{sequence_number: sequence_number}) do
    sequence_number
    |> SequenceNumber.to_xdr()
    |> OptionalSequenceNumber.new()
  end
end
