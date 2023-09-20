defmodule Stellar.TxBuild.Ledger.ConfigSettingTest do
  use ExUnit.Case

  alias StellarBase.XDR.{ConfigSettingID, LedgerKeyConfigSetting}
  alias Stellar.TxBuild.ConfigSettingID, as: TxConfigSettingID
  alias Stellar.TxBuild.Ledger.ConfigSetting

  setup do
    %{
      config_setting_id: :max_size
    }
  end

  test "new/1", %{config_setting_id: config_setting_id} do
    %ConfigSetting{
      config_setting_id: %TxConfigSettingID{identifier: ^config_setting_id}
    } = ConfigSetting.new(config_setting_id)
  end

  test "new/1 with invalid config_setting_id" do
    {:error, :invalid_identifier} = ConfigSetting.new(:invalid)
  end

  test "to_xdr/1", %{config_setting_id: config_setting_id} do
    %LedgerKeyConfigSetting{
      config_setting_id: %ConfigSettingID{identifier: :MAX_SIZE_BYTES}
    } =
      config_setting_id
      |> ConfigSetting.new()
      |> ConfigSetting.to_xdr()
  end
end
