defmodule Stellar.Horizon.Account.FlagsTest do
  use ExUnit.Case

  alias Stellar.Horizon.Account.Flags

  setup do
    %{
      attrs: %{
        auth_required: true,
        auth_revocable: false,
        auth_immutable: false,
        auth_clawback_enabled: true
      }
    }
  end

  test "new/2", %{attrs: attrs} do
    %Flags{
      auth_required: true,
      auth_revocable: false,
      auth_immutable: false,
      auth_clawback_enabled: true
    } = Flags.new(attrs)
  end

  test "new/2 empty_attrs" do
    %Flags{
      auth_required: false,
      auth_revocable: false,
      auth_immutable: false,
      auth_clawback_enabled: false
    } = Flags.new(%{})
  end
end
