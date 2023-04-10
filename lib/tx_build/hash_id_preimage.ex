defmodule Stellar.TxBuild.HashIDPreimage do
  @moduledoc """
  `HashIDPreimage` struct definition.
  """
  alias StellarBase.XDR.{EnvelopeType, HashIDPreimage}

  alias Stellar.TxBuild.{
    FromAsset,
    HashIDPreimageCreateContractArgs,
    HashIDPreimageContractAuth,
    OperationID,
    RevokeID,
    Ed25519ContractID,
    StructContractID,
    SourceAccountContractID
  }

  @behaviour Stellar.TxBuild.XDR

  @type hash_id ::
          OperationID.t()
          | RevokeID.t()
          | Ed25519ContractID.t()
          | StructContractID.t()
          | FromAsset.t()
          | SourceAccountContractID.t()
          | HashIDPreimageCreateContractArgs.t()
          | HashIDPreimageContractAuth.t()

  @allowed_types ~w(op_id pool_revoke_op_id contract_id_from_ed25519 contract_id_from_contract contract_id_from_asset contact_id_from_source_acc create_contract_args contract_auth)a

  @type validation :: {:ok, any()} | {:error, atom()}
  @type t :: %__MODULE__{type: String.t(), value: hash_id()}

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, _value} <- validate_hash_id_preimage({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_hash_id_preimage_type}

  @impl true
  def to_xdr(%__MODULE__{
        type: :op_id,
        value: %OperationID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_OP_ID)

    value
    |> OperationID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :pool_revoke_op_id,
        value: %RevokeID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_POOL_REVOKE_OP_ID)

    value
    |> RevokeID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :contract_id_from_ed25519,
        value: %Ed25519ContractID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_CONTRACT_ID_FROM_ED25519)

    value
    |> Ed25519ContractID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :contract_id_from_contract,
        value: %StructContractID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_POOL_REVOKE_OP_ID)

    value
    |> StructContractID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :contract_id_from_asset,
        value: %FromAsset{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_CONTRACT_ID_FROM_ASSET)

    value
    |> FromAsset.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :contact_id_from_source_acc,
        value: %SourceAccountContractID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_CONTRACT_ID_FROM_SOURCE_ACCOUNT)

    value
    |> SourceAccountContractID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :create_contract_args,
        value: %HashIDPreimageCreateContractArgs{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_CREATE_CONTRACT_ARGS)

    value
    |> HashIDPreimageCreateContractArgs.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :contract_auth,
        value: %HashIDPreimageContractAuth{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_CONTRACT_AUTH)

    value
    |> HashIDPreimageContractAuth.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  @spec validate_hash_id_preimage({atom(), hash_id()}) :: validation()
  defp validate_hash_id_preimage({:op_id, %OperationID{} = value}), do: {:ok, value}
  defp validate_hash_id_preimage({:pool_revoke_op_id, %RevokeID{} = value}), do: {:ok, value}

  defp validate_hash_id_preimage({:contract_id_from_ed25519, %Ed25519ContractID{} = value}),
    do: {:ok, value}

  defp validate_hash_id_preimage({:contract_id_from_contract, %StructContractID{} = value}),
    do: {:ok, value}

  defp validate_hash_id_preimage({:contract_id_from_asset, %FromAsset{} = value}),
    do: {:ok, value}

  defp validate_hash_id_preimage(
         {:contact_id_from_source_acc, %SourceAccountContractID{} = value}
       ),
       do: {:ok, value}

  defp validate_hash_id_preimage(
         {:create_contract_args, %HashIDPreimageCreateContractArgs{} = value}
       ),
       do: {:ok, value}

  defp validate_hash_id_preimage({:contract_auth, %HashIDPreimageContractAuth{} = value}),
    do: {:ok, value}

  defp validate_hash_id_preimage({type, _value}), do: {:error, :"invalid_#{type}"}
end
