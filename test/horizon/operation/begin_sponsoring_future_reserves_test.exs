defmodule Stellar.Horizon.Operation.BeginSponsoringFutureReservesTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.BeginSponsoringFutureReserves

  setup do
    %{attrs: %{sponsored_id: "GC3C4AKRBQLHOJ45U4XG35ESVWRDECWO5XLDGYADO6DPR3L7KIDVUMML"}}
  end

  test "new/2", %{attrs: %{sponsored_id: sponsored_id} = attrs} do
    %BeginSponsoringFutureReserves{sponsored_id: ^sponsored_id} =
      BeginSponsoringFutureReserves.new(attrs)
  end

  test "new/2 empty_attrs" do
    %BeginSponsoringFutureReserves{sponsored_id: nil} = BeginSponsoringFutureReserves.new(%{})
  end
end
