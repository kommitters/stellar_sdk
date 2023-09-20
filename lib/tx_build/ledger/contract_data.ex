defmodule Stellar.TxBuild.Ledger.ContractData do
  @moduledoc """
  `ContractData` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [validate_address: 1]

  alias Stellar.TxBuild.{SCAddress, SCVal}
  alias StellarBase.XDR.{ContractDataDurability, LedgerKeyContractData}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type contract :: SCAddress.t()
  @type key :: SCVal.t()
  @type durability :: :temporary | :persistent

  @type t :: %__MODULE__{
          contract: contract(),
          key: key(),
          durability: durability()
        }

  defstruct [:contract, :key, :durability]

  @allowed_durabilities ~w(temporary persistent)a

  @impl true
  def new(args, opts \\ [])

  def new(
        [
          {:contract, contract},
          {:key, key},
          {:durability, durability}
        ],
        _opts
      )
      when durability in @allowed_durabilities do
    with {:ok, contract} <- validate_address(contract),
         {:ok, key} <- validate_sc_val_ledger_instance(key) do
      %__MODULE__{
        contract: contract,
        key: key,
        durability: durability
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_ledger_key_args}

  @impl true
  def to_xdr(%__MODULE__{
        contract: contract,
        key: key,
        durability: durability
      }) do
    key = SCVal.to_xdr(key)
    durability = durability_to_xdr(durability)

    contract
    |> SCAddress.to_xdr()
    |> LedgerKeyContractData.new(key, durability)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_sc_val_ledger_instance(key :: key()) :: validation()
  defp validate_sc_val_ledger_instance(%SCVal{} = key), do: {:ok, key}
  defp validate_sc_val_ledger_instance(_key), do: {:error, :invalid_key}

  @spec durability_to_xdr(atom()) :: ContractDataDurability.t()
  defp durability_to_xdr(:temporary), do: ContractDataDurability.new(:TEMPORARY)
  defp durability_to_xdr(:persistent), do: ContractDataDurability.new(:PERSISTENT)
end
