defmodule Stellar.TxBuild.ConfigSettingIDTest do
  use ExUnit.Case

  alias Stellar.TxBuild.ConfigSettingID

  setup do
    identifier = :max_size

    %{
      identifier: identifier
    }
  end

  test "new/1", %{identifier: identifier} do
    %ConfigSettingID{identifier: ^identifier} = ConfigSettingID.new(identifier)
  end

  test "new/1 with invalid args" do
    {:error, :invalid_identifier} = ConfigSettingID.new(:invalid)
  end

  test "to_xdr/1", %{identifier: identifier} do
    %StellarBase.XDR.ConfigSettingID{identifier: :MAX_SIZE_BYTES} =
      identifier
      |> ConfigSettingID.new()
      |> ConfigSettingID.to_xdr()
  end

  test "to_xdr/1 with invalid struct" do
    {:error, :invalid_struct} = ConfigSettingID.to_xdr(:invalid)
  end
end
