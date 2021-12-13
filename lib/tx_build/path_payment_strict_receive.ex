defmodule Stellar.TxBuild.PathPaymentStrictReceive do
  @moduledoc """
  Sends an amount in a specific asset to a destination account through a path of offers.
  """
  import Stellar.TxBuild.OpValidate

  alias Stellar.TxBuild.{Account, Amount, Asset, AssetsPath, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.PathPaymentStrictReceive}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          destination: Account.t(),
          send_asset: Asset.t(),
          send_max: Amount.t(),
          path: AssetsPath.t(),
          dest_asset: Asset.t(),
          dest_amount: Amount.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [
    :destination,
    :send_asset,
    :send_max,
    :path,
    :dest_asset,
    :dest_amount,
    :source_account
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    destination = Keyword.get(args, :destination)
    send_asset = Keyword.get(args, :send_asset)
    send_max = Keyword.get(args, :send_max)
    dest_asset = Keyword.get(args, :dest_asset)
    dest_amount = Keyword.get(args, :dest_amount)
    path = Keyword.get(args, :path)
    source_account = Keyword.get(args, :source_account)

    with {:ok, destination} <- validate_account({:destination, destination}),
         {:ok, send_asset} <- validate_asset({:send_asset, send_asset}),
         {:ok, send_max} <- validate_amount({:send_max, send_max}),
         {:ok, dest_asset} <- validate_asset({:dest_asset, dest_asset}),
         {:ok, dest_amount} <- validate_amount({:dest_amount, dest_amount}),
         {:ok, path} <- validate_optional_assets_path({:path, path}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        destination: destination,
        send_asset: send_asset,
        send_max: send_max,
        dest_asset: dest_asset,
        dest_amount: dest_amount,
        path: path,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        destination: destination,
        send_asset: send_asset,
        send_max: send_max,
        dest_asset: dest_asset,
        dest_amount: dest_amount,
        path: path
      }) do
    op_type = OperationType.new(:PATH_PAYMENT_STRICT_RECEIVE)
    destination = Account.to_xdr(destination)
    send_asset = Asset.to_xdr(send_asset)
    send_max = Amount.to_xdr(send_max)
    dest_asset = Asset.to_xdr(dest_asset)
    dest_amount = Amount.to_xdr(dest_amount)
    path = AssetsPath.to_xdr(path)

    path_payment =
      PathPaymentStrictReceive.new(
        send_asset,
        send_max,
        destination,
        dest_asset,
        dest_amount,
        path
      )

    OperationBody.new(path_payment, op_type)
  end
end
