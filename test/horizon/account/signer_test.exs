defmodule Stellar.Horizon.Account.SignerTest do
  use ExUnit.Case

  alias Stellar.Horizon.Account.Signer

  setup do
    %{
      attrs: %{
        weight: 1,
        key: "GC7HDCY5A5Q6BJ466ABYJSZWPKQIWBPRHZMT3SUHW2YYDXGPZVS7I36S",
        type: "ed25519_public_key"
      }
    }
  end

  test "new/2", %{attrs: attrs} do
    %Signer{
      weight: 1,
      key: "GC7HDCY5A5Q6BJ466ABYJSZWPKQIWBPRHZMT3SUHW2YYDXGPZVS7I36S",
      type: "ed25519_public_key"
    } = Signer.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Signer{weight: nil, key: nil, type: nil} = Signer.new(%{})
  end
end
