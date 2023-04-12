defmodule Stellar.TxBuild.SCObject do
  @moduledoc """
  `SCObject` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  import Stellar.TxBuild.Validations,
    only: [
      validate_sc_vals: 1,
      is_struct?: 2
    ]

  alias Stellar.TxBuild.{SCMapEntry, SCVal}
  alias Stellar.TxBuild.SCAddress, as: TxSCAddress

  alias StellarBase.XDR.{
    Int128Parts,
    Int64,
    SCAddress,
    SCMap,
    SCObject,
    SCObjectType,
    SCVec,
    UInt64,
    VariableOpaque256000,
    SCContractCode,
    SCContractCodeType,
    Void,
    Hash
  }

  @type validation :: {:ok, any()} | {:error, atom()}

  @type value ::
          Int128Parts.t()
          | Int64.t()
          | SCAddress.t()
          | SCContractCode.t()
          | SCMap.t()
          | SCVec.t()
          | UInt64.t()
          | VariableOpaque256000.t()

  @type t :: %__MODULE__{
          type: String.t(),
          value: value()
        }

  @allowed_types ~w(vec map u64 i64 u128 i128 bytes contract_code address nonce_key)a

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, _value} <- validate_sc_obj({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sc_obj_type}

  @impl true
  def to_xdr(%__MODULE__{type: :vec, value: value}) do
    type = SCObjectType.new(:SCO_VEC)

    value
    |> Enum.map(&SCVal.to_xdr/1)
    |> SCVec.new()
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :map, value: value}) do
    type = SCObjectType.new(:SCO_MAP)

    value
    |> Enum.map(&SCMapEntry.to_xdr/1)
    |> SCMap.new()
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :u64, value: value}) do
    type = SCObjectType.new(:SCO_U64)

    value
    |> UInt64.new()
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :i64, value: value}) do
    type = SCObjectType.new(:SCO_I64)

    value
    |> Int64.new()
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :u128, value: %{lo: lo, hi: hi}}) do
    type = SCObjectType.new(:SCO_U128)
    lo = UInt64.new(lo)
    hi = UInt64.new(hi)

    lo
    |> Int128Parts.new(hi)
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :i128, value: %{lo: lo, hi: hi}}) do
    type = SCObjectType.new(:SCO_I128)
    lo = UInt64.new(lo)
    hi = UInt64.new(hi)

    lo
    |> Int128Parts.new(hi)
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :bytes, value: value}) do
    type = SCObjectType.new(:SCO_BYTES)

    value
    |> VariableOpaque256000.new()
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract_code, value: {:wasm_ref, hash}}) do
    type = SCObjectType.new(:SCO_CONTRACT_CODE)
    contract_code = SCContractCodeType.new(:SCCONTRACT_CODE_WASM_REF)

    hash
    |> Hash.new()
    |> SCContractCode.new(contract_code)
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract_code, value: :token}) do
    type = SCObjectType.new(:SCO_CONTRACT_CODE)
    contract_code = SCContractCodeType.new(:SCCONTRACT_CODE_TOKEN)

    Void.new()
    |> SCContractCode.new(contract_code)
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :address, value: value}) do
    type = SCObjectType.new(:SCO_ADDRESS)

    value
    |> TxSCAddress.to_xdr()
    |> SCObject.new(type)
  end

  def to_xdr(%__MODULE__{type: :nonce_key, value: value}) do
    type = SCObjectType.new(:SCO_NONCE_KEY)

    value
    |> TxSCAddress.to_xdr()
    |> SCObject.new(type)
  end

  def to_xdr(_error), do: {:error, :invalid_object_structure}

  @spec validate_sc_obj(tuple :: tuple()) :: validation()
  defp validate_sc_obj({:u64, value}) when is_integer(value) and value >= 0, do: {:ok, value}

  defp validate_sc_obj({:vec, value}) do
    validate_sc_vals({:vec, value})
  end

  defp validate_sc_obj({:map, value}) when is_list(value) do
    if Enum.all?(value, fn arg -> is_struct?(arg, SCMapEntry) end),
      do: {:ok, value},
      else: {:error, :invalid_map}
  end

  defp validate_sc_obj({:bytes, value}) when is_binary(value), do: {:ok, value}
  defp validate_sc_obj({:i64, value}) when is_integer(value), do: {:ok, value}

  defp validate_sc_obj({type, %{lo: lo, hi: hi} = value})
       when type in ~w(u128 i128)a and is_integer(lo) and is_integer(hi),
       do: {:ok, value}

  defp validate_sc_obj({:address, %TxSCAddress{} = value}), do: {:ok, value}
  defp validate_sc_obj({:nonce_key, %TxSCAddress{} = value}), do: {:ok, value}
  defp validate_sc_obj({:contract_code, :token}), do: {:ok, :token}

  defp validate_sc_obj({:contract_code, {:wasm_ref, hash} = value}) when is_binary(hash),
    do: {:ok, value}

  defp validate_sc_obj({type, _value}), do: {:error, :"invalid_#{type}"}
end
