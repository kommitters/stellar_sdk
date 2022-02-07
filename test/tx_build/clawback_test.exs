defmodule Stellar.TxBuild.ClawbackTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [clawback_op_xdr: 3]

  alias Stellar.TxBuild.{Account, Amount, Asset, Clawback}

  setup do
    from = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
    asset_code = "BTCN"
    asset_issuer = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    amount = 100

    %{
      asset: {asset_code, asset_issuer},
      from: from,
      amount: amount,
      xdr: clawback_op_xdr({asset_code, asset_issuer}, from, amount)
    }
  end

  test "new/2", %{from: from, asset: asset, amount: amount} do
    asset_str = Asset.new(asset)
    from_str = Account.new(from)
    amount_str = Amount.new(amount)

    %Clawback{asset: ^asset_str, from: ^from_str, amount: ^amount_str} =
      Clawback.new(
        asset: asset,
        from: from,
        amount: amount
      )
  end

  test "new/2 with_invalid_from" do
    {:error, [from: :invalid_account_id]} =
      Clawback.new(
        asset: :native,
        from: "ABC",
        amount: 10
      )
  end

  test "new/2 with_invalid_asset", %{from: from} do
    {:error, [asset: :invalid_asset_issuer]} =
      Clawback.new(
        asset: {"BTCN", "ABC"},
        from: from,
        amount: 10
      )
  end

  test "new/2 with_invalid_amount", %{from: from} do
    {:error, [amount: :invalid_amount]} =
      Clawback.new(
        asset: :native,
        from: from,
        amount: "10"
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = Clawback.new("ABC", "123")
  end

  test "to_xdr/1", %{xdr: xdr, asset: asset, from: from, amount: amount} do
    ^xdr =
      [asset: asset, from: from, amount: amount]
      |> Clawback.new()
      |> Clawback.to_xdr()
  end
end
