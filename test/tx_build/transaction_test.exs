defmodule Stellar.TxBuild.TransactionTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.{
    Account,
    Transaction,
    BaseFee,
    Memo,
    Operations,
    SequenceNumber,
    Preconditions
  }

  setup do
    account_id = "GBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMQQH"
    muxed_address = "MBXV5U2D67J7HUW42JKBGD4WNZON4SOPXXDFTYQ7BCOG5VCARGCRMAAAAAAAAAAAARKPQ"

    %{
      account_id: account_id,
      muxed_address: muxed_address,
      source_account: Account.new(account_id),
      muxed_source_account: Account.new(muxed_address),
      sequence_number: SequenceNumber.new(),
      memo: Memo.new(),
      preconditions: Preconditions.new(),
      base_fee: BaseFee.new(),
      operations: Operations.new()
    }
  end

  describe "validations" do
    test "validate_source_account", %{
      sequence_number: sequence_number,
      memo: memo,
      base_fee: base_fee,
      preconditions: preconditions,
      operations: operations
    } do
      {:error, :invalid_source_account} =
        Transaction.new(
          source_account: nil,
          sequence_number: sequence_number,
          base_fee: base_fee,
          preconditions: preconditions,
          memo: memo,
          operations: operations
        )
    end

    test "validate_sequence_number", %{
      source_account: source_account,
      memo: memo,
      base_fee: base_fee,
      preconditions: preconditions,
      operations: operations
    } do
      {:error, :invalid_sequence_number} =
        Transaction.new(
          source_account: source_account,
          sequence_number: -123_456,
          base_fee: base_fee,
          preconditions: preconditions,
          memo: memo,
          operations: operations
        )
    end

    test "validate_base_fee", %{
      source_account: source_account,
      sequence_number: sequence_number,
      memo: memo,
      preconditions: preconditions,
      operations: operations
    } do
      {:error, :invalid_base_fee} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: -100,
          preconditions: preconditions,
          memo: memo,
          operations: operations
        )
    end

    test "validate_preconditions", %{
      source_account: source_account,
      sequence_number: sequence_number,
      memo: memo,
      base_fee: base_fee,
      operations: operations
    } do
      {:error, :invalid_preconditions} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: base_fee,
          preconditions: [],
          memo: memo,
          operations: operations
        )
    end

    test "validate_memo", %{
      source_account: source_account,
      sequence_number: sequence_number,
      base_fee: base_fee,
      preconditions: preconditions,
      operations: operations
    } do
      {:error, :invalid_memo} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: base_fee,
          preconditions: preconditions,
          memo: "TEST",
          operations: operations
        )
    end

    test "validate_operations", %{
      source_account: source_account,
      sequence_number: sequence_number,
      memo: memo,
      base_fee: base_fee,
      preconditions: preconditions
    } do
      {:error, :invalid_operations} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: base_fee,
          preconditions: preconditions,
          memo: memo,
          operations: []
        )
    end
  end

  test "new/2", %{
    source_account: source_account,
    sequence_number: sequence_number,
    base_fee: base_fee,
    memo: memo,
    preconditions: preconditions,
    operations: operations
  } do
    %Transaction{
      source_account: ^source_account,
      sequence_number: ^sequence_number,
      preconditions: ^preconditions,
      base_fee: ^base_fee,
      memo: ^memo
    } =
      Transaction.new(
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        preconditions: preconditions,
        memo: memo,
        operations: operations
      )
  end

  test "new/2 with_muxed_source_account", %{
    muxed_source_account: muxed_source_account,
    sequence_number: sequence_number,
    base_fee: base_fee,
    memo: memo,
    preconditions: preconditions,
    operations: operations
  } do
    %Transaction{
      source_account: ^muxed_source_account,
      sequence_number: ^sequence_number,
      preconditions: ^preconditions,
      base_fee: ^base_fee,
      memo: ^memo
    } =
      Transaction.new(
        source_account: muxed_source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        preconditions: preconditions,
        memo: memo,
        operations: operations
      )
  end

  test "to_xdr/1", %{
    account_id: account_id,
    source_account: source_account,
    base_fee: base_fee,
    memo: memo,
    preconditions: preconditions,
    operations: operations
  } do
    sequence_number = SequenceNumber.new(4_130_487_228_432_385)
    xdr = XDRFixtures.transaction(account_id)

    ^xdr =
      Transaction.new(
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        preconditions: preconditions,
        memo: memo,
        operations: operations
      )
      |> Transaction.to_xdr()
  end

  test "to_xdr/1 with_muxed_source_account", %{
    muxed_address: muxed_address,
    muxed_source_account: muxed_source_account,
    base_fee: base_fee,
    memo: memo,
    preconditions: preconditions,
    operations: operations
  } do
    sequence_number = SequenceNumber.new(4_130_487_228_432_385)
    xdr = XDRFixtures.transaction_with_muxed_account(muxed_address)

    ^xdr =
      Transaction.new(
        source_account: muxed_source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        preconditions: preconditions,
        memo: memo,
        operations: operations
      )
      |> Transaction.to_xdr()
  end

  test "hash/1", %{
    source_account: source_account,
    sequence_number: sequence_number,
    base_fee: base_fee,
    memo: memo,
    preconditions: preconditions,
    operations: operations
  } do
    hash = "e83a644d3593b7e43bea3c0bd7c90714b6dbf329980a9eebe556aa72073fd4eb"

    ^hash =
      Transaction.new(
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        preconditions: preconditions,
        memo: memo,
        operations: operations
      )
      |> Transaction.hash()
  end

  test "base_signature/1", %{
    source_account: source_account,
    sequence_number: sequence_number,
    base_fee: base_fee,
    memo: memo,
    preconditions: preconditions,
    operations: operations
  } do
    base_signature =
      <<232, 58, 100, 77, 53, 147, 183, 228, 59, 234, 60, 11, 215, 201, 7, 20, 182, 219, 243, 41,
        152, 10, 158, 235, 229, 86, 170, 114, 7, 63, 212, 235>>

    tx =
      Transaction.new(
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        preconditions: preconditions,
        memo: memo,
        operations: operations
      )

    tx_xdr = Transaction.to_xdr(tx)

    ^base_signature = Transaction.base_signature(tx)
    ^base_signature = Transaction.base_signature(tx_xdr)
  end
end
