defmodule Stellar.TxBuild.SorobanAddressCredentials do
  @moduledoc """
  `SorobanAddressCredentials` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [validate_address: 1, validate_vec: 1]

  alias StellarBase.XDR.{Int64, SorobanAddressCredentials, UInt32}
  alias Stellar.TxBuild.{SCAddress, SCVec}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type address :: SCAddress.t()
  @type nonce :: non_neg_integer()
  @type signature_expiration_ledger :: non_neg_integer()
  @type signature_args :: SCVec.t()

  @type t :: %__MODULE__{
          address: address(),
          nonce: nonce(),
          signature_expiration_ledger: signature_expiration_ledger(),
          signature_args: signature_args()
        }

  defstruct [
    :address,
    :nonce,
    :signature_expiration_ledger,
    :signature_args
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    address = Keyword.get(args, :address)
    nonce = Keyword.get(args, :nonce)
    signature_expiration_ledger = Keyword.get(args, :signature_expiration_ledger)
    signature_args = Keyword.get(args, :signature_args)

    with {:ok, address} <- validate_address(address),
         {:ok, nonce} <- validate_integer({nonce, :nonce}),
         {:ok, signature_expiration_ledger} <-
           validate_integer({signature_expiration_ledger, :signature_expiration_ledger}),
         {:ok, signature_args} <- validate_vec(signature_args) do
      %__MODULE__{
        address: address,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        signature_args: signature_args
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_soroban_address_args}

  @impl true
  def to_xdr(%__MODULE__{
        address: address,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        signature_args: signature_args
      }) do
    nonce = Int64.new(nonce)
    signature_expiration_ledger = UInt32.new(signature_expiration_ledger)
    signature_args = SCVec.to_xdr(signature_args)

    address
    |> SCAddress.to_xdr()
    |> SorobanAddressCredentials.new(nonce, signature_expiration_ledger, signature_args)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_integer(tuple()) :: validation()
  defp validate_integer({integer, _type}) when is_integer(integer), do: {:ok, integer}
  defp validate_integer({_integer, type}), do: {:error, :"invalid_#{type}"}
end
