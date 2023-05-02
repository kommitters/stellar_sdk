defmodule Stellar.TxBuild.SCAddress do
  @moduledoc """
  `SCAddress` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias Stellar.KeyPair

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

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new(value, _opts) do
    with {:ok, {type, value}} <- validate_sc_address(value) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

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

  @spec validate_sc_address(value :: binary()) :: validation()
  defp validate_sc_address(value) when is_binary(value) do
    cond do
      KeyPair.validate_public_key(value) == :ok -> {:ok, {:account, value}}
      KeyPair.validate_contract(value) == :ok -> {:ok, {:contract, value}}
      true -> {:error, :invalid_sc_address}
    end
  end

  defp validate_sc_address(_value), do: {:error, :invalid_sc_address}
end
