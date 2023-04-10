defmodule Stellar.TxBuild.AddressWithNonce do
  @moduledoc """
  `AddressWithNonce` struct definition.
  """
  alias Stellar.TxBuild.SCAddress
  alias StellarBase.XDR.{AddressWithNonce, UInt64}

  @behaviour Stellar.TxBuild.XDR

  defstruct [:address, :nonce]

  @type t :: %__MODULE__{address: SCAddress.t(), nonce: non_neg_integer()}
  @impl true
  def new(args, opts \\ nil)

  def new(
        [
          %SCAddress{} = address,
          nonce
        ],
        _opts
      )
      when is_integer(nonce) and nonce >= 0 do
    %__MODULE__{
      address: address,
      nonce: nonce
    }
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
end
