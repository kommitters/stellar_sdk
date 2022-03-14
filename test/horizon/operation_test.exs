defmodule Stellar.Horizon.OperationTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Operation

  alias Stellar.Horizon.Operation.{
    AccountMerge,
    AllowTrust,
    BeginSponsoringFutureReserves,
    BumpSequence,
    ChangeTrust,
    CreateAccount,
    CreateClaimableBalance,
    ClaimClaimableBalance,
    CreatePassiveSellOffer,
    EndSponsoringFutureReserves,
    LiquidityPoolDeposit,
    LiquidityPoolWithdraw,
    ManageBuyOffer,
    ManageSellOffer,
    ManageData,
    PathPaymentStrictReceive,
    PathPaymentStrictSend,
    Payment,
    RevokeSponsorship,
    SetOptions
  }

  setup do
    json_body = Horizon.fixture("operation")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Operation{
      body: %PathPaymentStrictSend{
        amount: 26.5544244,
        asset_code: "BRL",
        asset_issuer: "GDVKY2GU2DRXWTBEYJJWSFXIGBZV6AZNBVVSUHEPZI54LIS6BA7DVVSP",
        asset_type: "credit_alphanum4",
        destination_min: 26.5544244,
        from: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z",
        path: [
          %{
            asset_code: "EURT",
            asset_issuer: "GAP5LETOV6YIE62YAM56STDANPRDO7ZFDBGSNHJQIYGGKSMOZAHOOS2S",
            asset_type: "credit_alphanum4"
          },
          %{asset_type: "native"}
        ],
        source_amount: 5.0,
        source_asset_code: "USD",
        source_asset_issuer: "GDUKMGUGDZQK6YHYA5Z6AY2G4XDSZPSZ3SW5UN3ARVMO6QSRDWP5YLEX",
        source_asset_type: "credit_alphanum4",
        to: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z"
      },
      created_at: ~U[2020-04-04 13:47:50Z],
      id: 124_624_072_438_579_201,
      paging_token: "124624072438579201",
      source_account: "GBZH7S5NC57XNHKHJ75C5DGMI3SP6ZFJLIKW74K6OSMA5E5DFMYBDD2Z",
      transaction: nil,
      transaction_hash: "2b863994825fe85b80bfdff433b348d5ce80b23cd9ee2a56dcd6ee1abd52c9f8",
      transaction_successful: true,
      type: "path_payment_strict_send",
      type_i: 13
    } = Operation.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Operation{
      body: %{},
      created_at: nil,
      id: nil,
      paging_token: nil,
      source_account: nil,
      transaction_hash: nil,
      transaction_successful: nil,
      type: nil,
      type_i: nil,
      transaction: nil
    } = Operation.new(%{})
  end

  test "operation_body" do
    for {type_i, type, body} <- [
          {0, "create_account", %CreateAccount{}},
          {1, "payment", %Payment{}},
          {2, "path_payment_strict_receive", %PathPaymentStrictReceive{}},
          {3, "manage_sell_offer", %ManageSellOffer{}},
          {4, "create_passive_sell_offer", %CreatePassiveSellOffer{}},
          {5, "set_options", %SetOptions{}},
          {6, "change_trust", %ChangeTrust{}},
          {7, "allow_trust", %AllowTrust{}},
          {8, "account_merge", %AccountMerge{}},
          {10, "manage_data", %ManageData{}},
          {11, "bump_sequence", %BumpSequence{}},
          {12, "manage_buy_offer", %ManageBuyOffer{}},
          {13, "path_payment_strict_send", %PathPaymentStrictSend{}},
          {14, "create_claimable_balance", %CreateClaimableBalance{}},
          {15, "claim_claimable_balance", %ClaimClaimableBalance{}},
          {16, "begin_sponsoring_future_reserves", %BeginSponsoringFutureReserves{}},
          {17, "end_sponsoring_future_reserves", %EndSponsoringFutureReserves{}},
          {19, "revoke_sponsorship", %RevokeSponsorship{}},
          {22, "liquidity_pool_deposit", %LiquidityPoolDeposit{}},
          {23, "liquidity_pool_withdraw", %LiquidityPoolWithdraw{}}
        ] do
      %Operation{body: ^body, type_i: ^type_i, type: ^type} =
        Operation.new(%{type_i: type_i, type: type})
    end
  end
end
