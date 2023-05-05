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
    SCMapEntry,
    HashIDPreimage
  }

  alias Stellar.{KeyPair, Network}
  alias StellarBase.XDR.{ContractAuth, EnvelopeType, SCVec}
  alias StellarBase.XDR.HashIDPreimage, as: HashIDPreimageXDR
  alias StellarBase.XDR.Hash, as: HashXDR
  alias StellarBase.XDR.HashIDPreimageContractAuth, as: HashIDPreimageContractAuthXDR

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
      [vec: signature_args]
      |> SCVal.new()
      |> SCVal.to_xdr()
      |> (&SCVec.new([&1])).()

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
        SCVal.new(bytes: raw_public_key)
      )

    signature_map_entry =
      SCMapEntry.new(
        SCVal.new(symbol: "signature"),
        SCVal.new(bytes: signature)
      )

    signature_sc_val = SCVal.new(map: [public_key_map_entry, signature_map_entry])

    %{contract_auth | signature_args: signature_args ++ [signature_sc_val]}
  end

  def sign(_args, _val), do: {:error, :invalid_secret_key}

  @spec sign_xdr(base_64 :: binary(), secret_key :: binary()) :: binary()
  def sign_xdr(base_64, secret_key) do
    {public_key, _secret_key} = KeyPair.from_secret_seed(secret_key)
    raw_public_key = KeyPair.raw_public_key(public_key)
    network_id = network_id_xdr()

    {%ContractAuth{
       address_with_nonce: %{
         address_with_nonce: %{
           nonce: nonce
         }
       },
       authorized_invocation: authorized_invocation
     } = contract_auth,
     ""} =
      base_64
      |> Base.decode64!()
      |> ContractAuth.decode_xdr!()

    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_CONTRACT_AUTH)

    signature =
      network_id
      |> HashXDR.new()
      |> HashIDPreimageContractAuthXDR.new(nonce, authorized_invocation)
      |> HashIDPreimageXDR.new(envelope_type)
      |> HashIDPreimageXDR.encode_xdr!()
      |> hash()
      |> KeyPair.sign(secret_key)

    public_key_map_entry =
      SCMapEntry.new(
        SCVal.new(symbol: "public_key"),
        SCVal.new(bytes: raw_public_key)
      )

    signature_map_entry =
      SCMapEntry.new(
        SCVal.new(symbol: "signature"),
        SCVal.new(bytes: signature)
      )

    signature_args = [SCVal.new(map: [public_key_map_entry, signature_map_entry])]

    signature_xdr_val =
      [vec: signature_args]
      |> SCVal.new()
      |> SCVal.to_xdr()
      |> (&SCVec.new([&1])).()

    %{
      contract_auth
      | signature_args: signature_xdr_val
    }
    |> ContractAuth.encode_xdr!()
    |> Base.encode64()
  end

  @spec network_id_xdr :: binary()
  defp network_id_xdr, do: hash(Network.passphrase())

  @spec hash(data :: binary()) :: binary()
  defp hash(data), do: :crypto.hash(:sha256, data)

  @spec validate_authorized_invocation(tuple :: tuple()) :: validation()
  defp validate_authorized_invocation({_field, %AuthorizedInvocation{} = value}),
    do: {:ok, value}

  defp validate_authorized_invocation({field, _}), do: {:error, :"invalid_#{field}"}
end
