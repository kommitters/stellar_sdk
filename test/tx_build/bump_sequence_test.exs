defmodule Stellar.TxBuild.BumpSeqenceTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [bump_sequence_op_xdr: 1]

  alias Stellar.TxBuild.BumpSequence

  setup do
    bump_to = 4_130_560_242_876_417

    %{
      bump_to: bump_to,
      xdr: bump_sequence_op_xdr(bump_to)
    }
  end

  test "new/2", %{bump_to: bump_to} do
    %BumpSequence{bump_to: ^bump_to} = BumpSequence.new(bump_to: bump_to)
  end

  test "new/2 with_invalid_bump_to" do
    {:error, [bump_to: :integer_expected]} = BumpSequence.new(bump_to: "ABC")
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = BumpSequence.new("123", "ABC")
  end

  test "to_xdr/1", %{xdr: xdr, bump_to: bump_to} do
    ^xdr =
      [bump_to: bump_to]
      |> BumpSequence.new()
      |> BumpSequence.to_xdr()
  end
end
