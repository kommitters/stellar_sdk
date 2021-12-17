defmodule Stellar.TxBuild.EndSponsoringFutureReservesTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [end_sponsoring_future_reserves_op_xdr: 0]

  alias Stellar.TxBuild.{EndSponsoringFutureReserves, OptionalAccount}

  setup do
    %{
      source_account:
        OptionalAccount.new("GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"),
      xdr: end_sponsoring_future_reserves_op_xdr()
    }
  end

  test "new/2" do
    %EndSponsoringFutureReserves{} = EndSponsoringFutureReserves.new()
  end

  test "new/2 with_source_account", %{source_account: source_account} do
    %EndSponsoringFutureReserves{source_account: ^source_account} =
      EndSponsoringFutureReserves.new(
        source_account: "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"
      )
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = EndSponsoringFutureReserves.new("ABC")
  end

  test "to_xdr/1", %{xdr: xdr} do
    ^xdr =
      []
      |> EndSponsoringFutureReserves.new()
      |> EndSponsoringFutureReserves.to_xdr()
  end
end
