defmodule Stellar.TxBuild.Ledger.ContractData do
  @moduledoc """
  Ledger `ContractData` struct definition.
  """
  alias StellarBase.XDR.{ContractData, Hash}
  alias Stellar.TxBuild.{SCVal}

  @behaviour Stellar.TxBuild.XDR

  @type contract_id :: binary()
  @type key :: SCVal.t()
  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{contract_id: binary(), key: SCVal.t()}

  defstruct [:contract_id, :key]

  @impl true
  def new(args, opts \\ [])

  # ContractData.new(contract_id: JAKLDFJIAER232AIW, key: 123)
  def new(args, _opts) do
    contract_id = Keyword.get(args, :contract_id)
    key = Keyword.get(args, :key)

    with {:ok, contract_id} <- validate_contract_id(contract_id),
         {:ok, key} <- validate_contract_data_key(key) do
      %__MODULE__{contract_id: contract_id, key: key}
    end
  end

  @impl true
  def to_xdr(%__MODULE__{contract_id: contract_id, key: key}) do
    contract_data = SCVal.to_xdr(key)

    contract_id
    |> Hash.new()
    |> ContractData.new(contract_data)
  end

  @spec validate_contract_id(contract_id :: contract_id()) :: validation()
  defp validate_contract_id(contract_id) do
    case Hash.new(contract_id) do
      %Hash{} = contract_id -> {:ok, contract_id}
      _error -> {:error, :invalid_account}
    end
  end

  @spec validate_contract_data_key(key :: key()) :: validation()
  defp validate_contract_data_key(key) do
    case SCVal.new(key) do
      %SCVal{} = contract_key -> {:ok, contract_key}
      _error -> {:error, :invalid_key}
    end
  end
end
