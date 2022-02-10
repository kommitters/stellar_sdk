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
    TimeBounds
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
      time_bounds: TimeBounds.new(),
      base_fee: BaseFee.new(),
      operations: Operations.new()
    }
  end

  describe "validations" do
    test "validate_source_account", %{
      sequence_number: sequence_number,
      memo: memo,
      base_fee: base_fee,
      time_bounds: time_bounds,
      operations: operations
    } do
      {:error, :invalid_source_account} =
        Transaction.new(
          source_account: nil,
          sequence_number: sequence_number,
          base_fee: base_fee,
          time_bounds: time_bounds,
          memo: memo,
          operations: operations
        )
    end

    test "validate_sequence_number", %{
      source_account: source_account,
      memo: memo,
      base_fee: base_fee,
      time_bounds: time_bounds,
      operations: operations
    } do
      {:error, :invalid_sequence_number} =
        Transaction.new(
          source_account: source_account,
          sequence_number: -123_456,
          base_fee: base_fee,
          time_bounds: time_bounds,
          memo: memo,
          operations: operations
        )
    end

    test "validate_base_fee", %{
      source_account: source_account,
      sequence_number: sequence_number,
      memo: memo,
      time_bounds: time_bounds,
      operations: operations
    } do
      {:error, :invalid_base_fee} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: -100,
          time_bounds: time_bounds,
          memo: memo,
          operations: operations
        )
    end

    test "validate_time_bounds", %{
      source_account: source_account,
      sequence_number: sequence_number,
      memo: memo,
      base_fee: base_fee,
      operations: operations
    } do
      {:error, :invalid_time_bounds} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: base_fee,
          time_bounds: [],
          memo: memo,
          operations: operations
        )
    end

    test "validate_memo", %{
      source_account: source_account,
      sequence_number: sequence_number,
      base_fee: base_fee,
      time_bounds: time_bounds,
      operations: operations
    } do
      {:error, :invalid_memo} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: base_fee,
          time_bounds: time_bounds,
          memo: "TEST",
          operations: operations
        )
    end

    test "validate_operations", %{
      source_account: source_account,
      sequence_number: sequence_number,
      memo: memo,
      base_fee: base_fee,
      time_bounds: time_bounds
    } do
      {:error, :invalid_operations} =
        Transaction.new(
          source_account: source_account,
          sequence_number: sequence_number,
          base_fee: base_fee,
          time_bounds: time_bounds,
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
    time_bounds: time_bounds,
    operations: operations
  } do
    %Transaction{
      source_account: ^source_account,
      sequence_number: ^sequence_number,
      time_bounds: ^time_bounds,
      base_fee: ^base_fee,
      memo: ^memo
    } =
      Transaction.new(
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        time_bounds: time_bounds,
        memo: memo,
        operations: operations
      )
  end

  test "new/2 with_muxed_source_account", %{
    muxed_source_account: muxed_source_account,
    sequence_number: sequence_number,
    base_fee: base_fee,
    memo: memo,
    time_bounds: time_bounds,
    operations: operations
  } do
    %Transaction{
      source_account: ^muxed_source_account,
      sequence_number: ^sequence_number,
      time_bounds: ^time_bounds,
      base_fee: ^base_fee,
      memo: ^memo
    } =
      Transaction.new(
        source_account: muxed_source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        time_bounds: time_bounds,
        memo: memo,
        operations: operations
      )
  end

  test "to_xdr/1", %{
    account_id: account_id,
    source_account: source_account,
    base_fee: base_fee,
    memo: memo,
    time_bounds: time_bounds,
    operations: operations
  } do
    sequence_number = SequenceNumber.new(4_130_487_228_432_385)
    xdr = XDRFixtures.transaction(account_id)

    ^xdr =
      Transaction.new(
        source_account: source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        time_bounds: time_bounds,
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
    time_bounds: time_bounds,
    operations: operations
  } do
    sequence_number = SequenceNumber.new(4_130_487_228_432_385)
    xdr = XDRFixtures.transaction_with_muxed_account(muxed_address)

    ^xdr =
      Transaction.new(
        source_account: muxed_source_account,
        sequence_number: sequence_number,
        base_fee: base_fee,
        time_bounds: time_bounds,
        memo: memo,
        operations: operations
      )
      |> Transaction.to_xdr()
  end
end
