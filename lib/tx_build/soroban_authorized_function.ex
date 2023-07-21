defmodule Stellar.TxBuild.SorobanAuthorizedFunction do
  @moduledoc """
  `SorobanAuthorizedFunction` struct definition.
  """
  alias StellarBase.XDR.{SorobanAuthorizedFunction, SorobanAuthorizedFunctionType}
  alias Stellar.TxBuild.{CreateContractArgs, SorobanAuthorizedContractFunction}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type type :: :contract_fn | :create_contract_host_fn
  @type value :: CreateContractArgs.t() | SorobanAuthorizedContractFunction.t()
  @type t :: %__MODULE__{type: type(), value: value()}

  defstruct [:type, :value]

  @allowed_types ~w(contract_fn create_contract_host_fn)a

  @impl true
  def new(value, opts \\ [])

  def new([{type, value}], _opts) when type in @allowed_types do
    with {:ok, value} <- validate_soroban_auth_function({type, value}) do
      %__MODULE__{type: type, value: value}
    end
  end

  def new(_value, _opts), do: {:error, :invalid_soroban_auth_function}

  @impl true
  def to_xdr(%__MODULE__{type: :contract_fn, value: value}) do
    type = SorobanAuthorizedFunctionType.new()

    value
    |> SorobanAuthorizedContractFunction.to_xdr()
    |> SorobanAuthorizedFunction.new(type)
  end

  def to_xdr(%__MODULE__{type: :create_contract_host_fn, value: value}) do
    type =
      SorobanAuthorizedFunctionType.new(:SOROBAN_AUTHORIZED_FUNCTION_TYPE_CREATE_CONTRACT_HOST_FN)

    value
    |> CreateContractArgs.to_xdr()
    |> SorobanAuthorizedFunction.new(type)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_soroban_auth_function(tuple()) :: validation()
  defp validate_soroban_auth_function(
         {:contract_fn, %SorobanAuthorizedContractFunction{} = value}
       ),
       do: {:ok, value}

  defp validate_soroban_auth_function({:create_contract_host_fn, %CreateContractArgs{} = value}),
    do: {:ok, value}

  defp validate_soroban_auth_function({type, _value}), do: {:error, :"invalid_#{type}"}
end
