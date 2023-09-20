defmodule Stellar.TxBuild.InvokeContractArgs do
  @moduledoc """
  `InvokeContractArgs` struct definition.
  """

  import Stellar.TxBuild.Validations,
    only: [validate_sc_vals: 1, validate_address: 1]

  alias StellarBase.XDR.{InvokeContractArgs, SCSymbol}
  alias Stellar.TxBuild.{SCAddress, SCVec}

  @behaviour Stellar.TxBuild.XDR

  @type error :: {:error, atom()}
  @type validation :: {:ok, any()} | error()
  @type contract_address :: SCAddress.t()
  @type function_name :: String.t()
  @type args :: list(SCVec.t())

  @type t :: %__MODULE__{
          contract_address: contract_address(),
          function_name: function_name(),
          args: args()
        }

  defstruct [:contract_address, :function_name, :args]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    contract_address = Keyword.get(args, :contract_address)
    function_name = Keyword.get(args, :function_name)
    function_args = Keyword.get(args, :args)

    with {:ok, contract_address} <- validate_address(contract_address),
         {:ok, function_name} <- validate_function_name(function_name),
         {:ok, function_args} <- validate_sc_vals({:vals, function_args}) do
      %__MODULE__{
        contract_address: contract_address,
        function_name: function_name,
        args: function_args
      }
    end
  end

  def new(_value, _opts), do: {:error, :invalid_soroban_auth_contract_function_args}

  @impl true
  def to_xdr(%__MODULE__{
        contract_address: contract_address,
        function_name: function_name,
        args: args
      }) do
    function_name = SCSymbol.new(function_name)

    args =
      args
      |> SCVec.new()
      |> SCVec.to_xdr()

    contract_address
    |> SCAddress.to_xdr()
    |> InvokeContractArgs.new(function_name, args)
  end

  def to_xdr(_struct), do: {:error, :invalid_struct}

  @spec validate_function_name(function_name :: function_name()) :: validation()
  defp validate_function_name(function_name) when is_binary(function_name),
    do: {:ok, function_name}

  defp validate_function_name(_function_name), do: {:error, :invalid_function_name}
end
