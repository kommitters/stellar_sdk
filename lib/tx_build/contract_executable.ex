defmodule Stellar.TxBuild.ContractExecutable do
  @moduledoc """
  `ContractExecutable` struct definition.
  """

  alias StellarBase.XDR.{ContractExecutable, ContractExecutableType, Hash, Void}

  @behaviour Stellar.TxBuild.XDR

  @type value :: String.t() | nil
  @type type ::
          :wasm_ref
          | :stellar_asset
  @type t :: %__MODULE__{type: type(), value: value()}

  defstruct [:type, :value]

  @allowed_types ~w(wasm_ref stellar_asset)a

  @impl true
  def new(value, opts \\ [])

  def new(:stellar_asset, _opts), do: %__MODULE__{type: :stellar_asset, value: nil}

  def new([{type, value}], _opts)
      when type in @allowed_types and is_binary(value) do
    %__MODULE__{type: type, value: value}
  end

  def new(_value, _opts), do: {:error, :invalid_contract_executable}

  @impl true
  def to_xdr(%__MODULE__{type: :wasm_ref, value: value}) do
    type = ContractExecutableType.new()

    value
    |> Hash.new()
    |> ContractExecutable.new(type)
  end

  def to_xdr(%__MODULE__{type: :stellar_asset, value: nil}) do
    type = ContractExecutableType.new(:CONTRACT_EXECUTABLE_STELLAR_ASSET)
    ContractExecutable.new(Void.new(), type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}
end
