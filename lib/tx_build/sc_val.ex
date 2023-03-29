defmodule Stellar.TxBuild.SCVal do
  @moduledoc """
  `SCVal` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [
      validate_account: 1,
      validate_asset: 1,
      validate_amount: 1,
      validate_optional_account: 1
    ]

  alias Stellar.TxBuild.{HostFunction, LedgerFootprint, ContractAuthList, OptionalAccount}
  alias StellarBase.XDR.{SCVal, SCValType, Int64, UInt32}

  @behaviour Stellar.TxBuild.XDR

  @type type :: :install | :create | :invoke
  @type contract_id :: :source_account | :ed25519_public_key | :asset | String.t()

  @type t :: %__MODULE__{
          type: type(),
          args: list(SCVal.t()) | [contract_id: contract_id(), wasm_id: String.t() | nil]
        }

  # Invocar.
  # HostFunction? HostFunction.new(:invoke, [name: "miguel"])

  @allowed_types ~w(u63 u32 i32 static object symbol bitset status)a

  defstruct [:type, :value]

  @impl true
  def new(args, opts \\ [])

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, sc_val} <- validate_sc_val({type, value}) do
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
    |> Int64.new()
    |> SCVal.new(type)
  end

  def to_xdr(%__MODULE__{type: :u32, value: value}) do
    type = SCValType.new(:SCV_U32)

    value
    |> UInt32.new()
    |> SCVal.new(type)
  end
end
