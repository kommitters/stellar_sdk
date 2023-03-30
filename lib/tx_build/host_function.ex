defmodule Stellar.TxBuild.HostFunction do
  @moduledoc """
  - install
  - create
  - invoke
  """

  alias Stellar.TxBuild.{HostFunction, SCVal}

  @behaviour Stellar.TxBuild.XDR

  @type type :: :install | :invoke | :create
  @type contract_id :: :source_account | :ed25519_public_key | :asset | String.t()
  @type function_name :: String.t()
  @type parameters :: list(SCVal.t())

  @type t :: %__MODULE__{
          type: type(),
          args: [
            contract_id: contract_id(),
            function_name: function_name(),
            parameters: parameters()
          ]
        }

  # Invocar.
  # HostFunction? HostFunction.new(:invoke, contract_id: "", function_name: "", args: [scval1, scval2, scval3])

  defstruct [:function, :footprint, :auth, :source_account]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    host_function_op = Keyword.get(args, :invoke)
    contract_id = Keyword.get(args, :contract_id)
    function_name = Keyword.get(args, :function_name)
    parameters = Keyword.get(args, :parameters)
    source_account = Keyword.get(args, :source_account)

    with {:ok, contract_id} <- validate_contract_id(contract_id),
         {:ok, function_name} do
    %__MODULE__{
      type: host_function_op,
      args: [
        contract_id: contract_id,
        function_name: function_name(),
        parameters: parameters,
        source_account: source_account
      ]
    }
  end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{destination: destination, asset: asset, amount: amount}) do
    op_type = OperationType.new(:PAYMENT)
    destination = Account.to_xdr(destination)
    asset = Asset.to_xdr(asset)
    amount = Amount.to_xdr(amount)

    destination
    |> Payment.new(asset, amount)
    |> OperationBody.new(op_type)
  end
end
