defmodule Stellar.TxBuild.SCVal do
  @moduledoc """
  `SCVal` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.SCContractInstance
  alias Stellar.TxBuild.{SCAddress, SCError, SCMapEntry}

  alias StellarBase.XDR.{
    Bool,
    Duration,
    Hash,
    Int128Parts,
    Int256Parts,
    Int32,
    Int64,
    SCBytes,
    ContractExecutable,
    ContractExecutableType,
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
    UInt128Parts,
    UInt256Parts,
    UInt32,
    UInt64,
    Void
  }

  @type type ::
          :bool
          | :void
          | :error
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
          | :address
          | :ledger_key_contract_instance
          | :ledger_key_nonce
          | :contract_instance

  @type validation :: {:ok, any()} | {:error, atom()}
  @type value ::
          nil
          | integer()
          | boolean()
          | SCError.t()
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

  @allowed_types ~w(bool void error u32 i32 u64 i64 time_point duration u128 i128 u256 i256 bytes string symbol vec map address ledger_key_contract_instance ledger_key_nonce contract_instance)a

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts)
      when type in @allowed_types do
    with {:ok, _value} <- validate_sc_val({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

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

  def to_xdr(%__MODULE__{type: :error, value: value}) do
    val_type = SCValType.new(:SCV_ERROR)

    value
    |> SCError.to_xdr()
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
    hi = UInt64.new(hi)
    lo = UInt64.new(lo)

    hi
    |> UInt128Parts.new(lo)
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :i128, value: %{lo: lo, hi: hi}}) do
    type = SCValType.new(:SCV_I128)
    hi = Int64.new(hi)
    lo = UInt64.new(lo)

    hi
    |> Int128Parts.new(lo)
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{
        type: :u256,
        value: %{hi_hi: hi_hi, hi_lo: hi_lo, lo_hi: lo_hi, lo_lo: lo_lo}
      }) do
    type = SCValType.new(:SCV_U256)
    hi_hi = UInt64.new(hi_hi)
    hi_lo = UInt64.new(hi_lo)
    lo_hi = UInt64.new(lo_hi)
    lo_lo = UInt64.new(lo_lo)

    hi_hi
    |> UInt256Parts.new(hi_lo, lo_hi, lo_lo)
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{
        type: :i256,
        value: %{hi_hi: hi_hi, hi_lo: hi_lo, lo_hi: lo_hi, lo_lo: lo_lo}
      }) do
    type = SCValType.new(:SCV_I256)
    hi_hi = Int64.new(hi_hi)
    hi_lo = UInt64.new(hi_lo)
    lo_hi = UInt64.new(lo_hi)
    lo_lo = UInt64.new(lo_lo)

    hi_hi
    |> Int256Parts.new(hi_lo, lo_hi, lo_lo)
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

  def to_xdr(%__MODULE__{type: :ledger_key_contract_instance, value: nil}) do
    type = SCValType.new(:SCV_LEDGER_KEY_CONTRACT_INSTANCE)

    SCVal.new(Void.new(), type)
  end

  def to_xdr(%__MODULE__{type: :address, value: value}) do
    type = SCValType.new(:SCV_ADDRESS)

    value
    |> SCAddress.to_xdr()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract_instance, value: {:wasm_ref, hash}}) do
    type = SCValType.new(:SCV_CONTRACT_INSTANCE)
    contract_code = ContractExecutableType.new(:CONTRACT_EXECUTABLE_WASM)

    hash
    |> Hash.new()
    |> ContractExecutable.new(contract_code)
    |> SCContractInstance.new(OptionalSCMap.new())
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :contract_instance, value: :token}) do
    type = SCValType.new(:SCV_CONTRACT_INSTANCE)
    contract_code = ContractExecutableType.new(:CONTRACT_EXECUTABLE_TOKEN)

    Void.new()
    |> ContractExecutable.new(contract_code)
    |> SCContractInstance.new(OptionalSCMap.new())
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :ledger_key_nonce, value: value}) do
    type = SCValType.new(:SCV_LEDGER_KEY_NONCE)

    value
    |> Int64.new()
    |> SCNonceKey.new()
    |> SCVal.new(type)
  end

  @spec to_native_from_xdr(xdr :: String.t()) :: any
  def to_native_from_xdr(xdr) when is_binary(xdr) do
    with {:ok, decoded_xdr} <- validate_base64(xdr),
         {:ok, {scval, _rest}} <- validate_xdr_decoding(decoded_xdr) do
      to_native(scval)
    end
  end

  def to_native_from_xdr(_xdr), do: {:error, :invalid_XDR}

  @spec to_native(SCVal.t()) :: any
  def to_native(%SCVal{
        value: %StellarBase.XDR.SCSymbol{value: value},
        type: %StellarBase.XDR.SCValType{identifier: :SCV_SYMBOL}
      }),
      do: value

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_VEC},
        value: %StellarBase.XDR.OptionalSCVec{
          sc_vec: %StellarBase.XDR.SCVec{
            items: items
          }
        }
      }) do
    Enum.map(items, &to_native/1)
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_VEC},
        value: %StellarBase.XDR.OptionalSCVec{
          sc_vec: nil
        }
      }),
      do: []

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_TIMEPOINT},
        value: %StellarBase.XDR.TimePoint{value: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_DURATION},
        value: %StellarBase.XDR.Duration{value: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_VOID},
        value: _value
      }) do
    nil
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_BOOL},
        value: %StellarBase.XDR.Bool{value: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_U128},
        value: %StellarBase.XDR.UInt128Parts{
          hi: %StellarBase.XDR.UInt64{datum: hi_value},
          lo: %StellarBase.XDR.UInt64{datum: lo_value}
        }
      }) do
    {hi_value, lo_value}
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_U64},
        value: %StellarBase.XDR.UInt64{datum: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_I64},
        value: %StellarBase.XDR.Int64{datum: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_U32},
        value: %StellarBase.XDR.UInt32{datum: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_I32},
        value: %StellarBase.XDR.Int32{datum: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_I128},
        value: %StellarBase.XDR.Int128Parts{
          hi: %StellarBase.XDR.Int64{datum: hi_value},
          lo: %StellarBase.XDR.UInt64{datum: lo_value}
        }
      }) do
    {hi_value, lo_value}
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_U256},
        value: %StellarBase.XDR.UInt256Parts{
          hi_hi: %StellarBase.XDR.UInt64{datum: hi_hi_value},
          hi_lo: %StellarBase.XDR.UInt64{datum: hi_lo_value},
          lo_hi: %StellarBase.XDR.UInt64{datum: lo_hi_value},
          lo_lo: %StellarBase.XDR.UInt64{datum: lo_lo_value}
        }
      }) do
    {hi_hi_value, hi_lo_value, lo_hi_value, lo_lo_value}
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_I256},
        value: %StellarBase.XDR.Int256Parts{
          hi_hi: %StellarBase.XDR.Int64{datum: hi_hi_value},
          hi_lo: %StellarBase.XDR.UInt64{datum: hi_lo_value},
          lo_hi: %StellarBase.XDR.UInt64{datum: lo_hi_value},
          lo_lo: %StellarBase.XDR.UInt64{datum: lo_lo_value}
        }
      }) do
    {hi_hi_value, hi_lo_value, lo_hi_value, lo_lo_value}
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_BYTES},
        value: %StellarBase.XDR.SCBytes{value: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_STRING},
        value: %StellarBase.XDR.SCString{value: value}
      }) do
    value
  end

  def to_native(%SCVal{
        type: %StellarBase.XDR.SCValType{identifier: :SCV_MAP},
        value: %StellarBase.XDR.OptionalSCMap{
          sc_map: %StellarBase.XDR.SCMap{
            items: items
          }
        }
      }) do
    Enum.reduce(items, %{}, fn entry, acc ->
      {key, val} = map_entry_to_native(entry)
      Map.put(acc, key, val)
    end)
  end

  @spec validate_base64(xdr :: String.t()) :: validation()
  defp validate_base64(xdr) when is_binary(xdr) do
    case Base.decode64(xdr) do
      {:ok, decoded_xdr} -> {:ok, decoded_xdr}
      _ -> {:error, :invalid_base64}
    end
  end

  @spec validate_xdr_decoding(decoded_xdr :: binary()) :: validation()
  defp validate_xdr_decoding(decoded_xdr) do
    case SCVal.decode_xdr(decoded_xdr) do
      {:ok, result} -> {:ok, result}
      _ -> {:error, :invalid_XDR}
    end
  end

  defp map_entry_to_native(%StellarBase.XDR.SCMapEntry{key: key, val: val}),
    do: {to_native(key), to_native(val)}

  @spec validate_sc_val(tuple :: tuple()) :: validation()
  defp validate_sc_val({type, value})
       when type in ~w(u32 u64 time_point duration)a and is_integer(value) and value >= 0,
       do: {:ok, value}

  defp validate_sc_val({type, value})
       when type in ~w(i32 i64)a and is_integer(value),
       do: {:ok, value}

  defp validate_sc_val({:bool, value}) when is_boolean(value), do: {:ok, value}
  defp validate_sc_val({:void, _value}), do: {:ok, nil}
  defp validate_sc_val({:error, %SCError{} = value}), do: {:ok, value}

  defp validate_sc_val({type, %{lo: lo, hi: hi} = value})
       when type in ~w(u128 i128)a and is_integer(lo) and is_integer(hi),
       do: {:ok, value}

  defp validate_sc_val({type, %{hi_hi: hi_hi, hi_lo: hi_lo, lo_hi: lo_hi, lo_lo: lo_lo} = value})
       when type in ~w(u256 i256)a and is_integer(hi_hi) and is_integer(hi_lo) and
              is_integer(lo_hi) and is_integer(lo_lo),
       do: {:ok, value}

  defp validate_sc_val({type, value})
       when type in ~w(bytes string symbol)a and is_binary(value),
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

  defp validate_sc_val({:contract_instance, :token}), do: {:ok, :token}

  defp validate_sc_val({:contract_instance, {:wasm_ref, hash} = value}) when is_binary(hash),
    do: {:ok, value}

  defp validate_sc_val({:address, %SCAddress{} = value}), do: {:ok, value}
  defp validate_sc_val({:ledger_key_contract_instance, _value}), do: {:ok, nil}
  defp validate_sc_val({:ledger_key_nonce, value}) when is_integer(value), do: {:ok, value}
  defp validate_sc_val({type, _value}), do: {:error, :"invalid_#{type}"}

  @spec is_map_entry?(value :: any()) :: boolean()
  defp is_map_entry?(%SCMapEntry{}), do: true
  defp is_map_entry?(_), do: false

  @spec is_sc_val?(value :: any()) :: boolean()
  defp is_sc_val?(%__MODULE__{}), do: true
  defp is_sc_val?(_), do: false
end
