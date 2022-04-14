defmodule Stellar.Test.Fixtures.XDR do
  @moduledoc """
  Mocks for XDR constructions.
  """

  alias Stellar.Test.Fixtures.XDR.{Accounts, Transactions, LiquidityPools, TransactionEnvelope}

  # accounts
  defdelegate muxed_account(account_id), to: Accounts
  defdelegate muxed_account_med25519(address), to: Accounts

  # transactions
  defdelegate transaction(account_id), to: Transactions
  defdelegate transaction_with_muxed_account(address), to: Transactions

  # transactions envelope
  defdelegate transaction_envelope(options \\ []), to: TransactionEnvelope

  # liquidity_pools
  defdelegate liquidity_pool_id(pool_id), to: LiquidityPools

  defdelegate liquidity_pool_withdraw(pool_id, amount, min_amount_a, min_amount_b),
    to: LiquidityPools
end
