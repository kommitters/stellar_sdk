defmodule Stellar.TxBuild.AddressWithNonce do
  @moduledoc """
  `AddressWithNonce` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [
      validate_pos_integer: 1
    ]

  alias Stellar.TxBuild.SCAddress
  alias StellarBase.XDR.{AddressWithNonce, UInt64}

  @behaviour Stellar.TxBuild.XDR

  defstruct [:address, :nonce]

  @type validation :: {:ok, any()} | {:error, atom()}

  @type t :: %__MODULE__{address: SCAddress.t(), nonce: non_neg_integer()}
  @impl true
  def new(args, opts \\ nil)

  ## change functions to keyword list
  def new(args, _opts) when is_list(args) do
    address = Keyword.get(args, :address)
    nonce = Keyword.get(args, :nonce)

    with {:ok, address} <- validate_address({:address, address}),
         {:ok, nonce} <- validate_pos_integer({:nonce, nonce}) do
      %__MODULE__{
        address: address,
        nonce: nonce
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_address_with_nonce}

  @impl true
  def to_xdr(%__MODULE__{
        address: address,
        nonce: nonce
      }) do
    address = SCAddress.to_xdr(address)
    nonce = UInt64.new(nonce)

    AddressWithNonce.new(address, nonce)
  end

  def to_xdr(_error), do: {:error, :invalid_struct_address_with_nonce}

  @spec validate_address(tuple()) :: validation()
  defp validate_address({_field, %SCAddress{} = value}), do: {:ok, value}
  defp validate_address({field, _value}), do: {:error, :"invalid_#{field}"}
end
