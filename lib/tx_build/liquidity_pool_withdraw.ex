defmodule Stellar.TxBuild.LiquidityPoolWithdraw do
  @moduledoc """
  Withdraw assets from a liquidity pool.
  """
  import Stellar.TxBuild.Validations,
    only: [validate_pool_id: 1, validate_amount: 1, validate_optional_account: 1]

  alias Stellar.TxBuild.{Amount, PoolID, OptionalAccount}
  alias StellarBase.XDR.{OperationBody, OperationType, Operations.LiquidityPoolWithdraw}

  @behaviour Stellar.TxBuild.XDR

  @type t :: %__MODULE__{
          liquidity_pool_id: PoolID.t(),
          amount: Amount.t(),
          min_amount_a: Amount.t(),
          min_amount_b: Amount.t(),
          source_account: OptionalAccount.t()
        }

  defstruct [
    :liquidity_pool_id,
    :amount,
    :min_amount_a,
    :min_amount_b,
    :source_account
  ]

  @impl true
  def new(args, opts \\ [])

  def new(args, _opts) when is_list(args) do
    liquidity_pool_id = Keyword.get(args, :liquidity_pool_id)
    amount = Keyword.get(args, :amount)
    min_amount_a = Keyword.get(args, :min_amount_a)
    min_amount_b = Keyword.get(args, :min_amount_b)
    source_account = Keyword.get(args, :source_account)

    with {:ok, liquidity_pool_id} <- validate_pool_id({:liquidity_pool_id, liquidity_pool_id}),
         {:ok, amount} <- validate_amount({:amount, amount}),
         {:ok, min_amount_a} <- validate_amount({:min_amount_a, min_amount_a}),
         {:ok, min_amount_b} <- validate_amount({:min_amount_b, min_amount_b}),
         {:ok, source_account} <- validate_optional_account({:source_account, source_account}) do
      %__MODULE__{
        liquidity_pool_id: liquidity_pool_id,
        amount: amount,
        min_amount_a: min_amount_a,
        min_amount_b: min_amount_b,
        source_account: source_account
      }
    end
  end

  def new(_args, _opts), do: {:error, :invalid_operation_attributes}

  @impl true
  def to_xdr(%__MODULE__{
        liquidity_pool_id: liquidity_pool_id,
        amount: amount,
        min_amount_a: min_amount_a,
        min_amount_b: min_amount_b
      }) do
    op_type = OperationType.new(:LIQUIDITY_POOL_WITHDRAW)
    liquidity_pool_id = PoolID.to_xdr(liquidity_pool_id)
    amount = Amount.to_xdr(amount)
    min_amount_a = Amount.to_xdr(min_amount_a)
    min_amount_b = Amount.to_xdr(min_amount_b)

    liquidity_pool_withdraw =
      LiquidityPoolWithdraw.new(
        liquidity_pool_id,
        amount,
        min_amount_a,
        min_amount_b
      )

    OperationBody.new(liquidity_pool_withdraw, op_type)
  end
end
