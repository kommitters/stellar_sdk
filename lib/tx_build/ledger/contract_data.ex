defmodule Stellar.TxBuild.Ledger.ContractData do
  @moduledoc """
  `ContractData` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [validate_address: 1]

  alias Stellar.TxBuild.{SCAddress, SCVal}
  alias StellarBase.XDR.{ContractEntryBodyType, ContractDataDurability, LedgerKeyContractData}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type contract :: SCAddress.t()
  @type key :: SCVal.t()
  @type durability :: :temporary | :persistent
  @type body_type :: :data_entry | :expiration_ext

  @type t :: %__MODULE__{
          contract: contract(),
          key: key(),
          durability: durability(),
          body_type: body_type()
        }

  defstruct [:contract, :key, :durability, :body_type]

  @allowed_durabilities ~w(temporary persistent)a
  @allowed_body_types ~w(data_entry expiration_ext)a

  @impl true
  def new(args, opts \\ [])

  def new(
        [
          {:contract, contract},
          {:key, key},
          {:durability, durability},
          {:body_type, body_type}
        ],
        _opts
      )
      when durability in @allowed_durabilities and body_type in @allowed_body_types do
    with {:ok, contract} <- validate_address(contract),
         {:ok, key} <- validate_sc_val_ledger_instance(key) do
      %__MODULE__{
        contract: contract,
        key: key,
        durability: durability,
        body_type: body_type
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_ledger_key_args}

  @impl true
  def to_xdr(%__MODULE__{
        contract: contract,
        key: key,
        durability: durability,
        body_type: body_type
      }) do
    key = SCVal.to_xdr(key)
    durability = durability_to_xdr(durability)
    body_type = body_type_to_xdr(body_type)

    contract
    |> SCAddress.to_xdr()
    |> LedgerKeyContractData.new(key, durability, body_type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_sc_val_ledger_instance(key :: key()) :: validation()
  defp validate_sc_val_ledger_instance(%SCVal{} = key), do: {:ok, key}
  defp validate_sc_val_ledger_instance(_key), do: {:error, :invalid_key}

  @spec durability_to_xdr(atom()) :: ContractDataDurability.t()
  defp durability_to_xdr(:temporary), do: ContractDataDurability.new(:TEMPORARY)
  defp durability_to_xdr(:persistent), do: ContractDataDurability.new(:PERSISTENT)

  @spec body_type_to_xdr(atom()) :: ContractEntryBodyType.t()
  defp body_type_to_xdr(:data_entry), do: ContractEntryBodyType.new(:DATA_ENTRY)
  defp body_type_to_xdr(:expiration_ext), do: ContractEntryBodyType.new(:EXPIRATION_EXTENSION)
end
