defmodule Stellar.TxBuild.LiquidityPoolDeposit do
  @moduledoc """
  Deposits assets into a liquidity pool.
  """
  import Stellar.TxBuild.Validations,
    only: [
      validate_pool_id: 1,
      validate_amount: 1,
      validate_price: 1,
      validate_optional_account: 1
    ]

  alias Stellar.TxBuild.{Amount, PoolID, Price, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.LiquidityPoolDeposit}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          liquidity_pool_id: PoolID.t(),
          max_amount_a: Amount.t(),
          max_amount_b: Amount.t(),
          min_price: Price.t(),
          max_price: Price.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [
    :liquidity_pool_id,
    :max_amount_a,
    :max_amount_b,
    :min_price,
    :max_price,
    :source_account
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    liquidity_pool_id = Keyword.get(args, :liquidity_pool_id)
    max_amount_a = Keyword.get(args, :max_amount_a)
    max_amount_b = Keyword.get(args, :max_amount_b)
    min_price = Keyword.get(args, :min_price)
    max_price = Keyword.get(args, :max_price)
    source_account = Keyword.get(args, :source_account)

    with {:ok, liquidity_pool_id} <- validate_pool_id({:liquidity_pool_id, liquidity_pool_id}),
         {:ok, max_amount_a} <- validate_amount({:max_amount_a, max_amount_a}),
         {:ok, max_amount_b} <- validate_amount({:max_amount_b, max_amount_b}),
         {:ok, min_price} <- validate_price({:min_price, min_price}),
         {:ok, max_price} <- validate_price({:max_price, max_price}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        liquidity_pool_id: liquidity_pool_id,
        max_amount_a: max_amount_a,
        max_amount_b: max_amount_b,
        min_price: min_price,
        max_price: max_price,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        liquidity_pool_id: liquidity_pool_id,
        max_amount_a: max_amount_a,
        max_amount_b: max_amount_b,
        min_price: min_price,
        max_price: max_price
      }) do
    op_type = OperationType.new(:LIQUIDITY_POOL_DEPOSIT)
    liquidity_pool_id = PoolID.to_xdr(liquidity_pool_id)
    max_amount_a = Amount.to_xdr(max_amount_a)
    max_amount_b = Amount.to_xdr(max_amount_b)
    min_price = Price.to_xdr(min_price)
    max_price = Price.to_xdr(max_price)

    liquidity_pool_deposit =
      LiquidityPoolDeposit.new(
        liquidity_pool_id,
        max_amount_a,
        max_amount_b,
        min_price,
        max_price
      )

    OperationBody.new(liquidity_pool_deposit, op_type)
  end
end
