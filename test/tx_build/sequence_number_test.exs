defmodule Stellar.TxBuild.SequenceNumberTest do
  use ExUnit.Case

  alias StellarBase.XDR.SequenceNumber, as: SequenceNumberXDR
  alias Stellar.TxBuild.{Account, SequenceNumber}

  setup do
    %{account: Account.new("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS")}
  end

  test "new/2", %{account: account} do
    %SequenceNumber{sequence_number: 4_130_487_228_432_385} = SequenceNumber.new(account)
  end

  test "to_xdr/1", %{account: account} do
    %SequenceNumberXDR{sequence_number: 4_130_487_228_432_385} =
      SequenceNumber.new(account) |> SequenceNumber.to_xdr()
  end
end
