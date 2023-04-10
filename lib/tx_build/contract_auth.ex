defmodule Stellar.TxBuild.ContractAuth do
  @moduledoc """
  `ContractAuth` struct definition.
  """

  alias StellarBase.XDR.{ContractAuth, SCVec, OptionalAddressWithNonce}
  alias Stellar.TxBuild.{AuthorizedInvocation, AddressWithNonce, SCVal}

  @type t :: %__MODULE__{
          address_with_nonce: AddressWithNonce.t(),
          authorized_invocation: AuthorizedInvocation.t(),
          signature_args: list(SCVal.t())
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:address_with_nonce, :authorized_invocation, :signature_args]

  @impl true
  def new(args, opts \\ nil)

  def new(
        [
          %AddressWithNonce{} = address_with_nonce,
          %AuthorizedInvocation{} = authorized_invocation,
          [%SCVal{} | _] = signature_args
        ],
        _opts
      ) do
    %__MODULE__{
      address_with_nonce: address_with_nonce,
      authorized_invocation: authorized_invocation,
      signature_args: signature_args
    }
  end

  def new(_args, _opts), do: {:error, :invalid_contract_auth}

  @impl true
  def to_xdr(%__MODULE__{
        address_with_nonce: address_with_nonce,
        authorized_invocation: authorized_invocation,
        signature_args: signature_args
      }) do
    address_with_nonce =
      address_with_nonce |> AddressWithNonce.to_xdr() |> OptionalAddressWithNonce.new()

    authorized_invocation = AuthorizedInvocation.to_xdr(authorized_invocation)
    signature_args = signature_args |> Enum.map(&SCVal.to_xdr/1) |> SCVec.new()

    ContractAuth.new(address_with_nonce, authorized_invocation, signature_args)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct_contract_auth}
end
