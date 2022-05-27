defmodule Stellar.TxBuild.CreateClaimableBalanceTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.XDR, as: XDRFixtures

  alias Stellar.TxBuild.{
    Amount,
    Asset,
    ClaimPredicate,
    Claimant,
    Claimants,
    CreateClaimableBalance
  }

  setup do
    destination = "GBTG2POJVVSRBQSZVA3IYJEZJQLPTIVVYOYRLTZEAEFBMVP72ZTQYA2V"
    asset_code4 = "BTCN"

    amount = 100
    asset = {asset_code4, destination}

    predicate1 = ClaimPredicate.new(:unconditional)

    predicate2 =
      ClaimPredicate.new(
        value: predicate1,
        type: :not
      )

    claimant1 = Claimant.new(destination: destination, predicate: predicate1)
    claimant2 = Claimant.new(destination: destination, predicate: predicate2)
    claimants = Claimants.new([claimant1, claimant2])

    %{
      asset: asset,
      amount: amount,
      claimants: claimants,
      xdr_create_claimable_balance: XDRFixtures.create_claimable_balance(asset, amount, claimants)
    }
  end

  test "new/2", %{
    asset: asset,
    amount: amount,
    claimants: claimants
  } do
    asset_str = Asset.new(asset)
    amount_str = Amount.new(amount)

    %CreateClaimableBalance{
      asset: ^asset_str,
      amount: ^amount_str,
      claimants: ^claimants
    } =
      CreateClaimableBalance.new(
        asset: asset,
        amount: amount,
        claimants: claimants
      )
  end

  test "new/2 error", %{
    asset: asset,
    amount: amount
  } do
    {:error, :invalid_claimant_list} =
      CreateClaimableBalance.new(
        asset: asset,
        amount: amount,
        claimants: "test"
      )
  end

  test "new/2 invalid_operation_attributes" do
    {:error, :invalid_operation_attributes} = CreateClaimableBalance.new("test", "test")
  end

  test "to_xdr/1", %{
    asset: asset,
    amount: amount,
    claimants: claimants,
    xdr_create_claimable_balance: xdr
  } do
    ^xdr =
      [asset: asset, amount: amount, claimants: claimants]
      |> CreateClaimableBalance.new()
      |> CreateClaimableBalance.to_xdr()
  end
end
