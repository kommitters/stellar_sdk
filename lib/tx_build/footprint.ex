# defmodule Stellar.TxBuild.FootPrint do
#   @moduledoc """
#   Performs the following operations:
#   - Invokes contract functions.
#   - Installs WASM of the new contracts.
#   - Deploys new contracts using the installed WASM or built-in implementations.
#   """

#   import Stellar.TxBuild.Validations,
#     only: [
#       validate_account: 1,
#       validate_asset: 1,
#       validate_amount: 1,
#       validate_optional_account: 1
#     ]

#   alias Stellar.TxBuild.{HostFunction, LedgerFootprint, ContractAuthList, OptionalAccount}
#   alias StellarBase.XDR.{OperationBody, OperationType, Operations.Payment}

#   @behaviour Stellar.TxBuild.XDR

#   @type t :: %__MODULE__{
#           function: HostFunction.t(),
#           footprint: LedgerFootprint.t(), #optional
#           auth: ContractAuthList.t(), #optional
#           source_account: OptionalAccount.t() #optional
#         }

#   # Invocar.
#   # InvokeHostFunction? InvokeHostFunction.new(function)

#   defstruct [:function, :footprint, :auth, :source_account]

#   @impl true
#   def new(args \\ [], opts \\ [])

#   def new(args, _opts) when is_list(args) do
#     #asignar 2 listas vacias
#     read_only = Keyword.get(args, :read_only, [])
#     read_write = Keyword.get(args, :read_write, [])

#     #validar lista de ledgerKeys

#     function = Keyword.get(args, :function)
#     footprint = Keyword.get(args, :footprint, Footprint.new())
#     auth = Keyword.get(args, :auth)
#     source_account = Keyword.get(args, :source_account)

#     with {:ok, destination} <- validate_account({:destination, destination}),
#          {:ok, asset} <- validate_asset({:asset, asset}),
#          {:ok, amount} <- validate_amount({:amount, amount}),
#          {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
#       %__MODULE__{
#         destination: destination,
#         asset: asset,
#         amount: amount,
#         source_account: source_account
#       }
#     end
#   end

#   def new(_args, _opts), do: {:error, :invalid_operation_attributes}

#   @impl true
#   def to_xdr(%__MODULE__{destination: destination, asset: asset, amount: amount}) do
#     op_type = OperationType.new(:PAYMENT)
#     destination = Account.to_xdr(destination)
#     asset = Asset.to_xdr(asset)
#     amount = Amount.to_xdr(amount)

#     destination
#     |> Payment.new(asset, amount)
#     |> OperationBody.new(op_type)
#   end
# end
