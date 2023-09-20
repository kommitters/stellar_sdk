defmodule Stellar.TxBuild.SorobanAddressCredentials do
  @moduledoc """
  `SorobanAddressCredentials` struct definition.
  """
  import Stellar.TxBuild.Validations,
    only: [validate_address: 1]

  alias StellarBase.XDR.{Int64, SorobanAddressCredentials, UInt32}
  alias Stellar.TxBuild.{SCAddress, SCVal}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type address :: SCAddress.t()
  @type nonce :: non_neg_integer()
  @type signature_expiration_ledger :: non_neg_integer()
  @type signature :: SCVal.t()

  @type t :: %__MODULE__{
          address: address(),
          nonce: nonce(),
          signature_expiration_ledger: signature_expiration_ledger(),
          signature: signature()
        }

  defstruct [
    :address,
    :nonce,
    :signature_expiration_ledger,
    :signature
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    address = Keyword.get(args, :address)
    nonce = Keyword.get(args, :nonce)
    signature_expiration_ledger = Keyword.get(args, :signature_expiration_ledger)
    signature = Keyword.get(args, :signature)

    with {:ok, address} <- validate_address(address),
         {:ok, nonce} <- validate_integer({nonce, :nonce}),
         {:ok, signature_expiration_ledger} <-
           validate_integer({signature_expiration_ledger, :signature_expiration_ledger}),
         {:ok, signature} <- validate_sc_val(signature) do
      %__MODULE__{
        address: address,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        signature: signature
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_soroban_address_args}

  @impl true
  def to_xdr(%__MODULE__{
        address: address,
        nonce: nonce,
        signature_expiration_ledger: signature_expiration_ledger,
        signature: signature
      }) do
    nonce = Int64.new(nonce)
    signature_expiration_ledger = UInt32.new(signature_expiration_ledger)
    signature = SCVal.to_xdr(signature)

    address
    |> SCAddress.to_xdr()
    |> SorobanAddressCredentials.new(nonce, signature_expiration_ledger, signature)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_integer(tuple()) :: validation()
  defp validate_integer({integer, _type}) when is_integer(integer), do: {:ok, integer}
  defp validate_integer({_integer, type}), do: {:error, :"invalid_#{type}"}

  @spec validate_sc_val(sc_val :: signature()) :: validation()
  defp validate_sc_val(%SCVal{} = sc_val), do: {:ok, sc_val}
  defp validate_sc_val(_sc_val), do: {:error, :invalid_sc_val}
end
