defmodule Stellar.TxBuild.SCVal do
  @moduledoc """
  `SCVal` struct definition.
  """

  @behaviour Stellar.TxBuild.XDR

  alias StellarBase.XDR.{
    SCVal,
    SCValType,
    Int32,
    UInt32,
    SCStatic,
    OptionalSCObject,
    SCSymbol,
    UInt64,
    SCStatus,
    Int64,
    Void
  }

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
          type: String.t(),
          value: value()
        }

  @allowed_types ~w(u63 u32 i32 static object symbol bitset status)a

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ nil)

  # SCval.new(u32: 123)
  def new([{type, value}], _opts) when type in @allowed_types do
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

  @spec validate_sc_val(tuple :: tuple()) :: validation()
  def validate_sc_val({:u32, value}) do
    case value |> UInt32.new() |> UInt32.encode_xdr() do
      {:ok, _uint32} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_u32}
    end
  end

  def validate_sc_val({:u63, value}) do
    case value |> Int64.new() |> Int64.encode_xdr() do
      {:ok, _int64} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_u64}
    end
  end

  def validate_sc_val({:i32, value}) do
    case value |> Int32.new() |> Int32.encode_xdr() do
      {:ok, _int32} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_i32}
    end
  end

  def validate_sc_val({:static, value}) do
    case value |> SCStatic.new() |> SCStatic.encode_xdr() do
      {:ok, _sc_static} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_static}
    end
  end

  # How to valid SCObject
  def validate_sc_val({:object, value}) do
    case value |> OptionalSCObject.new() |> OptionalSCObject.encode_xdr() do
      {:ok, _binary} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_optional_sc_object}
    end
  end

  def validate_sc_val({:symbol, value}) do
    case value |> SCSymbol.new() |> SCSymbol.encode_xdr() do
      {:ok, _sc_symbol} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_symbol}
    end
  end

  def validate_sc_val({:bitset, value}) do
    case value |> UInt64.new() |> UInt64.encode_xdr() do
      {:ok, _sc_uint64} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_bitset}
    end
  end

  def validate_sc_val({:status, value}) do
    case Void.new() |> SCStatus.new(value) |> SCStatus.encode_xdr() do
      {:ok, _sc_status} -> {:ok, value}
      {:error, _reason} -> {:error, :invalid_status}
    end
  end
end
