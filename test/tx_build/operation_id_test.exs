defmodule Stellar.TxBuild.OperationIDTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [operation_id_xdr: 3]

  alias Stellar.TxBuild.OperationID, as: TxOperationID
  alias Stellar.TxBuild.AccountID, as: TxAccountID
  alias Stellar.TxBuild.SequenceNumber, as: TxSequenceNumber

  setup do
    public_key = "GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN"
    source_account = TxAccountID.new(public_key)
    sequence_number = TxSequenceNumber.new(123)
    op_num = 123

    xdr = operation_id_xdr(source_account, sequence_number, op_num)

    %{
      source_account: source_account,
      sequence_number: sequence_number,
      op_num: op_num,
      public_key: public_key,
      xdr: xdr
    }
  end

  test "new/1", %{
    source_account: source_account,
    sequence_number: sequence_number,
    op_num: op_num,
    public_key: public_key
  } do
    %TxOperationID{
      source_account: ^source_account,
      sequence_number: ^sequence_number,
      op_num: ^op_num
    } =
      TxOperationID.new(
        source_account: public_key,
        sequence_number: sequence_number,
        op_num: op_num
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_operation_id} = TxOperationID.new("invalid_args")
  end

  test "to_xdr/1",
       %{
         sequence_number: sequence_number,
         op_num: op_num,
         xdr: xdr,
         public_key: public_key
       } do
    ^xdr =
      TxOperationID.new(
        source_account: public_key,
        sequence_number: sequence_number,
        op_num: op_num
      )
      |> TxOperationID.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_operation_id} = TxOperationID.to_xdr("invalid_struct")
  end
end
