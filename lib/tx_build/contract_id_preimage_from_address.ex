defmodule Stellar.TxBuild.ContractIDPreimageFromAddress do
  @moduledoc """
  `ContractIDPreimageFromAddress` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [validate_address: 1]

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{ContractIDPreimageFromAddress, UInt256}
  alias Stellar.TxBuild.SCAddress

  defstruct [:address, :salt]

  @type address :: SCAddress.t()
  @type salt :: binary()
  @type t :: %__MODULE__{address: address(), salt: salt()}

  @impl true
  def new(value, opts \\ [])

  def new(
        [{:address, address}, {:salt, salt}],
        _opts
      )
      when is_binary(salt) do
    with {:ok, address} <- validate_address(address) do
      %__MODULE__{address: address, salt: salt}
    end
  end

  def new(_value, _opts), do: {:error, :invalid_contract_id_preimage_value}

  @impl true
  def to_xdr(%__MODULE__{address: address, salt: salt}) do
    salt = UInt256.new(salt)

    address
    |> SCAddress.to_xdr()
    |> ContractIDPreimageFromAddress.new(salt)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
