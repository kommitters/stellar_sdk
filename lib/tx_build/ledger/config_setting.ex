defmodule Stellar.TxBuild.Ledger.ConfigSetting do
  @moduledoc """
  Ledger `ConfigSetting` struct definition.
  """
  alias StellarBase.XDR.LedgerKeyConfigSetting
  alias Stellar.TxBuild.ConfigSettingID

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{config_setting_id: ConfigSettingID.t()}

  defstruct [:config_setting_id]

  @impl true
  def new(config_setting_id, opts \\ [])

  def new(config_setting_id, _opts) do
    case ConfigSettingID.new(config_setting_id) do
      %ConfigSettingID{} = config_setting_id -> %__MODULE__{config_setting_id: config_setting_id}
      error -> error
    end
  end

  @impl true
  def to_xdr(%__MODULE__{config_setting_id: config_setting_id}) do
    config_setting_id
    |> ConfigSettingID.to_xdr()
    |> LedgerKeyConfigSetting.new()
  end
end
