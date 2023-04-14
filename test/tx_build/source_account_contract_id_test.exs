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
      xdr: xdr,
      public_key: public_key
    }
  end

  test "new/1", %{
    network_id: network_id,
    source_account: source_account,
    salt: salt,
    public_key: public_key
  } do
    %TxSourceAccountContractID{
      network_id: ^network_id,
      source_account: ^source_account,
      salt: ^salt
    } =
      TxSourceAccountContractID.new(
        network_id: network_id,
        source_account: public_key,
        salt: salt
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_source_account_contract_id} = TxSourceAccountContractID.new("invalid_args")
  end

  test "to_xdr/1", %{
    network_id: network_id,
    salt: salt,
    xdr: xdr,
    public_key: public_key
  } do
    ^xdr =
      [network_id: network_id, source_account: public_key, salt: salt]
      |> TxSourceAccountContractID.new()
      |> TxSourceAccountContractID.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_source_account_contract_id} =
      TxSourceAccountContractID.to_xdr("invalid_struct")
  end
end
