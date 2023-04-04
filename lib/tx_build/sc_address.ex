defmodule Stellar.TxBuild.SCAddress do
  @moduledoc """
  `SCAddress` struct definition.
  """

  import Stellar.TxBuild.Validations, only: [validate_account_id: 1]

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{
    SCAddressType,
    Hash,
    SCAddress
  }

  alias Stellar.TxBuild.AccountID

  @type validation :: {:ok, any()} | {:error, atom()}

  @type value :: binary()

  @type t :: %__MODULE__{
          type: atom(),
          value: value()
        }

  @allowed_types ~w(account contract)a

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, _value} <- validate_sc_address({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sc_address}

  @impl true
  def to_xdr(%__MODULE__{type: :account, value: value}) do
    type = SCAddressType.new(:SC_ADDRESS_TYPE_ACCOUNT)

    value
    |> AccountID.new()
    |> AccountID.to_xdr()
    |> SCAddress.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract, value: value}) do
    type = SCAddressType.new(:SC_ADDRESS_contract)

    value
    |> Hash.new()
    |> SCAddress.new(type)
  end

  @spec validate_sc_address(tuple :: tuple()) :: validation()
  defp validate_sc_address({:account, value}) do
    case validate_account_id({:account, value}) do
      {:ok, account_id} -> {:ok, account_id}
      {:error, _reason} -> {:error, :invalid_account_id}
    end
  end

  defp validate_sc_address({:contract, value}) when is_binary(value), do: {:ok, value}
  defp validate_sc_address({:contract, _value}), do: {:error, :invalid_contract_hash}
end
