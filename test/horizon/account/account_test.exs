defmodule Stellar.Horizon.AccountTest do
  use ExUnit.Case

  alias Stellar.Test.Fixtures.Horizon
  alias Stellar.Horizon.Account
  alias Stellar.Horizon.Account.{Balance, Flags, Signer, Thresholds}

  setup do
    json_body = Horizon.fixture("account")
    attrs = Jason.decode!(json_body, keys: :atoms)

    %{attrs: attrs}
  end

  test "new/2", %{attrs: attrs} do
    %Account{
      id: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
      account_id: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD",
      sequence: 17_218_523_889_680,
      subentry_count: 4,
      inflation_destination: nil,
      home_domain: nil,
      last_modified_ledger: 600_051,
      last_modified_time: ~U[2022-01-20 21:21:44Z],
      num_sponsoring: 0,
      num_sponsored: 0,
      thresholds: %Thresholds{},
      flags: %Flags{},
      balances: [%Balance{}, %Balance{}],
      signers: [%Signer{}, %Signer{}, %Signer{}],
      data: %{NFT: "QkdFR0ZFVEVHRUhIRUVI"},
      paging_token: "GCXMWUAUF37IWOOV2FRDKWEX3O2IHLM2FYH4WPI4PYUKAIFQEUU5X3TD"
    } = Account.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Account{
      id: nil,
      account_id: nil,
      sequence: nil,
      subentry_count: nil,
      inflation_destination: nil,
      home_domain: nil,
      last_modified_ledger: nil,
      last_modified_time: nil,
      num_sponsoring: nil,
      num_sponsored: nil,
      thresholds: nil,
      flags: nil,
      balances: nil,
      signers: nil,
      data: nil,
      paging_token: nil
    } = Account.new(%{})
  end
end
