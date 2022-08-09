defmodule Stellar.TxBuild.OptionalSequenceNumberTest do
  use ExUnit.Case

  alias Stellar.TxBuild.{SequenceNumber, OptionalSequenceNumber}
  alias StellarBase.XDR.SequenceNumber, as: SequenceNumberXDR
  alias StellarBase.XDR.OptionalSequenceNumber, as: OptionalSequenceNumberXDR

  setup do
    %{sequence_number: SequenceNumber.new(4_130_487_228_432_385)}
  end

  test "new/2", %{sequence_number: sequence_number} do
    %OptionalSequenceNumber{sequence_number: ^sequence_number} =
      OptionalSequenceNumber.new(sequence_number)
  end

  test "new/2 without_sequence_number" do
    %OptionalSequenceNumber{sequence_number: nil} = OptionalSequenceNumber.new()
  end

  test "to_xdr/1", %{sequence_number: sequence_number} do
    %OptionalSequenceNumberXDR{
      sequence_number: %SequenceNumberXDR{sequence_number: 4_130_487_228_432_385}
    } =
      sequence_number
      |> OptionalSequenceNumber.new()
      |> OptionalSequenceNumber.to_xdr()
  end

  test "to_xdr/1 without_sequence_number" do
    %OptionalSequenceNumberXDR{sequence_number: nil} =
      nil
      |> OptionalSequenceNumber.new()
      |> OptionalSequenceNumber.to_xdr()
  end
end
