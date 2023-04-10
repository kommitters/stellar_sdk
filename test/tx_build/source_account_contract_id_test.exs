defmodule Stellar.TxBuild.SourceAccountContractIDTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [source_account_contract_id_xdr: 3]

  alias Stellar.TxBuild.SourceAccountContractID, as: TxSourceAccountContractID
  alias Stellar.TxBuild.AccountID, as: TxAccountID

  setup do
    public_key = "GARVXS4KWSI6UQWZL2AAIB2KD4MAXG27YOE6IE64THZRSASAVR3ZPSUN"
    network_id = "network_id"
    salt = 123
    xdr = source_account_contract_id_xdr(network_id, public_key, salt)

    %{
      network_id: network_id,
      source_account: TxAccountID.new(public_key),
      salt: salt,
      xdr: xdr
    }
  end

  test "new/1", %{network_id: network_id, source_account: source_account, salt: salt} do
    %TxSourceAccountContractID{
      network_id: ^network_id,
      source_account: ^source_account,
      salt: ^salt
    } = TxSourceAccountContractID.new([network_id, source_account, salt])
  end

  test "new/1 invalid source account contract id" do
    {:error, :invalid_source_account_contract_id} = TxSourceAccountContractID.new("invalid")
  end

  test "to_xdr/1", %{
    network_id: network_id,
    source_account: source_account,
    salt: salt,
    xdr: xdr
  } do
    ^xdr =
      TxSourceAccountContractID.new([network_id, source_account, salt])
      |> TxSourceAccountContractID.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_source_account_contract_id} =
      TxSourceAccountContractID.to_xdr("invalid_struct")
  end
end
