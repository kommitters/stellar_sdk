defmodule Stellar.TxBuild.AddressWithNonceTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [address_with_nonce_xdr: 2]

  alias Stellar.TxBuild.AddressWithNonce, as: TxAddressWithNonce
  alias Stellar.TxBuild.SCAddress, as: TxSCAddress

  setup do
    address = TxSCAddress.new(account: "GB6FIXFOEK46VBDAG5USXRKKDJYFOBQZDMAPOYY6MC4KMRTSPVUH3X2A")
    nonce = 123
    xdr = address_with_nonce_xdr(address, nonce)

    %{address: address, nonce: nonce, xdr: xdr}
  end

  test "new/1", %{address: address, nonce: nonce} do
    %TxAddressWithNonce{
      address: ^address,
      nonce: ^nonce
    } = TxAddressWithNonce.new(address: address, nonce: nonce)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_address_with_nonce} = TxAddressWithNonce.new("invalid_args")
  end

  test "to_xdr/1",
       %{address: address, nonce: nonce, xdr: xdr} do
    ^xdr =
      TxAddressWithNonce.new(address: address, nonce: nonce)
      |> TxAddressWithNonce.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct_address_with_nonce} = TxAddressWithNonce.to_xdr("invalid_struct")
  end
end
