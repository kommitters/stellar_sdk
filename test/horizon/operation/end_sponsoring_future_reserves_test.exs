defmodule Stellar.Horizon.Operation.EndSponsoringFutureReservesTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.EndSponsoringFutureReserves

  setup do
    %{attrs: %{begin_sponsor: "GC3C4AKRBQLHOJ45U4XG35ESVWRDECWO5XLDGYADO6DPR3L7KIDVUMML"}}
  end

  test "new/2", %{attrs: %{begin_sponsor: begin_sponsor} = attrs} do
    %EndSponsoringFutureReserves{begin_sponsor: ^begin_sponsor} =
      EndSponsoringFutureReserves.new(attrs)
  end

  test "new/2 empty_attrs" do
    %EndSponsoringFutureReserves{begin_sponsor: nil} = EndSponsoringFutureReserves.new(%{})
  end
end
