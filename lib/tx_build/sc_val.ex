defmodule Stellar.TxBuild.SCVal do
  @moduledoc """
  `SCVal` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias Stellar.TxBuild.SCStatus, as: SCStatusSDK
  alias Stellar.TxBuild.SCObject

  alias StellarBase.XDR.{
    SCStatus,
    SCVal,
    SCValType,
    Int32,
    UInt32,
    SCStatic,
    OptionalSCObject,
    SCSymbol,
    UInt64,
    Int64
  }

  @type type :: :u63 | :u32 | :i32 | :static | :object | :symbol | :bitset | :status
  @type validation :: {:ok, any()} | {:error, atom()}
  @type value ::
          Int32.t()
          | UInt32.t()
          | Int64.t()
          | SCStatic.t()
          | OptionalSCObject.t()
          | SCSymbol.t()
          | UInt64.t()
          | SCStatus.t()

  @type t :: %__MODULE__{
          type: type(),
          value: value()
        }

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  def new([{type, value}], _opts)
      when type in ~w(u63 u32 i32 static object symbol bitset status)a do
    with {:ok, _value} <- validate_sc_val({type, value}) do
      %__MODULE__{
        type: type,
        value: value
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_sc_val_type}

  @impl true
  def to_xdr(%__MODULE__{type: :u63, value: value}) do
    type = SCValType.new(:SCV_U63)

    value
    |> UInt64.new()
    |> SCVal.new(type)
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

  def to_xdr(%__MODULE__{type: :static, value: value}) do
    type = SCValType.new(:SCV_STATIC)

    value
    |> SCStatic.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :object, value: value}) do
    type = SCValType.new(:SCV_OBJECT)

    value
    |> SCObject.to_xdr()
    |> OptionalSCObject.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :symbol, value: value}) do
    type = SCValType.new(:SCV_SYMBOL)

    value
    |> SCSymbol.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :bitset, value: value}) do
    type = SCValType.new(:SCV_BITSET)

    value
    |> UInt64.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :status, value: value}) do
    val_type = SCValType.new(:SCV_STATUS)

    value
    |> SCStatusSDK.to_xdr()
    |> SCVal.new(val_type)
  end

  @spec validate_sc_val(tuple :: tuple()) :: validation()
  defp validate_sc_val({type, value})
       when type in ~w(u32 u63 bitset)a and is_integer(value) and value >= 0,
       do: {:ok, value}

  defp validate_sc_val({:i32, value}) when is_integer(value), do: {:ok, value}
  defp validate_sc_val({:symbol, value}) when is_binary(value), do: {:ok, value}

  defp validate_sc_val({:static, value})
       when value in ~w(void true false contract_code)a,
       do: {:ok, value}

  defp validate_sc_val({:object, %SCObject{} = value}), do: {:ok, value}

  defp validate_sc_val({:status, %SCStatusSDK{} = value}), do: {:ok, value}

  defp validate_sc_val({type, _value}), do: {:error, :"invalid_#{type}"}
end
