defmodule Stellar.Horizon.Operation.InvokeHostFunctionTest do
  use ExUnit.Case

  alias Stellar.Horizon.Operation.InvokeHostFunction

  setup do
    %{
      attrs: %{
        function: "HostFunctionTypeHostFunctionTypeInvokeContract",
        parameters: [
          %{
            type: "Address",
            value: "AAAAEgAAAAFuL7HZoCvx+bT/To+OHfO36+3/QkxgYkN2Y+TiQOuY7A=="
          },
          %{type: "Sym", value: "AAAADwAAAAtjcmVhdGVfaGFzaAA="},
          %{
            type: "Address",
            value: "AAAAEgAAAAAAAAAABpLiohe9shRsvLoKhMVgFTIo7LbxpoyQKCmVIOLlG5o="
          },
          %{
            type: "Bytes",
            value: "AAAADQAAACA4uD/WlFMTWPjbOpu3xGfxE80ffpQiiWfrYP07dCWhkA=="
          }
        ],
        address: "",
        salt: "",
        asset_balance_changes: []
      }
    }
  end

  test "new/2", %{
    attrs:
      %{
        function: function,
        parameters: parameters,
        address: address,
        salt: salt,
        asset_balance_changes: asset_balance_changes
      } = attrs
  } do
    %InvokeHostFunction{
      function: ^function,
      parameters: ^parameters,
      address: ^address,
      salt: ^salt,
      asset_balance_changes: ^asset_balance_changes
    } = InvokeHostFunction.new(attrs)
  end

  test "new/2 empty_attrs" do
    %InvokeHostFunction{
      function: nil,
      parameters: nil,
      address: nil,
      salt: nil,
      asset_balance_changes: nil
    } = InvokeHostFunction.new(%{})
  end
end
