defmodule Stellar.TxBuild.SequenceNumberTest do
  use ExUnit.Case

  alias StellarBase.XDR.SequenceNumber, as: SequenceNumberXDR
  alias Stellar.TxBuild.{SequenceNumber}

  setup do
    %{sequence_number: 4_130_487_228_432_385}
  end

  test "new/2", %{sequence_number: sequence_number} do
    %SequenceNumber{sequence_number: ^sequence_number} = SequenceNumber.new(sequence_number)
  end

  test "to_xdr/1", %{sequence_number: sequence_number} do
    %SequenceNumberXDR{sequence_number: ^sequence_number} =
      SequenceNumber.new(sequence_number) |> SequenceNumber.to_xdr()
  end
end
