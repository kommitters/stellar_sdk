defmodule Stellar.TxBuild.ConfigSettingID do
  @moduledoc """
  `ConfigSettingID` struct definition.
  """
  alias StellarBase.XDR.ConfigSettingID

  @behaviour Stellar.TxBuild.XDR

  @type identifier_type :: atom()
  @type validation :: {:ok, atom()}

  @type t :: %__MODULE__{identifier: identifier_type()}

  defstruct [:identifier]

  @identifiers %{
    max_size: :MAX_SIZE_BYTES,
    compute: :COMPUTE_V0,
    ledger_cost: :LEDGER_COST_V0,
    historical_data: :HISTORICAL_DATA_V0,
    events: :EVENTS_V0,
    bandwidth: :BANDWIDTH_V0,
    cost_params_cpu: :COST_PARAMS_CPU_INSTRUCTIONS,
    cost_params_memory: :COST_PARAMS_MEMORY_BYTES,
    data_key_size: :DATA_KEY_SIZE_BYTES,
    data_entry_size: :DATA_ENTRY_SIZE_BYTES
  }

  @impl true
  def new(identifier, opts \\ [])

  def new(identifier, _opts) when is_map_key(@identifiers, identifier),
    do: %__MODULE__{identifier: identifier}

  def new(_args, _opts), do: {:error, :invalid_identifier}

  @impl true
  def to_xdr(%__MODULE__{identifier: identifier}) do
    with {:ok, identifier} <- retrieve_xdr_identifier(identifier) do
      ConfigSettingID.new(identifier)
    end
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec retrieve_xdr_identifier(identifier :: identifier_type()) :: validation()
  defp retrieve_xdr_identifier(identifier), do: {:ok, Map.get(@identifiers, identifier)}
end
