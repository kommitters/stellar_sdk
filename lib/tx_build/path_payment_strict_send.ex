defmodule Stellar.TxBuild.PathPaymentStrictSend do
  @moduledoc """
  Sends an amount in a specific asset to a destination account through a path of offers.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.{Account, Amount, Asset, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.Payment}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          destination: Account.t(),
          send_asset: Asset.t(),
          send_amount: Amount.t(),
          path: AssetsPath.t(),
          dest_asset: Asset.t(),
          dest_min: Amount.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [
    :destination,
    :send_asset,
    :send_amount,
    :path,
    :dest_asset,
    :dest_min,
    :source_account
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    destination = Keyword.get(args, :destination)
    send_asset = Keyword.get(args, :send_asset)
    send_amount = Keyword.get(args, :send_amount)
    dest_asset = Keyword.get(args, :dest_asset)
    dest_min = Keyword.get(args, :dest_min)
    path = Keyword.get(args, :path)
    source_account = Keyword.get(args, :source_account)

    # {:ok, path} <- optional_path({:path, path}),
    # {:ok, source_account} <- optional_account({:source_account, source_account})
    with {:ok, destination} <- validate_account({:destination, destination}),
         {:ok, send_asset} <- validate_asset({:send_asset, send_asset}),
         {:ok, send_amount} <- validate_amount({:send_amount, send_amount}),
         {:ok, dest_asset} <- validate_asset({:dest_asset, dest_asset}),
         {:ok, dest_min} <- validate_amount({:dest_min, dest_min}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        destination: destination,
        send_asset: send_asset,
        send_amount: send_amount,
        dest_asset: dest_asset,
        dest_min: dest_min,
        path: path,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{}) do
    # op_type = OperationType.new(:PAYMENT)
    # destination = Account.to_xdr(destination)
    # asset = Asset.to_xdr(asset)
    # amount = Amount.to_xdr(amount)

    # destination
    # |> Payment.new(asset, amount)
    # |> OperationBody.new(op_type)
  end
end
