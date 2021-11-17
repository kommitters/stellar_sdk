defmodule Stellar.Builder.Structs.SequenceNumber do
  @moduledoc """
  `SequenceNumber` struct definition.
  """

  alias Stellar.Builder.Structs.Account
  alias StellarBase.XDR.SequenceNumber

  @type t :: %__MODULE__{sequence_number: non_neg_integer()}

  defstruct [:sequence_number]

  @spec new(account :: Account.t()) :: t()
  def new(%Account{account_id: account_id}) do
    %__MODULE__{sequence_number: fetch_secuence_number(account_id)}
  end

  @spec to_xdr(to_xdr :: t()) :: SequenceNumber.t()
  def to_xdr(%__MODULE__{sequence_number: sequence_number}) do
    SequenceNumber.new(sequence_number)
  end

  @spec fetch_secuence_number(account_id :: String.t()) :: non_neg_integer()
  defp fetch_secuence_number(account_id) do
    4_130_487_228_432_385
  end
end
