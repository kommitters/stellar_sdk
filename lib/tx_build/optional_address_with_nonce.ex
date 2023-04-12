defmodule Stellar.TxBuild.OptionalAddressWithNonce do
  @moduledoc """
  `OptionalAddressWithNonce` struct definition.
  """

  alias StellarBase.XDR.OptionalAddressWithNonce
  alias Stellar.TxBuild.AddressWithNonce

  @behaviour Stellar.TxBuild.XDR

  @type address_with_nonce :: AddressWithNonce.t() | nil

  @type t :: %__MODULE__{address_with_nonce: address_with_nonce()}

  defstruct [:address_with_nonce]

  @impl true
  def new(address_with_nonce \\ nil, opts \\ [])

  def new(%AddressWithNonce{} = address_with_nonce, _opts),
    do: %__MODULE__{address_with_nonce: address_with_nonce}

  def new(nil, _opts), do: %__MODULE__{address_with_nonce: nil}

  def new(_address_with_nonce, _opts), do: {:error, :invalid_optional_address_with_nonce}

  @impl true
  def to_xdr(%__MODULE__{address_with_nonce: nil}), do: OptionalAddressWithNonce.new()

  def to_xdr(%__MODULE__{address_with_nonce: address_with_nonce}) do
    address_with_nonce
    |> AddressWithNonce.to_xdr()
    |> OptionalAddressWithNonce.new()
  end

  def to_xdr(_error), do: {:error, :invalid_struct_optional_address_with_nonce}
end
