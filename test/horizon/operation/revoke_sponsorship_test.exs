defmodule Stellar.Horizon.Operation.RevokeSponsorshipTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.RevokeSponsorship

  setup do
    %{
      attrs: %{
        account_id: "GC3C4AKRBQLHOJ45U4XG35ESVWRDECWO5XLDGYADO6DPR3L7KIDVUMML",
        claimable_balance_id: "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        signer_key: "GCVLWV5B3L3YE6DSCCMHLCK7QIB365NYOLQLW3ZKHI5XINNMRLJ6YHVX"
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        account_id: account_id,
        claimable_balance_id: claimable_balance_id,
        signer_key: signer_key
      } = attrs
  } do
    %RevokeSponsorship{
      account_id: ^account_id,
      claimable_balance_id: ^claimable_balance_id,
      signer_key: ^signer_key
    } = RevokeSponsorship.new(attrs)
  end

  test "new/2 empty_attrs" do
    %RevokeSponsorship{
      account_id: nil,
      claimable_balance_id: nil,
      data_account_id: nil,
      data_name: nil,
      offer_id: nil,
      trustline_account_id: nil,
      trustline_asset: nil,
      signer_account_id: nil,
      signer_key: nil
    } = RevokeSponsorship.new(%{})
  end
end
