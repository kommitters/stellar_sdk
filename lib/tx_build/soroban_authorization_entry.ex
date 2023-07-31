defmodule Stellar.TxBuild.SorobanAuthorizationEntry do
  @moduledoc """
  `SorobanAuthorizationEntry` struct definition.
  """

  alias StellarBase.XDR.HashIDPreimage, as: HashIDPreimageXDR

  alias StellarBase.XDR.HashIDPreimageSorobanAuthorization,
    as: HashIDPreimageSorobanAuthorizationXDR

  alias StellarBase.XDR.SCVec, as: SCVecXDR
  alias StellarBase.XDR.SorobanAddressCredentials, as: SorobanAddressCredentialsXDR
  alias StellarBase.XDR.SorobanAuthorizedInvocation, as: SorobanAuthorizedInvocationXDR
  alias StellarBase.XDR.{EnvelopeType, Hash, Int64, SorobanAuthorizationEntry, UInt32}
  alias Stellar.{KeyPair, Network}

  alias Stellar.TxBuild.{
    HashIDPreimage,
    HashIDPreimageSorobanAuthorization,
    SCMapEntry,
    SCVal,
    SCVec,
    SorobanAddressCredentials,
    SorobanCredentials,
    SorobanAuthorizedInvocation
  }

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type base_64 :: String.t()
  @type secret_key :: String.t()
  @type sign_authorization :: String.t()
  @type latest_ledger :: non_neg_integer()
  @type credentials :: SorobanCredentials.t()
  @type root_invocation :: SorobanAuthorizedInvocation.t()

  @type t :: %__MODULE__{
          credentials: credentials(),
          root_invocation: root_invocation()
        }

  defstruct [:credentials, :root_invocation]

  @impl true
  def new(value, opts \\ [])

  def new(args, _opts) when is_list(args) do
    credentials = Keyword.get(args, :credentials)
    root_invocation = Keyword.get(args, :root_invocation)

    with {:ok, credentials} <- validate_credentials(credentials),
         {:ok, root_invocation} <- validate_root_invocation(root_invocation) do
      %__MODULE__{
        credentials: credentials,
        root_invocation: root_invocation
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_auth_entry_args}

  @impl true
  def to_xdr(%__MODULE__{
        credentials: credentials,
        root_invocation: root_invocation
      }) do
    root_invocation = SorobanAuthorizedInvocation.to_xdr(root_invocation)

    credentials
    |> SorobanCredentials.to_xdr()
    |> SorobanAuthorizationEntry.new(root_invocation)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec sign(credentials :: t(), secret_key :: secret_key()) :: t() | error()
  def sign(
        %__MODULE__{
          credentials: %SorobanCredentials{
            value:
              %SorobanAddressCredentials{
                nonce: nonce,
                signature_expiration_ledger: signature_expiration_ledger,
                signature_args: signature_args
              } = soroban_address_credentials
          },
          root_invocation: root_invocation
        } = credentials,
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
        signature_expiration_ledger: signature_expiration_ledger + 3,
        invocation: root_invocation
      ]
      |> HashIDPreimageSorobanAuthorization.new()
      |> (&HashIDPreimage.new(soroban_auth: &1)).()
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

    soroban_address_credentials = %{
      soroban_address_credentials
      | signature_args: SCVec.append_sc_val(signature_args, signature_sc_val)
    }

    %{credentials | credentials: soroban_address_credentials}
  end

  def sign(_args, _secret_key), do: {:error, :invalid_sign_args}

  @spec sign_xdr(
          base_64 :: base_64(),
          secret_key :: secret_key(),
          latest_ledger :: latest_ledger()
        ) :: sign_authorization() | error()
  def sign_xdr(base_64, secret_key, latest_ledger)
      when is_binary(base_64) and is_binary(secret_key) and is_integer(latest_ledger) do
    {%SorobanAuthorizationEntry{
       credentials:
         %{
           value:
             %SorobanAddressCredentialsXDR{
               nonce: nonce
             } = soroban_address_credentials
         } = credentials,
       root_invocation: root_invocation
     } = soroban_auth,
     ""} =
      base_64
      |> Base.decode64!()
      |> SorobanAuthorizationEntry.decode_xdr!()

    signature_expiration_ledger = UInt32.new(latest_ledger + 3)

    signature_args =
      nonce
      |> build_signature_args_from_xdr(
        signature_expiration_ledger,
        root_invocation,
        secret_key
      )
      |> SCVal.to_xdr()
      |> (&SCVecXDR.new([&1])).()

    soroban_address_credentials = %{
      soroban_address_credentials
      | signature_args: signature_args,
        signature_expiration_ledger: signature_expiration_ledger
    }

    credentials = %{credentials | value: soroban_address_credentials}

    %{soroban_auth | credentials: credentials}
    |> SorobanAuthorizationEntry.encode_xdr!()
    |> Base.encode64()
  end

  def sign_xdr(_base_64, _secret_key, _latest_ledger), do: {:error, :invalid_sign_args}

  @spec network_id_xdr :: binary()
  defp network_id_xdr, do: hash(Network.passphrase())

  @spec hash(data :: binary()) :: binary()
  defp hash(data), do: :crypto.hash(:sha256, data)

  @spec validate_credentials(credentials :: credentials()) :: validation()
  defp validate_credentials(%SorobanCredentials{} = credentials), do: {:ok, credentials}
  defp validate_credentials(_credentials), do: {:error, :invalid_credentials}

  @spec validate_root_invocation(root_invocation :: root_invocation()) :: validation()
  defp validate_root_invocation(%SorobanAuthorizedInvocation{} = root_invocation),
    do: {:ok, root_invocation}

  defp validate_root_invocation(_root_invocation), do: {:error, :invalid_root_invocation}

  @spec build_signature_args_from_xdr(
          nonce :: Int64.t(),
          signature_expiration_ledger :: UInt32.t(),
          root_invocation :: SorobanAuthorizedInvocationXDR.t(),
          secret_key :: secret_key()
        ) :: SCVal.t() | error()
  defp build_signature_args_from_xdr(
         nonce,
         signature_expiration_ledger,
         root_invocation,
         secret_key
       ) do
    {public_key, _secret_key} = KeyPair.from_secret_seed(secret_key)
    raw_public_key = KeyPair.raw_public_key(public_key)
    network_id = network_id_xdr()
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_SOROBAN_AUTHORIZATION)

    signature =
      network_id
      |> Hash.new()
      |> HashIDPreimageSorobanAuthorizationXDR.new(
        nonce,
        signature_expiration_ledger,
        root_invocation
      )
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

    SCVal.new(map: [public_key_map_entry, signature_map_entry])
  end
end
