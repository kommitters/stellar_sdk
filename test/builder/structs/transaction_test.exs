defmodule Stellar.Builder.Structs.TransactionTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [transaction_xdr: 1]
  alias Stellar.Builder.Structs.{Account, Transaction, BaseFee, Memo, TimeBounds}

  setup do
    account_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    account = Account.new(account_id)

    %{
      account: account,
      memo: Memo.new(:none),
      time_bounds: TimeBounds.new(),
      base_fee: BaseFee.new(),
      xdr: transaction_xdr(account_id)
    }
  end

  test "new/2", %{account: account, memo: memo, time_bounds: time_bounds} do
    %Transaction{source_account: ^account, memo: ^memo, time_bounds: ^time_bounds} =
      Transaction.new(account)
  end

  test "new/2 with_options", %{account: account} do
    memo = Memo.new(:text, "hello")
    time_bounds = TimeBounds.set_max_time(123_456_789)

    %Transaction{source_account: ^account, memo: ^memo, time_bounds: ^time_bounds} =
      Transaction.new(account, memo: memo, time_bounds: time_bounds)
  end

  test "to_xdr/1", %{xdr: xdr, account: account} do
    ^xdr =
      account
      |> Transaction.new()
      |> Transaction.to_xdr()
  end
end
