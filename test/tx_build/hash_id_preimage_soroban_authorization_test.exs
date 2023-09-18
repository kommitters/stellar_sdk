defmodule Stellar.TxBuild.HashIDPreimageSorobanAuthorizationTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [soroban_auth_xdr: 4]

  alias Stellar.TxBuild.{
    HashIDPreimageSorobanAuthorization,
    SCVec,
    SCVal,
    SCAddress,
    InvokeContractArgs,
    SorobanAuthorizedFunction,
    SorobanAuthorizedInvocation
  }

  setup do
    fn_args = SCVec.new([SCVal.new(symbol: "dev")])

    contract_address = SCAddress.new("CBT6AP4HS575FETHYO6CMIZ2NUFPLKC7JGO7HNBEDTPLZJADT5RDRZP4")

    function_name = "hello"

    contract_fn =
      InvokeContractArgs.new(
        contract_address: contract_address,
        function_name: function_name,
        args: fn_args
      )

    soroban_function = SorobanAuthorizedFunction.new(contract_fn: contract_fn)

    network_id = "nerwork_id"
    nonce = 1234
    signature_expiration_ledger = 5678
    invocation = SorobanAuthorizedInvocation.new(function: soroban_function, sub_invocations: [])
    xdr = soroban_auth_xdr(network_id, nonce, signature_expiration_ledger, invocation)

    %{
      network_id: network_id,
      nonce: nonce,
      signature_expiration_ledger: signature_expiration_ledger,
      invocation: invocation,
      xdr: xdr
    }
  end

  test "new/1", %{
    network_id: network_id,
    nonce: nonce,
    signature_expiration_ledger: signature_expiration_ledger,
    invocation: invocation
  } do
    %HashIDPreimageSorobanAuthorization{
      network_id: ^network_id,
      nonce: ^nonce,
      signature_expiration_ledger: ^signature_expiration_ledger,
      invocation: ^invocation
    } =
      HashIDPreimageSorobanAuthorization.new(
        network_id: network_id,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        invocation: invocation
      )
  end

  test "new/1 with invalid args" do
    {:error, :invalid_preimage_soroban_auth} =
      HashIDPreimageSorobanAuthorization.new("invalid_args")
  end

  test "new/1 with invalid network_id", %{
    nonce: nonce,
    signature_expiration_ledger: signature_expiration_ledger,
    invocation: invocation
  } do
    {:error, :invalid_network_id} =
      HashIDPreimageSorobanAuthorization.new(
        network_id: 1234,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        invocation: invocation
      )
  end

  test "new/1 with invalid nonce", %{
    network_id: network_id,
    signature_expiration_ledger: signature_expiration_ledger,
    invocation: invocation
  } do
    {:error, :invalid_nonce} =
      HashIDPreimageSorobanAuthorization.new(
        network_id: network_id,
        nonce: "invalid",
        signature_expiration_ledger: signature_expiration_ledger,
        invocation: invocation
      )
  end

  test "new/1 with invalid signature_expiration_ledger", %{
    network_id: network_id,
    nonce: nonce,
    invocation: invocation
  } do
    {:error, :invalid_signature_expiration_ledger} =
      HashIDPreimageSorobanAuthorization.new(
        network_id: network_id,
        nonce: nonce,
        signature_expiration_ledger: "invalid",
        invocation: invocation
      )
  end

  test "new/1 with invalid invocation", %{
    network_id: network_id,
    nonce: nonce,
    signature_expiration_ledger: signature_expiration_ledger
  } do
    {:error, :invalid_invocation} =
      HashIDPreimageSorobanAuthorization.new(
        network_id: network_id,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        invocation: "invalid"
      )
  end

  test "to_xdr/1",
       %{
         network_id: network_id,
         nonce: nonce,
         signature_expiration_ledger: signature_expiration_ledger,
         invocation: invocation,
         xdr: xdr
       } do
    ^xdr =
      HashIDPreimageSorobanAuthorization.new(
        network_id: network_id,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        invocation: invocation
      )
      |> HashIDPreimageSorobanAuthorization.to_xdr()
  end

  test "to_xdr/1 when the struct is invalid" do
    {:error, :invalid_struct_revoke_id} =
      HashIDPreimageSorobanAuthorization.to_xdr("invalid_struct")
  end
end
