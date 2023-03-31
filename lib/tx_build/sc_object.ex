defmodule Stellar.TxBuild.SCObject do
  @moduledoc """
  `SCObject` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias Stellar.TxBuild.{SCMapEntry, SCVal}
  alias Stellar.TxBuild.SCContractCode, as: TxSCContractCode
  alias Stellar.TxBuild.SCAddress, as: TxSCAddress

  alias StellarBase.XDR.{
    Int128Parts,
    Int64,
    SCAddress,
    SCContractCode,
    SCMap,
    SCObject,
    SCObjectType,
    SCVec,
    UInt64,
    VariableOpaque256000
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

  def to_xdr(%__MODULE__{type: :contract_code, value: value}) do
    type = SCObjectType.new(:SCO_CONTRACT_CODE)

    value
    |> TxSCContractCode.to_xdr()
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
  def validate_sc_obj({:vec, value}) do
    case value |> Enum.map(&SCVal.to_xdr/1) |> SCVec.new() |> SCVec.encode_xdr() do
      {:ok, _sc_vec} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_scvec}
    end
  end

  def validate_sc_obj({:map, value}) do
    case value |> Enum.map(&SCMapEntry.to_xdr/1) |> SCMap.new() |> SCMap.encode_xdr() do
      {:ok, _sc_map} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_scmap}
    end
  end

  def validate_sc_obj({:u64, value}) do
    case value |> UInt64.new() |> UInt64.encode_xdr() do
      {:ok, _uint64} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_uint64}
    end
  end

  def validate_sc_obj({:i64, value}) do
    case value |> Int64.new() |> Int64.encode_xdr() do
      {:ok, _int64} -> {:ok, value}
      {:error, _reason} -> {:error, :int64}
    end
  end

  # How to valid SCObject
  def validate_sc_obj({:u128, %{lo: lo, hi: hi} = value}) do
    lo = UInt64.new(lo)
    hi = UInt64.new(hi)

    case lo |> Int128Parts.new(hi) |> Int128Parts.encode_xdr() do
      {:ok, _int128_parts} -> {:ok, value}
      {:error, _reason} -> {:error, :int128_parts}
    end
  end

  def validate_sc_obj({:u128, _value}), do: {:error, :invalid_value_format}

  def validate_sc_obj({:bytes, value}) do
    case value |> VariableOpaque256000.new() |> VariableOpaque256000.encode_xdr() do
      {:ok, _variable_opaque_256000} -> {:ok, value}
      {:error, _reason} -> {:error, :variable_opaque_256000}
    end
  end

  def validate_sc_obj({:contract_code, value}) do
    case value |> TxSCContractCode.to_xdr() |> SCContractCode.encode_xdr() do
      {:ok, _sc_contract_code} -> {:ok, value}
      {:error, _reason} -> {:error, :sc_contract_code}
    end
  end

  def validate_sc_obj({:address, value}) do
    case value |> TxSCAddress.to_xdr() |> SCAddress.encode_xdr() do
      {:ok, _sc_address} -> {:ok, value}
      {:error, _reason} -> {:error, :sc_address}
    end
  end

  def validate_sc_obj({:nonce_key, value}) do
    case value |> TxSCAddress.to_xdr() |> SCAddress.encode_xdr() do
      {:ok, _sc_address} -> {:ok, value}
      {:error, _reason} -> {:error, :sc_address}
    end
  end
end
