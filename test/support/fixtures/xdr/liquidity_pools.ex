defmodule Stellar.Test.Fixtures.XDR.LiquidityPools do
  @moduledoc """
  XDR constructions for LiquidityPools.
  """

  alias StellarBase.XDR.{
    Int32,
    Int64,
    OperationBody,
    OperationType,
    Operations,
    PoolID,
    Price
  }

  @type pool_id :: String.t()
  @type amount :: integer()
  @type price :: float()
  @type xdr :: PoolID.t() | OperationBody.t()

  @spec liquidity_pool_id(pool_id :: pool_id()) :: PoolID.t()
  def liquidity_pool_id("929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072") do
    %PoolID{
      value:
        <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49, 141,
          141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
    }
  end

  @spec liquidity_pool_withdraw(
          pool_id :: pool_id(),
          amount :: amount(),
          min_amount_a :: amount(),
          min_amount_b :: amount()
        ) :: xdr()
  def liquidity_pool_withdraw(
        "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        100,
        20,
        10
      ) do
    %OperationBody{
      operation: %Operations.LiquidityPoolWithdraw{
        amount: %Int64{datum: 1_000_000_000},
        min_amount_a: %Int64{datum: 200_000_000},
        min_amount_b: %Int64{datum: 100_000_000},
        pool_id: %PoolID{
          value:
            <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
              141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
        }
      },
      type: %OperationType{identifier: :LIQUIDITY_POOL_WITHDRAW}
    }
  end

  @spec liquidity_pool_deposit(
          pool_id :: pool_id(),
          max_amount_a :: amount(),
          max_amount_b :: amount(),
          min_price :: price(),
          max_price :: price()
        ) :: xdr()
  def liquidity_pool_deposit(
        "929b20b72e5890ab51c24f1cc46fa01c4f318d8d33367d24dd614cfdf5491072",
        20,
        10,
        1.5,
        2.5
      ) do
    %OperationBody{
      operation: %Operations.LiquidityPoolDeposit{
        max_amount_a: %Int64{datum: 200_000_000},
        max_amount_b: %Int64{datum: 100_000_000},
        max_price: %Price{
          denominator: %Int32{datum: 2},
          numerator: %Int32{datum: 5}
        },
        min_price: %Price{
          denominator: %Int32{datum: 2},
          numerator: %Int32{datum: 3}
        },
        pool_id: %PoolID{
          value:
            <<146, 155, 32, 183, 46, 88, 144, 171, 81, 194, 79, 28, 196, 111, 160, 28, 79, 49,
              141, 141, 51, 54, 125, 36, 221, 97, 76, 253, 245, 73, 16, 114>>
        }
      },
      type: %OperationType{identifier: :LIQUIDITY_POOL_DEPOSIT}
    }
  end
end
