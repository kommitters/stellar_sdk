defmodule Stellar.TxBuild.ContractIDPreimage do
  @moduledoc """
  `ContractIDPreimage` struct definition.
  """
  alias StellarBase.XDR.ContractIDPreimage
  alias StellarBase.XDR.ContractIDPreimageType
  alias Stellar.TxBuild.{Asset, ContractIDPreimageFromAddress}

  @behaviour Stellar.TxBuild.XDR

  @type type :: :from_address | :from_asset
  @type value :: Asset.t() | ContractIDPreimageFromAddress.t()
  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type t :: %__MODULE__{
          type: type(),
          value: value()
        }

  defstruct [:type, :value]

  @allowed_types ~w(from_address from_asset)a

  @impl true
  def new(value, opts \\ [])

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, _value} <- validate_contract_id_preimage({type, value}) do
      %__MODULE__{type: type, value: value}
    end
  end

  def new(_value, _opts), do: {:error, :invalid_contract_id_preimage}

  @impl true
  def to_xdr(%__MODULE__{type: :from_address, value: value}) do
    type = ContractIDPreimageType.new()

    value
    |> ContractIDPreimageFromAddress.to_xdr()
    |> ContractIDPreimage.new(type)
  end

  def to_xdr(%__MODULE__{type: :from_asset, value: value}) do
    type = ContractIDPreimageType.new(:CONTRACT_ID_PREIMAGE_FROM_ASSET)

    value
    |> Asset.to_xdr()
    |> ContractIDPreimage.new(type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_contract_id_preimage({type :: atom(), value :: value()}) :: validation()
  defp validate_contract_id_preimage({:from_asset, %Asset{} = value}), do: {:ok, value}

  defp validate_contract_id_preimage({:from_address, %ContractIDPreimageFromAddress{} = value}),
    do: {:ok, value}

  defp validate_contract_id_preimage({type, _value}), do: {:error, :"invalid_#{type}"}
end
