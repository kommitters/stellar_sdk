defmodule Stellar.TxBuild.BeginSponsoringFutureReservesTest do
  use ExUnit.Case

  import Stellar.Test.XDRFixtures, only: [begin_sponsoring_future_reserves_op_xdr: 1]

  alias Stellar.TxBuild.{AccountID, BeginSponsoringFutureReserves}

  setup do
    sponsored_id = "GD726E62G6G4ANHWHIQTH5LNMFVF2EQSEXITB6DZCCTKVU6EQRRE2SJS"

    %{
      sponsored_id: sponsored_id,
      sponsored: AccountID.new(sponsored_id),
      xdr: begin_sponsoring_future_reserves_op_xdr(sponsored_id)
    }
  end

  test "new/2", %{sponsored_id: sponsored_id, sponsored: sponsored} do
    %BeginSponsoringFutureReserves{sponsored_id: ^sponsored} =
      BeginSponsoringFutureReserves.new(sponsored_id: sponsored_id)
  end

  test "new/2 with_invalid_sponsored_id" do
    {:error, [sponsored_id: :invalid_account_id]} =
      BeginSponsoringFutureReserves.new(sponsored_id: "ABC")
  end

  test "new/2 with_invalid_attributes" do
    {:error, :invalid_operation_attributes} = BeginSponsoringFutureReserves.new(%{amount: 100})
  end

  test "to_xdr/1", %{xdr: xdr, sponsored_id: sponsored_id} do
    ^xdr =
      [sponsored_id: sponsored_id]
      |> BeginSponsoringFutureReserves.new()
      |> BeginSponsoringFutureReserves.to_xdr()
  end
end
