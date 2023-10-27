defmodule Stellar.Horizon.Operation.ExtendFootprintTTLTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.ExtendFootprintTTL

  setup do
    %{
      attrs: %{
        extend_to: 100_000
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        extend_to: extend_to
      } = attrs
  } do
    %ExtendFootprintTTL{
      extend_to: ^extend_to
    } = ExtendFootprintTTL.new(attrs)
  end

  test "new/2 empty_attrs" do
    %ExtendFootprintTTL{
      extend_to: nil
    } = ExtendFootprintTTL.new(%{})
  end
end
