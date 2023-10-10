defmodule Stellar.Horizon.Operation.BumpFootprintExpirationTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.BumpFootprintExpiration

  setup do
    %{
      attrs: %{
        ledgers_to_expire: 100_000
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        ledgers_to_expire: ledgers_to_expire
      } = attrs
  } do
    %BumpFootprintExpiration{
      ledgers_to_expire: ^ledgers_to_expire
    } = BumpFootprintExpiration.new(attrs)
  end

  test "new/2 empty_attrs" do
    %BumpFootprintExpiration{
      ledgers_to_expire: nil
    } = BumpFootprintExpiration.new(%{})
  end
end
