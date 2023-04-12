defmodule Stellar.TxBuild.ContractAuth do
  @moduledoc """
  `ContractAuth` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [
      validate_sc_vals: 1,
      validate_optional_address_with_nonce: 1
    ]

  alias Stellar.TxBuild.{
    AuthorizedInvocation,
    OptionalAddressWithNonce,
    SCObject,
    SCMapEntry,
    HashIDPreimage
  }

  alias Stellar.KeyPair
  alias Stellar.Network
  alias StellarBase.XDR.{ContractAuth, SCVec}
  alias StellarBase.XDR.HashIDPreimage, as: HashIDPreimageXDR

  alias Stellar.TxBuild.{
    AddressWithNonce,
    SCVal,
    HashIDPreimageContractAuth
  }

  @type error :: Keyword.t() | atom()
  @type validation :: {:ok, any()} | {:error, error()}

  @type t :: %__MODULE__{
          address_with_nonce: OptionalAddressWithNonce.t(),
          authorized_invocation: AuthorizedInvocation.t(),
          signature_args: list(SCVal.t())
        }

  @behaviour Stellar.TxBuild.XDR

  defstruct [:address_with_nonce, :authorized_invocation, :signature_args]

  @impl true
  def new(args, opts \\ nil)

  def new(args, _opts) when is_list(args) do
    address_with_nonce = Keyword.get(args, :address_with_nonce)
    authorized_invocation = Keyword.get(args, :authorized_invocation)
    signature_args = Keyword.get(args, :signature_args, [])

    with {:ok, opt_address_with_nonce} <-
           validate_optional_address_with_nonce({:address_with_nonce, address_with_nonce}),
         {:ok, authorized_invocation} <-
           validate_authorized_invocation({:authorized_invocation, authorized_invocation}),
         {:ok, signature_args} <-
           validate_sc_vals({:signature_args, signature_args}) do
      %__MODULE__{
        address_with_nonce: opt_address_with_nonce,
        authorized_invocation: authorized_invocation,
        signature_args: signature_args
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_contract_auth}

  @impl true
  def to_xdr(%__MODULE__{
        address_with_nonce: address_with_nonce,
        authorized_invocation: authorized_invocation,
        signature_args: signature_args
      }) do
    address_with_nonce = OptionalAddressWithNonce.to_xdr(address_with_nonce)

    authorized_invocation = AuthorizedInvocation.to_xdr(authorized_invocation)

    signature_args =
      signature_args
      |> Enum.map(&SCVal.to_xdr/1)
      |> SCVec.new()

    ContractAuth.new(address_with_nonce, authorized_invocation, signature_args)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct_contract_auth}

  @spec sign(contract_auth :: t(), secret_key :: binary) :: t()
  def sign(
        %__MODULE__{
          address_with_nonce: %OptionalAddressWithNonce{
            address_with_nonce: %AddressWithNonce{nonce: nonce}
          },
          authorized_invocation: authorized_invocation,
          signature_args: signature_args
        } = contract_auth,
        secret_key
      )
      when is_binary(secret_key) do
    {public_key, _secret_key} = KeyPair.from_secret_seed(secret_key)
    raw_public_key = KeyPair.raw_public_key(public_key)
    network_id = network_id_xdr()

    signature =
      [
        network_id: network_id,
        nonce: nonce,
        invocation: authorized_invocation
      ]
      |> HashIDPreimageContractAuth.new()
      |> (&HashIDPreimage.new(contract_auth: &1)).()
      |> HashIDPreimage.to_xdr()
      |> HashIDPreimageXDR.encode_xdr!()
      |> hash()
      |> KeyPair.sign(secret_key)

    public_key_map_entry =
      SCMapEntry.new(
        SCVal.new(symbol: "public_key"),
        SCVal.new(object: SCObject.new(bytes: raw_public_key))
      )

    signature_map_entry =
      SCMapEntry.new(
        SCVal.new(symbol: "signature"),
        SCVal.new(object: SCObject.new(bytes: signature))
      )

    signature_sc_val =
      SCVal.new(object: SCObject.new(map: [public_key_map_entry, signature_map_entry]))

    %{contract_auth | signature_args: signature_args ++ [signature_sc_val]}
  end

  def sign(_args, _val), do: {:error, :invalid_secret_key}

  @spec network_id_xdr :: binary()
  defp network_id_xdr, do: hash(Network.passphrase())

  @spec hash(data :: binary()) :: binary()
  defp hash(data), do: :crypto.hash(:sha256, data)

  @spec validate_authorized_invocation(tuple :: tuple()) :: validation()
  defp validate_authorized_invocation({_field, %AuthorizedInvocation{} = value}),
    do: {:ok, value}

  defp validate_authorized_invocation({field, _}), do: {:error, :"invalid_#{field}"}
end
