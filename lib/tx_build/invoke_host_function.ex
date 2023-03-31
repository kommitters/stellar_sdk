defmodule Stellar.TxBuild.InvokeHostFunction do
  @moduledoc """
  Performs the following operations:
  - Invokes contract functions.
  - Installs WASM of the new contracts.
  - Deploys new contracts using the installed WASM or built-in implementations.
  """

  import Stellar.TxBuild.Validations, only: [validate_optional_account: 1]

  alias Stellar.TxBuild.{HostFunction, OptionalAccount}

  alias StellarBase.XDR.Operations.InvokeHostFunction

  alias StellarBase.XDR.{
    OperationBody,
    OperationType,
    LedgerFootprint,
    ContractAuthList,
    LedgerKeyList
  }

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          function: HostFunction.t(),
          footprint: String.t(),
          auth: ContractAuthList.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [:function, :footprint, :auth, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    function = Keyword.get(args, :function)
    footprint = Keyword.get(args, :footprint, "")
    auth = Keyword.get(args, :auth)
    source_account = Keyword.get(args, :source_account)

    with {:ok, function} <- validate_function(function),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        function: function,
        footprint: footprint,
        auth: auth,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        function: function,
        footprint: "",
        auth: nil
      }) do
    op_type = OperationType.new(:INVOKE_HOST_FUNCTION)
    host_function = HostFunction.to_xdr(function)
    ledger_key_list = LedgerKeyList.new([])
    ledger_footprint = LedgerFootprint.new(ledger_key_list, ledger_key_list)
    contract_auth_list = ContractAuthList.new([])

    host_function
    |> InvokeHostFunction.new(ledger_footprint, contract_auth_list)
    |> OperationBody.new(op_type)
  end

  def to_xdr(%__MODULE__{
        function: function,
        footprint: footprint,
        auth: nil
      }) do
    op_type = OperationType.new(:INVOKE_HOST_FUNCTION)
    host_function = HostFunction.to_xdr(function)

    {ledger_footprint, _} =
      footprint
      |> Base.decode64!()
      |> LedgerFootprint.decode_xdr!()

    contract_auth_list = ContractAuthList.new([])

    host_function
    |> InvokeHostFunction.new(ledger_footprint, contract_auth_list)
    |> OperationBody.new(op_type)
  end

  def set_footprint(%__MODULE__{} = module, footprint), do: %{module | footprint: footprint}

  defp validate_function(function) do
    case function do
      %HostFunction{} -> {:ok, function}
      _ -> {:error, :invalid_function}
    end
  end
end
