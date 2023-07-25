defmodule Stellar.TxBuild.HashIDPreimage do
  @moduledoc """
  `HashIDPreimage` struct definition.
  """
  alias StellarBase.XDR.{EnvelopeType, HashIDPreimage}

  alias Stellar.TxBuild.{
    HashIDPreimageContractID,
    HashIDPreimageSorobanAuthorization,
    HashIDPreimageOperationID,
    HashIDPreimageRevokeID
  }

  @behaviour Stellar.TxBuild.XDR

  @type hash_id ::
          HashIDPreimageContractID.t()
          | HashIDPreimageOperationID.t()
          | HashIDPreimageRevokeID.t()
          | HashIDPreimageSorobanAuthorization.t()
  @type validation :: {:ok, any()} | {:error, atom()}
  @type type ::
          :op_id
          | :pool_revoke_op_id
          | :contract_id
          | :soroban_auth
  @type t :: %__MODULE__{type: type(), value: hash_id()}

  defstruct [:type, :value]

  @allowed_types ~w(op_id pool_revoke_op_id contract_id soroban_auth)a

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, value} <- validate_hash_id_preimage({type, value}) do
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
        value: %HashIDPreimageOperationID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_OP_ID)

    value
    |> HashIDPreimageOperationID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :pool_revoke_op_id,
        value: %HashIDPreimageRevokeID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_POOL_REVOKE_OP_ID)

    value
    |> HashIDPreimageRevokeID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :contract_id,
        value: %HashIDPreimageContractID{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_CONTRACT_ID)

    value
    |> HashIDPreimageContractID.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  def to_xdr(%__MODULE__{
        type: :soroban_auth,
        value: %HashIDPreimageSorobanAuthorization{} = value
      }) do
    envelope_type = EnvelopeType.new(:ENVELOPE_TYPE_SOROBAN_AUTHORIZATION)

    value
    |> HashIDPreimageSorobanAuthorization.to_xdr()
    |> HashIDPreimage.new(envelope_type)
  end

  @spec validate_hash_id_preimage({atom(), hash_id()}) :: validation()
  defp validate_hash_id_preimage({:op_id, %HashIDPreimageOperationID{} = value}), do: {:ok, value}

  defp validate_hash_id_preimage({:pool_revoke_op_id, %HashIDPreimageRevokeID{} = value}),
    do: {:ok, value}

  defp validate_hash_id_preimage({:contract_id, %HashIDPreimageContractID{} = value}),
    do: {:ok, value}

  defp validate_hash_id_preimage({:soroban_auth, %HashIDPreimageSorobanAuthorization{} = value}),
    do: {:ok, value}

  defp validate_hash_id_preimage({type, _value}), do: {:error, :"invalid_#{type}"}
end
