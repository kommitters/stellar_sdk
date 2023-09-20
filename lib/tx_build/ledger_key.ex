defmodule Stellar.TxBuild.LedgerKey do
  @moduledoc """
  `LedgerKey` struct definition.
  """

  alias StellarBase.XDR.{LedgerEntryType, LedgerKey}

  alias Stellar.TxBuild.Ledger.{
    Account,
    ClaimableBalance,
    Data,
    ConfigSetting,
    ContractCode,
    ContractData,
    Expiration,
    LiquidityPool,
    Offer,
    Trustline
  }

  @behaviour Stellar.TxBuild.XDR

  @type type ::
          :account
          | :trustline
          | :offer
          | :data
          | :claimable_balance
          | :liquidity_pool
          | :contract_data
          | :contract_code
          | :config_setting
          | :expiration

  @type entry ::
          Account.t()
          | ClaimableBalance.t()
          | Data.t()
          | LiquidityPool.t()
          | Offer.t()
          | Trustline.t()
          | ContractData.t()
          | ContractCode.t()
          | ConfigSetting.t()
          | Expiration.t()

  @type t :: %__MODULE__{type: type(), entry: entry()}

  defstruct [:type, :entry]

  @impl true
  def new(args, opts \\ [])

  def new({:account, [account_id: account_id]}, _opts) do
    case Account.new(account_id) do
      %Account{} = account -> %__MODULE__{type: :account, entry: account}
      _error -> {:error, :invalid_account}
    end
  end

  def new({:claimable_balance, [claimable_balance_id: claimable_balance_id]}, _opts) do
    case ClaimableBalance.new(claimable_balance_id) do
      %ClaimableBalance{} = claimable_balance ->
        %__MODULE__{type: :claimable_balance, entry: claimable_balance}

      _error ->
        {:error, :invalid_claimable_balance}
    end
  end

  def new({:liquidity_pool, [liquidity_pool_id: liquidity_pool_id]}, _opts) do
    case LiquidityPool.new(liquidity_pool_id) do
      %LiquidityPool{} = liquidity_pool ->
        %__MODULE__{type: :liquidity_pool, entry: liquidity_pool}

      _error ->
        {:error, :invalid_liquidity_pool}
    end
  end

  def new({:trustline, trustline}, _opts) do
    case Trustline.new(trustline) do
      %Trustline{} = trustline ->
        %__MODULE__{type: :trustline, entry: trustline}

      _error ->
        {:error, :invalid_trustline}
    end
  end

  def new({:offer, offer}, _opts) do
    case Offer.new(offer) do
      %Offer{} = offer -> %__MODULE__{type: :offer, entry: offer}
      _error -> {:error, :invalid_offer}
    end
  end

  def new({:data, data}, _opts) do
    case Data.new(data) do
      %Data{} = data -> %__MODULE__{type: :data, entry: data}
      _error -> {:error, :invalid_data}
    end
  end

  def new(
        {:contract_data, args},
        _opts
      ) do
    case ContractData.new(args) do
      %ContractData{} = contract_data ->
        %__MODULE__{type: :contract_data, entry: contract_data}

      _error ->
        {:error, :invalid_contract_data}
    end
  end

  def new(
        {:contract_code, args},
        _opts
      ) do
    case ContractCode.new(args) do
      %ContractCode{} = contract_code ->
        %__MODULE__{type: :contract_code, entry: contract_code}

      _error ->
        {:error, :invalid_contract_code}
    end
  end

  def new(
        {:config_setting, args},
        _opts
      ) do
    case ConfigSetting.new(args) do
      %ConfigSetting{} = config_setting ->
        %__MODULE__{type: :config_setting, entry: config_setting}

      _error ->
        {:error, :invalid_config_setting}
    end
  end

  def new(
        {:expiration, args},
        _opts
      ) do
    case Expiration.new(args) do
      %Expiration{} = expiration ->
        %__MODULE__{type: :expiration, entry: expiration}

      _error ->
        {:error, :invalid_expiration}
    end
  end

  def new(_args, _opts), do: {:error, :invalid_ledger_key}

  @impl true
  def to_xdr(%__MODULE__{type: type, entry: %{__struct__: entry_type} = entry}) do
    ledger_entry_type = ledger_entry_type(type)

    entry
    |> entry_type.to_xdr()
    |> LedgerKey.new(ledger_entry_type)
  end

  @spec ledger_entry_type(type :: type()) :: LedgerEntryType.t()
  defp ledger_entry_type(:account), do: LedgerEntryType.new(:ACCOUNT)
  defp ledger_entry_type(:trustline), do: LedgerEntryType.new(:TRUSTLINE)
  defp ledger_entry_type(:offer), do: LedgerEntryType.new(:OFFER)
  defp ledger_entry_type(:data), do: LedgerEntryType.new(:DATA)
  defp ledger_entry_type(:claimable_balance), do: LedgerEntryType.new(:CLAIMABLE_BALANCE)
  defp ledger_entry_type(:liquidity_pool), do: LedgerEntryType.new(:LIQUIDITY_POOL)
  defp ledger_entry_type(:contract_data), do: LedgerEntryType.new(:CONTRACT_DATA)
  defp ledger_entry_type(:contract_code), do: LedgerEntryType.new(:CONTRACT_CODE)
  defp ledger_entry_type(:config_setting), do: LedgerEntryType.new(:CONFIG_SETTING)
  defp ledger_entry_type(:expiration), do: LedgerEntryType.new(:EXPIRATION)
end
