defmodule Stellar.TxBuild.SCVal do
  @moduledoc """
  `SCVal` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias Stellar.TxBuild.{SCAddress, SCMapEntry, SCStatus}

  alias StellarBase.XDR.{
    Bool,
    Duration,
    Hash,
    Int128Parts,
    Int32,
    Int64,
    SCBytes,
    SCContractExecutable,
    SCContractExecutableType,
    SCMap,
    SCNonceKey,
    SCString,
    SCSymbol,
    SCVal,
    SCValType,
    SCVec,
    OptionalSCMap,
    OptionalSCVec,
    TimePoint,
    UInt32,
    UInt64,
    UInt256,
    Void
  }

  @parse_static %{
    void: :SCS_VOID,
    true: :SCS_TRUE,
    false: :SCS_FALSE,
    ledger_contract_code: :SCS_LEDGER_KEY_CONTRACT_CODE
  }
  @type type ::
          :bool
          | :void
          | :status
          | :u32
          | :i32
          | :u64
          | :i64
          | :time_point
          | :duration
          | :u128
          | :i128
          | :u256
          | :i256
          | :bytes
          | :string
          | :symbol
          | :vec
          | :map
          | :contract
          | :address
          | :ledger_key_contract
          | :ledger_key_nonce

  @type validation :: {:ok, any()} | {:error, atom()}
  @type value ::
          nil
          | integer()
          | boolean()
          | SCStatus.t()
          | map()
          | binary()
          | list()
          | atom()
          | SCAddress.t()

  @type t :: %__MODULE__{
          type: type(),
          value: value()
        }

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts)
      when type in ~w(bool void status u32 i32 u64 i64 time_point duration u128 i128 u256 i256 bytes string symbol vec map contract address ledger_key_contract ledger_key_nonce)a do
    with {:ok, _value} <- validate_sc_val({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

  def new(%SCObject{} = object, _opts), do: %__MODULE__{type: :object, value: object}
  def new(%SCStatusSDK{} = status, _opts), do: %__MODULE__{type: :status, value: status}
  def new(_args, _opts), do: {:error, :invalid_sc_val_type}

  @impl true
  def to_xdr(%__MODULE__{type: :bool, value: value}) do
    type = SCValType.new(:SCV_BOOL)

    value
    |> Bool.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :void, value: _value}) do
    type = SCValType.new(:SCV_VOID)

    Void.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :status, value: value}) do
    val_type = SCValType.new(:SCV_STATUS)

    value
    |> SCStatus.to_xdr()
    |> SCVal.new(val_type)
  end

  def to_xdr(%__MODULE__{type: :u32, value: value}) do
    type = SCValType.new(:SCV_U32)

    value
    |> UInt32.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :i32, value: value}) do
    type = SCValType.new(:SCV_I32)

    value
    |> Int32.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :u64, value: value}) do
    type = SCValType.new(:SCV_U64)

    value
    |> UInt64.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :i64, value: value}) do
    type = SCValType.new(:SCV_I64)

    value
    |> Int64.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :time_point, value: value}) do
    type = SCValType.new(:SCV_TIMEPOINT)

    value
    |> TimePoint.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :duration, value: value}) do
    type = SCValType.new(:SCV_DURATION)

    value
    |> Duration.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :u128, value: %{lo: lo, hi: hi}}) do
    type = SCValType.new(:SCV_U128)
    lo = UInt64.new(lo)
    hi = UInt64.new(hi)

    lo
    |> Int128Parts.new(hi)
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :i128, value: %{lo: lo, hi: hi}}) do
    type = SCValType.new(:SCV_I128)
    lo = UInt64.new(lo)
    hi = UInt64.new(hi)

    lo
    |> Int128Parts.new(hi)
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :u256, value: value}) do
    type = SCValType.new(:SCV_U256)

    value
    |> UInt256.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :i256, value: value}) do
    type = SCValType.new(:SCV_I256)

    value
    |> UInt256.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :bytes, value: value}) do
    type = SCValType.new(:SCV_BYTES)

    value
    |> SCBytes.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :string, value: value}) do
    type = SCValType.new(:SCV_STRING)

    value
    |> SCString.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :symbol, value: value}) do
    type = SCValType.new(:SCV_SYMBOL)

    value
    |> SCSymbol.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :vec, value: nil}) do
    type = SCValType.new(:SCV_VEC)

    nil
    |> OptionalSCVec.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :vec, value: value}) do
    type = SCValType.new(:SCV_VEC)

    value
    |> Enum.map(&to_xdr/1)
    |> SCVec.new()
    |> OptionalSCVec.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :map, value: nil}) do
    type = SCValType.new(:SCV_MAP)

    nil
    |> OptionalSCMap.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :map, value: value}) do
    type = SCValType.new(:SCV_MAP)

    value
    |> Enum.map(&SCMapEntry.to_xdr/1)
    |> SCMap.new()
    |> OptionalSCMap.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract, value: {:wasm_ref, hash}}) do
    type = SCValType.new(:SCV_CONTRACT_EXECUTABLE)
    contract_code = SCContractExecutableType.new(:SCCONTRACT_CODE_WASM_REF)

    hash
    |> Hash.new()
    |> SCContractExecutable.new(contract_code)
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract, value: :token}) do
    type = SCValType.new(:SCV_CONTRACT_EXECUTABLE)
    contract_code = SCContractExecutableType.new(:SCCONTRACT_EXECUTABLE_TOKEN)

    Void.new()
    |> SCContractExecutable.new(contract_code)
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :address, value: value}) do
    type = SCValType.new(:SCV_ADDRESS)

    value
    |> SCAddress.to_xdr()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :ledger_key_contract, value: _value}) do
    type = SCValType.new(:SCV_LEDGER_KEY_CONTRACT_EXECUTABLE)

    Void.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :ledger_key_nonce, value: value}) do
    type = SCValType.new(:SCV_LEDGER_KEY_NONCE)

    value
    |> SCAddress.to_xdr()
    |> SCNonceKey.new()
    |> SCVal.new(type)
  end

  @spec validate_sc_val(tuple :: tuple()) :: validation()
  defp validate_sc_val({type, value})
       when type in ~w(u32 u64 time_point duration)a and is_integer(value) and value >= 0,
       do: {:ok, value}

  defp validate_sc_val({type, value})
       when type in ~w(i32 i64)a and is_integer(value),
       do: {:ok, value}

  defp validate_sc_val({:bool, value}) when is_boolean(value), do: {:ok, value}
  defp validate_sc_val({:void, _value}), do: {:ok, nil}
  defp validate_sc_val({:status, %SCStatus{} = value}), do: {:ok, value}

  defp validate_sc_val({type, %{lo: lo, hi: hi} = value})
       when type in ~w(u128 i128)a and is_integer(lo) and is_integer(hi),
       do: {:ok, value}

  defp validate_sc_val({type, value})
       when type in ~w(u256 i256 bytes string symbol)a and is_binary(value),
       do: {:ok, value}

  defp validate_sc_val({:vec, nil}), do: {:ok, nil}

  defp validate_sc_val({:vec, value}) when is_list(value) do
    if Enum.all?(value, &is_sc_val?/1),
      do: {:ok, value},
      else: {:error, :invalid_vec}
  end

  defp validate_sc_val({:map, nil}), do: {:ok, nil}

  defp validate_sc_val({:map, value}) when is_list(value) do
    if Enum.all?(value, &is_map_entry?/1),
      do: {:ok, value},
      else: {:error, :invalid_map}
  end

  defp validate_sc_val({:contract, :token}), do: {:ok, :token}

  defp validate_sc_val({:contract, {:wasm_ref, hash} = value}) when is_binary(hash),
    do: {:ok, value}

  defp validate_sc_val({:address, %SCAddress{} = value}), do: {:ok, value}
  defp validate_sc_val({:ledger_key_contract, _value}), do: {:ok, nil}
  defp validate_sc_val({:ledger_key_nonce, %SCAddress{} = value}), do: {:ok, value}
  defp validate_sc_val({type, _value}), do: {:error, :"invalid_#{type}"}

  @spec is_map_entry?(value :: any()) :: boolean()
  defp is_map_entry?(%SCMapEntry{}), do: true
  defp is_map_entry?(_), do: false

  @spec is_sc_val?(value :: any()) :: boolean()
  defp is_sc_val?(%__MODULE__{}), do: true
  defp is_sc_val?(_), do: false
end
