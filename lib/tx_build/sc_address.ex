defmodule Stellar.TxBuild.SCAddress do
  @moduledoc """
  `SCAddress` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{
    SCAddressType,
    Hash,
    SCAddress,
    AccountID
  }

  alias StellarBase.XDR.AccountID, as: AccountIDFromXDR

  alias Stellar.TxBuild.AccountID

  @type validation :: {:ok, any()} | {:error, atom()}

  @type value :: AccountID.t() | binary()

  @type t :: %__MODULE__{
          type: String.t(),
          value: value()
        }

  @allowed_types ~w(type_account type_contract)a

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
  def to_xdr(%__MODULE__{type: :type_account, value: value}) do
    type = SCAddressType.new(:SC_ADDRESS_TYPE_ACCOUNT)

    value
    |> AccountID.to_xdr()
    |> SCAddress.new(type)
  end

  def to_xdr(%__MODULE__{type: :type_contract, value: value}) do
    type = SCAddressType.new(:SC_ADDRESS_TYPE_CONTRACT)

    value
    |> Hash.new()
    |> SCAddress.new(type)
  end

  @spec validate_sc_address(tuple :: tuple()) :: validation()
  def validate_sc_address({:type_account, value}) do
    case value |> AccountID.to_xdr() |> AccountIDFromXDR.encode_xdr() do
      {:ok, _void} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_account_id}
    end
  end

  def validate_sc_address({:type_contract, value}) do
    case value |> Hash.new() |> Hash.encode_xdr() do
      {:ok, _hash} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_hash}
    end
  end
end
